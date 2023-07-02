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
	local function canOpenCurtain(player: Player)
		local playerRank = GroupUtils.promiseRankInGroup(player, game.CreatorId):Wait()
		if playerRank < 27 then
			return
		end

		return true
	end

	local function handleCurtain(state: boolean)
		for _, curtain in pairs(self._curtainBinders:GetAll()) do
			if state then
				curtain:Open()
			else
				curtain:Close()
			end
		end
	end

	self._maid:GiveTask(Rx.fromSignal(self._curtainEvent.OnServerEvent)
		:Pipe({
			-- Check if the player can open the curtain
			Rx.where(canOpenCurtain),
			-- Get the state, the second argument of the RemoteEvent
			Rx.map(function(_, state: boolean)
				return state
			end),
		})
		:Subscribe(handleCurtain))
end

function CurtainService:Cleanup()
	print("Cleaning up")
	self._maid:Cleanup()
end

return CurtainService
