--[=[
    @class NotificationTitles

    Contains titles for the NotificationService
    @return Table
]=]

local require = require(script.Parent.loader).load(script)
local Table = require("Table")

return Table.readonly({
	ANNOUNCEMENT = "Announcement",
	NOTIFICATION = "Notification",
})
