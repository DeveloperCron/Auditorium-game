--[=[
    @class FruitoloConstants
]=]

local require = require(script.Parent.loader).load(script)
local Signal = require("Signal")
local Table = require("Table")

return Table.readonly({
	_slockSignal = Signal.new(),
})
