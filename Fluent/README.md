# Fluent Renewed

![Fluent Renewed Title](Assets/darkmode.png#gh-dark-mode-only)
![Fluent Renewed Title](Assets/darkmode.png#gh-light-mode-only)

## ⚡ Features

- Modern design
- Many customization options
- Almost any UI Element you would ever need

## 🔌 Installation

You can load Fluent through a GitHub Release:

```lua
local Library = loadstring(game:GetService("HttpService"):GetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau", true))()
```

```lua
local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau", true))()
```

## 📜 Usage

[Example Script the studio environment](https://github.com/ActualMasterOogway/Fluent-Renewed/blob/master/Example.client.luau)

[Example Script for an exploit environment](https://github.com/ActualMasterOogway/Fluent-Renewed/blob/master/Example.luau)

## 🎛️ Window options

```lua
local Window = Library:CreateWindow{
    Title = "My Hub",
    Icon = "sparkles",              -- Lucide/Phosphor name or rbxassetid://, drawn next to the title
    Size = UDim2.fromOffset(560, 400),
    MinSize = Vector2.new(380, 300),
    Theme = "Dark Purple",          -- Default theme

    AutoSave = true,                -- Remembers every option between sessions (default)
    ConfigFolder = "FluentRenewed", -- Where configs live
    ConfigName = nil,               -- Auto-save slot, defaults to "autosave_<PlaceId>"

    AI = {
        Enabled = true,
        Key = "",                   -- OpenAI compatible API key, e.g. a Groq key
        Model = "llama-3.3-70b-versatile",
        Url = "https://api.groq.com/openai/v1/chat/completions"
    }
}
```

### Auto save and configs

Every toggle, slider, dropdown, colorpicker, keybind and input is written to disk shortly
after it changes and restored the next time the script runs, so an option you turned on
stays on until you turn it off. Elements pull their saved value the moment they are built,
so it works no matter when you create them.

```lua
Library.Config:BuildSection(Tab)      -- Auto save switch + create/load/overwrite/delete configs
Library.Config:SetIgnoreIndexes{"MyTempToggle"}
Library.Config:SetAutoSave(false)
Library.Config:Save("pvp")
Library.Config:Load("pvp")
Library.Config:List()
```

### Show / hide icon

A round icon floats on the left of the screen on every platform. Tap it to hide or bring
back the interface, drag it to move it out of the way. The minimize keybind still works.

### AI assistant

The assistant lives inside the window and slides in from the right edge. Open and minimize
it with the icon on the titlebar, next to the minimize button. Without a key the chat still
opens and says what is missing.

```lua
Library:SetAIKey("gsk_...")
Library:SetAIConfig{ Model = "llama-3.1-8b-instant", SystemPrompt = "..." }
Library:ToggleAI(true)
```

## Credits

- [Master Oogway](https://github.com/ActualMasterOogway/Fluent-Renewed) - The master mind behind Fluent Renewed
- [dawid](https://github.com/dawid-scripts/Fluent) - The master mind behind Fluent
- [Lucide](https://github.com/lucide-icons), [Phosphor](https://github.com/phosphor-icons) - The sexy icons
- [richie0866/remote-spy](https://github.com/richie0866/remote-spy) - Assets for the UI, some of the code
- [violin-suzutsuki/LinoriaLib](https://github.com/violin-suzutsuki/LinoriaLib) - Code for most of the elements, save manager
- [7kayoh/Acrylic](https://github.com/7kayoh/Acrylic) - Porting richie0866's acrylic module to lua
- [Latte Softworks & Kotera](https://github.com/latte-soft/wax/) - Bundler
- [Pepsied-5229/Pepsi-UI-Library](https://github.com/Pepsied-5229/Pepsi-UI-Library) - Inspiration for new features, some of the code
