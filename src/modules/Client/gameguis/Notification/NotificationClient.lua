--[=[
    @class NotifcationService
]=]

export type INotificationAddProps = {
	title: string?,
	label: string?,
}

local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
local ScreenGuiProvider = require("ScreenGuiProvider")
local GetRemoteEvent = require("GetRemoteEvent")
local Rx = require("Rx")
local NotificationUI = require("NotificationUI")

local NotificationClient = {}
NotificationClient.ClassName = "NotificationService"

function NotificationClient:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._event = GetRemoteEvent("notificationEvent")
	self._maid:GiveTask(self._event)

	self._children = {}

	self._screenGui = self:_renderUI()
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

-- Here we listen for new notifications
function NotificationClient:Start()
	local function isNotificationValid(class)
		return NotificationUI.isNotification(class) and class ~= nil
	end
	-- Removing current notifications in order to create place for another notification
	-- This will be called at the start and of creating a notification
	-- Maybe in the future switch to observableSet if it will be ready up for this case
	local function cleanNotifications()
		for index, notification in self._children do
			local isValid = isNotificationValid(notification)
			if not isValid then
				return
			end

			notification:Hide()
			self._maid:GiveTask(Rx.fromPromise(notification._percentVisible:PromiseFinished()):Subscribe(function()
				notification:Destroy()
				self._children[index] = nil
			end))
		end
	end

	local function addNotification(props: INotificationAddProps)
		local renderMaid = Maid.new()

		-- Removing current notifications
		cleanNotifications()
		-- Creating a new notification here!
		local notification = NotificationUI.new()
		self._maid:GiveTask(renderMaid)

		notification:setLabelText(props.label)
		notification:setTitleText(props.title)
		-- Parent the notification to the screenGui
		notification.Gui.Parent = self._screenGui
		notification:Show()

		-- It will not destroy the notification but hide it!
		renderMaid:GiveTask(Rx.fromSignal(notification.Activated):Subscribe(function()
			notification:Hide()
		end))

		-- Remember to cleanup the renderMaid when it's not needed!
		self._maid:GiveTask(function()
			task.delay(1, function()
				renderMaid:Destroy()
			end)
		end)

		table.insert(self._children, notification)
		self._maid:GiveTask(task.delay(5, cleanNotifications))
	end

	-- Listening to the event!
	self._maid:GiveTask(Rx.fromSignal(self._event.OnClientEvent):Subscribe(function(data)
		addNotification(data)
	end))
end

return NotificationClient
