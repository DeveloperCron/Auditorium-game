--[=[
    @class SlockServer
]=]
local require = require(script.Parent.loader).load(script)
local FruitoloConstants = require("FruitoloConstants")

return function(context, state)
	assert(typeof(state) == "boolean", "bad state")
	FruitoloConstants.SLOCK_EVENT:Fire(state, context.Executor)

	return "Fired server"
end
