--[=[
    @class DashboardService
]=]

local require = require(script.Parent.loader).load(script)
local DashboardPanel = require("DashboardPanel")
local DashboardButton = require("DashboardButton")
local FruitoloConstants = require("FruitoloConstants")
local BaseObject = require("BaseObject")
local Maid = require("Maid")

local Dashboard = setmetatable({}, BaseObject)
Dashboard.ClassName = "Dashboard"
Dashboard.__index = Dashboard

function Dashboard.new(obj)
	local self = setmetatable(BaseObject.new(obj), Dashboard)
	self._dashboardEvent = FruitoloConstants.CURTAIN_EVENT
	self._maid:GiveTask(self._dashboardEvent)

	self._surfaceGui = self:_makeSurfaceGui()
	self._maid:GiveTask(self._surfaceGui)

	self._maid.gui = self:_render()

	return self
end

function Dashboard:_makeSurfaceGui()
	local SurfaceGui = Instance.new("SurfaceGui")
	SurfaceGui.Name = "SurfaceGui"
	SurfaceGui.ClipsDescendants = true
	SurfaceGui.LightInfluence = 1
	SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SurfaceGui.Parent = self._obj

	return SurfaceGui
end

function Dashboard:_render()
	local maid = Maid.new()
	self._maid:GiveTask(maid)

	local dashboardPanel = DashboardPanel.new()
	maid:GiveTask(dashboardPanel)

	dashboardPanel:Show()
	dashboardPanel.Gui.Parent = self._surfaceGui

	do
		local button = DashboardButton.new()
		button:setDisplayName("Close Curtain")
		button:setKeypoint1(Color3.fromRGB(225, 66, 66))
		button:setKeypoint2(Color3.fromRGB(255, 111, 111))
		maid:GiveTask(button)
		maid:GiveTask(button.Activated:Connect(function()
			self._dashboardEvent:FireServer(false)
		end))
		maid:GiveTask(dashboardPanel:AddDashboardButton(button))
	end

	do
		local button = DashboardButton.new()
		button:setDisplayName("Open Curtain")
		button:setKeypoint1(Color3.fromRGB(0, 211, 18))
		button:setKeypoint2(Color3.fromRGB(147, 255, 80))
		maid:GiveTask(button)
		maid:GiveTask(button.Activated:Connect(function()
			self._dashboardEvent:FireServer(true)
		end))
		maid:GiveTask(dashboardPanel:AddDashboardButton(button))
	end

	return maid
end

return Dashboard
