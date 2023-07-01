--[[
	@class ClientMain
]]
local packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")

local serviceBag = require(packages:WaitForChild("ServiceBag")).new()

serviceBag:GetService(packages:WaitForChild("FruitoloAuditoriumServiceClient"))

serviceBag:Init()
serviceBag:Start()