--[=[
	@class PlayerNametag
]=]

local require = require(script.Parent.loader).load(script)
local GroupUtils = require("GroupUtils")
local Maid = require("Maid")
local PlayerUtils = require("PlayerUtils")
local CharacterUtils = require("CharacterUtils")

-- Maybe change that to Rx?
local ServerStorage = game:GetService("ServerStorage")
local BiilBoardGui = ServerStorage.BillBoardGui
local Nametag: BillboardGui = BiilBoardGui.Nametag

local PlayerNametag = {}
PlayerNametag.ClassName = "Nametag"
PlayerNametag.__index = PlayerNametag

function PlayerNametag.addNameTag(player)
	assert(typeof(player) == "Instance", "Bad player")
	local nametagMaid = Maid.new()

	local humanoidRootPart = CharacterUtils.getAlivePlayerRootPart(player)
	local humanoid = CharacterUtils.getPlayerHumanoid(player)
	if not humanoidRootPart and not humanoid then
		return
	end

	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	local newOverhead = Nametag:Clone()
	nametagMaid:GiveTask(newOverhead)

	local Frame = newOverhead.Frame
	local UpperText: TextLabel = Frame.UpperText
	local LowerText: TextLabel = Frame.LowerText

	UpperText.Text = PlayerUtils.formatName(player)
	-- Promising the player role
	nametagMaid:GiveTask(GroupUtils.promiseRoleInGroup(player, game.CreatorId)
		:Then(function(rank)
			LowerText.Text = rank
		end)
		:Catch(function()
			warn("[PlayerNametag] | Error resolving promise")
		end))

	newOverhead.Parent = humanoidRootPart

	return nametagMaid
end

return PlayerNametag
