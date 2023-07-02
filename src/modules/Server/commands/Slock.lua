--[=[
    @class Slock

    A function that slocks the server
]=]

return {
	Name = "slock",
	Aliases = { "slock" },
	Description = "Locks the server",
	Group = "Admin",
	Args = {
		{
			Type = "boolean",
			Name = "state",
			Description = "state",
		},
	},
}
