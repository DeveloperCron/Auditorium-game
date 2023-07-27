--[=[
    @class Curtain
]=]

local require = require(script.Parent.loader).load(script)
local BaseObject = require("BaseObject")

local Curtain = setmetatable({}, BaseObject)
Curtain.ClassName = "Curtain"
Curtain.__index = Curtain

function Curtain.new(obj, serviceBag)
	local self = setmetatable(BaseObject.new(obj), Curtain)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	return self
end

function Curtain:Close()
	self._obj.Transparency = 0
end

function Curtain:Open()
	self._obj.Transparency = 1
end

return Curtain
