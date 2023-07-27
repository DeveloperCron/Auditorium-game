--[=[
    @class ServerlockService
]=]

local require = require(script.Parent.loader).load(script)
local Maid = require("Maid")
local FruitoloConstants = require("FruitoloConstants")
local ValueObject = require("ValueObject")
local NotificationService = require("NotificationService")
local NotificationTitles = require("NotificationTitles")
local ServiceBag = require("ServiceBag")

local SlockService = {}
SlockService.ServiceName = "SlockService"

function SlockService:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")
	self._maid = Maid.new()

	self._isLocked = ValueObject.new(false, "boolean")
	self._maid:GiveTask(self._isLocked)

	self._slockEvent = FruitoloConstants.SLOCK_EVENT
	self._maid:GiveTask(self._slockEvent)

	self._notificationService = serviceBag:GetService(NotificationService)
end

local function getTextByValue(value: boolean)
	return value and "Server is locked" or "Server is unlocked"
end

local function convertToBoolean(state: string)
	if string.lower(state) == "true" then
		return true
	end

	return false
end

function SlockService:Start()
	self._maid:GiveTask(self._slockEvent:Connect(function(state: string, executor)
		state = convertToBoolean(state)

		self._isLocked:SetValue(state)
		self._notificationService:PushNotification(
			executor,
			{ title = NotificationTitles.NOTIFICATION, label = getTextByValue(state) }
		)
	end))
end

function SlockService:IsLocked()
	return self._isLocked.Value
end

return SlockService
