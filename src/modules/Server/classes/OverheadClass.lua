--[=[
	@class OverheadClass
]=]

local require = require(script.Parent.loader).load(script)
local CharacterUtils = require("CharacterUtils")
local PlayerUtils = require("PlayerUtils")
local GroupUtils = require("GroupUtils")

local ServerStorage = game:GetService("ServerStorage")
local BiilBoardGui = ServerStorage.BillBoardGui

local Nametag: BillboardGui = BiilBoardGui.Nametag

local OverheadClass = {}
OverheadClass.ClassName = "NametagClass"
OverheadClass.__index = OverheadClass

function OverheadClass:addOverhead(player: Player)
	assert(typeof(player) == "Instance", "Bad player")

	local humanoidRootPart = CharacterUtils.getAlivePlayerRootPart(player)
	local humanoid = CharacterUtils.getPlayerHumanoid(player)
	if not humanoidRootPart and not humanoid then
		return
	end

	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	local newOverhead = Nametag:Clone()

	local Frame = newOverhead.Frame
	local UpperText: TextLabel = Frame.UpperText
	local LowerText: TextLabel = Frame.LowerText

	UpperText.Text = PlayerUtils.formatName(player)
	-- Promising the player role
	GroupUtils.promiseRoleInGroup(player, game.CreatorId):Then(function(rank)
		LowerText.Text = rank
	end)
	newOverhead.Parent = humanoidRootPart
end

return OverheadClass
