--[=[
    @class PlayerServiceClient
]=]

local require = require(script.Parent.loader).load(script)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GroupUtils = require("GroupUtils")
local Maid = require("Maid")
local FruitoloAuditoriumBindersClient = require("FruitoloAuditoriumBindersClient")
local CatchFactory = require("CatchFactory")

local player = Players.LocalPlayer

local PlayerServiceClient = {}
PlayerServiceClient.ClassName = "PlayerServiceClient"

function PlayerServiceClient:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._rankdoorBinder = self._serviceBag:GetService(FruitoloAuditoriumBindersClient).RankDoor
end

function PlayerServiceClient:_destroyAllDoors()
	for _, class in self._rankdoorBinder:GetAll() do
		class:Destroy()
	end
end

function PlayerServiceClient:Start()
	self._maid:GiveTask(GroupUtils.promiseRankInGroup(player, game.CreatorId)
		:Then(function(rank: number)
			if rank >= 27 and not RunService:IsStudio() then
				self:_destroyAllDoors()
			end
		end)
		:Catch(CatchFactory("GroupUtils.promiseRankInGroup")))
end

function PlayerServiceClient:Destroy()
	self._maid:DoCleaning()
end

return PlayerServiceClient
