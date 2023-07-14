--[=[
	@class Header.lua
]=]

local require = require(script.Parent.loader).load(script)
local BaseObject = require("BaseObject")
local Blend = require("Blend")
local ObservableCamera = require("ObservableCamera")
local Rx = require("Rx")
local TextServiceUtils = require("TextServiceUtils")

local Header = setmetatable({}, BaseObject)
Header.__index = Header

function Header.new(text: string)
	local self = setmetatable(BaseObject.new(), Header)

	-- Getting the text that will be used to calculate the Header size
	self._text = Blend.Computed(text, function(Value)
		return Value
	end)

	-- Observing the viewport in order to covert offset to scale
	self._maid:GiveTask(Rx.combineLatest({
		viewport = ObservableCamera.observeCamera(),
		textSize = self:_observeTextSize(),
	}):Subscribe(function(data)
		self._viewportSize = data.viewport
		self._textSize = data.textSize + Vector2.new(120, 40)
	end))

	return self
end

--[=[
	```lua
	_observableTextSize(text):Subscribe(function(value)
		...
	end)
	```
	@return Observable<Vector2> -- Returns and observable that emits Vector2  

]=]
function Header:_observeTextSize()
	return TextServiceUtils.observeSizeForLabelProps({
		Text = self._text,
		Font = Enum.Font.GothamBold,
		MaxSize = Vector2.new(math.huge, math.huge),
		TextSize = 36,
	})
end

function Header:render()
	local backgroundColor = Color3.fromRGB(252, 107, 107)

	return Blend.New("Frame")({
		Size = UDim2.fromScale(
			self._textSize.X / self._viewportSize.X + 0.2,
			self._textSize.Y / self._viewportSize.Y + 0.2
		),
		Position = UDim2.fromScale(0.2, -0.02),
		AnchorPoint = Vector2.one / 2,
		BackgroundColor3 = backgroundColor,

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
				Text = self._text,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Bold,
					Enum.FontStyle.Normal
				),
			}),
		},
	})
end

return Header
