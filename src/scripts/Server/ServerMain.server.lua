--[[
	@class ServerMain
]]
local ServerScriptService = game:GetService("ServerScriptService")

local loader = ServerScriptService.FruitoloAuditorium:FindFirstChild("LoaderUtils", true).Parent
local packages = require(loader).bootstrapGame(ServerScriptService.FruitoloAuditorium)

local serviceBag = require(packages.ServiceBag).new()

serviceBag:GetService(packages.FruitoloAuditoriumService)

serviceBag:Init()
serviceBag:Start()