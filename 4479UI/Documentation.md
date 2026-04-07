# 4479UI Library Documentation

**Version:** v4.0  
**File:** `4479UI.lua`  
**Lines:** 2766  
**Returns:** `Update` table

---

## Overview

4479UI is a custom Roblox UI library for script hubs. It provides a full windowed interface with tabs, controls, notifications, executor detection, loading screens, config persistence, and Discord webhook integration. All UI elements auto-scale for mobile (0.5x) when `TouchEnabled` and no keyboard is detected.

---

## Global Color Variables

Set these before creating a window to theme the UI.

| Variable | Default | Purpose |
|---|---|---|
| `_G.Primary` | `Color3.fromRGB(100, 100, 100)` | Accent / element backgrounds |
| `_G.Dark` | `Color3.fromRGB(22, 22, 26)` | Dark background color |
| `_G.Third` | `Color3.fromRGB(128, 0, 255)` | Purple highlight / toggle-on color |

---

## Module Return: `Update`

The library returns a table called `Update`. All top-level methods are called on this table.

---

## Notifications

### `Update:Notify(desc)`

Shows a Discord-style stacking notification at the top-center of the screen.

| Param | Type | Description |
|---|---|---|
| `desc` | `string` | Notification message text |

- Max 5 visible at once (oldest auto-dismissed when exceeded)
- Each notification has a 3-second countdown progress bar
- Slides in from above, slides out upward on dismiss
- Displays the 4479Hub icon and title

### `Update:CreateLoadingNotification()`

Creates a persistent loading notification in the bottom-right corner with a spinning logo and animated "Loading..." text.

**Returns:** `notifObject` table

| Method | Description |
|---|---|
| `notifObject:SetStatus(status)` | Sets the subtitle/status text below "Loading..." |
| `notifObject:Close()` | Slides out and destroys the notification |

### `Update:ShowLoadedNotification()`

Shows a "Loaded Successfully!" notification in the bottom-right corner with a green check badge on the logo. Auto-dismisses after 3 seconds.

### `Update:ShowWarningNotification()`

Shows an "EXECUTOR UNSUPPORTED" warning notification in the top-right corner with a purple accent bar. Includes a message to join Discord. Auto-dismisses after 10 seconds with a progress bar.

### `Update:ShowTeamNotification()`

Shows a top-center notification saying "Choose team before loading the script" with a purple stroke. Does not auto-dismiss.

**Returns:** The `ScreenGui` instance (destroy it manually when done).

---

## Discord Webhook

### `Update:SetDiscordNotifInterval(seconds)`

Sets the minimum interval (in seconds) between Discord webhook sends. Default is `60`.

### `Update:CanSendDiscordNotif()`

Returns `true` if enough time has passed since the last webhook send, based on the interval set above. Also updates the internal timestamp.

### `Update:DiscordNotify(desc, webhookUrl, embedData)`

Sends a notification both in-game (via `Update:Notify`) and to a Discord webhook.

| Param | Type | Description |
|---|---|---|
| `desc` | `string` | Message text (used for in-game notif and as fallback `content`) |
| `webhookUrl` | `string` | Discord webhook URL |
| `embedData` | `table` (optional) | Custom JSON payload; if nil, sends `{content = desc}` |

**Returns:** `true` if sent, `false` if rate-limited.

Uses `request`, `http_request`, or `syn.request` (whichever is available).

---

## Executor Detection

### `Update:GetExecutorInfo(runTests)`

Detects the executor and determines support status. Optionally runs the full UNC/sUNC/rUNC/cUNC/input/misc capability audit.

| Param | Type | Default | Description |
|---|---|---|---|
| `runTests` | `bool` | `false`/`nil` | When `true`, runs all 6 check categories and populates percentages + `allChecks` |

**Returns:** `info` table

