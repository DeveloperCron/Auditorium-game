--[=[
    @class SettingsBase.lua
]=]

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BasicPane = require("BasicPane")
local SpringObject = require("SpringObject")

local SettingsBase = setmetatable({}, BasicPane)
SettingsBase.ClassName = "SettingsBase"
SettingsBase.__index = SettingsBase

function SettingsBase.new()
	local self = setmetatable(BasicPane.new(), SettingsBase)

	self._displayName = Instance.new("StringValue")
	self._displayName.Value = ""
	self._maid:GiveTask(self._displayName)

	self._percentVisible = SpringObject.new(0.5, 40)
	self._maid:GiveTask(self._percentVisible)

	self._maid:GiveTask(self.VisibleChanged:Connect(function(isVisible, doNotAnimate)
		self._percentVisible.t = isVisible and 1 or 0
		if doNotAnimate then
			self._percentVisible.p = self._percentVisible.t
			self._percentVisible.v = 0
		end
	end))

	return self
end

function SettingsBase:SetDisplayName(displayName: string)
	self._displayName.Value = displayName
end

function SettingsBase:GetDisplayName()
	return self._displayName.Value
end

function SettingsBase:_renderBase(props)
	local SCREEN_PADDING = 0.05

	local percentVisible = self._percentVisible:ObserveRenderStepped()
	local scale = Blend.Computed(percentVisible, function(visible)
		return 0.8 + 0.2 * visible
	end)

	return Blend.New("Frame")({
		Size = Blend.Computed(props.Size, function(value: Vector2)
			return UDim2.fromScale(value.X, value.Y)
		end),
		Position = props.Position,
		AnchorPoint = Vector2.new(0, 0),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Name = self._displayName,
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Active = Blend.Computed(percentVisible, function(visible)
			return visible > 0
		end),
		Visible = Blend.Computed(percentVisible, function(visible)
			return visible > 0.8
		end),

		[Blend.Children] = {
			Blend.New("UIScale")({
				Scale = scale,
			}),
			Blend.New("UICorner")({
				CornerRadius = UDim.new(0.15, 0),
			}),
			Blend.New("UIPadding")({
				PaddingTop = UDim.new(SCREEN_PADDING, 0),
				PaddingBottom = UDim.new(SCREEN_PADDING, 0),
				PaddingLeft = UDim.new(SCREEN_PADDING, 0),
				PaddingRight = UDim.new(SCREEN_PADDING, 0),
			}),
			Blend.New("UISizeConstraint")({
				MaxSize = Vector2.new(250, 140),
				MinSize = Vector2.new(250, 240),
			}),
			Blend.New("UIAspectRatioConstraint")({
				AspectRatio = 2,
			}),
			Blend.New("Frame")({
				Size = UDim2.fromScale(1, 0.3),
				Position = UDim2.fromScale(0.5, 0.15),
				AnchorPoint = Vector2.one / 2,
				Name = "Header",

				[Blend.Children] = {
					Blend.New("ImageLabel")({
						Size = UDim2.fromScale(0.450, 0.450),
						Position = UDim2.fromScale(0.05, 0.5),
						AnchorPoint = Vector2.one / 2,
						Image = "rbxassetid://14109055712",
						BackgroundTransparency = 1,

						[Blend.Children] = {
							Blend.New("UIAspectRatioConstraint")({
								AspectRatio = 1,
							}),
						},
					}),
					Blend.New("TextLabel")({
						Size = UDim2.fromScale(0.25, 1),
						Position = UDim2.fromScale(0.25, 0.5),
						AnchorPoint = Vector2.one / 2,
						Font = Enum.Font.FredokaOne,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextColor3 = Color3.fromHex("#000"),
						BackgroundTransparency = 1,
						Text = self._displayName,
						TextScaled = true,
					}),
				},
			}),

			-- Rendering the children should be done here
			props[Blend.Children],
		},
	})
end

return SettingsBase
