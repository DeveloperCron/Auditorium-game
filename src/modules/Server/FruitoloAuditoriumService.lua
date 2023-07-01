--[=[
	@class FruitoloAuditoriumService
]=]

local require = require(script.Parent.loader).load(script)

local FruitoloAuditoriumService = {}
FruitoloAuditoriumService.ServiceName = "FruitoloAuditoriumService"

function FruitoloAuditoriumService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrService"))

	-- Internal
	self._serviceBag:GetService(require("CurtainService"))
	self._serviceBag:GetService(require("PlayerService"))
	self._serviceBag:GetService(require("ServerlockService"))
	self._serviceBag:GetService(require("FruitoloAuditoriumBindersServer"))
end

return FruitoloAuditoriumService
