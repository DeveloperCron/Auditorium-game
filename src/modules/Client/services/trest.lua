-- ScreenController.client.lua
-- @author: Dev_Cron

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Camera = workspace.CurrentCamera
local buttonTargetScreen = workspace:FindFirstChild("StageCamera")
local Player = Players.LocalPlayer
local lockCameraConnection = nil
local characterCamCF = nil
local characterCamCFIsRelative = false
local transitionCount = 0
local FocusedScreen = nil

local Vendor = ReplicatedStorage.Vendor
local subModules = Vendor.SubModules

local icon = require(subModules.TopbarPlus)

local function setHumanoidControl(hasControl)
	local character = Player.Character
	if character and character.Parent then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not hasControl then
			humanoid.WalkSpeed = 0
			if humanoid.UseJumpPower then
				humanoid.JumpPower = 0
			else
				humanoid.JumpHeight = 0
			end
			humanoid.AutoRotate = false
		else
			humanoid.WalkSpeed = StarterPlayer.CharacterWalkSpeed
			if humanoid.UseJumpPower then
				humanoid.JumpPower = StarterPlayer.CharacterJumpPower
			else
				humanoid.JumpHeight = StarterPlayer.CharacterJumpHeight
			end
			humanoid.AutoRotate = true
		end
	end

	-- Find the jump button and adjust it's visibility
	if UserInputService.TouchEnabled then
		local playerGui = Player:FindFirstChild("PlayerGui")
		if playerGui then
			local touchGui = playerGui:FindFirstChild("TouchGui")
			if touchGui then
				local controlFrame = touchGui:FindFirstChild("TouchControlFrame")
				if controlFrame then
					local jumpButton = controlFrame:FindFirstChild("JumpButton")
					if jumpButton then
						TweenService:Create(
							touchGui.TouchControlFrame.JumpButton,
							TweenInfo.new(0.5),
							{ ImageTransparency = hasControl and 0 or 1 }
						):Play()
					end
				end
			end
		end
	end
end

local function setCameraCF(screenPart)
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

local function getCharacterPart()
	local character = Player.Character
	if character and character.Parent and character:IsA("Model") then
		return character.PrimaryPart
	end
end

local function FocusScreen(screenPart, manageLockingCharacterControl)
	-- If screenPart is nil or the character, the camera will return to the character
	if screenPart and screenPart == Player.Character then
		screenPart = nil
	end

	if FocusedScreen == screenPart then
		return
	end

	FocusedScreen = screenPart

	transitionCount += 1
	local thisTransitionCount = transitionCount

	-- Tween camera into position
	local targetCF = nil
	local camTweenRelativeTargetPart = nil
	if screenPart then
		if manageLockingCharacterControl then
			setHumanoidControl(false)
		end

		-- If focusing a screen, and no currently saved relative info for the character, then capture relative character info.
		if not characterCamCF then
			local cameraSubjectPart = getCharacterPart()
			if cameraSubjectPart then
				characterCamCF = CFrame.new(cameraSubjectPart.Position):ToObjectSpace(Camera.CFrame)
				characterCamCFIsRelative = true
			else
				characterCamCF = Camera.CFrame
				characterCamCFIsRelative = false
			end
		end

		Camera.CameraType = Enum.CameraType.Scriptable
		targetCF = setCameraCF(screenPart)
	else
		targetCF = characterCamCF
		if characterCamCFIsRelative then
			camTweenRelativeTargetPart = getCharacterPart()
		end
	end

	if targetCF then
		-- Tweening an object so that we can apply the tweened cframe overtop a camera subject
		local cfObject = Instance.new("CFrameValue")
		if camTweenRelativeTargetPart and camTweenRelativeTargetPart.Parent then
			cfObject.Value = CFrame.new(camTweenRelativeTargetPart.Position * -1) * Camera.CFrame
		else
			cfObject.Value = Camera.CFrame
		end
		local cameraTween = TweenService:Create(
			cfObject,
			TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
			{ Value = targetCF }
		)
		local cfChangedConn = cfObject.Changed:connect(function()
			if transitionCount == thisTransitionCount then
				Camera.CameraType = Enum.CameraType.Scriptable
				if camTweenRelativeTargetPart and camTweenRelativeTargetPart.Parent then
					Camera.CFrame = CFrame.new(camTweenRelativeTargetPart.Position) * cfObject.Value
				else
					Camera.CFrame = cfObject.Value
				end
			end
		end)
		cameraTween:Play()
		cameraTween.Completed:Wait()
		cfChangedConn:Disconnect()
		cfChangedConn = nil
		cfObject = nil
	end

	-- Camera finished tweening
	if transitionCount == thisTransitionCount then
		if screenPart then
			-- Lock camera to screen
			if lockCameraConnection then
				lockCameraConnection:Disconnect()
				lockCameraConnection = nil
			end
			lockCameraConnection = RunService.RenderStepped:Connect(function()
				if transitionCount == thisTransitionCount then
					Camera.CFrame = setCameraCF(screenPart)
				end
			end)
		else
			-- Return camera to character
			Camera.CameraType = Enum.CameraType.Custom
			characterCamCF = nil
			characterCamCFIsRelative = false
			local character = Player.Character
			if character and character.Parent then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					Camera.CameraSubject = humanoid
				end
			end
			if manageLockingCharacterControl then
				setHumanoidControl(true)
			end
		end
	end
end

local function toggleFullscreen() -- Only toggle if button exists, as a user control
	if FocusedScreen ~= buttonTargetScreen then
		FocusScreen(buttonTargetScreen)
	else
		FocusScreen()
	end
end

icon.new()
	:setName("ScreenIcon")
	:setImage(12129421849, "selected")
	:bindToggleKey(Enum.KeyCode.V)
	:bindEvent("selected", function(_)
		toggleFullscreen()
	end)
	:bindEvent("deselected", function(_)
		toggleFullscreen()
	end)
	:setCaption("Stage View")
