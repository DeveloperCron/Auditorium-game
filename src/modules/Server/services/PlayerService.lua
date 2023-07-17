--[=[
	@service PlayerService
]=]

local require = require(script.Parent.loader).load(script)
local RunService = game:GetService("RunService")

local Maid = require("Maid")
local GroupUtils = require("GroupUtils")
local RxPlayerUtils = require("RxPlayerUtils")
local RxCharacterUtils = require("RxCharacterUtils")
local SlockService = require("SlockService")
local PlayerNametag = require("PlayerNametag")
local Playerleaderstats = require("Playerleaderstats")
local CollisionsFilteringService = require("CollisionsFilteringService")

local PlayerService = {}
PlayerService.ServiceName = "PlayerService"

function PlayerService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._nametagPollers = {}
	self._slockService = self._serviceBag:GetService(SlockService)
	self._collisionsFilteringService = self._serviceBag:GetService(CollisionsFilteringService)
end

function PlayerService:Start()
	local function onPlayerBrioAdded(brio)
		local player = brio:GetValue()
		local maid = brio:ToMaid()

		-- We're checking if the server is locked
		local isLocked = self._slockService:IsLocked()
		if isLocked and not RunService:IsStudio() then
			maid:GiveTask(GroupUtils.promiseRankInGroup(player, game.CreatorId)
				:Then(function(rank: number)
					if rank <= 27 then
						player:Kick("Server is currently locked!")
					end
				end)
				:Catch(warn("GrouUtils failed to promiseRankInGroup")))
		end

		Playerleaderstats.register(player)

		maid:GiveTask(RxCharacterUtils.observeLastCharacterBrio(player):Subscribe(function(brioCharacter)
			local character = brioCharacter:GetValue()
			self._nametagPollers[player] = PlayerNametag.addNameTag(player)
			self._collisionsFilteringService:addCharacter(character)
		end))

		maid:GiveTask(function()
			self._nametagPollers[player] = nil
		end)
	end

	self._maid:GiveTask(RxPlayerUtils.observePlayersBrio():Subscribe(onPlayerBrioAdded))
end

return PlayerService
