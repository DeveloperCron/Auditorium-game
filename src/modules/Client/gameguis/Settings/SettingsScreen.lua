--[=[
    @class SettingsScreen
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
	self._settingsList:RegisterBar("Sound", true)
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
		Position = UDim2.fromScale(0.5, 0.5),
		Size = Vector2.new(0.350, 0.300),

		[Blend.Children] = {
			self._settingsList.Gui,
		},
	})
end

return SettingsScreen
