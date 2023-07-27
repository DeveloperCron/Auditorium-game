local RunService = game:GetService("RunService")
--[=[
    @class StageService.lua
]=]

local require = require(script.Parent.loader).load(script)
local IsPlayerSHR = require("IsPlayerSHR")
local FruitoloConstants = require("FruitoloConstants")
local Maid = require("Maid")
local ServiceBag = require("ServiceBag")

local StageService = {}
StageService.ClassName = "StageService"

function StageService:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")

	self._maid = Maid.new()

	self._curtainEvent = FruitoloConstants.CURTAIN_EVENT
	self._maid:GiveTask(self._curtainEvent)

	self._curtainBinders = serviceBag:GetService(require("FruitoloAuditoriumBindersServer")).Curtain
end

function StageService:Start()
	self._maid:GiveTask(self._curtainEvent.OnServerEvent:Connect(function(player, state)
		if not IsPlayerSHR(player) and not RunService:IsStudio() then
			return
		end

		for _, curtain in pairs(self._curtainBinders:GetAll()) do
			if state then
				curtain:Open()
			else
				curtain:Close()
			end
		end
	end))
end

return StageService
