--[=[
    @class SettingsScreen.story.lua
]=]

local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local Maid = require("Maid")
local SettingsScreen = require("SettingsScreen")
local StoryBarUtils = require("StoryBarUtils")
local StoryBarPaneUtils = require("StoryBarPaneUtils")

return function(target)
	local maid = Maid.new()

	local settingsScreen = SettingsScreen.new()
	maid:GiveTask(settingsScreen)

	settingsScreen.Gui.Parent = target
	settingsScreen:Show()

	-- Bind UI visiblity to switch.
	local bar = StoryBarUtils.createStoryBar(maid, target)
	StoryBarPaneUtils.makeVisibleSwitch(bar, settingsScreen)
	return function()
		maid:DoCleaning()
	end
end
