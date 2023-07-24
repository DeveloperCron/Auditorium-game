local remodel = require("./lune")

local game = remodel.readPlaceFile("Auditorium.rbxlx")

-- If the directory does not exist yet, we'll create it.
remodel.createDirAll("models")

local Models = game.ServerStorage.BillBoardGui

for _, model in ipairs(Models:GetChildren()) do
	-- Save out each child as an rbxmx model
	remodel.writeModelFile("models/" .. model.Name .. ".rbxmx", model)
end
