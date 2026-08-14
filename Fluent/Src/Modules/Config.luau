local HttpService = game:GetService("HttpService")

local Root = script.Parent.Parent

local Config = {
	Folder = "FluentRenewed",
	Name = "autosave",
	AutoSave = true,
	Enabled = false,
	Data = {},
	Ignore = {},
	SaveDelay = 0.5,

	Applying = false,
	Queued = false,
	LastError = nil
}

local function FileSystem()
	return typeof(writefile) == "function"
		and typeof(readfile) == "function"
		and typeof(isfile) == "function"
		and typeof(isfolder) == "function"
		and typeof(makefolder) == "function"
end

local function SafeIsFile(Path: string): boolean
	local Success, Result = pcall(isfile, Path)
	return Success and Result == true
end

local function SafeIsFolder(Path: string): boolean
	local Success, Result = pcall(isfolder, Path)
	return Success and Result == true
end

local function Stringify(Value): string
	if typeof(Value) == "Instance" then
		local Success, Result = pcall(function()
			return Value:GetFullName()
		end)

		return Success and Result or tostring(Value)
	end

	return tostring(Value)
end

local Parsers = {
	Toggle = {
		Save = function(Option)
			return { value = Option.Value and true or false }
		end,
		Load = function(Option, Data)
			if typeof(Data.value) == "boolean" then
				Option:SetValue(Data.value)
			end
		end
	},

	Slider = {
		Save = function(Option)
			return { value = tonumber(Option.Value) }
		end,
		Load = function(Option, Data)
			if tonumber(Data.value) then
				Option:SetValue(tonumber(Data.value))
			end
		end
	},

	Input = {
		Save = function(Option)
			return { value = tostring(Option.Value or "") }
		end,
		Load = function(Option, Data)
			if typeof(Data.value) == "string" then
				Option:SetValue(Data.value)
			end
		end
	},

	Keybind = {
		Save = function(Option)
			local Value = Option.Value

			if typeof(Value) == "EnumItem" then
				Value = Value.Name
			end

			if typeof(Value) ~= "string" then
				return nil
			end

			return { value = Value, mode = Option.Mode }
		end,
		Load = function(Option, Data)
			if typeof(Data.value) == "string" then
				Option:SetValue(Data.value, Data.mode)
			end
		end
	},

	Colorpicker = {
		Save = function(Option)
			return { value = Option.Value:ToHex(), transparency = Option.Transparency }
		end,
		Load = function(Option, Data)
			if typeof(Data.value) ~= "string" then
				return
			end

			local Success, Color = pcall(Color3.fromHex, Data.value)

			if Success then
				Option:SetValueRGB(Color, Data.transparency)
			end
		end
	},

	Dropdown = {
		-- Dropdown values can be Instances, Enums or tables, none of which survive a
		-- round trip through JSON. What always survives is what the dropdown *displays*,
		-- so that is what gets stored and matched back on load.
		Save = function(Option)
			local Display = typeof(Option.Displayer) == "function" and Option.Displayer or tostring

			if Option.Multi then
				local Selected = {}

				for Value, Enabled in next, Option.Value or {} do
					if Enabled then
						Selected[#Selected + 1] = Stringify(Display(Value))
					end
				end

				return { value = Selected, multi = true }
			end

			return {
				value = Option.Value ~= nil and Stringify(Display(Option.Value)) or nil,
				multi = false
			}
		end,
		Load = function(Option, Data)
			local Display = typeof(Option.Displayer) == "function" and Option.Displayer or tostring

			local function Find(Wanted)
				for _, Value in next, Option.Values or {} do
					if Stringify(Display(Value)) == Wanted then
						return Value
					end
				end

				return nil
			end

			if Option.Multi then
				local Selected = {}

				for _, Wanted in next, (typeof(Data.value) == "table" and Data.value or {}) do
					local Value = Find(Wanted)

					if Value ~= nil then
						Selected[Value] = true
					end
				end

				Option:SetValue(Selected)
			elseif typeof(Data.value) == "string" then
				local Value = Find(Data.value)

				if Value ~= nil then
					Option:SetValue(Value)
				end
			end
		end
	}
}

Config.Parsers = Parsers

function Config:SupportsFiles(): boolean
	return FileSystem()
end

function Config:BuildFolderTree()
	if not FileSystem() then
		return false
	end

	local Paths = { self.Folder, `{self.Folder}/configs` }

	for Index = 1, #Paths do
		if not SafeIsFolder(Paths[Index]) then
			local Success, Error = pcall(makefolder, Paths[Index])

			if not Success then
				self.LastError = Error
				return false
			end
		end
	end

	return true
end

function Config:SetFolder(Folder: string)
	self.Folder = Folder
	self:BuildFolderTree()

	return self
end

function Config:SetIgnoreIndexes(List: { string })
	for _, Key in next, List do
		self.Ignore[Key] = true
	end

	return self
end

function Config:GetPath(Name: string): string
	return `{self.Folder}/configs/{Name}.json`
end

function Config:Serialize(): { [string]: any }
	local Library = require(Root)
	local Objects = {}

	for Idx, Option in next, Library.Options do
		local Parser = typeof(Option) == "table" and Option.Type and Parsers[Option.Type]

		if Parser and not self.Ignore[Idx] then
			local Success, Result = pcall(Parser.Save, Option)

			if Success and Result then
				Result.type = Option.Type
				Objects[tostring(Idx)] = Result
			end
		end
	end

	return { version = 1, objects = Objects }
end

function Config:Deserialize(Data: { [string]: any })
	local Library = require(Root)

	if typeof(Data) ~= "table" or typeof(Data.objects) ~= "table" then
		return
	end

	self.Applying = true

	for Idx, Option in next, Library.Options do
		local Stored = Data.objects[tostring(Idx)]

		if Stored and typeof(Option) == "table" and Option.Type == Stored.type and Parsers[Stored.type] then
			pcall(Parsers[Stored.type].Load, Option, Stored)
		end
	end

	self.Applying = false
end

-- Applies whatever was stored for a single option. Elements call into this the moment
-- they register themselves, so options created long after the config was read still come
-- back with the value the user left them on.
function Config:Restore(Idx, Option)
	if typeof(Option) ~= "table" or not Option.Type or self.Ignore[Idx] then
		return
	end

	local Stored = self.Data and typeof(self.Data.objects) == "table" and self.Data.objects[tostring(Idx)]

	if not Stored or Stored.type ~= Option.Type or not Parsers[Option.Type] then
		return
	end

	local WasApplying = self.Applying
	self.Applying = true

	pcall(Parsers[Option.Type].Load, Option, Stored)

	self.Applying = WasApplying
end

function Config:RestoreAll()
	self:Deserialize(self.Data)
end

function Config:Save(Name: string?): (boolean, string?)
	Name = Name or self.Name

	if not FileSystem() then
		return false, "This executor has no file system"
	end

	if not Name or Name:gsub("%s", "") == "" then
		return false, "No config name given"
	end

	self:BuildFolderTree()

	local Data = self:Serialize()
	local Success, Encoded = pcall(HttpService.JSONEncode, HttpService, Data)

	if not Success then
		return false, "Failed to encode config"
	end

	local Written, Error = pcall(writefile, self:GetPath(Name), Encoded)

	if not Written then
		self.LastError = Error
		return false, tostring(Error)
	end

	if Name == self.Name then
		self.Data = Data
	end

	return true
end

function Config:Read(Name: string): ({ [string]: any }?, string?)
	if not FileSystem() then
		return nil, "This executor has no file system"
	end

	local Path = self:GetPath(Name)

	if not SafeIsFile(Path) then
		return nil, "Config does not exist"
	end

	local ReadSuccess, Contents = pcall(readfile, Path)

	if not ReadSuccess then
		return nil, "Failed to read config"
	end

	local DecodeSuccess, Decoded = pcall(HttpService.JSONDecode, HttpService, Contents)

	if not DecodeSuccess or typeof(Decoded) ~= "table" then
		return nil, "Failed to decode config"
	end

	return Decoded
end

function Config:Load(Name: string?): (boolean, string?)
	Name = Name or self.Name

	local Data, Error = self:Read(Name)

	if not Data then
		return false, Error
	end

	if Name == self.Name then
		self.Data = Data
	end

	self:Deserialize(Data)

	return true
end

function Config:Delete(Name: string): (boolean, string?)
	if not FileSystem() or typeof(delfile) ~= "function" then
		return false, "This executor cannot delete files"
	end

	local Path = self:GetPath(Name)

	if not SafeIsFile(Path) then
		return false, "Config does not exist"
	end

	local Success, Error = pcall(delfile, Path)

	if not Success then
		return false, tostring(Error)
	end

	return true
end

function Config:List(): { string }
	local Out = {}

	if not FileSystem() or typeof(listfiles) ~= "function" then
		return Out
	end

	local Success, Files = pcall(listfiles, `{self.Folder}/configs`)

	if not Success or typeof(Files) ~= "table" then
		return Out
	end

	for _, File in next, Files do
		if File:sub(-5) == ".json" then
			local Name = File:match("[^/\\]+$")

			if Name then
				Out[#Out + 1] = Name:sub(1, -6)
			end
		end
	end

	table.sort(Out)

	return Out
end

-- Coalesces the storm of callbacks a single user action produces into one write.
function Config:Queue()
	if not self.Enabled or not self.AutoSave or self.Applying or self.Queued then
		return
	end

	if not FileSystem() then
		return
	end

	self.Queued = true

	task.delay(self.SaveDelay, function()
		self.Queued = false

		if self.Enabled and self.AutoSave and not self.Applying then
			self:Save(self.Name)
		end
	end)
end

function Config:SetAutoSave(State: boolean)
	self.AutoSave = State and true or false

	if self.AutoSave then
		self:Queue()
	end

	return self
end

-- Reads the auto-save file into memory. Values are handed out to elements as they
-- register, so this is safe to call before the interface has been built.
function Config:Init(Options: { Folder: string?, Name: string?, AutoSave: boolean? }?)
	Options = typeof(Options) == "table" and Options or {}

	if typeof(Options.Folder) == "string" then
		self.Folder = Options.Folder
	end

	if typeof(Options.Name) == "string" then
		self.Name = Options.Name
	end

	if typeof(Options.AutoSave) == "boolean" then
		self.AutoSave = Options.AutoSave
	end

	self.Enabled = true

	self:BuildFolderTree()

	local Data = self:Read(self.Name)

	self.Data = Data or { version = 1, objects = {} }

	-- Anything created before Init() (or under a differently named index) still gets a pass.
	task.defer(function()
		self:RestoreAll()
	end)

	return self
end

function Config:BuildSection(Tab)
	local Library = require(Root)

	assert(typeof(Tab) == "table", "Config:BuildSection expects a Tab")

	local Section = Tab:AddSection("Configuration")

	Section:AddToggle("FluentConfig_AutoSave", {
		Title = "Auto save",
		Description = "Remembers every option you change and restores it next time",
		Default = self.AutoSave,
		Callback = function(Value)
			self:SetAutoSave(Value)
		end
	})

	Section:AddInput("FluentConfig_Name", {
		Title = "Config name",
		Placeholder = "my config"
	})

	local List = Section:AddDropdown("FluentConfig_List", {
		Title = "Config list",
		Values = self:List(),
		AllowNull = true
	})

	local function Refresh()
		List:SetValues(self:List())
	end

	local function Notify(Content: string, SubContent: string?)
		Library:Notify({
			Title = "Configuration",
			Content = Content,
			SubContent = SubContent,
			Duration = 6
		})
	end

	Section:AddButton({
		Title = "Create config",
		Description = "Saves the current state under the name above",
		Callback = function()
			local Name = Library.Options.FluentConfig_Name.Value or ""

			if Name:gsub("%s", "") == "" then
				return Notify("Invalid config name", "The name cannot be empty")
			end

			local Success, Error = self:Save(Name)

			if not Success then
				return Notify("Failed to create config", Error)
			end

			Refresh()

			return Notify("Created config", Name)
		end
	})

	Section:AddButton({
		Title = "Load config",
		Callback = function()
			local Name = Library.Options.FluentConfig_List.Value

			if not Name then
				return Notify("No config selected")
			end

			local Success, Error = self:Load(Name)

			if not Success then
				return Notify("Failed to load config", Error)
			end

			return Notify("Loaded config", Name)
		end
	})

	Section:AddButton({
		Title = "Overwrite config",
		Callback = function()
			local Name = Library.Options.FluentConfig_List.Value

			if not Name then
				return Notify("No config selected")
			end

			local Success, Error = self:Save(Name)

			if not Success then
				return Notify("Failed to overwrite config", Error)
			end

			return Notify("Overwrote config", Name)
		end
	})

	Section:AddButton({
		Title = "Delete config",
		Callback = function()
			local Name = Library.Options.FluentConfig_List.Value

			if not Name then
				return Notify("No config selected")
			end

			local Success, Error = self:Delete(Name)

			if not Success then
				return Notify("Failed to delete config", Error)
			end

			Refresh()
			List:SetValue(nil)

			return Notify("Deleted config", Name)
		end
	})

	Section:AddButton({
		Title = "Refresh list",
		Callback = Refresh
	})

	self:SetIgnoreIndexes({ "FluentConfig_Name", "FluentConfig_List" })

	return Section
end

return Config
