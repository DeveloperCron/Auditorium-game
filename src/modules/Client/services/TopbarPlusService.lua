--[=[
    @class TopbarPlus.lua
]=]

local soundsList = {
	workspace.Sound.Sound2,
	workspace.Sound.Sound1,
	workspace.Sound.Sound3,
	workspace.Sound.Sound4,
	workspace.Sound.Sound5,
	workspace.Sound.Sound6,
}

local require = require(script.Parent.loader).load(script)
local SettingsScreen = require("SettingsScreen")
local ScreenGuiProvider = require("ScreenGuiProvider")
local Icon = require("icon")
local Maid = require("Maid")
local ServiceBag = require("ServiceBag")
local StageService = require("StageService")

local TopbarPlusService = {}
TopbarPlusService.ClassName = "TopbarPlus"

function TopbarPlusService:Init(serviceBag)
	assert(ServiceBag.isServiceBag(serviceBag), "Not a valid service bag")
	self._maid = Maid.new()

	self._isSoundPlaying = Instance.new("BoolValue")
	self._isSoundPlaying.Value = true
	self._maid:GiveTask(self._isSoundPlaying)

	self._maid._ui, self._settingsScreen = self:_renderUI()
	self._stageService = serviceBag:GetService(StageService)
end

local function makeScreenGui(maid, name: string)
	local screenGui: ScreenGui = ScreenGuiProvider:Get(name)
	screenGui.IgnoreGuiInset = false
	-- screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
	maid:GiveTask(screenGui)

	return screenGui
end

function TopbarPlusService:_renderUI()
	local maid = Maid.new()
	local renderMaid = Maid.new()
	local screenGui = makeScreenGui(maid, "SETTINGS")

	local settingsScreen = SettingsScreen.new()
	renderMaid:GiveTask(settingsScreen)

	renderMaid:GiveTask(settingsScreen.FocusActivated:Connect(function()
		self._stageService:Focus()
	end))

	renderMaid:GiveTask(settingsScreen.SoundActivated:Connect(function()
		self:_playSound()
	end))

	maid:GiveTask(function()
		settingsScreen:Hide()

		task.delay(1, function()
			renderMaid:Destroy()
		end)
	end)

	settingsScreen.Gui.Parent = screenGui
	return maid, settingsScreen
end

function TopbarPlusService:_playSound()
	if not self._isSoundPlaying.Value then
		for _, sound in ipairs(soundsList) do
			-- Play the sound if it is not already playing
			if not sound.IsPlaying then
				sound:Play()
			end

			-- Wait for 5 seconds before playing the next sound
			task.wait(5)
		end
		self._isSoundPlaying = true
	else
		for _, sound in pairs(soundsList) do
			sound:Stop()
		end

		self._isSoundPlaying.Value = false
	end
end

function TopbarPlusService:Start()
	Icon.new()
		:setName("Settings")
		:setImage(14130093939)
		:bindToggleKey(Enum.KeyCode.V)
		:bindEvent("selected", function(_)
			self._settingsScreen:Show()
		end)
		:bindEvent("deselected", function(_)
			self._settingsScreen:Hide()
		end)
		:setCaption("View settings")
end

function TopbarPlusService:Destroy()
	self._maid:DoCleaning()
end

return TopbarPlusService
