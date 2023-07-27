--[=[
    @class StageService.lua

	Maybe there's a better way of doing so, using the CameraStackService
]=]

local require = require(script.Parent.loader).load(script)
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local Maid = require("Maid")
local RxCharacterUtils = require("RxCharacterUtils")
local RxBrioUtils = require("RxBrioUtils")
local RxInstanceUtils = require("RxInstanceUtils")
local ValueObject = require("ValueObject")
local PromiseChild = require("PromiseChild")
local CatchFactory = require("CatchFactory")
local player = Players.LocalPlayer

local StageService = {}
StageService.ClassName = "StageService"

function StageService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._hasControl = ValueObject.new(true, "boolean")
	self._maid:GiveTask(self._hasControl)
	self:_setupCharacterAndHumanoidObservables()

	self._maid:GiveTask(PromiseChild(workspace, "StageCamera", 10):Then(function(stage)
		self._stage = stage
	end):Catch(CatchFactory("PromiseChild")))
end

function StageService:_setupCharacterAndHumanoidObservables()
	self._maid:GiveTask(RxCharacterUtils.observeLastCharacterBrio(player)
		:Pipe({
			RxBrioUtils.switchMapBrio(function(character)
				return RxInstanceUtils.observeLastNamedChildBrio(character, "Humanoid", "Humanoid"):Pipe({
					RxBrioUtils.map(function(humanoid: Instance)
						return character, humanoid
					end),
				})
			end),
		})
		:Subscribe(function(brio)
			self._character, self._humanoid = brio:GetValue()
		end))
end

function StageService:Start()
	-- Updates everytime the self._hasControl ValueObject is being changed!
	self._maid:GiveTask(self._hasControl:Observe():Subscribe(function(hasControl: boolean)
		if self._humanoid == nil then
			return
		end

		if not hasControl then
			self._humanoid.WalkSpeed = 0
			self._humanoid.JumpPower = 0
			self._humanoid.AutoRotate = false
		else
			self._humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
			self._humanoid.JumpPower = StarterPlayer.CharacterJumpPower
			self._humanoid.AutoRotate = true
		end
	end))
end

function StageService:FocusOnStage()
	self._camera.CameraType = Enum.CameraType.Scriptable
end

function StageService:UnFocusOnStage() end

function StageService:Destroy()
	self._maid:DoCleaning()
end

return StageService
