--[=[
	@service PlayerService
]=]

local require = require(script.Parent.loader).load(script)
local Players = game:GetService("Players")

local Maid = require("Maid")
local OverheadClass = require("OverheadClass")
local LeaderstatsClass = require("LeaderstatsClass")

local PlayerService = {}
PlayerService.ServiceName = "PlayerService"

function PlayerService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	self._maid = Maid.new()
end

function PlayerService:Start()
	local function onPlayerAdded(player: Player)
		local function onCharacterAdded(character: Model)
			OverheadClass:addOverhead(player)
		end

		onCharacterAdded(player.Character or player.CharacterAdded:Wait())
		self._maid:GiveTask(player.CharacterAdded:Connect(onCharacterAdded))
		-- Adding leaderstats
		LeaderstatsClass.registerLeaderstats(player)
	end

	self._maid:GiveTask(Players.PlayerAdded:Connect(onPlayerAdded))
	for _, player in pairs(Players:GetPlayers()) do
		task.defer(onPlayerAdded, player)
	end
end

return PlayerService
