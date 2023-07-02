--[=[
    @class FruitoloPermissions
]=]
local require = require(script.Parent.loader).load(script)
local PermissionProviderUtils = require("PermissionProviderUtils")
local PermissionService = require("PermissionService")

local FruitoloPermissions = {}
FruitoloPermissions.ClassName = "FruitoloPermissions"

function FruitoloPermissions:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._permissionService = self._serviceBag:GetService(PermissionService)
	self._config = PermissionProviderUtils.createGroupRankConfig({
		groupId = game.CreatorId,
		minAdminRequiredRank = 14,
		minCreatorRequiredRank = 14,
	})

	self._permissionService:SetProviderFromConfig(self._config)
end

return FruitoloPermissions
