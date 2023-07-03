--[=[
    @class SlockServer
]=]
local require = require(script.Parent.loader).load(script)
local FruitoloConstants = require("FruitoloConstants")

return function(_, state)
	assert(typeof(state) == "boolean", "bad state")
	FruitoloConstants._slockSignal:Fire(state)

	return "Fired server"
end
