--[=[
    @class DashboardButton
]=]

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local Signal = require("Signal")
local BasicPane = require("BasicPane")

local DashboardButton = setmetatable({}, BasicPane)
DashboardButton.ClassName = "DashboardButton"
DashboardButton.__index = DashboardButton

function DashboardButton.new()
	local self = setmetatable(BasicPane.new(), DashboardButton)
	self.Activated = Signal.new()
	self._maid:GiveTask(self.Activated)

	self._displayName = Instance.new("StringValue")
	self._displayName.Value = ""
	self._maid:GiveTask(self._displayName)

	self._keypoint1 = Instance.new("Color3Value")
	self._keypoint1.Value = Color3.fromRGB(255, 255, 255)
	self._maid:GiveTask(self._keypoint1)

	self._keypoint2 = Instance.new("Color3Value")
	self._keypoint2.Value = Color3.fromRGB(255, 211, 211)
	self._maid:GiveTask(self._keypoint2)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function DashboardButton:setDisplayName(newDisplayName: string)
	self._displayName.Value = newDisplayName
end

function DashboardButton:setKeypoint1(color: Color3)
	self._keypoint1.Value = color
end

function DashboardButton:setKeypoint2(color: Color3)
	self._keypoint2.Value = color
end

function DashboardButton.isDashboardButton(class)
	return class and getmetatable(class) == DashboardButton
end

function DashboardButton:_render()
	local textColor = Color3.fromRGB(255, 255, 255)

	return Blend.New("TextButton")({
		Size = UDim2.fromOffset(150, 125),
		Name = "Button",
		Text = "",

		[Blend.OnEvent("Activated")] = function()
			self.Activated:Fire()
		end,

		[Blend.Children] = {
			Blend.New("UICorner")({
				CornerRadius = UDim.new(0, 10),
			}),

			Blend.New("UIGradient")({
				Color = Blend.Computed(self._keypoint1, self._keypoint2, ColorSequence.new),
			}),

			Blend.New("TextLabel")({
				FontFace = Font.new(
					"rbxasset://fonts/families/SourceSansPro.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = self._displayName,
				TextColor3 = textColor,
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, 40),
				Size = UDim2.fromOffset(150, 40),
			}),
		},
	})
end

return DashboardButton
