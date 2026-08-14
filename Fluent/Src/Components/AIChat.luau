local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Root = script.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local AddSignal = Creator.AddSignal

local PANEL_WIDTH = 280
local PANEL_TOP = 54
local SLIDE = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function GetRequestFunction()
	if typeof(request) == "function" then
		return request
	elseif typeof(http_request) == "function" then
		return http_request
	elseif syn and typeof(syn.request) == "function" then
		return syn.request
	elseif http and typeof(http.request) == "function" then
		return http.request
	elseif fluxus and typeof(fluxus.request) == "function" then
		return fluxus.request
	end

	return nil
end

return function(Config)
	local Library = require(Root)

	local Chat = {
		Open = false,
		Busy = false,
		History = {}
	}

	local Settings = Library.AI

	local CloseIcon = Library.Utilities:GetIcon("minus")
	local SendIcon = Library.Utilities:GetIcon("send")
	local ClearIcon = Library.Utilities:GetIcon("trash")

	local ClosedPosition = UDim2.new(1, 6, 0, PANEL_TOP)
	local OpenPosition = UDim2.new(1, -(PANEL_WIDTH + 12), 0, PANEL_TOP)

	local MessageLayout = New("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local MessageHolder = New("ScrollingFrame", {
		Size = UDim2.new(1, -20, 1, -84),
		Position = UDim2.fromOffset(10, 38),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 3,
		ScrollBarImageTransparency = 0.9,
		BottomImage = "rbxassetid://6889812791",
		MidImage = "rbxassetid://6889812721",
		TopImage = "rbxassetid://6276641225"
	}, {
		MessageLayout
	})

	local InputBox = New("TextBox", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		Text = "",
		PlaceholderText = "Ask me anything...",
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		ClearTextOnFocus = false,
		TextTruncate = Enum.TextTruncate.AtEnd,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -46, 1, 0),
		Position = UDim2.fromOffset(10, 0),
		ThemeTag = {
			TextColor3 = "Text",
			PlaceholderColor3 = "SubText"
		}
	})

	local SendButton = New("TextButton", {
		Size = UDim2.fromOffset(28, 28),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -5, 0.5, 0),
		Text = "",
		BackgroundTransparency = 0.15,
		ThemeTag = {
			BackgroundColor3 = "Accent"
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6)
		}),
		New("ImageLabel", {
			Size = UDim2.fromOffset(15, 15),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = SendIcon and SendIcon.Image or "",
			ImageRectOffset = SendIcon and SendIcon.ImageRectOffset or Vector2.zero,
			ImageRectSize = SendIcon and SendIcon.ImageRectSize or Vector2.zero,
			ThemeTag = {
				ImageColor3 = "Text"
			}
		})
	})

	local InputFrame = New("Frame", {
		Size = UDim2.new(1, -20, 0, 34),
		Position = UDim2.new(0, 10, 1, -44),
		BackgroundTransparency = 0.85,
		ThemeTag = {
			BackgroundColor3 = "Input"
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6)
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.5,
			ThemeTag = {
				Color = "InElementBorder"
			}
		}),
		InputBox,
		SendButton
	})

	local function HeaderButton(Icon, Offset, Callback)
		local Button = New("TextButton", {
			Size = UDim2.fromOffset(22, 22),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, Offset, 0, 18),
			BackgroundTransparency = 1,
			Text = "",
			ThemeTag = {
				BackgroundColor3 = "Text"
			}
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 6)
			}),
			New("ImageLabel", {
				Size = UDim2.fromOffset(13, 13),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = Icon and Icon.Image or "",
				ImageRectOffset = Icon and Icon.ImageRectOffset or Vector2.zero,
				ImageRectSize = Icon and Icon.ImageRectSize or Vector2.zero,
				ThemeTag = {
					ImageColor3 = "SubText"
				}
			})
		})

		local _, SetTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency", true)

		AddSignal(Button.MouseEnter, function()
			SetTransparency(0.9)
		end)

		AddSignal(Button.MouseLeave, function()
			SetTransparency(1)
		end)

		AddSignal(Button.MouseButton1Click, Callback)

		return Button
	end

	local Header = New("Frame", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1
	}, {
		New("TextLabel", {
			Text = (Settings.Name or "AI Assistant"):upper(),
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
			TextSize = 11,
			TextTransparency = 0.25,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			Position = UDim2.fromOffset(12, 0),
			Size = UDim2.new(1, -70, 1, 0),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text"
			}
		})
	})

	Chat.Panel = New("Frame", {
		Size = UDim2.new(0, PANEL_WIDTH, 1, -(PANEL_TOP + 12)),
		Position = ClosedPosition,
		BackgroundTransparency = 0.02,
		Visible = false,
		ClipsDescendants = true,
		ZIndex = 50,
		Parent = Config.Parent,
		ThemeTag = {
			BackgroundColor3 = "DropdownHolder"
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.4,
			ThemeTag = {
				Color = "DropdownBorder"
			}
		}),
		Header,
		MessageHolder,
		InputFrame
	})

	local function ScrollToBottom()
		task.defer(function()
			MessageHolder.CanvasPosition = Vector2.new(0, math.max(0, MessageLayout.AbsoluteContentSize.Y))
		end)
	end

	local MessageCount = 0

	local function AddMessage(Author: string, Text: string, IsUser: boolean)
		MessageCount += 1

		local Label = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = Text,
			TextSize = 13,
			TextWrapped = true,
			RichText = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "Text"
			}
		})

		local Bubble = New("Frame", {
			Size = UDim2.new(1, -4, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = IsUser and 0.8 or 0.88,
			LayoutOrder = MessageCount,
			Parent = MessageHolder,
			ThemeTag = {
				BackgroundColor3 = IsUser and "Accent" or "Element"
			}
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 6)
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 7),
				PaddingBottom = UDim.new(0, 7),
				PaddingLeft = UDim.new(0, 9),
				PaddingRight = UDim.new(0, 9)
			}),
			New("UIListLayout", {
				Padding = UDim.new(0, 3),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			New("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
				Text = Author,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, 12),
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				ThemeTag = {
					TextColor3 = "SubText"
				}
			}),
			Label
		})

		ScrollToBottom()

		return Bubble, Label
	end

	Chat.AddMessage = AddMessage

	local function Context(): string
		local Player = Players.LocalPlayer
		local Lines = {
			`Game place id: {game.PlaceId}`,
			`Player: {Player and Player.DisplayName or "unknown"} (@{Player and Player.Name or "unknown"})`
		}

		local Names = {}

		for Idx, Option in next, Library.Options do
			if typeof(Option) == "table" and Option.Type then
				Names[#Names + 1] = `{Idx} ({Option.Type})`
			end

			if #Names >= 40 then
				break
			end
		end

		if #Names > 0 then
			Lines[#Lines + 1] = `Interface options available: {table.concat(Names, ", ")}`
		end

		return table.concat(Lines, "\n")
	end

	local function Ask(Prompt: string): (boolean, string)
		local Request = GetRequestFunction()

		if not Request then
			return false, "This executor does not expose an HTTP request function, so the assistant cannot reach the API."
		end

		if not Settings.Key or Settings.Key == "" then
			return false, "No API key is set. Call Library:SetAIKey(\"your-key\") (or pass AI = { Key = \"...\" } to the window) to enable the assistant."
		end

		local Messages = {
			{
				role = "system",
				content = `{Settings.SystemPrompt}\n\n=== LIVE CONTEXT ===\n{Context()}`
			}
		}

		for _, Entry in next, Chat.History do
			Messages[#Messages + 1] = Entry
		end

		Messages[#Messages + 1] = { role = "user", content = Prompt }

		local Encoded = HttpService:JSONEncode({
			model = Settings.Model,
			messages = Messages,
			max_tokens = Settings.MaxTokens,
			temperature = Settings.Temperature
		})

		local Success, Response = pcall(Request, {
			Url = Settings.Url,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Authorization"] = `Bearer {Settings.Key}`
			},
			Body = Encoded
		})

		if not Success or typeof(Response) ~= "table" then
			return false, `Request failed: {tostring(Response):sub(1, 160)}`
		end

		local Decoded
		local DecodeSuccess, DecodeResult = pcall(HttpService.JSONDecode, HttpService, Response.Body or "")

		if DecodeSuccess then
			Decoded = DecodeResult
		end

		if typeof(Decoded) == "table" then
			if Decoded.choices and Decoded.choices[1] and Decoded.choices[1].message then
				return true, tostring(Decoded.choices[1].message.content)
			end

			if Decoded.error then
				return false, `API error: {tostring(Decoded.error.message or Decoded.error.type or "unknown")}`
			end
		end

		local Status = Response.StatusCode or Response.Status or "?"

		return false, `HTTP {Status}: {tostring(Response.StatusMessage or "no usable response")}`
	end

	local function Send(Prompt: string)
		Prompt = (Prompt or ""):gsub("^%s+", ""):gsub("%s+$", "")

		if Prompt == "" or Chat.Busy then
			return
		end

		Chat.Busy = true
		InputBox.Text = ""

		AddMessage("You", Prompt, true)

		local _, Pending = AddMessage(Settings.Name or "AI Assistant", "Thinking...", false)

		task.spawn(function()
			local Success, Reply = Ask(Prompt)

			if Pending and Pending.Parent then
				Pending.Text = Reply
			else
				AddMessage(Settings.Name or "AI Assistant", Reply, false)
			end

			if Success then
				table.insert(Chat.History, { role = "user", content = Prompt })
				table.insert(Chat.History, { role = "assistant", content = Reply })

				while #Chat.History > (Settings.HistoryLimit or 8) * 2 do
					table.remove(Chat.History, 1)
				end
			end

			Chat.Busy = false
			ScrollToBottom()
		end)
	end

	Chat.Send = Send

	function Chat:Clear()
		for _, Child in next, MessageHolder:GetChildren() do
			if not Child:IsA("UIListLayout") then
				Child:Destroy()
			end
		end

		table.clear(Chat.History)
		MessageCount = 0
	end

	local function Greet()
		AddMessage(
			Settings.Name or "AI Assistant",
			Settings.Greeting or "Hey! Ask me anything about this game or the menu.",
			false
		)
	end

	-- Slides in from the right edge of the window, the same way the rest of the panel
	-- animations behave, and only stops rendering once it is fully out of frame.
	function Chat:SetOpen(State: boolean)
		State = State and true or false

		if State == Chat.Open then
			return
		end

		Chat.Open = State

		if State then
			Chat.Panel.Visible = true
			TweenService:Create(Chat.Panel, SLIDE, { Position = OpenPosition }):Play()

			ScrollToBottom()
			InputBox:CaptureFocus()
		else
			InputBox:ReleaseFocus()
			TweenService:Create(Chat.Panel, SLIDE, { Position = ClosedPosition }):Play()

			task.delay(SLIDE.Time, function()
				if not Chat.Open then
					Chat.Panel.Visible = false
				end
			end)
		end
	end

	function Chat:Toggle()
		Chat:SetOpen(not Chat.Open)
	end

	function Chat:Destroy()
		Chat.Panel:Destroy()
	end

	Chat:Clear()
	Greet()

	AddSignal(SendButton.MouseButton1Click, function()
		Send(InputBox.Text)
	end)

	AddSignal(InputBox.FocusLost, function(EnterPressed)
		if EnterPressed then
			Send(InputBox.Text)
		end
	end)

	HeaderButton(ClearIcon, -32, function()
		Chat:Clear()
		Greet()
	end).Parent = Header

	HeaderButton(CloseIcon, -8, function()
		Chat:SetOpen(false)
	end).Parent = Header

	AddSignal(MessageLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		MessageHolder.CanvasSize = UDim2.fromOffset(0, MessageLayout.AbsoluteContentSize.Y)
	end)

	return Chat
end
