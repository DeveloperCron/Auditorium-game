--[=[
    @class StageService.lua

	Modified roblox code because im lazy to make it by myself
	Based on TweenService because springs dont support CFrame's
]=]

export type ISpringProps = {
	frequency: number,
	dampingRatio: number,
}

local require = require(script.Parent.loader).load(script)
local Players = game:GetService("Players")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Maid = require("Maid")
local RxCharacterUtils = require("RxCharacterUtils")
local RxBrioUtils = require("RxBrioUtils")
local RxInstanceUtils = require("RxInstanceUtils")
local ValueObject = require("ValueObject")
local PromiseChild = require("PromiseChild")
local CatchFactory = require("CatchFactory")
local ServiceBag = require("ServiceBag")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local StageService = {}
StageService.ClassName = "StageService"

function StageService:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")
	self._maid = Maid.new()

	self._hasControl = ValueObject.new(true, "boolean")
	self._maid:GiveTask(self._hasControl)
	self:_setupCharacterAndHumanoidObservables()

	self._characterCamCF = ValueObject.new()
	self._maid:GiveTask(self._characterCamCF)

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

function StageService:_setCameraCF(screenPart: Instance)
	local halfFOV = math.rad(Camera.FieldOfView / 2)
	local halfScreenHeight = screenPart.Size.Y / 2
	local distanceOffset = halfScreenHeight / math.tan(halfFOV)
	local cameraAspectRatio = (Camera.ViewportSize.X / Camera.ViewportSize.Y)
	local screenAspectRatio = screenPart.Size.X / screenPart.Size.Y
	if cameraAspectRatio < screenAspectRatio then
		distanceOffset = distanceOffset / (cameraAspectRatio / screenAspectRatio)
	end
	local targetCF = screenPart.CFrame * CFrame.new(0, 0, -(distanceOffset + screenPart.Size.Z / 2))

	return CFrame.new(targetCF.Position, screenPart.Position)
end

function StageService:_focus(screenPart)
	-- If screenPart is nil or the character, the camera will return to the character
	if screenPart and screenPart == self._character then
		screenPart = nil
	end

	if self._characterCamCF.Value then
		Camera.CameraType = Enum.CameraType.Scriptable
		Camera.CameraSubject = nil
	end

	if screenPart then
		self._hasControl:SetValue(false)
		Camera.CameraType = Enum.CameraType.Scriptable
		Camera.CameraSubject = nil
	else
		Camera.CameraType = Enum.CameraType.Custom
		Camera.CameraSubject = self._humanoid
		self._hasControl:SetValue(true)
		self._characterCamCF:SetValue(nil)
	end

	-- Tween camera into position
	local targetCF = screenPart and self:_setCameraCF(screenPart) or self._characterCamCF.Value
	local cameraTween = TweenService:Create(
		Camera,
		TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
		{ CFrame = targetCF }
	)
	cameraTween:Play()

	if screenPart then
		self._characterCamCF:SetValue(Camera.CFrame)
	end
end

-- Change it to valueObject it will be better
function StageService:Focus()
	if Camera.CameraType == Enum.CameraType.Scriptable then
		self:_focus()
	else
		self:_focus(self._stage)
	end
end

function StageService:Destroy()
	self._maid:DoCleaning()
end

return StageService
