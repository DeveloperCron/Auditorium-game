--[=[
    @class RankDoorClass
]=]

local require = require(script.Parent.loader).load(script)
local BaseObject = require("BaseObject")

local RankDoor = setmetatable({}, BaseObject)
RankDoor.__index = RankDoor

function RankDoor.new(robloxInstance)
	local self = setmetatable(BaseObject.new(robloxInstance), RankDoor)
	self._maid:GiveTask(self._obj)

	return self
end

function RankDoor:Destroy()
	self._maid:DoCleaning()
end

return RankDoor
