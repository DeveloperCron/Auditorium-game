--[=[
    @class ToggleButton.story.lua
]=]

local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local Maid = require("Maid")
local ToggleButton = require("ToggleButton")

return function(target)
	local maid = Maid.new()

	local toggleButton = ToggleButton.new(true)
	toggleButton.Gui.Parent = target
	toggleButton:Show()
	maid:GiveTask(toggleButton)

	return function()
		maid:DoCleaning()
	end
end
