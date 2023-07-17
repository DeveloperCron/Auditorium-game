--[=[
    @class ToggleButton

    Basic switch button with animation
]=]

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BasicPane = require("BasicPane")
local Signal = require("Signal")
local ButtonHighlightModel = require("ButtonHighlightModel")

local ToggleButton = setmetatable({}, BasicPane)
ToggleButton.ClassName = "SwitchButton"
ToggleButton.__index = ToggleButton

function ToggleButton.new()
	local self = setmetatable(BasicPane.new(), ToggleButton)

	self.Activated = Signal.new()
	self._maid:GiveTask(self.Activated)

	self._buttonModel = ButtonHighlightModel.new()
	self._maid:GiveTask(self._buttonModel)

	self._hovered = Blend.State(false)
	self._maid:GiveTask(self._hovered)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	self._maid:GiveTask(self._buttonModel:ObserveIsMouseOrTouchOver():Subscribe(function(isHovered)
		self._hovered:SetValue(isHovered)
	end))

	return self
end

function ToggleButton:GetIsChoosen()
	return self._buttonModel._isChoosen.Value
end

function ToggleButton:SetIsChoosen(choosen: boolean)
	return self._buttonModel:SetIsChoosen(choosen)
end

-- THIS IS HORRIBLE!
function ToggleButton:_render()
	local positionSpring = Blend.Spring(
		Blend.Computed(self._buttonModel._isChoosen, function(chosen)
			if chosen then
				return UDim2.fromScale(0.7, 0.5)
			else
				return UDim2.fromScale(0.3, 0.5)
			end
		end),
		35,
		0.5
	)

	local colorSpring = Blend.Spring(
		Blend.Computed(self._buttonModel._isChoosen, function(chosen)
			if chosen then
				return Color3.fromRGB(52, 52, 52)
			else
				return Color3.fromRGB(248, 247, 247)
			end
		end),
		35,
		1
	)

	local ballColorSpring = Blend.Spring(
		Blend.Computed(self._buttonModel._isChoosen, function(chosen)
			if chosen then
				return Color3.fromRGB(255, 255, 255)
			else
				return Color3.fromRGB(52, 52, 52)
			end
		end),
		35,
		1
	)

	local scaleSpring = Blend.Spring(
		Blend.Computed(self._buttonModel:ObservePercentPressed(), function(hovered)
			return 1 - hovered * 0.2
		end),
		35,
		0.5
	)

	return Blend.New("TextButton")({
		Size = UDim2.fromScale(0.100, 0.045),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.one / 2,
		BackgroundTransparency = 0,
		BackgroundColor3 = colorSpring,
		[Blend.Instance] = function(rbx)
			self._buttonModel:SetButton(rbx)
		end,

		[Blend.OnEvent("Activated")] = function()
			self.Activated:Fire()
		end,

		[Blend.Children] = {
			Blend.New("UIStroke")({
				Thickness = 10,
				Color = Color3.fromHex("#444444"),
			}),

			Blend.New("UIAspectRatioConstraint")({
				AspectRatio = 2,
			}),

			Blend.New("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),

			Blend.New("Frame")({
				Size = UDim2.fromScale(0.36, 0.7),
				Position = positionSpring,
				AnchorPoint = Vector2.one / 2,
				BackgroundColor3 = ballColorSpring,

				[Blend.Children] = {
					Blend.New("UICorner")({
						CornerRadius = UDim.new(1, 0),
					}),

					Blend.New("UIScale")({
						Scale = scaleSpring,
					}),
				},
			}),
		},
	})
end

return ToggleButton
