--[=[
    @class CurtainService.lua
]=]

local require = require(script.Parent.loader).load(script)
local Maid = require("Maid")
local GetRemoteEvent = require("GetRemoteEvent")
local GroupUtils = require("GroupUtils")
local Rx = require("Rx")

local CurtainService = {}
CurtainService.ServiceName = "CurtainService"

function CurtainService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._curtainEvent = GetRemoteEvent("curtainEvent")
	self._curtainBinders = self._serviceBag:GetService(require("FruitoloAuditoriumBindersServer")).Curtain
end

function CurtainService:Start()
	local function handleCurtainEvent(player: Player, state: boolean)
		assert(typeof(state) == "boolean", "Bad state")

		local playerRank = GroupUtils.promiseRankInGroup(player, game.CreatorId)
		Rx.fromPromise(playerRank):Subscribe(function(rank)
			if rank <= 0 then
				player:Kick("Quit exploiting get off of the stage")
			end
		end)

		for _, curtain in pairs(self._curtainBinders:GetAll()) do
			if state then
				curtain:Open()
			else
				curtain:Close()
			end
		end
	end

	-- CurtainEvent listener
	self._maid:GiveTask(self._curtainEvent:Connect(handleCurtainEvent))
end

function CurtainService:Cleanup()
	print("Cleaning up")
	self._maid:Cleanup()
end

return CurtainService
