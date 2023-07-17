--[=[
    @class DashboardPanel
]=]

local require = require(script.Parent.loader).load(script)
local BasicPane = require("BasicPane")
local Blend = require("Blend")
local RxBrioUtils = require("RxBrioUtils")
local ObservableList = require("ObservableList")
local DashboardButton = require("DashboardButton")

local DashboardPanel = setmetatable({}, BasicPane)
DashboardPanel.ClassName = "DashboardPanel"
DashboardPanel.__index = DashboardPanel

function DashboardPanel.new()
	local self = setmetatable(BasicPane.new(), DashboardPanel)

	self._children = ObservableList.new()
	self._maid:GiveTask(self._children)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function DashboardPanel:AddDashboardButton(class)
	assert(DashboardButton.isDashboardButton(class), "Bad dashboard button")

	return self._children:Add(class)
end

function DashboardPanel:_render()
	local backgroundColor = Color3.fromRGB(188, 177, 162)
	return Blend.New("Frame")({
		BackgroundColor3 = backgroundColor,
		Size = UDim2.fromOffset(325, 400),

		[Blend.Children] = {
			Blend.New("UICorner")({
				CornerRadius = UDim.new(0, 10),
			}),

			Blend.New("UIGradient")({
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(172, 127, 100)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(186, 141, 102)),
				}),
			}),

			Blend.New("TextLabel")({
				FontFace = Font.new(
					"rbxasset://fonts/families/SourceSansPro.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
				Text = "Fruitolo Controls",
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextScaled = true,
				TextSize = 14,
				TextWrapped = true,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(325, 50),
			}),

			Blend.New("Frame")({
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.one / 2,
				BackgroundTransparency = 1,

				[Blend.Children] = {
					Blend.New("UIListLayout")({
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					self._children:ObserveItemsBrio():Pipe({
						RxBrioUtils.map(function(class)
							return class.Gui
						end),
					}),
				},
			}),
		},
	})
end

return DashboardPanel
