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

-- Event Registrations
e:RegisterEvent("ADDON_LOADED");

-- Logic
e:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "Blizzard_Collections" then
		-- Reconfigure the bar's layout and position.
		MountJournal.MountCount:SetWidth(140);
		MountJournal.MountCount:SetHeight(35);
		MountJournal.MountCount:SetPoint("TOPLEFT", MountJournal, "TOPLEFT", 70, -25);
		
		-- Get mount information.
		local collected = 0;
		local uncollected = 0;
		local unusable = 0;
		local mountIDs = C_MountJournal.GetMountIDs();
		for i, mountID in ipairs(mountIDs) do
			local _, _, _, _, isUsable, _, _, _, _, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(mountID);
			if (isCollected and hideOnChar == true) then
				unusable = unusable + 1;
			elseif (isCollected ~= true and hideOnChar ~= true) then
				uncollected = uncollected + 1;
			elseif (isCollected and hideOnChar ~= true) then
				collected = collected + 1;
			end
		end
		
		MountJournal.MountCount.Label:SetText("Collected: |cffFFFFFF" .. collected .. "|r\n" ..
		"Uncollected: |cffFFFFFF" .. uncollected .. "|r\n" ..
		"Usable: |cffFFFFFF" .. (collected-unusable) .. "|r");
		MountJournal.MountCount.Count:Hide();
	end
end);