--[=[
    @classNotificationService
]=]

export type IData = {
	title: string,
	label: string,
}

local require = require(script.Parent.loader).load(script)
local FruitoloConstants = require("FruitoloConstants")
local Maid = require("Maid")
local TextFilterUtils = require("TextFilterUtils")

local NotificationService = {}
NotificationService.ClassName = "NotifcationService"

function NotificationService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._notifcationEvent = FruitoloConstants.NOTIFICATION_EVENT
	self._maid:GiveTask(self._notifcationEvent)
end

function NotificationService:PushNotification(player, data)
	self._maid:GiveTask(
		TextFilterUtils.promiseNonChatStringForBroadcast(data.label, player.UserId, Enum.TextFilterContext.PublicChat)
			:Then(function(filtered)
				self._notifcationEvent:FireAllClients({ title = data.title, label = filtered })
			end)
			:Catch(warn)
	)
end

return NotificationService
