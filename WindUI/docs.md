# WindUI Documentation & Full Example

> WindUI Original docs: https://footagesus.github.io/WindUI-Docs/docs

---

## Table of Contents

- [Load WindUI](#load-windui)
- [Library Settings](#library-settings)
- [Themes](#themes)
- [Localization](#localization)
- [Window](#window)
- [Key System](#key-system)
- [Tab Section (Sidebar)](#tab-section-sidebar)
- [Tab](#tab)
- [Dialog](#dialog)
- [Popup](#popup)
- [Tag](#tag)
- [Notification](#notification)
- [Divider](#divider)
- [Space](#space)
- [Button](#button)
- [Code](#code)
- [Colorpicker](#colorpicker)
- [Dropdown](#dropdown)
- [Input](#input)
- [Keybind](#keybind)
- [Paragraph](#paragraph)
- [Section (Inside Tab)](#section-inside-tab)
- [Slider](#slider)
- [Toggle](#toggle)
- [Configs](#configs)
- [Icons](#icons)
- [Installation (Source)](#installation-source)
- [FAQ](#faq)
- [Full Example Script](#full-example-script)

---

## Load WindUI

Load with custom source:

```lua
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/4479cantcode/Library/refs/heads/main/WindUI/Source.lua"))()
```

Load latest official version:

```lua
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
```

Load specific version:

```lua
local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()
```

---

## Library Settings

```lua
WindUI:SetNotificationLower(true)

WindUI:SetFont("Montserrat")

WindUI:GetThemes()

WindUI:GetCurrentTheme()

WindUI:GetWindowTransparency()

WindUI:GetWindowSize()
```

---

## Themes

### Creating a Theme (Default)

```lua
WindUI:AddTheme({
    Name = "My Theme",
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#101010"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
})
```

### Creating a Theme (With Gradients)

Use `WindUI:Gradient()` for any color field:

```lua
WindUI:AddTheme({
    Name = "Gradient Theme",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1f1f23"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#18181b"), Transparency = 0 },
    }, {
        Rotation = 0,
    }),
    Background = Color3.fromHex("#101010"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
})
```

### Set Theme

```lua
WindUI:SetTheme("My Theme")
```

---

## Localization

Paste **before** `CreateWindow()`. Auto-detects user language.

```lua
WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["en"] = {
            ["HUB_TITLE"] = "My Hub",
            ["WELCOME"]   = "Welcome!",
            ["SETTINGS"]  = "Settings",
            ["FEATURES"]  = "Features",
        },
        ["ru"] = {
            ["HUB_TITLE"] = "Мой Хаб",
            ["WELCOME"]   = "Добро пожаловать!",
            ["SETTINGS"]  = "Настройки",
            ["FEATURES"]  = "Функционал",
        },
    }
})
```

### Set Language Manually

```lua
WindUI:SetLanguage("en")
```

### Usage

```lua
local Window = WindUI:CreateWindow({
    Title = "loc:HUB_TITLE",
    Author = "loc:WELCOME",
})
```

---

## Window

### Creating Window (Full)

```lua
local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "door-open",
    Author = "by Author",
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked user icon")
        end,
    },
})
```

### Creating Window (Short)

```lua
local Window = WindUI:CreateWindow({
    Title = "My Hub",
    Icon = "door-open",
    Author = "by Author",
    Folder = "MyHub",
    Theme = "Dark",
})
```

### Window Options

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `"WindUI"` |
| `Icon` | `string` | `nil` |
| `Author` | `string` | `nil` |
| `Folder` | `string` | `"WindUI"` |
| `Size?` | `UDim2` | `UDim2.fromOffset(580, 460)` |
| `MinSize?` | `Vector2` | `Vector2.new(560, 350)` |
| `MaxSize?` | `Vector2` | `Vector2.new(850, 560)` |
| `Transparent?` | `boolean` | `false` |
| `Theme?` | `string` | `"Dark"` |
| `Resizable?` | `boolean` | `true` |
| `SideBarWidth?` | `number` | `200` |
| `BackgroundImageTransparency?` | `number` | `0.42` |
| `HideSearchBar?` | `boolean` | `false` |
| `ScrollBarEnabled?` | `boolean` | `false` |
| `User?` | `table` | `nil` |
| `KeySystem?` | `table` | `nil` |

### Setting Window Properties

```lua
Window:SetBackgroundImage("rbxassetid://...")
Window:SetBackgroundImageTransparency(0.5)
Window:SetToggleKey(Enum.KeyCode.RightControl)
Window:SetTransparency(true)
Window:SetResizable(true)
```

### Edit OpenButton

```lua
Window:EditOpenButton({
    Title = "Open",
    Icon = "door-open",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 2,
    Color = Color3.fromHex("#FFFFFF"),
    Enabled = true,
})
```

### Topbar Buttons

```lua
Window:DisableTopbarButtons({"Close", "Minimize", "Maximize"})

Window:CreateTopbarButton({
    Icon = "bell",
    Callback = function()
        print("Custom button clicked")
    end,
})
```

### User Icon

```lua
Window:EnableUser()
Window:DisableUser()
Window:SetAnonymous(true)
```

### Window Actions

```lua
Window:Open()
Window:Close()
Window:Toggle()
```

### Window Triggers

```lua
Window:OnClose(function()
    print("Window closed")
end)

Window:OnOpen(function()
    print("Window opened")
end)

Window:OnDestroy(function()
    print("Window destroyed")
end)
```

### Element Management

```lua
Window:UnlockAllElements()
Window:LockAllElements()
Window:GetLockedElements()
Window:GetUnlockedElements()
Window:GetAllElements()
```

### Other

```lua
Window:SetWindowIconSize(24)
```

---

## Key System

The Key System is configured inside `CreateWindow()`.

### Using Built-in Keys

```lua
local Window = WindUI:CreateWindow({
    Title = "My Hub",
    Icon = "door-open",
    Author = "by Author",
    Folder = "MyHub",
    KeySystem = {
        Key = { "1234", "5678" },
        Note = "Get your key from our Discord!",
        Thumbnail = {
            Image = "rbxassetid://...",
            Title = "Key System",
        },
        URL = "https://discord.gg/yourserver",
        SaveKey = false,
    },
})
```

### Using API Services (PlatoBoost / Panda Development / Luarmor)

```lua
local Window = WindUI:CreateWindow({
    Title = "My Hub",
    Folder = "MyHub",
    KeySystem = {
        Note = "Get your key below.",
        API = {
            {
                Title = "Platoboost",
                Desc = "Click to copy.",
                Icon = "rbxassetid://...",
                Type = "platoboost",
                ServiceId = 1234,
                Secret = "platoboost-secret",
            },
            {
                Type = "pandadevelopment",
                ServiceId = "myServiceId",
            },
        },
    },
})
```

### KeySystem Options

| Prop | Type | Default |
|---|---|---|
| `Key?` | `table` | `nil` |
| `Note` | `string` | `nil` |
| `Thumbnail?` | `table` | `nil` |
| `URL?` | `string` | `nil` |
| `SaveKey?` | `boolean` | `false` |
| `API?` | `table` | `nil` |

### Adding Custom Key Services

```lua
WindUI.Services.mycustomservice = {
    Name = "My Custom Service",
    Icon = "droplet",
    Args = { "ServiceId" },
    New = function(ServiceId)
        function validateKey(key)
            if not key then
                return false, "Key is invalid!"
            end
            return true, "Key is valid!"
        end
        function copyLink()
            return setclipboard("https://your-key-link.com")
        end
        return {
            Verify = validateKey,
            Copy = copyLink,
        }
    end
}
```

---

## Tab Section (Sidebar)

Creates collapsible sections in the sidebar to organize tabs.

```lua
local Section = Window:Section({
    Title = "Section Title",
    Icon = "bird",
    Opened = true,
})
```

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `"Section"` |
| `Icon?` | `string` | `nil` |
| `Opened?` | `boolean` | `true` |

---

## Tab

```lua
local Tab = Window:Tab({
    Title = "Tab Title",
    Icon = "bird",
    Locked = false,
})
```

### Select Tab

```lua
Tab:Select()
```

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `"Tab"` |
| `Icon?` | `string` | `nil` |
| `Locked?` | `boolean` | `false` |

---

## Dialog

```lua
local Dialog = Window:Dialog({
    Icon = "bird",
    Title = "Dialog Title",
    Content = "Content Text",
    Buttons = {
        {
            Title = "Confirm",
            Callback = function()
                print("Confirmed!")
            end,
        },
        {
            Title = "Cancel",
            Callback = function()
                print("Cancelled!")
            end,
        },
    },
})
```

### Show / Close

```lua
Dialog:Show()
Dialog:Close()
```

### Dialog Options

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `"Dialog"` |
| `Icon?` | `string` | `nil` |
| `IconThemed?` | `boolean` | `false` |
| `Content` | `string` | `nil` |
| `Buttons` | `table` | `{}` |

### Button Options (inside Dialog)

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `"Button"` |
| `Icon?` | `string` | `nil` |
| `Variant?` | `string` | `"Primary"` |
| `Callback?` | `function` | `nil` |

---

## Popup

```lua
WindUI:Popup({
    Title = "Popup Title",
    Icon = "info",
    Content = "Popup content",
    Buttons = {
        {
            Title = "Cancel",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Callback = function() end,
            Variant = "Primary",
        },
    },
})
```

---

## Tag

```lua
Window:Tag({
    Title = "v1.6.6",
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 0,
})
```

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `""` |
| `Icon?` | `string` | `nil` |
| `Color?` | `Color3` | `nil` |
| `Radius?` | `number` | `0` (0 to 13) |

---

## Notification

```lua
WindUI:Notify({
    Title = "Notification Title",
    Content = "Notification Content example!",
    Duration = 3,
    Icon = "bird",
})
```

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `"Notification"` |
| `Content` | `string` | `""` |
| `Duration?` | `number` | `3` |
| `Icon?` | `string` | `nil` |

---

## Divider

Can be used in both Window (sidebar) and Tab (content area).

```lua
Window:Divider()
Tab:Divider()
```

---

## Space

Can be used in both Window (sidebar) and Tab (content area).

```lua
Window:Space()
Tab:Space()
```

---

## Button

```lua
local Button = Tab:Button({
    Title = "Button",
    Desc = "Test Button",
    Locked = false,
    Callback = function()
        print("Button clicked")
    end,
})
```

### Methods

```lua
Button:SetTitle("New Title")
Button:SetDesc("New Description")
Button:Lock()
Button:Unlock()
Button:Destroy()
```

---

## Code

```lua
local Code = Tab:Code({
    Title = "Code",
    Code = [[print("Hello World!")]],
})
```

### Methods

```lua
Code:SetCode([[print("New code!")]])
Code:Destroy()
Code:OnCopy(function()
    print("Code copied!")
end)
```

---

## Colorpicker

```lua
local Colorpicker = Tab:Colorpicker({
    Title = "Colorpicker",
    Desc = "Pick a color",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        print("Color: " .. tostring(color))
    end,
})
```

### Methods

```lua
Colorpicker:SetTitle("New Title")
Colorpicker:SetDesc("New Description")
Colorpicker:Lock()
Colorpicker:Unlock()
Colorpicker:Destroy()
```

---

## Dropdown

### Multi Dropdown

```lua
local Dropdown = Tab:Dropdown({
    Title = "Dropdown (Multi)",
    Desc = "Pick categories",
    Values = { "Category A", "Category B", "Category C" },
    Value = { "Category A" },
    Multi = true,
    AllowNone = true,
    Callback = function(option)
        print(game:GetService("HttpService"):JSONEncode(option))
    end,
})
```

### Single Dropdown

```lua
local Dropdown = Tab:Dropdown({
    Title = "Dropdown",
    Desc = "Pick one",
    Values = { "Option A", "Option B", "Option C" },
    Value = "Option A",
    Multi = false,
    Callback = function(option)
        print(option)
    end,
})
```

### Methods

```lua
Dropdown:SetTitle("New Title")
Dropdown:SetDesc("New Description")

Dropdown:Select("Option B")
Dropdown:Select({"Option B", "Option C"})

Dropdown:Refresh({ "New A", "New B" })
Dropdown:Lock()
Dropdown:Unlock()
Dropdown:Destroy()
```

---

## Input

```lua
local Input = Tab:Input({
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input",
    Placeholder = "Enter text...",
    Callback = function(input)
        print("text entered: " .. input)
    end,
})
```

`Type` can be `"Input"` or `"Textarea"`.

### Methods

```lua
Input:SetTitle("New Title")
Input:SetDesc("New Description")
Input:Set("New value")
Input:SetPlaceholder("New Placeholder")
Input:Lock()
Input:Unlock()
Input:Destroy()
```

---

## Keybind

```lua
local Keybind = Tab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open UI",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end,
})
```

### Methods

```lua
Keybind:SetTitle("New Title")
Keybind:SetDesc("New Description")
Keybind:Lock()
Keybind:Unlock()
Keybind:Destroy()
```

---

## Paragraph

```lua
local Paragraph = Tab:Paragraph({
    Title = "Paragraph Title",
    Desc = "Paragraph description text",
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "bird",
            Title = "Button",
            Callback = function()
                print("Paragraph button clicked")
            end,
        },
    },
})
```

### Methods

```lua
Paragraph:SetTitle("New Title")
Paragraph:SetDesc("New Description")
Paragraph:SetImage("rbxassetid://...", 30)
Paragraph:SetThumbnail("rbxassetid://...", 80)
Paragraph:Destroy()
```

### Paragraph Colors

Available color strings: `"Red"`, `"Green"`, `"Blue"`, `"Yellow"`, `"Orange"`, `"Purple"`, `"Cyan"`, `"White"`, `"Black"`

---

## Section (Inside Tab)

Creates a collapsible section within a tab to group elements.

```lua
local Section = Tab:Section({
    Title = "Section",
    Box = false,
    FontWeight = "SemiBold",
    TextTransparency = 0.05,
    TextXAlignment = "Left",
    TextSize = 17,
    Opened = true,
})
```

### Short Version

```lua
local Section = Tab:Section({ Title = "Section" })
```

### Methods

```lua
Section:SetTitle("New Title")
Section:Destroy()
```

### Adding Elements Inside Section

```lua
Section:Button({ Title = "Inside Section", Callback = function() end })
Section:Toggle({ Title = "Section Toggle", Callback = function(v) end })
```

---

## Slider

```lua
local Slider = Tab:Slider({
    Title = "Slider",
    Desc = "Slider Description",
    Step = 1,
    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        print(value)
    end,
})
```

For float support, set `Step` to a float (e.g., `Step = 0.1`).

### Methods

```lua
Slider:SetTitle("New Title")
Slider:SetDesc("New Description")
Slider:Set(42)
Slider:SetMax(200)
Slider:SetMin(10)
Slider:Lock()
Slider:Unlock()
Slider:Destroy()
```

### Slider Options

| Prop | Type | Default |
|---|---|---|
| `Title` | `string` | `"Slider"` |
| `Desc?` | `string` | `nil` |
| `Step?` | `number` | `1` |
| `Value` | `table` | `{}` |
| `Callback` | `function` | `nil` |
| `Locked?` | `boolean` | `false` |

### Value Options

| Prop | Type |
|---|---|
| `Min` | `number` |
| `Max` | `number` |
| `Default` | `number` |

---

## Toggle

```lua
local Toggle = Tab:Toggle({
    Title = "Toggle",
    Desc = "Toggle Description",
    Icon = "bird",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        print("Toggle: " .. tostring(state))
    end,
})
```

### Methods

```lua
Toggle:SetTitle("New Title")
Toggle:SetDesc("New Description")
Toggle:Set(true)
Toggle:Lock()
Toggle:Unlock()
Toggle:Destroy()
```

---

## Configs

### Setup

```lua
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("myConfigExample")
```

### Register Elements (Flag Method)

```lua
Tab:Toggle({
    Title = "Toggle",
    Desc = "Config Test Toggle",
    Flag = "ToggleElement",
    Callback = function(v)
        print("Toggle Changed: " .. tostring(v))
    end,
})
```

### Register Elements (Manual)

```lua
myConfig:Register("SpecialName", Element)
```

### Save / Load / Delete

```lua
myConfig:Save()
myConfig:Load()
myConfig:Delete()
```

### Get All Config Files

```lua
ConfigManager:AllConfigs()
```

Config files are saved at:
`{Executor}/Workspace/WindUI/{Folder}/config/{ConfigName}.json`

---

## Icons

WindUI supports three icon libraries:

- **Lucide Icons** — https://lucide.dev
- **Geist Icons** — https://vercel.com/geist/icons
- **Craft Icons** — https://www.figma.com/community/file/1415718327120418204

### Usage

```lua
local Icon = "lucide:bird"
local Icon = "geist:window"
local Icon = "craft:macbook-stroke"
```

You can also use just the icon name (defaults to Lucide):

```lua
local Icon = "bird"
```

Or use `rbxassetid://` for Roblox asset IDs.

---

## Installation (Source)

For contributors who want to build WindUI from source:

```bash
git clone https://github.com/Footagesus/WindUI.git
cd WindUI
npm install
aftman install
```

Build commands:

```bash
npm run dev
npm run build
npm run live-build
```

Live-build serves at `http://localhost:8642`. Load in Roblox:

```lua
loadstring(game:HttpGet("http://localhost:8642/dist/main.lua"))()
```

---

## FAQ

**What is WindUI?**
A modern, customizable UI library for Roblox with many elements, key system support, themes, localization, and configs.

**How to lock elements?**
Use `:Lock()` on any element. Use `:Unlock()` to re-enable.

**How to colorize custom icons?**
Set `IconThemed = true` on elements that support it.

**How to disable OpenButton?**
In `Window:EditOpenButton()`, set `Enabled = false`.

---

## Full Example Script

A complete script showcasing every WindUI feature using the 4479Hub loader:

```lua
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/4479cantcode/Library/refs/heads/main/WindUI/Source.lua"))()

WindUI:AddTheme({
    Name = "4479 Theme",
    Accent = Color3.fromHex("#1a1a2e"),
    Background = Color3.fromHex("#0f0f1a"),
    Outline = Color3.fromHex("#e94560"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#16213e"),
    Icon = Color3.fromHex("#e94560"),
})

WindUI:SetTheme("4479 Theme")

local Window = WindUI:CreateWindow({
    Title = "4479Hub",
    Icon = "door-open",
    Author = "by 4479",
    Folder = "4479Hub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "4479 Theme",
    SideBarWidth = 200,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("User icon clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "4479Hub",
    Icon = "door-open",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 2,
    Color = Color3.fromHex("#e94560"),
    Enabled = true,
})

Window:Tag({
    Title = "v1.0.0",
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 6,
})

local MainSection = Window:Section({
    Title = "Main",
    Icon = "home",
    Opened = true,
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home",
})

Window:Divider()

local CombatSection = Window:Section({
    Title = "Combat",
    Icon = "swords",
    Opened = true,
})

local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "swords",
})

local FarmTab = Window:Tab({
    Title = "Farming",
    Icon = "wheat",
})

Window:Divider()

local MiscSection = Window:Section({
    Title = "Miscellaneous",
    Icon = "settings",
    Opened = true,
})

local VisualsTab = Window:Tab({
    Title = "Visuals",
    Icon = "eye",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

MainTab:Select()

MainTab:Paragraph({
    Title = "Welcome to 4479Hub",
    Desc = "A powerful script hub for Roblox games.",
    Color = "Blue",
})

MainTab:Space()

MainTab:Button({
    Title = "Print Hello",
    Desc = "Prints hello to the console",
    Callback = function()
        print("Hello from 4479Hub!")
    end,
})

MainTab:Divider()

MainTab:Toggle({
    Title = "Auto Farm",
    Desc = "Enables automatic farming",
    Icon = "wheat",
    Value = false,
    Flag = "AutoFarm",
    Callback = function(state)
        print("Auto Farm: " .. tostring(state))
    end,
})

MainTab:Toggle({
    Title = "God Mode",
    Desc = "Makes you invincible",
    Type = "Checkbox",
    Value = false,
    Flag = "GodMode",
    Callback = function(state)
        print("God Mode: " .. tostring(state))
    end,
})

MainTab:Slider({
    Title = "Walk Speed",
    Desc = "Adjust your walk speed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 500,
        Default = 16,
    },
    Flag = "WalkSpeed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value;
    end,
})

MainTab:Slider({
    Title = "Jump Power",
    Desc = "Adjust your jump power",
    Step = 1,
    Value = {
        Min = 50,
        Max = 500,
        Default = 50,
    },
    Flag = "JumpPower",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value;
    end,
})

MainTab:Dropdown({
    Title = "Teleport Location",
    Desc = "Choose where to teleport",
    Values = { "Spawn", "Shop", "Boss Area", "Secret Zone" },
    Value = "Spawn",
    Multi = false,
    Flag = "TeleportLocation",
    Callback = function(option)
        print("Teleporting to: " .. option)
    end,
})

MainTab:Input({
    Title = "Player Name",
    Desc = "Enter a player name to teleport to",
    Value = "",
    Placeholder = "Enter username...",
    Type = "Input",
    Flag = "PlayerNameInput",
    Callback = function(input)
        print("Teleporting to player: " .. input)
    end,
})

MainTab:Keybind({
    Title = "Toggle UI",
    Desc = "Set a keybind to toggle the UI",
    Value = "RightControl",
    Flag = "ToggleKeybind",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end,
})

MainTab:Code({
    Title = "Loadstring",
    Code = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/4479cantcode/Library/refs/heads/main/WindUI/Source.lua"))()]],
})

CombatTab:Section({ Title = "Aimbot Settings" })

CombatTab:Toggle({
    Title = "Aimbot",
    Desc = "Locks aim to nearest enemy",
    Value = false,
    Flag = "Aimbot",
    Callback = function(state)
        print("Aimbot: " .. tostring(state))
    end,
})

CombatTab:Slider({
    Title = "FOV Radius",
    Desc = "Aimbot field of view",
    Step = 5,
    Value = {
        Min = 50,
        Max = 800,
        Default = 200,
    },
    Flag = "FOVRadius",
    Callback = function(value)
        print("FOV: " .. value)
    end,
})

CombatTab:Dropdown({
    Title = "Aim Part",
    Desc = "Which body part to aim at",
    Values = { "Head", "HumanoidRootPart", "Torso" },
    Value = "Head",
    Multi = false,
    Flag = "AimPart",
    Callback = function(option)
        print("Aim Part: " .. option)
    end,
})

CombatTab:Divider()

CombatTab:Section({ Title = "Attack Settings" })

CombatTab:Toggle({
    Title = "Auto Attack",
    Desc = "Automatically attacks nearby enemies",
    Value = false,
    Flag = "AutoAttack",
    Callback = function(state)
        print("Auto Attack: " .. tostring(state))
    end,
})

FarmTab:Toggle({
    Title = "Auto Quest",
    Desc = "Automatically accepts and completes quests",
    Value = false,
    Flag = "AutoQuest",
    Callback = function(state)
        print("Auto Quest: " .. tostring(state))
    end,
})

FarmTab:Dropdown({
    Title = "Farm Mode",
    Desc = "Select farming strategy",
    Values = { "Nearest", "Strongest", "Weakest", "Boss Only" },
    Value = "Nearest",
    Multi = false,
    Flag = "FarmMode",
    Callback = function(option)
        print("Farm Mode: " .. option)
    end,
})

FarmTab:Dropdown({
    Title = "Selected Mobs",
    Desc = "Choose which mobs to farm",
    Values = { "Bandits", "Pirates", "Marines", "Bosses" },
    Value = { "Bandits" },
    Multi = true,
    AllowNone = true,
    Flag = "SelectedMobs",
    Callback = function(option)
        print("Mobs: " .. game:GetService("HttpService"):JSONEncode(option))
    end,
})

FarmTab:Toggle({
    Title = "Bring Mobs",
    Desc = "Teleports mobs to you",
    Value = false,
    Flag = "BringMobs",
    Callback = function(state)
        print("Bring Mobs: " .. tostring(state))
    end,
})

VisualsTab:Toggle({
    Title = "ESP",
    Desc = "Shows player locations through walls",
    Value = false,
    Flag = "ESP",
    Callback = function(state)
        print("ESP: " .. tostring(state))
    end,
})

VisualsTab:Colorpicker({
    Title = "ESP Color",
    Desc = "Choose ESP highlight color",
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0,
    Flag = "ESPColor",
    Callback = function(color)
        print("ESP Color: " .. tostring(color))
    end,
})

VisualsTab:Toggle({
    Title = "Fullbright",
    Desc = "Removes all darkness",
    Value = false,
    Flag = "Fullbright",
    Callback = function(state)
        if state then
            game:GetService("Lighting").Brightness = 2;
            game:GetService("Lighting").FogEnd = 100000;
        else
            game:GetService("Lighting").Brightness = 1;
            game:GetService("Lighting").FogEnd = 5000;
        end
    end,
})

VisualsTab:Slider({
    Title = "Field of View",
    Desc = "Adjust camera FOV",
    Step = 1,
    Value = {
        Min = 30,
        Max = 120,
        Default = 70,
    },
    Flag = "CameraFOV",
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value;
    end,
})

SettingsTab:Paragraph({
    Title = "4479Hub Settings",
    Desc = "Configure your hub preferences below.",
})

SettingsTab:Dropdown({
    Title = "Theme",
    Desc = "Change the UI theme",
    Values = (function()
        local themes = {};
        for name, _ in pairs(WindUI:GetThemes()) do
            table.insert(themes, name);
        end
        return themes;
    end)(),
    Value = "4479 Theme",
    Multi = false,
    Callback = function(option)
        WindUI:SetTheme(option)
    end,
})

SettingsTab:Toggle({
    Title = "Transparent Background",
    Desc = "Toggle window transparency",
    Value = true,
    Callback = function(state)
        Window:SetTransparency(state)
    end,
})

SettingsTab:Keybind({
    Title = "Toggle Keybind",
    Desc = "Change the UI toggle key",
    Value = "RightControl",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end,
})

SettingsTab:Input({
    Title = "Webhook URL",
    Desc = "Enter your Discord webhook URL",
    Value = "",
    Placeholder = "https://discord.com/api/webhooks/...",
    Type = "Input",
    Callback = function(input)
        print("Webhook set: " .. input)
    end,
})

SettingsTab:Divider()

SettingsTab:Section({ Title = "Config System" })

local ConfigManager = Window.ConfigManager;
local DefaultConfig = ConfigManager:CreateConfig("Default");

SettingsTab:Button({
    Title = "Save Config",
    Desc = "Save current settings",
    Callback = function()
        DefaultConfig:Save();
        WindUI:Notify({
            Title = "Config",
            Content = "Config saved!",
            Duration = 3,
            Icon = "check",
        });
    end,
})

SettingsTab:Button({
    Title = "Load Config",
    Desc = "Load saved settings",
    Callback = function()
        DefaultConfig:Load();
        WindUI:Notify({
            Title = "Config",
            Content = "Config loaded!",
            Duration = 3,
            Icon = "check",
        });
    end,
})

SettingsTab:Button({
    Title = "Delete Config",
    Desc = "Delete saved config file",
    Callback = function()
        DefaultConfig:Delete();
        WindUI:Notify({
            Title = "Config",
            Content = "Config deleted!",
            Duration = 3,
            Icon = "trash",
        });
    end,
})

SettingsTab:Divider()

SettingsTab:Button({
    Title = "Destroy Hub",
    Desc = "Completely removes the UI",
    Callback = function()
        Window:Close();
    end,
})

local Dialog = Window:Dialog({
    Icon = "info",
    Title = "Welcome",
    Content = "Welcome to 4479Hub! Enjoy the features.",
    Buttons = {
        {
            Title = "Got it!",
            Variant = "Primary",
            Callback = function() end,
        },
    },
})
Dialog:Show();

WindUI:Notify({
    Title = "4479Hub Loaded",
    Content = "Hub loaded successfully!",
    Duration = 5,
    Icon = "check",
})
```
