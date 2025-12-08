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
	elseif string.find(arg1, "The Alliance Flag was returned to its base by") or string.find(arg1, "The Alliance Flag was picked up by") or string.find(arg1, "captured the Alliance flag!") then 
		flagDroppedAlliance = false
	elseif string.find(arg1, "The Horde flag was returned to its base by") or string.find(arg1, "The Horde flag was picked up by") or string.find(arg1, "captured the Horde flag!") then
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
        DEFAULT_CHAT_FRAME:AddMessage(string.format("FlagSnap v%s by %s.", GetAddOnMetadata("FlagSnap", "Version"), GetAddOnMetadata("FlagSnap", "Author")))
        f:UnregisterEvent("ADDON_LOADED")
		f:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE")
		f:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE")
        f:SetScript("OnEvent", OnEventHandler)
    end
end)

------------------------------------------------------------
-- Slash command handler as redundancy to keybinds
------------------------------------------------------------
SLASH_FLAGSNAP1 = "/fs"

SlashCmdList["FLAGSNAP"] = function(msg)
    local cmd, arg = string.match(msg, "^(%S*)%s*(.-)$")
    cmd = string.lower(cmd or "")
    arg = string.lower(arg or "")
	
	if cmd == "test" then
		if arg == "on" or arg == "1" or arg == "true" then
			EngageFlagSnap()
			DEFAULT_CHAT_FRAME:AddMessage("FlagSnap: test |cff00ff00engaged|r.")
		elseif arg == "off" or arg == "0" or arg == "false" then
			DisengageFlagSnap()
			DEFAULT_CHAT_FRAME:AddMessage("FlagSnap: test |cffff0000disengaged|r.")
		else
			DEFAULT_CHAT_FRAME:AddMessage("Usage: /fs test [on/off]")
		end
	else 
		if flagSnapEngaged == true then
			DEFAULT_CHAT_FRAME:AddMessage("/fs test [|cff00ff00on|r/off]")
		elseif flagSnapEngaged == false then
			DEFAULT_CHAT_FRAME:AddMessage("/fs test [on/|cffff0000off|r]")
		end	
	end
end

--[[
# Notes

## CHAT_MSG_BG_SYSTEM_ALLIANCE:
"The Alliance Flag was dropped by"
"The Alliance Flag was returned to its base by"
"The Alliance Flag was picked up by"
"captured the Alliance flag!"

## CHAT_MSG_BG_SYSTEM_HORDE:
"The Horde flag was dropped by"
"The Horde flag was returned to its base by"
"The Horde flag was picked up by"
"captured the Horde flag!"

## CHAT_MSG_BG_SYSTEM_NEUTRAL:
"Let the battle for Warsong Gulch begin!"

## Bufftexture horde flag:
Interface\\Icons\\INV_BannerPVP_01

## Bufftexture alliance flag:
Interface\\Icons\\INV_BannerPVP_02
--]]
