--[=[
    @class Notification

	--@TODO extract the ToolTip! Make it a component by itself
]=]
local require = require(script.Parent.loader).load(script)
local ButtonHighlightModel = require("ButtonHighlightModel")
local SpringObject = require("SpringObject")
local BasicPane = require("BasicPane")
local InputImageLibrary = require("InputImageLibrary")
local Signal = require("Signal")
local Blend = require("Blend")

local Label = require("Label")
local Tooltip = require("Tooltip")

local Notification = setmetatable({}, BasicPane)
Notification.ClassName = "Notification"
Notification.__index = Notification

function Notification.new()
	local self = setmetatable(BasicPane.new(), Notification)

	self.Activated = Signal.new()
	self._maid:GiveTask(self.Activated)

	self._title = Instance.new("StringValue")
	self._title.Value = ""
	self._maid:GiveTask(self._title)

	self._labelText = Instance.new("StringValue")
	self._labelText.Value = ""
	self._maid:GiveTask(self._labelText)

	self._percentVisible = SpringObject.new(0, 35)
	self._maid:GiveTask(self._percentVisible)

	self._isHighlighted = Instance.new("BoolValue")
	self._isHighlighted.Value = false
	self._maid:GiveTask(self._isHighlighted)

	self._buttonModel = ButtonHighlightModel.new()
	self._maid:GiveTask(self._buttonModel)

	self._maid:GiveTask(self.VisibleChanged:Connect(function(isVisible, doNotAnimate)
		self._percentVisible.t = isVisible and 1 or 0
		if doNotAnimate then
			self._percentVisible.p = self._percentVisible.t
			self._percentVisible.v = 0
		end
	end))

	self._maid:GiveTask(self._buttonModel:ObserveIsMouseOrTouchOver():Subscribe(function(isHovered)
		self:setIsHighlighted(isHovered)
	end))

	self._maid:GiveTask(self:_getClickButton():Subscribe(function(gui)
		self._clickButton = gui
	end))

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function Notification.isNotification(class)
	return class and getmetatable(class) == Notification
end

function Notification:setLabelText(text: string)
	assert(typeof(text) == "string" or "number", "Bad text")
	self._labelText.Value = text
end

function Notification:setTitleText(text: string)
	assert(typeof(text) == "string" or "number", "Bad text")
	self._title.Value = text
end

function Notification:setIsHighlighted(isHighlighted: boolean)
	self._isHighlighted.Value = isHighlighted
end

-- Extract it in the future
function Notification:_getClickButton()
	local clickButton = InputImageLibrary:GetScaledImageLabel(Enum.UserInputType.MouseButton1, "Light")
	self._maid:GiveTask(clickButton)

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

	Blend.mount(clickButton, {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.one / 2,
	})

	return Blend.New("TextButton")({
		Size = UDim2.fromScale(0.100, 0.300),
		Position = UDim2.fromScale(0.93, 0.75),
		AnchorPoint = Vector2.one / 2,
		BackgroundTransparency = 1,

		[Blend.OnEvent("Activated")] = function()
			self.Activated:Fire()
		end,

		[Blend.Instance] = function(rbx)
			self._buttonModel:SetButton(rbx)
		end,

		[Blend.Children] = {
			Blend.New("UIScale")({
				Scale = scaleSpring,
			}),
			-- We no more need Blend.Children
			clickButton,
		},
	})
end

function Notification:_render()
	local percentVisible = self._percentVisible:ObserveRenderStepped()
	local scale = Blend.Computed(percentVisible, function(visible)
		return 0.8 + 0.2 * visible
	end)

	return Blend.New("Frame")({
		Size = UDim2.fromScale(0.5, 0.15),
		Position = UDim2.fromScale(0.5, 0.2),
		AnchorPoint = Vector2.one / 2,
		Name = "NotifcationContainer",

		Active = Blend.Computed(percentVisible, function(visible)
			return visible > 0
		end),
		Visible = Blend.Computed(percentVisible, function(visible)
			return visible > 0
		end),
		BackgroundColor3 = Color3.fromRGB(255, 195, 142),

		[Blend.Children] = {
			Blend.New("UIScale")({
				Scale = scale,
			}),

			Blend.New("UICorner")({
				CornerRadius = UDim.new(0.2, 0),
			}),

			self._clickButton,

			Label({
				message = self._labelText,
			}),

			Tooltip({
				text = self._title,
			}),
		},
	})
end

return Notification
