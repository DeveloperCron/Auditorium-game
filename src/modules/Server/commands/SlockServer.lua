--[=[
    @class SlockServer
]=]
local require = require(script.Parent.loader).load(script)
local CmdrConfig = require("CmdrConfig")

return function(_, state)
	assert(typeof(state) == "boolean", "bad state")
	CmdrConfig._slockSignal:Fire(state)

	return "Fired server"
end
