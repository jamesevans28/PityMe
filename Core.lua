PityMe = LibStub("AceAddon-3.0"):NewAddon("PityMe", "AceConsole-3.0", "AceEvent-3.0","AceComm-3.0", "AceSerializer-3.0")

 
---------------------------------------------------------------
--------           DEBUG                      -----------------
---------------------------------------------------------------
local debug = false;
PityMe.debug = false;
---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------

function PityMe:SlashCommands(input)

	input = string.lower(input)

	if input == "guild" then
		PityMe:SetupGUI();
	elseif input == "log" then
		PityMe:MyCurrentChancesGUI();
	elseif input == "debug" then
		
		PityMe.debug = not PityMe.debug;
		debug = not debug;
		if PityMe.debug then
			self:Print("Setting debug to ON")
		else
			self:Print("Setting debug to OFF")
		end

	elseif input == "reset" then
		self:Print("Resetting all current counts");
		PityMe:ResetCounts();
	elseif input == "share" then
		self:Print("Sharing Data with Guild");
		PityMe:ShareData("PityMeCHANCE", PityMe:FormatMyData());
	else
		self:Print("Welcome to PityMe Legendary Chance Tracker.")
		self:Print("Usage:")
		self:Print("Current guild chances: /pityme guild")
		self:Print("Your log of legendaries: /pityme log")
		self:Print("Reset your current counts: /pityme reset")
		self:Print("Toggle debug mode: /pityme debug")
	end 

end








function PityMe:OnInitialize()
	
	if PityMeDB == nil then
    	if debug then
    		self:Print("Resetting PityMeDB");
    	end
    	PityMeDB = {}
    	PityMeDB.log = {}
    	PityMeDB.active = {}
    end

    if chance_counts == nil then
    	self:Print("Chance counts is nil, so resetting and initialising the counts")
    	PityMe:ResetCounts()
    end

    if chance_counts.world_bosses == nil then
    	chance_counts.world_bosses = 0
    end

    if chance_counts.pvp == nil then
    	chance_counts.pvp = 0
    end

   local arg1, arg2, diff = GetInstanceInfo()
		
	
	--PityMe:SetupGUI();
	PityMe:RegisterChatCommand('pityme', 'SlashCommands')
end

function PityMe:OnEnable()

    self:RegisterEvent("PLAYER_REGEN_DISABLED");
    --self:RegisterEvent("PLAYER_REGEN_ENABLED");
    self:RegisterEvent("CHAT_MSG_LOOT");
    self:RegisterEvent("QUEST_TURNED_IN");
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
    self:RegisterEvent("CHAT_MSG_ADDON");
    self:RegisterEvent("PLAYER_LOGIN");

    self:RegisterComm("PityMeCHANCE", "PityMeCHANCE_Received");
    self:RegisterComm("PityMeSYNC", "PityMeSYNC_Received");
    self:RegisterComm("PityMeLOG", "PityMeLOG_Received");

    self:Print(PityMe:PrintCountWelcomeMessage());
	PityMe:ShareData("PityMeCHANCE", PityMe:FormatMyData());
end

-- function PityMe:PLAYER_ENTERING_WORLD()
-- 	chance_ok = RegisterAddonMessagePrefix("PityMeCHANCE");
--     loot_ok = RegisterAddonMessagePrefix("PityMeLOOT");
--     sync_ok = RegisterAddonMessagePrefix("PityMeSYNC"); 
-- end

function PityMe:PLAYER_LOGIN()

	self:Print("Login");
	 -- Called when the addon is loaded
    self:Print(PityMe:PrintCountWelcomeMessage());
	PityMe:ShareData("PityMeCHANCE", PityMe:FormatMyData());

end

function PityMe:PLAYER_REGEN_DISABLED()
	if debug then
    	self:Print("You have entered combat!");
	end

    damage = 0;
    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

-- function PityMe:PLAYER_REGEN_ENABLED()
--     self:Print("You have left combat!")
--     local UIConfig = CreateFrame("Frame", "MyFrame", UIParent, "BasicFrameTemplateWithInset");
-- 	--UIConfig:SetSize(800,500);
-- 	--UIConfig:SetPoint("CENTER",UIParent,"CENTER");
-- end

-- function PityMe:SwingDamage(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand, multistrike)
-- 	self:Print("test");
-- end


function PityMe:CHAT_MSG_LOOT(...)

	if debug then
		self:Print("You looted an item!")
	end
	local event, message, _, _, _, looter = ...
	local _, _, lootedItem = string.find(message, '(|.+|r)')
	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(lootedItem)

	if looter ~= GetUnitName("player") then
		if debug then
			self:Print("This item is not for the current player");
		end
		return
	end

	if quality == 5 then
		self:Print("WOO! Legendary!")
		self:Print("Took this many chances to get that legendary")
		PityMe:PrintCounts()
		--add current count to log
		PityMe:AddRecordToDBLog(PityMe:FormatMyData());
		PityMe:ShareData("PityMeLOOT", PityMe:FormatMyData());
		--reset current count
		PityMe:ResetCounts();
	end

	--if we are getting a keystone, it means we may have picked up our weekly chest. 
	-- check that we are inside our order hall
	if name == "Mythic Keystone" then
	
		local _, type, diff = GetInstanceInfo()

		if name == "none" then
			chance_counts.weekly_chest = chance_counts.weekly_chest + 1
		end

	end



