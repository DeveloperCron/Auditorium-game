--[=[
	@class FruitoloAuditoriumService
]=]

local require = require(script.Parent.loader).load(script)

local FruitoloAuditoriumService = {}
FruitoloAuditoriumService.ServiceName = "FruitoloAuditoriumService"

function FruitoloAuditoriumService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- Internal
	self._serviceBag:GetService(require("CurtainService"))
	self._serviceBag:GetService(require("PlayerService"))
	self._serviceBag:GetService(require("SlockService"))
	self._serviceBag:GetService(require("FruitoloAdmin"))
	self._serviceBag:GetService(require("NotificationService"))
	self._serviceBag:GetService(require("CollisionsFilteringService"))
	self._serviceBag:GetService(require("FruitoloAuditoriumBindersServer"))
end

return FruitoloAuditoriumService
