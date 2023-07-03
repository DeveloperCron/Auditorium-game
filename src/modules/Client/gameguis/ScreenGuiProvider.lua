--[=[
    @class ScreenGuiProvider
]=]

local require = require(script.Parent.loader).load(script)
local GenericScreenGuiProvider = require("GenericScreenGuiProvider")

return GenericScreenGuiProvider.new({
	NOTIFICATION = 1,
})
