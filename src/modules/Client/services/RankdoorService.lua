--[=[
    @class RankdoorService
]=]

local require = require(script.Parent.loader).load(script)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local GroupUtils = require("GroupUtils")
local FruitoloAuditoriumBindersClient = require("FruitoloAuditoriumBindersClient")

local player = Players.LocalPlayer

local RankdoorService = {}
RankdoorService.ClassName = "RankdoorService"

function RankdoorService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._rankDoorsBinders = self._serviceBag:GetService(FruitoloAuditoriumBindersClient).RankDoor
end

function RankdoorService:Start()
	GroupUtils.promiseRankInGroup(player, game.CreatorId):Then(function(rank)
		-- Change the group rank
		if rank >= 27 or RunService:IsStudio() then
			for _, door in pairs(self._rankDoorsBinders:GetAll()) do
				door:Destroy()
			end
		end
	end)
end

return RankdoorService
