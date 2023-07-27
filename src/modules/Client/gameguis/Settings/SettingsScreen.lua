--[=[
    @class SettingsScreen

	--@TODO make the use of mathematics here better and maybe optimize it more
	AutomaticSize sucks therefore it cannot be used in this case
]=]

local require = require(script.Parent.loader).load(script)
local SettingsList = require("SettingsList")
local SettingsBase = require("SettingsBase")
local BasicPaneUtils = require("BasicPaneUtils")
local Blend = require("Blend")

local SettingsScreen = setmetatable({}, SettingsBase)
SettingsScreen.ClassName = "SettingsScreen"
SettingsScreen.__index = SettingsScreen

function SettingsScreen.new()
	local self = setmetatable(SettingsBase.new(), SettingsScreen)
	self:SetDisplayName("Settings")

	self._settingsList = SettingsList.new()
	self._soundSetting = self._settingsList:RegisterBar("Sound", true)
	self._stageSetting = self._settingsList:RegisterBar("Stage Focus", false)
	self._maid:GiveTask(BasicPaneUtils.observeVisible(self):Subscribe(function(isVisible)
		self._settingsList:SetVisible(isVisible)
	end))
	self._maid:GiveTask(self._settingsList)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function SettingsScreen:_render()
	return self:_renderBase({
		Position = UDim2.fromScale(0.05, 0.05),
		Size = Vector2.new(0.350, 0.240),

		[Blend.Children] = {
			self._settingsList.Gui,
		},
	})
end

return SettingsScreen
