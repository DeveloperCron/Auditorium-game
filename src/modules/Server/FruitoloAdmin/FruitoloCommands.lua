--[=[
    @class Commands.lua
]=]

local require = require(script.Parent.loader).load(script)
local FruitoloConstants = require("FruitoloConstants")
local Workspace = game:GetService("Workspace")

export type Command = {
	PrimaryAlias: string,
	SecondaryAlias: string?,
	PermissionLevel: number, -- 0-255
	Function: (player: Player, args: { string }) -> (),
}

local Commands = {
	Prefix = "/",
	List = {
		{
			PrimaryAlias = "gravity",
			SecondaryAlias = "grav",
			PermissionLevel = 0,
			Function = function(player: Player, args: { string })
				local gravity = args[1]
				if gravity and tonumber(gravity) then
					Workspace.Gravity = tonumber(gravity) :: number
				end
			end,
		},
		{
			PrimaryAlias = "slock",
			SecondaryAlias = "slock",
			Function = function(player: Player, args: { string })
				local state = args[1]
				if state then
					FruitoloConstants.SLOCK_EVENT:Fire(state, player)
				end
			end,
		},
	} :: { Command },
}

return Commands
