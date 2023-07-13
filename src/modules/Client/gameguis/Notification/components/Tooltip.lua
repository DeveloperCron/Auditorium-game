--[=[
    @class Tooltip

    Credits for quenty 
    https://gist.github.com/Quenty/803e0a6f36804e327c60347e52803359

    It's still very gross but im not fixing it as for now
]=]

export type ITooltipProps = {
	text: string,
}

local require = require(script.Parent.loader).load(script)
local Blend = require("Blend")
local RxInstanceUtils = require("RxInstanceUtils")
local Rx = require("Rx")
local TextServiceUtils = require("TextServiceUtils")

local function observeChallenge()
	return RxInstanceUtils.observeProperty(workspace, "CurrentCamera"):Pipe({
		Rx.where(function(value)
			return value ~= nil
		end),
		Rx.switchMap(function(camera)
			return RxInstanceUtils.observeProperty(camera, "ViewportSize"):Pipe({
				Rx.where(function(viewportSize)
					return viewportSize.x ~= 1 and viewportSize.y ~= 1
				end),
				Rx.map(function(viewport)
					return viewport
				end),
			})
		end),
	})
end

local function observeTextSize(text: string)
	return TextServiceUtils.observeSizeForLabelProps({
		Text = text,
		Font = Enum.Font.GothamBold,
		MaxSize = Vector2.new(math.huge, math.huge),
		TextSize = 36,
	})
end

local function Tooltip(props: ITooltipProps)
	local backgroundColor = Color3.fromRGB(252, 107, 107)
	-- I know it's bad but that's the only way we can do something like that
	local textSize, viewportSize

	Rx.combineLatest({
		viewport = observeChallenge(),
		size = observeTextSize(props.text),
	}):Subscribe(function(data)
		viewportSize = data.viewport
		textSize = data.size + Vector2.new(120, 40)
	end)

	return Blend.New("Frame")({
		-- IT'S GROSSSS! but works
		Size = UDim2.fromScale(textSize.X / viewportSize.X + 0.2, textSize.Y / viewportSize.Y + 0.2),
		Position = UDim2.fromScale(0.2, -0.02),
		AnchorPoint = Vector2.one / 2,
		Name = "Title",
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
				Text = props.text,
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

return Tooltip
