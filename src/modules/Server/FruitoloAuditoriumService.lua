--[=[
	@class FruitoloAuditoriumService
]=]

local require = require(script.Parent.loader).load(script)
-- Commands
local Slock = require("Slock")
local SlockServer = require("SlockServer")

local FruitoloAuditoriumService = {}
FruitoloAuditoriumService.ServiceName = "FruitoloAuditoriumService"

function FruitoloAuditoriumService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._cmdr = self._serviceBag:GetService(require("CmdrService"))

	-- Internal
	self._serviceBag:GetService(require("CurtainService"))
	self._serviceBag:GetService(require("PlayerService"))
	self._serviceBag:GetService(require("ServerlockService"))
	self._serviceBag:GetService(require("FruitoloPermissions"))
	self._serviceBag:GetService(require("NotificationServer"))
	self._serviceBag:GetService(require("FruitoloAuditoriumBindersServer"))
end

function FruitoloAuditoriumService:Start()
	self._cmdr:RegisterCommand(Slock, SlockServer)
end

return FruitoloAuditoriumService
