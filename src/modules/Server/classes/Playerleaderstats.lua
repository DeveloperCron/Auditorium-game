--[=[
	@class Playerleaderstats
]=]
local require = require(script.Parent.loader).load(script)
local GroupUtils = require("GroupUtils")

local Playerleaderstats = {}
Playerleaderstats.ClassName = "Playerleaderstats"
Playerleaderstats.__index = Playerleaderstats

function Playerleaderstats.register(player: Player)
	assert(typeof(player) == "Instance", "Bad player")

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local rank = Instance.new("StringValue")
	rank.Name = "Rank"

	GroupUtils.promiseRoleInGroup(player, game.CreatorId):Then(function(value)
		rank.Value = value
	end)

	rank.Parent = leaderstats
	leaderstats.Parent = player
end

return Playerleaderstats
