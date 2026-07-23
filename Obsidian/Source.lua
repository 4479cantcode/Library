local PrimaryUrl = "https://api.jnkie.com/api/v1/luascripts/public/83f5cfe5f8f39d308218375956af224ac1d0010c2a8e314b1042237f4c5ad51b/download"
local BackupUrl = "https://raw.githubusercontent.com/4479cantcode/Obsidian/refs/heads/main/Source.lua"

local function RunScript(Url)
    local Success, Result = pcall(function()
        local ScriptSource = game:HttpGet(Url)
        local LoadedScript, LoadError = loadstring(ScriptSource)

        if not LoadedScript then
            error(tostring(LoadError))
        end

        return LoadedScript()
    end)

    return Success, Result
end

local PrimarySuccess, PrimaryResult = RunScript(PrimaryUrl)

if PrimarySuccess then
    return PrimaryResult
end

warn("1 Failed:", PrimaryResult)
warn("Trying Backup...")

local BackupSuccess, BackupResult = RunScript(BackupUrl)

if BackupSuccess then
    return BackupResult
end

warn("2 Failed:", BackupResult)
error("Both Failed")
