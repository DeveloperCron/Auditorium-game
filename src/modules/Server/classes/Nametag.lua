--[=[
	@class Nametag.lua
]=]

local require = require(script.Parent.loader).load(script)
local CatchFactory = require("CatchFactory")
local PromiseChild = require("PromiseChild")
local GroupUtils = require("GroupUtils")
local PlayerUtils = require("PlayerUtils")
local Resources = require("Resources")
local CharcterUtils = require("CharacterUtils")
local FruitoloConstants = require("FruitoloConstants")

local GROUP_ID = FruitoloConstants.GROUP_ID

local function Nametag(player, character, characterMaid)
	characterMaid:GivePromise(PromiseChild(character, "Head"):Then(function(head)
		local PlayerOverhead = Resources.GetGuiObject("Nametag"):Clone()
		PlayerOverhead.Adornee = head

		local humanoid: Humanoid = CharcterUtils.getPlayerHumanoid(player)
		if humanoid then
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end

		characterMaid:GivePromise(PromiseChild(PlayerOverhead, "Frame")
			:Then(function(frame)
				local LowerText = frame.LowerText
				local UpperText = frame.UpperText

				local formattedName = PlayerUtils.formatName(player)
				UpperText.Text = formattedName

				characterMaid:GiveTask(GroupUtils.promiseRoleInGroup(player, GROUP_ID)
					:Then(function(role)
						LowerText.Text = role
					end)
					:Catch(CatchFactory("GroupUtils.promiseRoleInGroup")))
			end)
			:Catch(CatchFactory("PromiseChild"))
			:Finally(function()
				PlayerOverhead.Parent = head
				characterMaid:GiveTask(PlayerOverhead)
			end))
	end):Catch(CatchFactory("PromiseChild")))
end

return Nametag
