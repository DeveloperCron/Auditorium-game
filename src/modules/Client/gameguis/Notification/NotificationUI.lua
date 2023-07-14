--[=[
    @class Notification
]=]

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BasicPane = require("BasicPane")
local SpringObject = require("SpringObject")

local Label = require("Label")
local Header = require("Header")
local Button = require("Button")

local NotificationUI = setmetatable({}, BasicPane)
NotificationUI.ClassName = "NotificationUI"
NotificationUI.__index = NotificationUI

function NotificationUI.new()
	local self = setmetatable(BasicPane.new(), NotificationUI)

	self._title = Instance.new("StringValue")
	self._title.Value = ""
	self._maid:GiveTask(self._title)

	self._labelText = Instance.new("StringValue")
	self._labelText.Value = ""
	self._maid:GiveTask(self._labelText)

	self._percentVisible = SpringObject.new(0, 35)
	self._maid:GiveTask(self._percentVisible)

	self._label = Label.new(self._labelText)
	self._maid:GiveTask(self._label)

	self._button = Button.new()
	self._maid:GiveTask(self._button)

	self._header = Header.new(self._title)
	self._maid:GiveTask(self._header)

	-- Aliasing the Activated to the UI
	-- @TODO change this in the future!
	self.Activated = self._button.Activated

	self._maid:GiveTask(self.VisibleChanged:Connect(function(isVisible, doNotAnimate)
		self._percentVisible.t = isVisible and 1 or 0
		if doNotAnimate then
			self._percentVisible.p = self._percentVisible.t
			self._percentVisible.v = 0
		end
	end))

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function NotificationUI.isNotification(class)
	return class and getmetatable(class) == NotificationUI
end

function NotificationUI:setLabelText(text: string)
	assert(typeof(text) == "string" or "number", "Bad text")
	self._labelText.Value = text
end

function NotificationUI:setTitleText(text: string)
	assert(typeof(text) == "string" or "number", "Bad text")
	self._title.Value = text
end

function NotificationUI:_render()
	local percentVisible = self._percentVisible:ObserveRenderStepped()
	local scale = Blend.Computed(percentVisible, function(visible)
		return 0.8 + 0.2 * visible
	end)
	local transparency = Blend.Computed(percentVisible, function(visible)
		return 1 - visible
	end)

	return Blend.New("CanvasGroup")({
		Size = UDim2.fromScale(0.5, 0.16),
		Position = UDim2.fromScale(0.5, 0.2),
		AnchorPoint = Vector2.one / 2,
		Name = "NotificationPreview",
		BackgroundTransparency = 1,
		GroupTransparency = transparency,

		Active = Blend.Computed(percentVisible, function(visible)
			return visible > 0
		end),
		Visible = Blend.Computed(percentVisible, function(visible)
			return visible > 0
		end),

		[Blend.Children] = {
			Blend.New("UIScale")({
				Scale = scale,
			}),

			Blend.New("Frame")({
				Size = UDim2.fromScale(0.9, 0.7),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.one / 2,
				BackgroundColor3 = Color3.fromRGB(255, 195, 142),
				Name = "Notification",
				[Blend.Children] = {
					Blend.New("UICorner")({
						CornerRadius = UDim.new(0.2, 0),
					}),

					-- Components
					self._button:render({
						Position = UDim2.fromScale(0.93, 0.75),
					}),
					self._label:render(),
					self._header:render(),
				},
			}),
		},
	})
end

return NotificationUI
