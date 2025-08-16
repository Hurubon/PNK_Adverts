-- Copyright (C) 2025 Hrvoje 'Hurubon' Žohar
-- See the end of the file for extended copyright information
local Adverts = PNK_LibStub:NewLibrary("PNK_Adverts", 1);

if Adverts == nil then
    return;
end

--[[---------------------------------------------------------------------------
	End of boilerplate
--]]---------------------------------------------------------------------------
PNK_ADVERTS_OUTPUT_CHAT = PNK_ADVERTS_OUTPUT_CHAT or "Global";

local Loader  = PNK_LibStub:GetLibrary("PNK_Loader");
local Timer   = PNK_LibStub:GetLibrary("PNK_Timer");

function Adverts.Print(...)
    local message = string.join("", "[|cFF2EBFA6", "PNK_Adverts", "|r]: ", tostringall(...));
    DEFAULT_CHAT_FRAME:AddMessage(message);
end

--[[---------------------------------------------------------------------------
	Slash commands
--]]---------------------------------------------------------------------------
Adverts.commands = {};

function Adverts.commands.HELP()
	Adverts.Print("TODO!");
end

function Adverts.commands.START(advert_name, frequency, ...)
	local message  = string.join(" ", ...);
	local Callback = function()
		SendChatMessage(
			message,
			"CHANNEL",
			nil,
			GetChannelName(PNK_ADVERTS_OUTPUT_CHAT));
	end;

	-- TOOD: Factor out.
	local to_seconds = function(time)
		local h = tonumber( string.sub(time, 1, 2) );
		local m = tonumber( string.sub(time, 4, 5) );
		local s = tonumber( string.sub(time, 7, 8) );

		return 3600 * h + 60 * m + s;
	end

	local ok = Timer:AcquireTimer(advert_name, to_seconds(frequency), Callback);
	if ok then
		Adverts.Print(("Created advert %s in %s (repeat every %s).")
			:format(advert_name, PNK_ADVERTS_OUTPUT_CHAT, frequency));
		Callback();
	else
		Adverts.Print(("Cannot create advert %s because it already exists.")
			:format(advert_name));
	end
end

function Adverts.commands.STOP(advert_name)
	local ok = Timer:ReleaseTimer(advert_name);
	if ok then
		Adverts.Print(("Stopped advert %s.")
			:format(advert_name));
	else
		Adverts.Print(("Cannot stop advert %s because it doesn't exist.")
			:format(advert_name));
	end
end

function Adverts.commands.SETCHAT(chat)
	PNK_ADVERTS_OUTPUT_CHAT = chat;
end

--[[---------------------------------------------------------------------------
	Handler
--]]---------------------------------------------------------------------------
local function HandleSlashCommands(command_text)
	if command_text:len() == 0 then
		Adverts.commands.HELP();
		return;
	end

	local args = {};
	for _, arg in next, {string.split(" ", command_text)} do
		if arg:len() > 0 then
			table.insert(args, arg);
		end
	end

	local path = Adverts.commands;
	for id, arg in ipairs(args) do
		arg = string.upper(arg);

		if path[arg] == nil then
			-- skip
		elseif type(path[arg]) == "function" then
			path[arg]( select(id + 1, unpack(args)) );
			return;
		elseif type(path[arg]) == "table" then
			path = path[arg];
		else
			Adverts.commands.HELP();
			return;
		end
	end
end

--[[---------------------------------------------------------------------------
	Initialisation
--]]---------------------------------------------------------------------------
local function Init(self)
	SLASH_PNK_Adverts1 = '/ads';
	SlashCmdList.PNK_Adverts = HandleSlashCommands;
	Adverts.Print("Loaded.");
end

Loader:Register("PNK_Adverts", Init);
--[[
	PNK_Adverts - automated adverts in World of Warcraft chats
	Copyright (C) 2025 Hrvoje 'Hurubon' Žohar
	
	PNK_Adverts is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	
	PNK_Adverts is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]
