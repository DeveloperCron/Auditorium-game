--[=[
    @class ObserveCamaraUtils
	
	Credits for quenty 
    https://gist.github.com/Quenty/803e0a6f36804e327c60347e52803359
]=]

local require = require(script.Parent.loader).load(script)
local Rx = require("Rx")
local RxInstanceUtils = require("RxInstanceUtils")

local ObservableCamera = {}
ObservableCamera.ClassName = "ObservableCamera"
ObservableCamera.__index = ObservableCamera

--[=[
	OnservableCamera, utility function to observe camera and the viewport
	@return Observable
]=]
function ObservableCamera.observeCamera()
	return RxInstanceUtils.observeProperty(workspace, "CurrentCamera"):Pipe({
		Rx.where(function(value)
			return value ~= nil
		end),
		Rx.switchMap(function(camera)
			return RxInstanceUtils.observeProperty(camera, "ViewportSize"):Pipe({
				Rx.where(function(viewportSize)
					return viewportSize.x ~= 1 and viewportSize.y ~= 1
				end),
				Rx.map(function(viewport)
					return viewport
				end),
			})
		end),
	})
end

return ObservableCamera
