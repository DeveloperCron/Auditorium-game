--[=[
    @class Nametag
]=]

local require = require(script.Parent.loader).load(script)
local ServerStorage = game:GetService("ServerStorage")
local GroupUtils = require("GroupUtils")
local CharacterUtils = require("CharacterUtils")
local PlayerUtils = require("PlayerUtils")
local Blend = require("Blend")
local PromiseChild = require("PromiseChild")

local function Nametag(player: Player, maid)
	maid:GiveTask(PromiseChild(ServerStorage, "BillBoardGui"):Then(function(BillBoardFolder)
		maid:GiveTask(PromiseChild(BillBoardFolder, "Nametag"):Then(function(nametag: Instance)
			local humanoidRootPart = CharacterUtils.getAlivePlayerRootPart(player)
			local humanoid = CharacterUtils.getPlayerHumanoid(player)
			if not humanoidRootPart and not humanoid then
				return
			end
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

			local newNametag = nametag:Clone()
			newNametag.Parent = humanoidRootPart

			local formattedName = PlayerUtils.formatName(player)
			local promisePlayerRole = GroupUtils.promiseRoleInGroup(player, game.CreatorId)
			maid:GiveTask(promisePlayerRole
				:Then(function(role)
					maid:GiveTask(Blend.mount(newNametag, {
						Blend.Find("Frame")({
							Blend.Find("UpperText")({
								Text = formattedName,
							}),
							Blend.Find("LowerText")({
								Text = role,
							}),
						}),
					}))
				end)
				:Catch("GroupUtils.promiseRoleInGroup() is failing"))
		end))
	end))
end

return Nametag
