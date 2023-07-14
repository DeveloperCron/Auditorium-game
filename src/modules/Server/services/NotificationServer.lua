--[=[
    @classNotificationService
]=]
local require = require(script.Parent.loader).load(script)
local GetRemoteEvent = require("GetRemoteEvent")

local NotificationServer = {}
NotificationServer.ClassName = "NotifcationServiceServer"

function NotificationServer:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._notifcationEvent = GetRemoteEvent("notificationEvent")
end

return NotificationServer
