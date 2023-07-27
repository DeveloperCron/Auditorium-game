--[=[
    @class Label
]=]
local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local BaseObject = require("BaseObject")

local Label = setmetatable({}, BaseObject)
Label.ClassName = "Label"
Label.__index = Label

function Label.new(message)
	local self = setmetatable(BaseObject.new(), Label)

	self._message = Blend.Computed(message, function(Value)
		return Value
	end)

	self._visibleGraphemes = Blend.State(-1)
	self._maid:GiveTask(self._visibleGraphemes)

	self._isTyping = Blend.State(false)
	self._maid:GiveTask(self._isTyping)

	return self
end

function Label:_startTypeWrite(computedMessage: string)
	self._visibleGraphemes:SetValue(0)

	-- if we just started typing, we need to start a loop to type in the text
	if not self._isTyping.Value then
		self._isTyping:SetValue(true)

		for _ in utf8.graphemes(computedMessage) do
			self._visibleGraphemes:SetValue(self._visibleGraphemes.Value + 1)
			task.wait(0.03)
		end

		self._isTyping:SetValue(false)
	end
end

function Label:render()
	self._maid:GiveTask(self._message:Subscribe(function(sentence)
		self:_startTypeWrite(sentence)
	end))

	return Blend.New("TextLabel")({
		Size = UDim2.fromScale(0.9, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.one / 2,
		BackgroundTransparency = 1,
		TextScaled = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = Color3.fromRGB(53, 53, 53),
		FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		Text = self._message,
		MaxVisibleGraphemes = self._visibleGraphemes,

		[Blend.Children] = {
			Blend.New("UITextSizeConstraint")({
				MaxTextSize = 24,
				MinTextSize = 1,
			}),
		},
	})
end

return Label
