--[=[
    @class SettingBar
]=]

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BasicPane = require("BasicPane")
local ToggleButton = require("ToggleButton")
local Signal = require("Signal")

local SettingBar = setmetatable({}, BasicPane)
SettingBar.ClassName = "SettingBar"
SettingBar.__index = SettingBar

function SettingBar.new(defaultValue: boolean)
	local self = setmetatable(BasicPane.new(), SettingBar)

	self.Activated = Signal.new()
	self._maid:GiveTask(self.Activated)

	self._toggleButton = ToggleButton.new(defaultValue)
	self._maid:GiveTask(self._toggleButton)

	self._displayName = Instance.new("StringValue")
	self._displayName.Value = ""
	self._maid:GiveTask(self._displayName)

	self._maid:GiveTask(self._toggleButton:ObserveActivated():Subscribe(function()
		self.Activated:Fire()
	end))

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function SettingBar.isSettingBar(class)
	return class and getmetatable(class) == SettingBar
end

function SettingBar:SetDisplayName(displayName: string)
	self._displayName.Value = displayName
end

function SettingBar:GetDisplayName()
	return self._displayName.Value
end

function SettingBar:_render()
	return Blend.New("Frame")({
		Size = UDim2.fromScale(1, 0.8),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.one / 2,

		[Blend.Children] = {
			Blend.New("TextLabel")({
				Position = UDim2.fromScale(0.4, 0.5),
				Size = UDim2.fromScale(0.6, 0.6),
				AnchorPoint = Vector2.one / 2,
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				TextScaled = true,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Color3.fromRGB(53, 53, 53),
				Text = self._displayName,
			}),
			Blend.New("Frame")({
				Size = UDim2.fromScale(0.2, 0.7),
				Position = UDim2.fromScale(0.8, 0.5),
				AnchorPoint = Vector2.one / 2,

				[Blend.Children] = {
					self._toggleButton.Gui,
				},
			}),
		},
	})
end

return SettingBar
