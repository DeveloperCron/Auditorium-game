local require = require(game:GetService("ServerScriptService"):FindFirstChild("LoaderUtils", true).Parent).load(script)

local ToggleButton = require("ToggleButton")
local Maid = require("Maid")

return function(target)
	local renderMaid = Maid.new()

	local toggleButton = ToggleButton.new()
	renderMaid:GiveTask(toggleButton)

	toggleButton:Show()
	toggleButton.Gui.Parent = target

	renderMaid:GiveTask(toggleButton.Activated:Connect(function()
		toggleButton:SetIsChoosen(not toggleButton:GetIsChoosen())
	end))

	return function()
		renderMaid:DoCleaning()
	end
end
