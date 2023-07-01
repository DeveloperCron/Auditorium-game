--[=[
    @class Door
]=]
local require = require(script.Parent.loader).load(script)
local BaseObject = require("BaseObject")

local Door = setmetatable({}, BaseObject)
Door.ClassName = "Door"
Door.__index = Door

function Door.new(obj, serviceBag)
	local self = setmetatable(BaseObject.new(obj), Door)
	assert(not self._serviceBag, "Already initialized")

	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid:GiveTask(obj)

	return self
end

return Door
