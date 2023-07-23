--[=[
    @classNotificationService
]=]

export type IDataProps = {
	title: string,
	label: string,
}

local require = require(script.Parent.loader).load(script)
local FruitoloConstants = require("FruitoloConstants")
local Maid = require("Maid")
local TextFilterUtils = require("TextFilterUtils")
local CatchFactory = require("CatchFactory")

local NotificationService = {}
NotificationService.ClassName = "NotifcationService"

function NotificationService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._notifcationEvent = FruitoloConstants.NOTIFICATION_EVENT
	self._maid:GiveTask(self._notifcationEvent)
end

function NotificationService:PushNotification(player: Player, data: IDataProps)
	self._maid:GiveTask(
		TextFilterUtils.promiseNonChatStringForBroadcast(data.label, player.UserId, Enum.TextFilterContext.PublicChat)
			:Then(function(filtered)
				self._notifcationEvent:FireAllClients({ title = data.title, label = filtered })
			end)
			:Catch(CatchFactory("TextFilterUtils.promiseNonChatStringForBroadcast"))
	)
end

return NotificationService
