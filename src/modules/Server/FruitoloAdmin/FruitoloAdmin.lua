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
	-- self._maid:GiveTask(commandsFolder)

	for _, commandInfo in Commands.List do
		local textChatCommand = Instance.new("TextChatCommand")
		textChatCommand.Name = commandInfo.PrimaryAlias
		-- Set the primary and secondary aliases with the prefix set in the Commands module
		textChatCommand.PrimaryAlias = Commands.Prefix .. commandInfo.PrimaryAlias
		if commandInfo.SecondaryAlias then
			textChatCommand.SecondaryAlias = Commands.Prefix .. commandInfo.SecondaryAlias
		end
		textChatCommand.Parent = commandsFolder

		self._maid:GiveTask(textChatCommand.Triggered:Connect(function(textSource, message)
			-- Find the player object of the speaker
			local player = Players:GetPlayerByUserId(textSource.UserId)
			assert(player ~= nil, string.format("No player with UserId: %d", textSource.UserId))

			-- Make sure the player has permission to use this command
			local isPlayerAllowed = self._adminCache:Contains(player)
			if isPlayerAllowed then
				-- Clean up whitespace in the message so that extra spaces do not cause empty strings in the split
				local cleanMessage = string.gsub(message, "%s+", " ")
				-- Split up the message into individual words
				local words = string.split(cleanMessage, " ")
				-- The first word is the command, select all words except the first to pass in as arguments
				local args = table.move(words, 2, #words, 1, {})

				-- Call the set command Function, passing in the player who triggered it and any additional words after the command
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

	if self._adminCache:Contains(player) then
		self._adminCache:Remove(player)
	end
end

return FruitoloAdmin
