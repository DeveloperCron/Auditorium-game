--[=[
	@class Resources.lua

	Again stolen from howmanysmall but i changed it
]=]

local require = require(script.Parent.loader).load(script)
local ServerStorage = game:GetService("ServerStorage")

local Resources = {}
local Caches = {}

function Resources.GetGuiObject(guiName: string)
	if Caches[guiName] then
		return Caches[guiName]
	end

	local BillBoardGui = ServerStorage:FindFirstChild("BillBoardGui")
	if not BillBoardGui then
		warn("[Resources.GetGuiObject] BillBoardGui is nil")
	end

	local object = BillBoardGui:FindFirstChild(guiName)
	if object then
		Caches[object.Name] = object
		return object
	else
		warn("[Resources.GetGuiObject] Object is nil")
	end
end

return Resources