| Field | Type | Description |
|---|---|---|
| `name` | `string` | Executor name via `identifyexecutor` / `getexecutorname` |
| `isSupported` | `bool` | Whether the executor passes core requirements (or was manually overridden) |
| `supportsLuau` | `bool` | Whether typed Luau / if-then-else syntax works in `loadstring` |
| `hasCoreAPIs` | `bool` | `hookmetamethod`, `hookfunction`, `newcclosure`, `checkcaller`, `getnamecallmethod` all exist |
| `identityLevel` | `number` | Thread identity level |
| `uncPercent` | `number` | UNC compliance percentage (0-100). **0 if `runTests` is false** |
| `suncPercent` | `number` | Script environment compliance percentage. **0 if `runTests` is false** |
| `runcPercent` | `number` | Bytecode/proto compliance percentage. **0 if `runTests` is false** |
| `cuncPercent` | `number` | Hooking/closures compliance percentage. **0 if `runTests` is false** |
| `inputPercent` | `number` | Input simulation compliance percentage. **0 if `runTests` is false** |
| `miscPercent` | `number` | Misc functions compliance percentage. **0 if `runTests` is false** |
| `allChecks` | `table` | Detailed breakdown per category: `{checks, passed, total}`. **Empty if `runTests` is false** |

**Always resolved** (regardless of `runTests`): `name`, `isSupported`, `supportsLuau`, `hasCoreAPIs`, `identityLevel`.

**Support resolution order:**

1. If the executor name has a manual override (via `SetExecutorSupported`), that override wins
2. Otherwise, auto-detection requires: `hasCoreAPIs == true`, `supportsLuau == true`, `require` available, and `hookfunction` available

```lua
local info = Update:GetExecutorInfo()
print(info.name, info.isSupported)

local fullInfo = Update:GetExecutorInfo(true)
print(fullInfo.uncPercent .. "% UNC")
```

### `Update:IsUnsupportedExecutor()`

Shorthand. Calls `GetExecutorInfo()` without tests. Returns `true` if the executor is **not** supported.

### `Update:ShowUnsupportedPopup(discordLink)`

Shows a modal popup warning about unsupported executor with:

- Close (✕) and Continue (✓) buttons
- "Copy Discord Link" button (defaults to `https://discord.gg/2GvW9kgzBj`)
- "Don't show popup for 12 hours" checkbox (persisted via `writefile`)

**Returns:** `true` if user chose to continue, `false` if closed. Yields until a choice is made. If suppressed via the 12-hour preference, returns `true` immediately.

---

## Executor Overrides

Manual overrides let you force any executor to be treated as supported or unsupported, bypassing auto-detection. Overrides are stored in `Update._executorOverrides` (keyed by lowercase executor name). They take priority over auto-detection in `GetExecutorInfo`.

### `Update:SetExecutorSupported(name, supported)`

Sets a manual override for a specific executor.

| Param | Type | Description |
|---|---|---|
| `name` | `string` | Executor name (case-insensitive) |
| `supported` | `bool` | `true` to force supported, `false` to force unsupported |

```lua
Update:SetExecutorSupported("Wave", true)
Update:SetExecutorSupported("SomeJunk", false)
```

### `Update:RemoveExecutorOverride(name)`

Removes a single override so the executor falls back to auto-detection.

| Param | Type | Description |
|---|---|---|
| `name` | `string` | Executor name (case-insensitive) |

```lua
Update:RemoveExecutorOverride("Wave")
```

### `Update:ClearExecutorOverrides()`

Wipes all manual overrides. Every executor reverts to auto-detection.

```lua
Update:ClearExecutorOverrides()
```

---

## Executor Tests

### `Update:RunExecutorTests()`

Runs a comprehensive UNC/sUNC/rUNC/cUNC/Input/Misc/Clipboard/WebRequest test suite. Logs results line-by-line.

**Returns:** `result` table

| Method | Description |
|---|---|
| `result:ToClipboard()` | Copies full test log to clipboard via `setclipboard` |
| `result:GetLines()` | Returns the array of log strings |

**Categories tested:**

