--[=[
	@class FruitoloAuditoriumServiceClient
]=]

local require = require(script.Parent.loader).load(script)

local FruitoloAuditoriumServiceClient = {}
FruitoloAuditoriumServiceClient.ServiceName = "FruitoloAuditoriumServiceClient"

function FruitoloAuditoriumServiceClient:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")

	-- External
	self._serviceBag:GetService(require("CmdrServiceClient"))

	-- Internal
	self._serviceBag:GetService(require("DashboardService"))
	self._serviceBag:GetService(require("FruitoloAuditoriumBindersClient"))
	self._serviceBag:GetService(require("FruitoloAuditoriumTranslator"))
end

-- function FruitoloAuditoriumServiceClient:Start()
-- 	GroupUtils.promiseRankInGroup(Player, game.CreatorId):Then(function(rank)
-- 		-- Change the group rank
-- 		if rank >= 0 then
-- 			print(self._FruitoloBinders)
-- 			for _, door in pairs(self._FruitoloBinders.RankDoor:GetAll()) do
-- 				door:Destroy()
-- 			end
-- 		end
-- 	end)
-- end

return FruitoloAuditoriumServiceClient
