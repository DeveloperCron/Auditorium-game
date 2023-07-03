--[=[
    @class Notification
]=]
local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BasicPane = require("BasicPane")
local SpringObject = require("SpringObject")
local TextServiceUtils = require("TextServiceUtils")
local ValueObject = require("ValueObject")
local ViewPortSize = workspace.Camera.ViewportSize
-- local Math = require("Math")

local Notification = setmetatable({}, BasicPane)
Notification.ClassName = "Notification"
Notification.__index = Notification

function Notification.new()
	local self = setmetatable(BasicPane.new(), Notification)

	self._title = Instance.new("StringValue")
	self._title.Value = ""
	self._maid:GiveTask(self._title)

	self._labelText = Instance.new("StringValue")
	self._labelText.Value = ""
	self._maid:GiveTask(self._labelText)

	self._percentVisible = SpringObject.new(0, 40)
	self._maid:GiveTask(self._percentVisible)

	self._titleSize = ValueObject.new(Vector2.new(120, 40), "Vector2")
	self._maid:GiveTask(self._titleSize)

	self._absoluteSize = ValueObject.new(Vector2.new(), "Vector2")
	self._maid:GiveTask(self._absoluteSize)

	self._maid:GiveTask(self.VisibleChanged:Connect(function(isVisible, doNotAnimate)
		self._percentVisible.t = isVisible and 1 or 0
		if doNotAnimate then
			if doNotAnimate then
				self._percentVisible.p = self._percentVisible.t
				self._percentVisible.v = 0
			end
		end
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

-- EW! must change it some day
function Notification:setTitleText(text: string)
	assert(typeof(text) == "string" or "number", "Bad text")
	self._title.Value = text

	self._maid:GiveTask(TextServiceUtils.observeSizeForLabelProps({
		Text = text,
		Font = Enum.Font.Cartoon,
		MaxSize = Vector2.new(math.huge, math.huge),
		TextSize = 36,
	}):Subscribe(function(size: Vector2)
		self._titleSize:SetValue(size)
	end))
end

function Notification:_render()
	local percentVisible = self._percentVisible:ObserveRenderStepped()
	print(ViewPortSize)

	return Blend.New("Frame")({
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
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
				Scale = Blend.Computed(percentVisible, function(visible)
					return 0.7 + 0.3 * visible
				end),
			}),

			Blend.New("UICorner")({
				CornerRadius = UDim.new(0.2, 0),
			}),

			Blend.New("TextLabel")({
				Size = UDim2.fromScale(0.9, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.one / 2,
				BackgroundTransparency = 1,
				FontSize = Enum.FontSize.Size18,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Medium,
					Enum.FontStyle.Normal
				),
				Text = self._labelText,
			}),

			Blend.New("Frame")({
				-- Bad way but we need to do achieve that somehow!
				Size = Blend.Computed(self._titleSize, function(textSize)
					return UDim2.fromScale(textSize.X / ViewPortSize.X + 0.1, textSize.Y / ViewPortSize.Y + 0.2)
				end),
				Position = UDim2.fromScale(0.2, -0.02),
				AnchorPoint = Vector2.one / 2,
				Rotation = -2,
				Name = "Title",
				BackgroundColor3 = Color3.fromRGB(252, 107, 107),

				[Blend.Children] = {
					Blend.New("UICorner")({
						CornerRadius = UDim.new(1, 0),
					}),

					Blend.New("TextLabel")({
						Size = UDim2.fromScale(0.9, 1),
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.one / 2,
						TextScaled = true,
						BackgroundTransparency = 1,
						Text = self._title,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.new(
							"rbxasset://fonts/families/GothamSSm.json",
							Enum.FontWeight.Bold,
							Enum.FontStyle.Normal
						),
					}),
				},
			}),
		},
	})
end

return Notification
