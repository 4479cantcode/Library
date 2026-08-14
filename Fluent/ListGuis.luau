local Roots = {}

local Success, Hidden = pcall(function()
	return (gethui or get_hidden_ui)()
end)

if Success and Hidden then
	Roots[#Roots + 1] = Hidden
end

pcall(function()
	Roots[#Roots + 1] = game:GetService("CoreGui")
end)

pcall(function()
	Roots[#Roots + 1] = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 5)
end)

print("-ScreenGuis on screen-")

for _, Root in next, Roots do
	for _, Gui in next, Root:GetChildren() do
		if Gui:IsA("LayerCollector") and Gui.Enabled then
			print(`{Root.ClassName} -> {Gui.Name} ({#Gui:GetChildren()} children)`)
		end
	end
end

print("-")
