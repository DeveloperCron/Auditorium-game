--[=[
    @class FruitoloAdmin
]=]

local require = require(script.Parent.loader).load(script)

local PermissionServiceClient = require("PermissionServiceClient")

local FruitoloAdmin = {}
FruitoloAdmin.ClassName = "FruitoloAdmin"

function FruitoloAdmin:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._cmdrService = self._serviceBag:GetService(require("CmdrServiceClient"))

	self._PermissionServiceClient = self._serviceBag:GetService(PermissionServiceClient)
	self._PermissionServiceClient:PromiseIsAdmin(game.Players.LocalPlayer):Then(function(value)
		print(string.format("🔰 [Fruitolo Admin] | Player is an admin? %s", tostring(value)))
	end)
end

return FruitoloAdmin
