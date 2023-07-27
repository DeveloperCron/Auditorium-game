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
local Nametag = require("Nametag")
local CollisionsFilteringService = require("CollisionsFilteringService")
local FruitoloAdmin = require("FruitoloAdmin")
local IsPlayerStaff = require("IsPlayerStaff")
local IsPlayerSHR = require("IsPlayerSHR")
local CatchFactory = require("CatchFactory")
local FruitoloConstants = require("FruitoloConstants")
local RagdollService = require("RagdollService")
local ServiceBag = require("ServiceBag")

local GROUP_ID = FruitoloConstants.GROUP_ID

local PlayerService = {}
PlayerService.ServiceName = "PlayerService"

function PlayerService:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")
	self._maid = Maid.new()

	self._nametagPollers = {}

	-- serviceBags
	self._slockService = serviceBag:GetService(SlockService)
	self._fruitoloAdmin = serviceBag:GetService(FruitoloAdmin)
	self._ragdollService = serviceBag:GetService(RagdollService):SetRagdollOnDeath(true)
	self._collisionsFilteringService = serviceBag:GetService(CollisionsFilteringService)
end

function PlayerService:_createLeaderstats(player: Player, maid)
	local Leaderstats = Instance.new("Folder")
	Leaderstats.Name = "leaderstats"
	maid:GiveTask(Leaderstats)

	local Rank = Instance.new("StringValue")
	Rank.Name = "Rank"
	maid:GiveTask(Rank)

	Rank.Parent = Leaderstats
	Leaderstats.Parent = player

	-- Gross but works
	maid:GiveTask(GroupUtils.promiseRoleInGroup(player, GROUP_ID)
		:Then(function(role)
			Rank.Value = role
		end)
		:Catch(CatchFactory("GroupUtils.promiseRoleInGroup")))
end

function PlayerService:Start()
	local function onPlayerAddedBrio(brio)
		local player = brio:GetValue()
		local maid = brio:ToMaid()

		local isServerLocked = self._slockService:IsLocked()
		if isServerLocked and IsPlayerStaff(player) and not RunService:IsStudio() then
			player:Kick("Server is locked!")
		end

		if IsPlayerSHR(player) or RunService:IsStudio() then
			self._fruitoloAdmin:Add(player)
		end

		self:_createLeaderstats(player, maid)

		maid:GiveTask(RxCharacterUtils.observeLastCharacterBrio(player):Subscribe(function(brioCharacter)
			local character = brioCharacter:GetValue()
			local characterMaid = brioCharacter:ToMaid()

			self._collisionsFilteringService:addCharacter(character)
			self._nametagPollers[player] = Nametag(player, character, characterMaid)

			characterMaid:GiveTask(function()
				if self._nametagPollers[player] then
					self._nametagPollers[player] = nil
				end
			end)
		end))

		maid:GiveTask(function()
			self._fruitoloAdmin:Remove(player)
			self._nametagPollers[player] = nil
		end)
	end

	self._maid:GiveTask(RxPlayerUtils.observePlayersBrio():Subscribe(onPlayerAddedBrio))
end

return PlayerService
