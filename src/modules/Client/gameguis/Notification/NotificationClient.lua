--[=[
    @class NotifcationService
]=]

export type INotificationProps = {
	title: string?,
	label: string?,
}

local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
local ScreenGuiProvider = require("ScreenGuiProvider")
local GetRemoteEvent = require("GetRemoteEvent")
local NotificationUI = require("NotificationUI")
local ObservableList = require("ObservableList")
local cancellableDelay = require("cancellableDelay")
local Rx = require("Rx")

local NotificationClient = {}
NotificationClient.ClassName = "NotificationService"

function NotificationClient:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._event = GetRemoteEvent("notificationEvent")
	self._maid:GiveTask(self._event)

	self._notificationsList = ObservableList.new()
	self._maid:GiveTask(self._notificationsList)

	self._screenGui = self:_renderUI()

	self._maid:GiveTask(self._notificationsList:ObserveItemsBrio():Subscribe(function(brio)
		local notification, key = brio:GetValue()
		local maid = brio:ToMaid()

		maid:GiveTask(Rx.fromSignal(notification.Activated):Subscribe(function()
			notification:Hide()
		end))

		maid:GiveTask(cancellableDelay(5, function()
			notification:Hide()
			maid:GiveTask(Rx.fromPromise(notification._percentVisible:PromiseFinished()):Subscribe(function()
				self._notificationsList:RemoveByKey(key)
			end))
		end))
	end))
end

local function makeScreenGui(maid, name: string): ScreenGui
	local screenGui: ScreenGui = ScreenGuiProvider:Get(name)
	screenGui.IgnoreGuiInset = true
	maid:GiveTask(screenGui)

	return screenGui
end

function NotificationClient:_renderUI()
	local renderMaid = Maid.new()
	self._maid:GiveTask(renderMaid)

	local screenGui = makeScreenGui(renderMaid, "NOTIFICATION")

	return screenGui
end

function NotificationClient:PushNotification(props)
	local maid = Maid.new()
	local notificationIndex = self._maid:GiveTask(maid)

	local notification = NotificationUI.new()
	maid:GiveTask(notification)
	notification:setLabelText(props.label)
	notification:setTitleText(props.title)
	notification.Gui.Parent = self._screenGui
	notification:Show()

	maid:GiveTask(self._notificationsList:Add(notification))

	return function()
		self._maid[notificationIndex] = nil
	end
end

function NotificationClient:Start()
	self._maid:GiveTask(Rx.fromSignal(self._event.OnClientEvent):Subscribe(function(data: INotificationProps)
		self:PushNotification(data)
	end))
end

return NotificationClient
