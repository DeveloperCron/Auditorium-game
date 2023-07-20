--[=[
	@class FruitoloAuditoriumServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local FruitoloAuditoriumServiceClient = {}
FruitoloAuditoriumServiceClient.ServiceName = "FruitoloAuditoriumServiceClient"

function FruitoloAuditoriumServiceClient:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrServiceClient"))

	-- Internal
	self._serviceBag:GetService(require("FruitoloAuditoriumBindersClient"))
	self._serviceBag:GetService(require("PermissionServiceClient"))
	self._serviceBag:GetService(require("FruitoloAdmin"))
	self._serviceBag:GetService(require("NotificationClient"))
	self._serviceBag:GetService(require("TopbarPlusService"))
	self._serviceBag:GetService(require("FruitoloAuditoriumTranslator"))
end

return FruitoloAuditoriumServiceClient
