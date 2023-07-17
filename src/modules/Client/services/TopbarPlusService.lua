--[=[
    @class TopbarPlus.lua
]=]

local require = require(script.Parent.loader).load(script)
local Icon = require("icon")

local TopbarPlusService = {}
TopbarPlusService.ClassName = "TopbarPlus"

function TopbarPlusService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
end

-- 12129421849
function TopbarPlusService:Start()
	-- Creating a new Icon Instance
	Icon
		.new()
		:setName("ScreenIcon")
		:setImage(12112769614)
		:bindToggleKey(Enum.KeyCode.V)
		-- :bindEvent("selected", function(_)
		-- 	toggleFullscreen()
		-- end)
		-- :bindEvent("deselected", function(_)
		-- 	toggleFullscreen()
		-- end)
		:setCaption(
			"Stage View"
		)
end

return TopbarPlusService
