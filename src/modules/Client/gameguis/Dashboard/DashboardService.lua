--[=[
    @class DashboardService
]=]
local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
local DashboardUI = require("DashboardUI")
local GetRemoteEvent = require("GetRemoteEvent")
local DashboardButton = require("DashboardButton")
local RxInstanceUtils = require("RxInstanceUtils")

local DashboardService = {}
DashboardService.ClassName = "DashboardService"

function DashboardService:Init(serviceBag)
	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._curtainEvent = GetRemoteEvent("curtainEvent")
	self._maid:GiveTask(self._curtainEvent)

	self._maid.gui, self._surfaceGui = self:_renderDashboard()
end

function DashboardService:_renderDashboard()
	-- @TODO This sucks
	local maid = Maid.new()
	local renderMaid = Maid.new()

	local SurfaceGui = Instance.new("SurfaceGui")
	SurfaceGui.Name = "SurfaceGui"
	SurfaceGui.ClipsDescendants = true
	SurfaceGui.LightInfluence = 1
	SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	maid:GiveTask(RxInstanceUtils.observeLastNamedChildBrio(workspace, "Part", "Dashboard"):Subscribe(function(brio)
		local dashboard = brio:GetValue()
		SurfaceGui.Parent = dashboard
	end))

	local dashboardUI = DashboardUI.new()
	renderMaid:GiveTask(dashboardUI)

	maid:GiveTask(function()
		dashboardUI:Hide()

		task.delay(1, function()
			renderMaid:Destroy()
		end)
	end)

	dashboardUI:Show()
	dashboardUI.Gui.Parent = SurfaceGui

	do
		local button = DashboardButton.new()
		button:setDisplayName("Close Curtain")
		button:setKeypoint1(Color3.fromRGB(225, 66, 66))
		button:setKeypoint2(Color3.fromRGB(255, 111, 111))
		maid:GiveTask(button)
		maid:GiveTask(button.Activated:Connect(function()
			self._curtainEvent:FireServer(false)
		end))
		maid:GiveTask(dashboardUI:AddDashboardButton(button))
	end

	do
		local button = DashboardButton.new()
		button:setDisplayName("Open Curtain")
		button:setKeypoint1(Color3.fromRGB(0, 211, 18))
		button:setKeypoint2(Color3.fromRGB(147, 255, 80))
		maid:GiveTask(button)
		maid:GiveTask(button.Activated:Connect(function()
			self._curtainEvent:FireServer(true)
		end))
		maid:GiveTask(dashboardUI:AddDashboardButton(button))
	end

	return maid, SurfaceGui
end

function DashboardService:Destroy()
	self._maid:Cleanup()
end

return DashboardService
