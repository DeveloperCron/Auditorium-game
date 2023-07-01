--[=[
    @class CurtainBase

    Some functions that will make debugging good later
]=]

local require = require(script.Parent.loader).load(script)

local BaseObject = require("BaseObject")
local LinkUtils = require("LinkUtils")
local RxInstanceUtils = require("RxInstanceUtils")

local CurtainBase = setmetatable({}, BaseObject)
CurtainBase.ClassName = "CurtainBase"
CurtainBase.__index = CurtainBase

function CurtainBase.new(obj, serviceBag)
	local self = setmetatable(BaseObject.new(obj), CurtainBase)
	self._serviceBag = assert(serviceBag, "No serviceBag")

	return self
end

function CurtainBase:GetParent()
	return LinkUtils.getLinkValue("Parent", self._obj)
end

function CurtainBase:ObserveState()
	return RxInstanceUtils.observeProperty(self._obj, "Transparency")
end

return CurtainBase
