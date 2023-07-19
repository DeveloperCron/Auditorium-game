local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)

local NotificationUI = require("NotificationUI")
local Maid = require("Maid")
local StoryBarUtils = require("StoryBarUtils")
local StoryBarPaneUtils = require("StoryBarPaneUtils")

return function(target)
	local renderMaid = Maid.new()

	local notification = NotificationUI.new()
	notification:setTitleText("Announcement")
	notification:setLabelText("We'll be starting soon! Currently the server is locked for chief+")
	renderMaid:GiveTask(notification)

	notification:Show()
	notification.Gui.Parent = target

	renderMaid:GiveTask(notification.Activated:Connect(function()
		notification:Hide()
	end))

	-- Bind UI visiblity to switch.
	local bar = StoryBarUtils.createStoryBar(renderMaid, target)
	StoryBarPaneUtils.makeVisibleSwitch(bar, notification)
	return function()
		renderMaid:DoCleaning()
	end
end
