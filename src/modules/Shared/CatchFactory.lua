-- TODO: Report errors via AnalyticsService (when enabled)
-- Stolen from howmanysmall, im jew and im allowed

local CatchFunctions = setmetatable({}, {
	__index = function(self, Index)
		local function Value(Error)
			warn(string.format("Error in function %s: %s", Index, tostring(Error)))
		end

		self[Index] = Value
		return Value
	end,
})

local function CatchFactory(FunctionName)
	return CatchFunctions[FunctionName]
end

return CatchFactory
