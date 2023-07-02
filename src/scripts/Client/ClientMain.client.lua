--[[
	@class ClientMain
]]
local packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")

local execution = os.clock()

local serviceBag = require(packages:WaitForChild("ServiceBag")).new()

serviceBag:GetService(packages:WaitForChild("FruitoloAuditoriumServiceClient"))

serviceBag:Init()
serviceBag:Start()
print(string.format("✅ | Took services %ims to initialize!", 1000 * (os.clock() - execution)))
