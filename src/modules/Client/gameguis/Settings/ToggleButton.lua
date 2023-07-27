--[=[
    @class ToggleButton
]=]

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BasicPane = require("BasicPane")
local ButtonHighlightModel = require("ButtonHighlightModel")
local RxValueBaseUtils = require("RxValueBaseUtils")

local ToggleButton = setmetatable({}, BasicPane)
ToggleButton.ClassName = "ToggleButton"
ToggleButton.__index = ToggleButton

function ToggleButton.new(defaultValue: boolean)
	local self = setmetatable(BasicPane.new(), ToggleButton)

	self._toggledState = Instance.new("BoolValue")
	self._toggledState.Value = if defaultValue ~= nil then defaultValue else false
	self._maid:GiveTask(self._toggledState)

	self._buttonModel = ButtonHighlightModel.new()
	self._maid:GiveTask(self._buttonModel)

	self._strokeColor = Instance.new("Color3Value")
	self._strokeColor.Value = Color3.fromHex("#444")
	self._maid:GiveTask(self._strokeColor)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function ToggleButton:ObserveActivated()
	return RxValueBaseUtils.observeValue(self._toggledState)
end

function ToggleButton:_render()
	local SCREEN_PADDING = 4
	local function toggle(first, second)
		return Blend.Spring(
			Blend.Computed(self._toggledState, function(toggled)
				return if toggled then first else second
			end),
			35
		)
	end

	local springScale = Blend.Spring(
		Blend.Computed(self._buttonModel:ObservePercentPressed(), function(hovered)
			return 1 - hovered * 0.2
		end),
		40,
		0.5
	)

	local knobColorSpring = toggle(Color3.fromRGB(255, 255, 255), Color3.fromRGB(35, 35, 35))
	local backgroundSpring = toggle(Color3.fromRGB(255, 192, 55), Color3.fromRGB(255, 255, 255))
	local knobPositionSpring = toggle(1, 0)

	return Blend.New("Frame")({
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.one / 2,
		BackgroundTransparency = 1,

		[Blend.Children] = {
			Blend.New("TextButton")({
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = backgroundSpring,
				Text = "",
				[Blend.Instance] = function(rbx: Instance)
					self._buttonModel:SetButton(rbx)
				end,
				[Blend.OnEvent("Activated")] = function()
					self._toggledState.Value = not self._toggledState.Value
				end,

				[Blend.Children] = {
					Blend.New("UIAspectRatioConstraint")({
						AspectRatio = 2,
					}),
					Blend.New("UICorner")({
						CornerRadius = UDim.new(1, 0),
					}),
					Blend.New("UIPadding")({
						PaddingTop = UDim.new(0, SCREEN_PADDING),
						PaddingBottom = UDim.new(0, SCREEN_PADDING),
						PaddingLeft = UDim.new(0, SCREEN_PADDING),
						PaddingRight = UDim.new(0, SCREEN_PADDING),
					}),

					Blend.New("UIStroke")({
						Thickness = 1.5,
						Color = self._strokeColor.Value,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					}),

					Blend.New("Frame")({
						Size = UDim2.fromScale(0.5, 1),
						AnchorPoint = Blend.Computed(knobPositionSpring, function(value)
							return Vector2.new(value, 0.5)
						end),
						Position = Blend.Computed(knobPositionSpring, function(value)
							return UDim2.fromScale(value, 0.5)
						end),
						BackgroundColor3 = knobColorSpring,

						[Blend.Children] = {
							Blend.New("UIScale")({
								Scale = springScale,
							}),

							Blend.New("UICorner")({
								CornerRadius = UDim.new(1, 0),
							}),

							Blend.New("UIAspectRatioConstraint")({
								AspectRatio = 1,
							}),
						},
					}),
				},
			}),
		},
	})
end

return ToggleButton
