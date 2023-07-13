--[=[
    @class Label
]=]

type IProps = {
	message: string,
}

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local Maid = require("Maid")

local function Label(props: IProps)
	local renderMaid = Maid.new()
	local message = Blend.Computed(props.message, function(Value)
		return Value
	end)

	local isTyping = false
	local visibleGraphemes = Blend.State(-1)

	local function startTypeWrite(computedMessage)
		visibleGraphemes:SetValue(0)

		-- if we just started typing, we need to start a loop to type in the text
		if not isTyping then
			isTyping = true

			for _ in utf8.graphemes(computedMessage) do
				visibleGraphemes:SetValue(visibleGraphemes.Value + 1)
				task.wait(0.03)
			end

			isTyping = false
		end
	end

	renderMaid:GiveTask(message:Subscribe(function(sentence)
		startTypeWrite(sentence)
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
		Text = message,
		MaxVisibleGraphemes = visibleGraphemes,

		[Blend.Children] = {
			Blend.New("UITextSizeConstraint")({
				MaxTextSize = 24,
				MinTextSize = 1,
			}),
		},
	})
end

return Label
