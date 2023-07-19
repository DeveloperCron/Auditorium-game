--[=[
    @class SettingsScreen.story.lua
]=]

local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local Maid = require("Maid")
local SettingsScreen = require("SettingsScreen")

return function(target)
	local maid = Maid.new()

	local settingsScreen = SettingsScreen.new()
	maid:GiveTask(settingsScreen)

	settingsScreen.Gui.Parent = target
	settingsScreen:Show()

	return function()
		maid:DoCleaning()
	end
end
