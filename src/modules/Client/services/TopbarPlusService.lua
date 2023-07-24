--[=[
    @class TopbarPlus.lua
]=]

local require = require(script.Parent.loader).load(script)
local SettingsScreen = require("SettingsScreen")
local ScreenGuiProvider = require("ScreenGuiProvider")
local Icon = require("icon")
local Maid = require("Maid")

local TopbarPlusService = {}
TopbarPlusService.ClassName = "TopbarPlus"

function TopbarPlusService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._maid._ui, self._settingsScreen = self:_renderUI()
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

	maid:GiveTask(function()
		settingsScreen:Hide()

		task.delay(1, function()
			renderMaid:Destroy()
		end)
	end)

	settingsScreen.Gui.Parent = screenGui

	return maid, settingsScreen
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
