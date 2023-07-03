--[=[
    @class NotifcationService
]=]
local require = require(script.Parent.loader).load(script)
local Maid = require("Maid")
local Notification = require("Notification")
local NotificationUI = require("NotificationUI")
local ScreenGuiProvider = require("ScreenGuiProvider")

local NotifcationService = {}
NotifcationService.ClassName = "NotificationService"

function NotifcationService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._screenGui, self._notifcationUI = self:_renderUI()
end

local function makeScreenGui(maid, name: string): ScreenGui
	local screenGui: ScreenGui = ScreenGuiProvider:Get(name)
	screenGui.IgnoreGuiInset = true
	maid:GiveTask(screenGui)

	return screenGui
end

function NotifcationService:_renderUI()
	local renderMaid = Maid.new()
	self._maid:GiveTask(renderMaid)

	local screenGui = makeScreenGui(renderMaid, "NOTIFICATION")
	local notificationUI = NotificationUI.new()
	notificationUI.Gui.Parent = screenGui
	notificationUI:Show()

	do
		local notification = Notification.new()
		notification:setLabelText("Debugging Test")
		notification:setTitleText("Announcement")
		notification:Show()
		renderMaid:GiveTask(notification)
		renderMaid:GiveTask(notificationUI:addNotifcation(notification))
	end

	return screenGui, notificationUI
end

return NotifcationService
