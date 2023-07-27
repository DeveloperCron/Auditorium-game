--[=[
	@class FruitoloAuditoriumService
]=]

local require = require(script.Parent.loader).load(script)
local ServiceBag = require("ServiceBag")

local FruitoloAuditoriumService = {}
FruitoloAuditoriumService.ServiceName = "FruitoloAuditoriumService"

function FruitoloAuditoriumService:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")

	-- Internal
	serviceBag:GetService(require("StageService"))
	serviceBag:GetService(require("PlayerService"))
	serviceBag:GetService(require("SlockService"))
	serviceBag:GetService(require("FruitoloAdmin"))
	serviceBag:GetService(require("NotificationService"))
	serviceBag:GetService(require("CollisionsFilteringService"))
	serviceBag:GetService(require("SoftShutdownService"))
	serviceBag:GetService(require("FruitoloAuditoriumBindersServer"))
end

return FruitoloAuditoriumService
