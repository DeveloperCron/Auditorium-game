local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)
local NotificationUI = require("NotificationUI")
local Maid = require("Maid")

return function(target)
	local renderMaid = Maid.new()

	local notification = NotificationUI.new()
	notification:setTitleText("Announcement")
	notification:setLabelText("We'll be starting soon!")
	renderMaid:GiveTask(notification)

	notification:Show()
	notification.Gui.Parent = target

	renderMaid:GiveTask(notification.Activated:Connect(function()
		notification:Hide()
	end))

	return function()
		renderMaid:DoCleaning()
	end
end
