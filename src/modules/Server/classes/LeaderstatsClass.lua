--[=[
	@class LeaderstatsClass
]=]
local require = require(script.Parent.loader).load(script)
local GroupUtils = require("GroupUtils")

local LeaderstatsClass = {}
LeaderstatsClass.ClassName = "LeaderstatsClass"
LeaderstatsClass.__index = LeaderstatsClass

function LeaderstatsClass.registerLeaderstats(player: Player)
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

return LeaderstatsClass
