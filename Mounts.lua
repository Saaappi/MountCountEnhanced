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

-- 0: Horde, 1: Alliance
local mounts = {
	[1255] = {
		["name"] = "Deepcoral Snapdragon",
		["faction"] = 1,
	}, -- [A] Horde variant isn't automatically learned.
	[1256] = {
		["name"] = "Snapdragon Kelpstalker",
		["faction"] = 0,
	},
};

t.mounts = mounts;