local remodel = require("./lune")

local game = remodel.readPlaceFile("Auditorium.rbxlx")

-- If the directory does not exist yet, we'll create it.
remodel.createDirAll("models")

local Model = game.Workspace.StageCamera
remodel.writeModelFile("models/" .. Model.Name .. ".rbxmx", Model)

-- local Models = game.ServerStorage

-- for _, model in ipairs(Models:GetChildren()) do
-- 	-- Save out each child as an rbxmx model
-- 	remodel.writeModelFile("models/" .. model.Name .. ".rbxmx", model)
-- end
