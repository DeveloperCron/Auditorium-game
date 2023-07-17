--[=[
    @class FruitoloConstants
]=]

local require = require(script.Parent.loader).load(script)
local Table = require("Table")
local GetRemoteEvent = require("GetRemoteEvent")
local Signal = require("Signal")

return Table.readonly({
	CURTAIN_EVENT = GetRemoteEvent("CURTAIN_EVENT"),
	NOTIFICATION_EVENT = GetRemoteEvent("NOTIFICATION_EVENT"),

	SLOCK_EVENT = Signal.new(),
})
