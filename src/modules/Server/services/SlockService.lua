--[=[
    @class ServerlockService
]=]

local require = require(script.Parent.loader).load(script)
local Maid = require("Maid")
local Rx = require("Rx")
local FruitoloConstants = require("FruitoloConstants")
local ValueObject = require("ValueObject")
local NotificationService = require("NotificationService")
local NotificationTitles = require("NotificationTitles")

local SlockService = {}
SlockService.ServiceName = "SlockService"

function SlockService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._isLocked = ValueObject.new(false, "boolean")
	self._maid:GiveTask(self._isLocked)

	self._slockEvent = FruitoloConstants.SLOCK_EVENT
	self._maid:GiveTask(self._slockEvent)

	self._notificationService = self._serviceBag:GetService(NotificationService)
end

local function getTextByValue(value: boolean)
	return value and "Server is locked" or "Server is unlocked"
end

function SlockService:Start()
	self._maid:GiveTask(Rx.fromSignal(self._slockEvent):Subscribe(function(value: boolean, executor)
		self._isLocked:SetValue(value)
		self._notificationService:PushNotification(
			executor,
			{ title = NotificationTitles.NOTIFICATION, label = getTextByValue(value) }
		)
	end))
end

function SlockService:IsLocked()
	return self._isLocked.Value
end

return SlockService
