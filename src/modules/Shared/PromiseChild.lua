--[=[
    @class PromiseChild.lua

    My implementation of PromiseChild, not using waitforchild
	Made by HowManySmall, modified Dev_Cron
]=]

local require = require(script.Parent.loader).load(script)
local Promise = require("Promise")

local function PromiseChild(Parent, ChildName, Timeout)
	return Promise.new(function(Resolve, Reject, OnCancel)
		local Child = Parent:FindFirstChild(ChildName)
		if Child then
			Resolve(Child)
		else
			local Offset = Timeout or 5
			local StartTime = os.clock()
			local Cancelled = false
			local Connection

			OnCancel(function()
				Cancelled = true
				if Connection then
					Connection = Connection:Disconnect()
				end

				return Reject(
					"PromiseChild(" .. Parent:GetFullName() .. ', "' .. tostring(ChildName) .. '") was cancelled.'
				)
			end)

			Connection = Parent:GetPropertyChangedSignal("Parent"):Connect(function()
				if not Parent.Parent then
					if Connection then
						Connection = Connection:Disconnect()
					end

					Cancelled = true
					return Reject(
						"PromiseChild(" .. Parent:GetFullName() .. ', "' .. tostring(ChildName) .. '") was cancelled.'
					)
				end
			end)

			repeat
				task.wait(0.03)
				Child = Parent:FindFirstChild(ChildName)
			until Child or StartTime + Offset < os.clock() or Cancelled

			if Connection then
				Connection:Disconnect()
			end

			if not Timeout then
				Reject(
					"Infinite yield possible for PromiseChild("
						.. Parent:GetFullName()
						.. ', "'
						.. tostring(ChildName)
						.. '")'
				)
			elseif Child then
				Resolve(Child)
			end
		end
	end)
end

return PromiseChild
