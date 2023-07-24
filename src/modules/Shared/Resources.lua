--[[
    Resources
    A module for managing and caching GUI objects from ServerStorage.
]]
local require = require(script.Parent.loader).load(script)
local ServerStorage = game:GetService("ServerStorage")

local Resources = {}
local Caches: { [string]: Instance } = {}
local MAX_CACHE_SIZE: number = 50

function Resources.GetGuiObject(guiName: string): Instance | nil
	if Caches[guiName] then
		return Caches[guiName]
	end

	local BillBoardGui = ServerStorage:FindFirstChild("BillBoardGui")
	if not BillBoardGui then
		warn("[Resources.GetGuiObject] BillBoardGui is nil")
		return nil
	end

	local object = BillBoardGui:FindFirstChild(guiName)
	if object then
		-- Check if the cache size exceeds the limit and remove the least recently used entry
		if #Caches >= MAX_CACHE_SIZE then
			local oldestKey
			for key in pairs(Caches) do
				oldestKey = key
				break
			end
			Caches[oldestKey] = nil
		end

		Caches[object.Name] = object
		return object
	else
		warn("[Resources.GetGuiObject] Object not found:", guiName)
		return nil
	end
end

return Resources
