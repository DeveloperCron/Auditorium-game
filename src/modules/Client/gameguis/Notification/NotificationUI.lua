--[=[
    @class NotificationUI
]=]

local require = require(script.Parent.loader).load(script)
local BasicPane = require("BasicPane")
local Blend = require("Blend")
local ObservableList = require("ObservableList")
local RxBrioUtils = require("RxBrioUtils")
local Notification = require("Notification")

local NotificationUI = setmetatable({}, BasicPane)
NotificationUI.ClassName = "NotificationUI"
NotificationUI.__index = NotificationUI

function NotificationUI.new()
	local self = setmetatable(BasicPane.new(), NotificationUI)

	self._children = ObservableList.new()
	self._maid:GiveTask(self._children)

	self._maid:GiveTask(self:_render():Subscribe(function(gui)
		self.Gui = gui
	end))

	return self
end

function NotificationUI:addNotifcation(class)
	assert(Notification.isNotification(class), "Bad notification")

	return self._children:Add(class)
end

function NotificationUI:_render()
	return Blend.New("Frame")({
		Size = UDim2.fromScale(0.5, 0.2),
		Position = UDim2.fromScale(0.5, 0.2),
		AnchorPoint = Vector2.one / 2,

		BackgroundTransparency = 1,

		[Blend.Children] = {
			self._children:ObserveItemsBrio():Pipe({
				RxBrioUtils.map(function(class)
					return class.Gui
				end),
			}),
		},
	})
end

function NotificationUI:observeChildren() end

return NotificationUI