- **UNC** (35 checks): `cache`, `cloneref`, `compareinstances`, `fireclickdetector`, `fireproximityprompt`, `firetouchinterest`, `getcallingscript`, `getconnections`, `getcustomasset`, `gethiddenproperty`, `gethui`, `getinstances`, `getloadedmodules`, `getnamecallmethod`, `getnilinstances`, `getrawmetatable`, `getscriptbytecode`, `getscriptclosure`, `getscripthash`, `getthreadidentity`, `hookfunction`, `hookmetamethod`, `identifyexecutor`, `iscclosure`, `islclosure`, `isreadonly`, `loadstring`, `newcclosure`, `checkcaller`, `readfile`, `writefile`, `isfile`, `isfolder`, `makefolder`, `delfile`, `delfolder`, `listfiles`, `setclipboard`, `setrawmetatable`, `setreadonly`, `setthreadidentity`, `request`, `Drawing`, `debug`, `crypt`
- **sUNC** (12 checks): Script environment functions
- **rUNC** (13 checks): Bytecode/proto/debug functions
- **cUNC** (14 checks): Hooking/closure functions
- **Input** (12 checks): Mouse/keyboard simulation
- **Misc** (15 checks): `saveinstance`, `setfpscap`, `firesignal`, etc.
- **Clipboard/File** (12 checks): File I/O functions
- **WebRequest** (4 checks): HTTP request functions

---

## Loading Screen

### `Update:StartLoad()`

Creates a full-screen dark loading overlay with:

- Pulsing purple logo ring
- "4479 Hub" title
- "Loading..." animated subtitle with dots
- Animated progress bar (fills to 30% initially)
- "v4.0" version label in bottom-right

Registers `Update:Loaded()` internally.

### `Update:Loaded()`

Available only after `StartLoad()`. Triggers the progress bar to fill to 100%, then fades out the loading screen and destroys it.

---

## Config Persistence

On require, the library auto-creates folder structure `4479Hub/Library/` and loads or creates a per-player JSON config file.

### Globals registered:

| Function | Description |
|---|---|
| `getgenv().LoadConfig()` | Loads settings from `4479Hub/Library/<PlayerName>.json` |
| `getgenv().SaveConfig()` | Saves current settings to the same file |

### Library settings (persisted):

| Key | Default | Description |
|---|---|---|
| `SaveSettings` | `true` | Whether to persist settings |
| `LoadAnimation` | `true` | Whether to show loading animation |

### `Update:SaveSettings()`

Returns `true` if save-settings is enabled.

### `Update:LoadAnimation()`

Returns `true` if loading animation is enabled.

---

## Helper Functions (Internal)

These are defined at the top level and used internally throughout the library.

| Function | Description |
|---|---|
| `CreateRounded(Parent, Size)` | Adds a `UICorner` with the given pixel radius (auto-scaled) |
| `CreateGradient(Parent)` | Adds a 45° dark gradient (`UIGradient`) to a frame |
| `MakeDraggable(topbarobject, object)` | Makes `object` draggable by holding `topbarobject` (smooth tween at 0.15s) |
| `scaleUDim2(udim2)` | Scales offset values by `scaleFactor` (1 on desktop, 0.5 on mobile) |
| `scaleNumber(num)` | Scales a number by `scaleFactor` |

---

## Usage Example

```lua
local Update = loadstring(game:HttpGet("your_url_here"))()

Update:SetExecutorSupported("Wave", true)
Update:SetExecutorSupported("SomeJunk", false)

if Update:IsUnsupportedExecutor() then
    Update:ShowWarningNotification()
    local continue = Update:ShowUnsupportedPopup()
    if not continue then return end
end

if Update:LoadAnimation() then
    Update:StartLoad()
    task.wait(2)
    Update:Loaded()
    task.wait(1)
end

local Window = Update:Window({
    SubTitle = "v4.0",
    Size = UDim2.new(0, 500, 0, 350),
    TabWidth = 130
})

local MainTab = Window:Tab("Main", "rbxassetid://ICON_ID")

MainTab:Toggle("Auto Farm", false, "Farms automatically", function(state)
    print("Toggled:", state)
end)

MainTab:Button("Click Me", function()
    Update:Notify("Button clicked!")
end)
```
YES THIS IS AI.
