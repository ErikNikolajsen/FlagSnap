-- ===============================================================
--  FlagSnap
-- ===============================================================

BINDING_HEADER_FLAGSNAP = "FlagSnap"
BINDING_NAME_FLAGSNAP_TOGGLE = "Toggle FlagSnap on/off"

local f = CreateFrame("Frame")
local flagDroppedAlliance = false
local flagDroppedHorde = false
local flagSnapEngaged = false
local flagSnapOn = true

local function DropFlag()
	i=0
	while not(GetPlayerBuff(i) == -1) do 
		if (string.find(GetPlayerBuffTexture(GetPlayerBuff(i)), "INV_BannerPVP_01")) or (string.find(GetPlayerBuffTexture(GetPlayerBuff(i)), "INV_BannerPVP_02")) then 
			CancelPlayerBuff(GetPlayerBuff(i))
		end
	i=i+1
	end
end

local function EngageFlagSnap()
	f:SetScript("OnUpdate", function(self, delta)
		UnitXP("interact", 1)
	end)
	DEFAULT_CHAT_FRAME:AddMessage("FlagSnap engaged", 1.0, 1.0, 0)
	flagSnapEngaged = true
end

local function DisengageFlagSnap()
	f:SetScript("OnUpdate", nil)
	DEFAULT_CHAT_FRAME:AddMessage("FlagSnap disengaged", 1.0, 1.0, 0)
	flagSnapEngaged = false
end

local function CheckEngagementConditions()
	if (flagDroppedAlliance == true or flagDroppedHorde == true) and flagSnapEngaged == false then
		EngageFlagSnap()
	elseif flagDroppedAlliance == false and flagDroppedHorde == false and flagSnapEngaged == true then
		DisengageFlagSnap()
	end
end

local function OnEventHandler()
	if string.find(arg1, "The Alliance Flag was dropped by") then
		flagDroppedAlliance = true
	elseif string.find(arg1, "The Horde flag was dropped by") then
		flagDroppedHorde = true
	elseif string.find(arg1, "The Alliance Flag was returned to its base by") or string.find(arg1, "The Alliance Flag was picked up by") or string.find(arg1, "captured the Alliance flag!") or string.find(arg1, "The Alliance flag is now placed at its base.") then 
		flagDroppedAlliance = false
	elseif string.find(arg1, "The Horde flag was returned to its base by") or string.find(arg1, "The Horde flag was picked up by") or string.find(arg1, "captured the Horde flag!") or string.find(arg1, "The Horde flag is now placed at its base.") then
		flagDroppedHorde = false
	end
	
	if flagSnapOn == true then
		CheckEngagementConditions()
	end
end

function FlagSnapToggle()
	if flagSnapOn == false then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00FlagSnap|r |cff00ff00on|r")
		flagSnapOn = true
		CheckEngagementConditions()
	elseif flagSnapOn == true then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff00FlagSnap|r |cffff0000off|r")
		if flagSnapEngaged == true then
			DisengageFlagSnap()
		end
		flagSnapOn = false
		DropFlag()
	end
end

-- Main logic
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()
    if event == "ADDON_LOADED" and arg1 == "FlagSnap" then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("|cffffff00FlagSnap v%s by %s|r", GetAddOnMetadata("FlagSnap", "Version"), GetAddOnMetadata("FlagSnap", "Author")))
        f:UnregisterEvent("ADDON_LOADED")
		f:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
		f:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
        f:SetScript("OnEvent", OnEventHandler)
    end
end)

------------------------------------------------------------
-- Slash command handler
------------------------------------------------------------
SLASH_FLAGSNAP1 = "/fs"
SLASH_FLAGSNAP2 = "/flagsnap"

SlashCmdList["FLAGSNAP"] = function(msg)
	local _, _, cmd, arg = string.find(msg, "^(%S*)%s*(.-)$")
    cmd = string.lower(cmd or "")
    arg = string.lower(arg or "")
	
	-- engage and disengage FlagSnap manually for testing
	if cmd == "test" then
		if arg == "on" or arg == "1" or arg == "true" then
			DEFAULT_CHAT_FRAME:AddMessage("FlagSnap: test |cff00ff00on|r.", 1.0, 1.0, 0)
			EngageFlagSnap()
		elseif arg == "off" or arg == "0" or arg == "false" then
			DEFAULT_CHAT_FRAME:AddMessage("FlagSnap: test |cffff0000off|r.", 1.0, 1.0, 0)
			DisengageFlagSnap()
		end
	-- reset the state of the game manually for testing
	elseif cmd == "reset" then
		flagDroppedAlliance = false
		flagDroppedHorde = false
		flagSnapEngaged = false
		flagSnapOn = true
		DEFAULT_CHAT_FRAME:AddMessage("FlagSnap has been reset", 1.0, 1.0, 0)
	-- prints commands
	else
		DEFAULT_CHAT_FRAME:AddMessage("FlagSnap commands:", 1.0, 1.0, 0)
		if flagSnapEngaged == true then
			DEFAULT_CHAT_FRAME:AddMessage("/fs test [|cff00ff00on|r/off]", 1.0, 1.0, 0)
		elseif flagSnapEngaged == false then
			DEFAULT_CHAT_FRAME:AddMessage("/fs test [on/|cffff0000off|r]", 1.0, 1.0, 0)
		end
		DEFAULT_CHAT_FRAME:AddMessage("/fs reset", 1.0, 1.0, 0)
	end
end

--[[
# Notes

## CHAT_MSG_BG_SYSTEM_ALLIANCE:
"The Alliance Flag was dropped by"
"The Alliance Flag was returned to its base by"
"The Alliance Flag was picked up by"
"captured the Alliance flag!"
"The Alliance flag is now placed at its base."

## CHAT_MSG_BG_SYSTEM_HORDE:
"The Horde flag was dropped by"
"The Horde flag was returned to its base by"
"The Horde flag was picked up by"
"captured the Horde flag!"
"The Horde flag is now placed at its base."

## CHAT_MSG_BG_SYSTEM_NEUTRAL:
"Let the battle for Warsong Gulch begin!"
"The flags are now placed at their bases."

## Bufftexture horde flag:
Interface\\Icons\\INV_BannerPVP_01

## Bufftexture alliance flag:
Interface\\Icons\\INV_BannerPVP_02
--]]
