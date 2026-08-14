local Window = Library:CreateWindow{
    Title = `Fluent {Library.Version}`,
    SubTitle = "local test build",
    Icon = "sparkles",
    TabWidth = 150,
    Size = UDim2.fromOffset(580, 460), -- Same as WindUI's startup size
    Resize = false,
    MinSize = Vector2.new(380, 300),
    Acrylic = true,
    Theme = "Dark Purple",
    MinimizeKey = Enum.KeyCode.RightControl,

    AutoSave = true,
    ConfigFolder = "FluentRenewedTest",

    AI = {
        Enabled = true,
        Name = "Assistant",
        Key = ""
    }
}

local Tabs = {
    Main = Window:CreateTab{ Title = "Main", Icon = "zap" },
    Dropdowns = Window:CreateTab{ Title = "Dropdowns", Icon = "chevron-down" },
    Settings = Window:CreateTab{ Title = "Settings", Icon = "settings" }
}

local Options = Library.Options

Tabs.Main:CreateParagraph("Info", {
    Title = "What to check",
    Content = "Window opens at 580x460.\n"
        .. "Titlebar minimize collapses it to the button bar.\n"
        .. "The icon on the left hides everything, drag it to move it.\n"
        .. "The bot icon on the titlebar opens the AI panel.\n"
        .. "Flip some options, rerun the script, they should come back."
})

Tabs.Main:CreateToggle("TestToggle", {
    Title = "Toggle",
    Description = "Turn me on, rerun the script, I should still be on",
    Default = false,
    Callback = function(Value)
        print("Toggle:", Value)
    end
})

Tabs.Main:CreateSlider("TestSlider", {
    Title = "Slider",
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print("Slider:", Value)
    end
})

Tabs.Main:CreateInput("TestInput", {
    Title = "Input",
    Default = "",
    Placeholder = "type something"
})

Tabs.Main:CreateKeybind("TestKeybind", {
    Title = "Keybind",
    Mode = "Toggle",
    Default = "LeftAlt"
})

Tabs.Main:CreateColorpicker("TestColorpicker", {
    Title = "Colorpicker",
    Default = Color3.fromRGB(168, 85, 247)
})

Tabs.Main:CreateButton{
    Title = "Notification",
    Description = "Fires a test notification",
    Callback = function()
        Library:Notify{
            Title = "Fluent",
            Content = "Notifications work",
            SubContent = "Dark Purple",
            Duration = 4
        }
    end
}

-- The dropdown fix is the thing worth hammering here: open each one, click around the
-- top of the list, pick values, click outside to close.
Tabs.Dropdowns:CreateDropdown("SingleDropdown", {
    Title = "Single select",
    Description = "Should stay open until you click outside it",
    Values = {"one", "two", "three", "four", "five", "six", "seven", "eight"},
    Multi = false,
    Default = 1
})

Tabs.Dropdowns:CreateDropdown("MultiDropdown", {
    Title = "Multi select",
    Description = "Pick several without it closing",
    Values = {"alpha", "beta", "gamma", "delta", "epsilon", "zeta", "eta", "theta"},
    Multi = true,
    Default = {"beta"}
})

Tabs.Dropdowns:CreateDropdown("SearchDropdown", {
    Title = "Searchable",
    Values = (function()
        local Values = {}

        for Index = 1, 60 do
            Values[Index] = `option {Index}`
        end

        return Values
    end)(),
    Searchable = true,
    Multi = false
})

Tabs.Dropdowns:CreateDropdown("LongDropdown", {
    Title = "Long list",
    Description = "Placed low on purpose, this one opens upwards",
    Values = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"},
    Multi = false
})

Library.Config:BuildSection(Tabs.Settings)

Tabs.Settings:CreateButton{
    Title = "Print saved options",
    Callback = function()
        for Idx, Option in next, Options do
            if typeof(Option) == "table" and Option.Type then
                print(Idx, Option.Type, Option.Value)
            end
        end
    end
}

Tabs.Settings:CreateButton{
    Title = "Unload",
    Callback = Library.Destroy
}

Window:SelectTab(1)

Library:Notify{
    Title = "Fluent",
    Content = "Test build loaded",
    Duration = 5
}
