--[=[
    @class SettingsList

	--@TODO
	Add responsive calculations, the frame size should be the listLayout fit
]=]

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local RxBrioUtils = require("RxBrioUtils")
local BasicPane = require("BasicPane")
local ObservableList = require("ObservableList")
local SettingBar = require("SettingBar")

local SettingsList = setmetatable({}, BasicPane)
SettingsList.ClassName = "SettingBarGroup"
SettingsList.__index = SettingsList

function SettingsList.new()
	local self = setmetatable(BasicPane.new(), SettingsList)

	self._barsList = ObservableList.new()
	self._maid:GiveTask(self._barsList)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

--[[
    @param settingName string -- The setting name
    @param defaultValue boolean -- Toggle Button state

    @return SettingBar
]]
function SettingsList:RegisterBar(settingName: string, defaultValue: boolean)
	assert(type(settingName) == "string", "Bad setting name")
	assert(type(defaultValue) == "boolean", "Bad defaultValue")

	local settingBar = SettingBar.new(defaultValue)
	settingBar:SetDisplayName(settingName)
	self._maid:GiveTask(settingBar)

	self._maid:GiveTask(self._barsList:Add(settingBar))

	return settingBar
end

function SettingsList:_render()
	return Blend.New("Frame")({
		Size = UDim2.fromScale(1, 0.35),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.one / 2,
		BackgroundTransparency = 1,
		Name = "List",

		[Blend.Children] = {
			Blend.New("UIListLayout")({
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0.05, 0),
			}),

			self._barsList:ObserveItemsBrio():Pipe({
				RxBrioUtils.map(function(class)
					return class.Gui
				end),
			}),
		},
	})
end

return SettingsList
