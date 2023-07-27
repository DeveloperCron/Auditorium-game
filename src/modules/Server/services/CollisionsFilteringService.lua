--[=[
    @class CollisionsFilteringService

    Filtering the collisions of the player character
]=]

local require = require(script.Parent.loader).load(script)
local PhysicsService = game:GetService("PhysicsService")
local RxInstanceUtils = require("RxInstanceUtils")
local Maid = require("Maid")
local ServiceBag = require("ServiceBag")

PhysicsService:RegisterCollisionGroup("Characters")
PhysicsService:CollisionGroupSetCollidable("Characters", "Characters", false)

local CollisionsFilteringService = {}
CollisionsFilteringService.ClassName = "CollisionsFilteringService"

function CollisionsFilteringService:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")
	self._maid = Maid.new()
end

function CollisionsFilteringService:addCharacter(character: Model)
	self._maid:GiveTask(RxInstanceUtils.observeDescendantsBrio(character):Subscribe(function(brio)
		local descendant = brio:GetValue()
		if not descendant:IsA("BasePart") then
			return brio:Kill()
		end

		descendant.CollisionGroup = "Characters"
	end))
end

return CollisionsFilteringService
