--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService.FruitoloAuditorium:FindFirstChild("LoaderUtils", true).Parent
local execution = os.clock()
local packages = require(loader).bootstrapGame(ServerScriptService.FruitoloAuditorium)

local serviceBag = require(packages.ServiceBag).new()

serviceBag:GetService(packages.FruitoloAuditoriumService)

serviceBag:Init()
serviceBag:Start()
print(string.format("✅ | Took services %ims to initialize!", 1000 * (os.clock() - execution)))