end

function PityMe:COMBAT_LOG_EVENT_UNFILTERED(eventName, timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, argxx, destGuid, destName, destFlags, arg9, arg10, arg11, arg12, ...)
	 
	--if(string.sub(event,string.len(event)-7,7) == "_DAMAGE") then
	-- if string.match(event,"UNIT_DIED") then
 -- 		self:Print("event: " .. eventName);
 -- 		self:Print("type: " .. event);
 -- 		--self:Print("damage: " .. arg12);

	-- end;

	-- if string.match(event,"UNIT_DIED") then
	-- 	self:Print("Killed: " .. destName .. " with id: " .. PityMe:MobId(destGuid));
	-- end;

	if string.match(event,"PARTY_KILL") then
		PityMe:print("Killed: " .. destName .. " with id: " .. PityMe:MobId(destGuid));
		

		if PityMe:IsLegendaryEnabledBoss(PityMe:MobId(destGuid)) then
			PityMe:print("Legendary enabled boss!");
			PityMe:IncrementKillCounter()
		elseif PityMe:IsWorldBoss(PityMe:MobId(destGuid)) then
			PityMe:print("Legendary enabled boss!");
			PityMe:IncrementWorldBossCounter()
		else
			PityMe:print("Not a legendary enabled boss");	
		end
		--PityMe:printCounts()
	end;

	

end

-- If any emissary quest is completed, then increment the daily quest counter
function PityMe:QUEST_TURNED_IN(timestamp, questId, arg3, arg4)

	if questId == 42421 --nightfallen
		or questId == 42234 --highmountain
		or questId == 42420 --court of farondis
		or questId == 42422 --wardens
		or questId == 42170 --dreamweavers
		or questId == 43179 --kirin tor
		then
		PityMe:IncrementDailyQuestCounter();

	end

end




-- Get the ID for the mob, given the guid
function PityMe:MobId(guid)
	if not guid then return 1 end
	local _, _, _, _, _, id = strsplit("-", guid)
	return tonumber(id) or 1
end


-- reset all counts after getting a legendary, or setting up for the first time
function PityMe:ResetCounts()
	
	self:Print("Resetting all counts")
	chance_counts = {}
	chance_counts.daily_chest = 0
	chance_counts.weekly_chest = 0
	chance_counts.normal_dungeon = 0
	chance_counts.heroic_dungeon = 0
	chance_counts.mythic_dungeon = 0
	chance_counts.mythic_plus_dungeon = 0
	chance_counts.lfr_raid = 0
	chance_counts.normal_raid = 0
	chance_counts.heroic_raid = 0
	chance_counts.mythic_raid = 0
	chance_counts.world_bosses = 0
	chance_counts.pvp = 0

end

function PityMe:PrintCounts()

	self:Print("Emissary Quests: " .. chance_counts.daily_chest);
	self:Print("Weekly M+ Quests: " .. chance_counts.weekly_chest);
	self:Print("Normal Dungeon Bosses: " .. chance_counts.normal_dungeon);
	self:Print("Heroic Dungeon Bosses: " .. chance_counts.heroic_dungeon);
	self:Print("Mythic Dungeon Bosses: " .. chance_counts.mythic_dungeon);
	self:Print("M+ Dungeon Bosses: " .. chance_counts.mythic_plus_dungeon);
	self:Print("Normal Raid Bosses: " .. chance_counts.normal_raid);
	self:Print("Heroic Raid Bosses: " .. chance_counts.heroic_raid);
	self:Print("Mythic Raid Bosses: " .. chance_counts.mythic_raid);
	
	self:Print("TOTAL CHANCES: " .. PityMe:GetTotalChances())
end

function PityMe:GetTotalChances()
	if chance_counts == nil then
		return 0
	end

	total 	= chance_counts.daily_chest 
			 + chance_counts.weekly_chest 
			 + chance_counts.normal_dungeon 
			 + chance_counts.heroic_dungeon 
			 + chance_counts.mythic_dungeon 
			 + chance_counts.mythic_plus_dungeon
			 + chance_counts.lfr_raid 
			 + chance_counts.normal_raid 
			 + chance_counts.heroic_raid 
			 + chance_counts.mythic_raid
			 + chance_counts.world_bosses
			 + chance_counts.pvp;
	return total
end

function PityMe:PrintCountWelcomeMessage()

	 total = PityMe:GetTotalChances()
	 self:Print("Been " .. total .. " chances since your last legendary. Good luck!")
	 self:Print("Type /pityme to bring up your guild list. They must have addon to show")
end


function PityMe:IncrementDailyQuestCounter()

	chance_counts.daily_chest = chance_counts.daily_chest + 1;
	PityMe:ShareData("PityMeCHANCE", PityMe:FormatMyData());
