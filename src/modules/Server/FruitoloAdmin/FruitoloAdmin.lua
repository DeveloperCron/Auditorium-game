--[=[
    @class init.lua

    Custom admin commands for fruitolo
    Uses the new technology!
]=]

local require = require(script.Parent.loader).load(script)
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local Maid = require("Maid")
local ObservableSet = require("ObservableSet")
local Commands = require("FruitoloCommands")

local FruitoloAdmin = {}
FruitoloAdmin.ClassName = "FruitoloAdmin"

function FruitoloAdmin:Init(serviceBag)
	assert(
		TextChatService.ChatVersion == Enum.ChatVersion.TextChatService,
		"TextChatService.ChatVersion must be set to 'TextChatService'"
	)

	assert(not self._serviceBag, "Already initialized")
	self._serviceBag = assert(serviceBag, "No serviceBag")
	self._maid = Maid.new()

	self._adminCache = ObservableSet.new()
	self._maid:GiveTask(self._adminCache)
end

function FruitoloAdmin:Start()
	local commandsFolder = Instance.new("Folder")
	commandsFolder.Name = "AdminCommands"
	commandsFolder.Parent = TextChatService

	for _, commandInfo in Commands.List do
		local textChatCommand = Instance.new("TextChatCommand")
		textChatCommand.Name = commandInfo.PrimaryAlias
		textChatCommand.PrimaryAlias = Commands.Prefix .. commandInfo.PrimaryAlias
		if commandInfo.SecondaryAlias then
			textChatCommand.SecondaryAlias = Commands.Prefix .. commandInfo.SecondaryAlias
		end
		textChatCommand.Parent = commandsFolder

		self._maid:GiveTask(textChatCommand.Triggered:Connect(function(textSource, message)
			local player = Players:GetPlayerByUserId(textSource.UserId)
			assert(player ~= nil, string.format("No player with UserId: %d", textSource.UserId))

			local isPlayerAllowed = self._adminCache:Contains(player)
			if isPlayerAllowed then
				local cleanMessage = string.gsub(message, "%s+", " ")
				local words = string.split(cleanMessage, " ")
				local args = table.move(words, 2, #words, 1, {})

				commandInfo.Function(player, args)
			end
		end))
	end
end

function FruitoloAdmin:Add(player: Player)
	assert(typeof(player) == "Instance", "Bad player")

	self._maid:GiveTask(self._adminCache:Add(player))
end

function FruitoloAdmin:Remove(player: Player)
	assert(typeof(player) == "Instance", "Bad player")

	-- Might need to be removed!
	if self._adminCache:Contains(player) then
		print("Is player removed?")
		self._adminCache:Remove(player)
	end
end

return FruitoloAdmin
