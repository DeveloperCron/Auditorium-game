--[=[
    @class NotifcationService
]=]
local require = require(script.Parent.loader).load(script)
local Maid = require("Maid")
local ScreenGuiProvider = require("ScreenGuiProvider")
-- local GetRemoteEvent = require("GetRemoteEvent")
-- local Rx = require("Rx")

local NotifcationService = {}
NotifcationService.ClassName = "NotificationService"

function NotifcationService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	-- self._notifcationEvent = GetRemoteEvent("notificationEvent")
	-- self._maid:GiveTask(self._notifcationEvent)

	self._screenGui = self:_renderUI()
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

	return screenGui
end

-- Here we listen for new notifications
function NotifcationService:Start()
	-- local function isThereNotifcation() end
	-- local function createNotification() end
	-- local function removeNotification() end

	-- self._maid:GiveTask(Rx.fromSignal(self._notifcationEvent.OnClientEvent):Pipe({}):Subscribe(function() end))
end

return NotifcationService
