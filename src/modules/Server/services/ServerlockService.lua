--[=[
    @class ServerlockService
]=]

local require = require(script.Parent.loader).load(script)
local Maid = require("Maid")
local RxValueBaseUtils = require("RxValueBaseUtils")
local Rx = require("Rx")
local FruitoloConstants = require("FruitoloConstants")

local ServerlockService = {}
ServerlockService.ServiceName = "ServerlockService"

function ServerlockService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._lockedBoolean = Instance.new("BoolValue")
	self._lockedBoolean.Value = true
	self._maid:GiveTask(self._lockedBoolean)

	self._slockEvent = FruitoloConstants._slockSignal
end

function ServerlockService:Start()
	self._maid:GiveTask(Rx.fromSignal(self._slockEvent):Subscribe(function(value: boolean)
		self:setIsLocked(value)
	end))
end

function ServerlockService:observeIsLocked()
	return RxValueBaseUtils.observeValue(self._lockedBoolean)
end

function ServerlockService:setIsLocked(state: boolean)
	assert(typeof(state) == "boolean", "Bad state")
	self._lockedBoolean = state
end

return ServerlockService
