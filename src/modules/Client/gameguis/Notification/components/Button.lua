--[=[
    @class Button.lua
]=]

export type IButtonProps = {
	Position: UDim2,
}

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BaseObject = require("BaseObject")
local ButtonHighlightModel = require("ButtonHighlightModel")
local InputImageLibrary = require("InputImageLibrary")
local Signal = require("Signal")

local Button = setmetatable({}, BaseObject)
Button.ClassName = "Button"
Button.__index = Button

function Button.new()
	local self = setmetatable(BaseObject.new(), Button)

	self.Activated = Signal.new()
	self._maid:GiveTask(self.Activated)

	self._isHighlighted = Blend.State(false)
	self._maid:GiveTask(self._isHighlighted)

	-- Store the button model in the axtual button so we can ensure it cleans up
	-- This assumes only one render. We can also construct it in the Button.Render
	self._buttonModel = ButtonHighlightModel.new()
	self._maid:GiveTask(self._buttonModel)

	self._button = InputImageLibrary:GetScaledImageLabel(Enum.UserInputType.MouseButton1, "Light")
	self._maid:GiveTask(self._button)

	self._maid:GiveTask(self._buttonModel:ObserveIsMouseOrTouchOver():Subscribe(function(isHovered)
		self._isHighlighted:SetValue(isHovered)
	end))

	self._maid:GiveTask(self._buttonModel:ObserveIsPressed():Subscribe(function()
		self.Activated:Fire()
	end))

	return self
end

function Button:render(props: IButtonProps)
	local scaleSpring = Blend.Spring(
		Blend.Computed(self._isHighlighted, function(isHovered)
			if isHovered then
				return 0.8
			end

			return 1
		end),
		35,
		0.5
	)

	Blend.mount(self._button, {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.one / 2,
	})

	return Blend.New("TextButton")({
		Size = UDim2.fromScale(0.100, 0.300),
		Position = props.Position,
		AnchorPoint = Vector2.one / 2,
		BackgroundTransparency = 1,

		[Blend.Instance] = function(rbx)
			self._buttonModel:SetButton(rbx)
		end,

		[Blend.Children] = {
			Blend.New("UIScale")({
				Scale = scaleSpring,
			}),

			Blend.New("UIAspectRatioConstraint")({
				AspectRatio = 1,
			}),
			-- We no more need Blend.Children
			self._button,
		},
	})
end

return Button
