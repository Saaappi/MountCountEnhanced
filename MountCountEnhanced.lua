--[[
	The purpose of the addon is to tell the player how much anima is in their inventory on demand.
]]--

--[[ TODO
]]--

--[[
	These variables are provided to the addon by Blizzard.
		addonName	: This is self explanatory, but it's the name of the addon.
		t			: This is an empty table. This is how the addon can communicate between files or local functions, sort of like traditional classes.
]]--
local addonName, t = ...;
local e = CreateFrame("Frame");
local unusableMounts = {};
local useErrors = {
	"To use this mount in the current area you must be underwater.",
	"You can't use that here.",
};

-- Event Registrations
e:RegisterEvent("ADDON_LOADED");

-- Functions
local function CheckForUseError(useError)
	for _, err in ipairs(useErrors) do
		if useError == err then
			return true;
		end
	end
end

local function GetPlayerFaction()
	local faction = UnitFactionGroup("player");
	if faction == "Alliance" then
		return 1;
	else
		return 0;
	end
end

-- Logic
e:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "Blizzard_Collections" then
		-- Reconfigure the bar's layout and position.
		MountJournal.MountCount:SetWidth(160);
		MountJournal.MountCount:SetHeight(35);
		MountJournal.MountCount:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 70, -25);
		
		-- Get mount information.
		local numMountsCollectedOnAccount = 0; -- This includes all mounts collected on the account, regardless of faction.
		local numMountsUncollectedOnAccount = 0; -- Self explanatory. Get to work!
		local numMountsUsableOnAccount = 0; -- The number of mounts usable to the character.
		local numMountsUnusableOnAccount = 0; -- The number of collected mounts not usuable to the current character.
		local mountIDs = C_MountJournal.GetMountIDs();
		for index, mountID in ipairs(mountIDs) do
			local name, _, _, _, _, _, _, _, _, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID);
			local isUsable, useError = C_MountJournal.GetMountUsabilityByID(mountID, false);
			if ((isCollected and isUsable) or (isCollected and CheckForUseError(useError))) then
				numMountsUsableOnAccount = numMountsUsableOnAccount + 1;
			end
			if (isCollected and hideOnChar ~= true) then
				numMountsCollectedOnAccount = numMountsCollectedOnAccount + 1;
			end
			if (isCollected ~= true and hideOnChar ~= true) then
				numMountsUncollectedOnAccount = numMountsUncollectedOnAccount + 1;
			end
			if (isCollected and hideOnChar) then
				numMountsUnusableOnAccount = numMountsUnusableOnAccount + 1;
				table.insert(unusableMounts, name);
			elseif (t.mounts[mountID] and t.mounts[mountID]["faction"] ~= GetPlayerFaction() and t.mounts[mountID]["name"] ~= name) then
				numMountsUnusableOnAccount = numMountsUnusableOnAccount + 1;
				table.insert(unusableMounts, name);
			end
		end
		
		MountJournal.MountCount.Label:SetText("Collected: |cffFFFFFF" .. numMountsCollectedOnAccount .. "|r (|cffFFFFFF" .. (numMountsUsableOnAccount+numMountsUnusableOnAccount) .. "|r)\n" ..
		"Uncollected: |cffFFFFFF" .. numMountsUncollectedOnAccount .. "|r\n" ..
		"Usable: |cffFFFFFF" .. numMountsUsableOnAccount .. "|r");
		MountJournal.MountCount.Count:Hide();
	end
end);