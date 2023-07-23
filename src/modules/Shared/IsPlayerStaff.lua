--[=[
    @class IsPlayerStaff.lua
]=]

local require = require(script.Parent.loader).load(script)
local GroupUtils = require("GroupUtils")
local FruitoloConstants = require("FruitoloConstants")

local GROUP_ID = FruitoloConstants.GROUP_ID
local MINIMUM_RANK_FOR_STAFF = FruitoloConstants.MINIMUM_RANK_FOR_STAFF
local SHR_RANK = FruitoloConstants.SHR_RANK

local StaffCache = {}

local function IsPlayerStaff(player: Player)
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")

	local IsStaff = StaffCache[player]
	if IsStaff ~= nil then
		return IsStaff
	end

	local Rank = GroupUtils.promiseRankInGroup(player, GROUP_ID):Wait()
	if Rank then
		IsStaff = Rank >= MINIMUM_RANK_FOR_STAFF and Rank <= SHR_RANK
		StaffCache[player] = IsStaff
		return IsStaff
	else
		warn(string.format("GroupUtils.promiseRankInGroup failed: %s", tostring(Rank)))
		return false
	end
end

return IsPlayerStaff
