--[=[
    @class RankDoorClass
]=]

local require = require(script.Parent.loader).load(script)
local BaseObject = require("BaseObject")

local RankDoorClass = setmetatable({}, BaseObject)
RankDoorClass.__index = RankDoorClass

function RankDoorClass.new(robloxInstance)
	local self = setmetatable(BaseObject.new(robloxInstance), RankDoorClass)
	self._maid:GiveTask(self._obj)

	return self
end

function RankDoorClass:Destroy()
	self._maid:DoCleaning()
end

return RankDoorClass