end


function PityMe:IncrementKillCounter()

	local _, _, diff = GetInstanceInfo()
	difficulty = diff

	if difficulty == 1 then
		chance_counts.normal_dungeon = chance_counts.normal_dungeon + 1
	end

	if difficulty == 2 then
		chance_counts.heroic_dungeon = chance_counts.heroic_dungeon + 1
	end

	if difficulty == 23 then
		chance_counts.mythic_dungeon = chance_counts.mythic_dungeon + 1
	end

	-- if difficulty == 8 then
	-- 	chance_counts.mythic_plus_dungeon = chance_counts.mythic_plus_dungeon + 1
	-- end

	if difficulty == 14 then
		chance_counts.normal_raid = chance_counts.normal_raid + 1
	end

	if difficulty == 15 then
		chance_counts.heroic_raid = chance_counts.heroic_raid + 1
	end

	if difficulty == 16 then
		chance_counts.mythic_raid = chance_counts.mythic_raid + 1
	end

	if difficulty == 17 then
		chance_counts.lfr_raid = chance_counts.lfr_raid + 1
	end

	PityMe:ShareData("PityMeCHANCE", PityMe:FormatMyData());

	-- 0 - None; not in an Instance.
	-- 1 - 5-player Instance.
	-- 2 - 5-player Heroic Instance.
	-- 3 - 10-player Raid Instance.
	-- 4 - 25-player Raid Instance.
	-- 5 - 10-player Heroic Raid Instance.
	-- 6 - 25-player Heroic Raid Instance.
	-- 7 - 25-player Raid Finder Instance.
	-- 8 - Challenge Mode Instance.
	-- 9 - 40-player Raid Instance.
	-- 10 - Not used.
	-- 11 - Heroic Scenario Instance.
	-- 12 - Scenario Instance.
	-- 13 - Not used.
	-- 14 - 10-30-player Normal Raid Instance.
	-- 15 - 10-30-player Heroic Raid Instance.
	-- 16 - 20-player Mythic Raid Instance .
	-- 17 - 10-30-player Raid Finder Instance.
	-- 18 - 40-player Event raid (Used by the level 100 version of Molten Core for WoW's 10th anniversary).
	-- 19 - 5-player Event instance (Used by the level 90 version of UBRS at WoD launch).
	-- 20 - 25-player Event scenario (unknown usage).
	-- 21 - Not used.
	-- 22 - Not used.
	-- 23 - Mythic 5-player Instance.
	-- 24 - Timewalker 5-player Instance.

end

function IncrementWorldBossCounter()
	chance_counts.world_bosses = chance_counts.world_bosses + 1;
end

function PityMe:IsWorldBoss(boss_id)
	for _,v in pairs(PityMe.world_bosses) do
	  if v == boss_id then
	  	PityMe:print("This is a legendary enabled world boss");
	    return true
	  end
	end

end

function PityMe:IsLegendaryEnabledBoss(boss_id)

	for _,v in pairs(PityMe.bosses) do
	  if v == boss_id then
	  	if debug then 
	  		self:Print("This is a legendary enabled boss");
	  	end
	    return true
	  end
	end
	if debug then 
	  		self:Print(boss_id .. "is not a legendary enabled mob");
	  	end
	return false

end










--add a message to your account db
function PityMe:AddRecordToDBLog(data)

	table.insert(PityMeDB.log, data);
end

--add a message to your account db
-- the active db show sa record of all current chance counts
function PityMe:AddRecordToDBActive(data)

	--loop through local db and check if there is already a record in there with your current active chances
	for a,b in pairs(PityMeDB.active) do
		 
	  if b.playerName == data.playerName then
	    	 PityMeDB.active[a]=data;
	    	 PityMe:print("Updating existing data");
	    	return
	    end
	  end



	 -- if no record exists then insert a new record
	PityMe:print("Adding record to db")
	table.insert(PityMeDB.active, data);

end



--check how many chests you got at the end of the m+ dungeon
function PityMe:CHALLENGE_MODE_COMPLETED()
	local mapID, level, time, onTime, keystoneUpgradeLevels = C_ChallengeMode.GetCompletionInfo()
	local name, _, timeLimit = C_ChallengeMode.GetMapInfo(mapID)

	local TIME_FOR_3 = 0.6
	local TIME_FOR_2 = 0.8

	timeLimit = timeLimit * 1000
	local timeLimit2 = timeLimit * TIME_FOR_2
	local timeLimit3 = timeLimit * TIME_FOR_3

	if time <= timeLimit3 then
		PityMe:UpdateMythicPlusCompletion(3)
	elseif time <= timeLimit2 then
		PityMe:UpdateMythicPlusCompletion(2)
	else
		PityMe:UpdateMythicPlusCompletion(1)
	end
end


--increament mythic plus counter
function PityMe:UpdateMythicPlusCompletion(chests)
	chance_counts.mythic_plus_dungeon = chance_counts.mythic_plus_dungeon + chests
	PityMe:ShareData("PityMeCHANCE", PityMe:FormatMyData());
end

	

