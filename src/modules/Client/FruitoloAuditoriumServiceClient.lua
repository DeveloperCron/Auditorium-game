--[=[
	@class FruitoloAuditoriumServiceClient
]=]

local require = require(script.Parent.loader).load(script)
local ServiceBag = require("ServiceBag")

local FruitoloAuditoriumServiceClient = {}
FruitoloAuditoriumServiceClient.ServiceName = "FruitoloAuditoriumServiceClient"

function FruitoloAuditoriumServiceClient:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")

	-- Internal
	serviceBag:GetService(require("FruitoloAuditoriumBindersClient"))
	serviceBag:GetService(require("PermissionServiceClient"))
	serviceBag:GetService(require("NotificationClient"))
	serviceBag:GetService(require("TopbarPlusService"))
	serviceBag:GetService(require("PlayerServiceClient"))
	serviceBag:GetService(require("SoftShutdownServiceClient"))
	serviceBag:GetService(require("FruitoloAuditoriumTranslator"))
end

return FruitoloAuditoriumServiceClient
