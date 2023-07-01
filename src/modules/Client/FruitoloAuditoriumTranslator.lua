--[[
	@class FruitoloAuditoriumTranslator
]]

local require = require(script.Parent.loader).load(script)

return require("JSONTranslator").new("FruitoloAuditoriumTranslator", "en", {
	gameName = "FruitoloAuditorium";
})