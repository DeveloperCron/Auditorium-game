--[=[
    @class ServerlockService
]=]

local require = require(script.Parent.loader).load(script)
local Maid = require("Maid")
local RxValueBaseUtils = require("RxValueBaseUtils")

local ServerlockService = {}
ServerlockService.ServiceName = "ServerlockService"

function ServerlockService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._lockedBoolean = Instance.new("BoolValue")
	self._lockedBoolean.Value = true
	self._maid:GiveTask(self._lockedBoolean)
end

function ServerlockService:observeIsLocked(): boolean
	return RxValueBaseUtils.observeValue(self._lockedBoolean)
end

function ServerlockService:setIsLocked(state: boolean)
	self._lockedBoolean = state
end

return ServerlockService
