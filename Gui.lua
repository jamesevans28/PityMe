-- chance_counts.daily_chest 
-- 			 + chance_counts.weekly_chest 
-- 			 + chance_counts.normal_dungeon 
-- 			 + chance_counts.heroic_dungeon 
-- 			 + chance_counts.mythic_dungeon 
-- 			 + chance_counts.mythic_plus_dungeon
-- 			 + chance_counts.lfr_raid 
-- 			 + chance_counts.normal_raid 
-- 			 + chance_counts.heroic_raid 
-- 			 + chance_counts.mythic_raid;


function PityMe:MyCurrentChancesGUI()
	local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
	frame:SetTitle("PityMe Current Chances")
	frame:SetStatusText("Total Chances: " .. PityMe:GetTotalChances())
	frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
	frame:SetLayout("List")
	frame:SetWidth(350)
	
	--Quests Group
	local DailyQuestGroup = AceGUI:Create("InlineGroup")
	DailyQuestGroup:SetTitle("Regulars")
	DailyQuestGroup:SetFullWidth(true);
	DailyQuestGroup:SetLayout("Flow")
	local label = AceGUI:Create("Label")
	label:SetText("Emissary Quests")
	label:SetWidth(200);
	label:SetFullWidth(false)
	DailyQuestGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.daily_chest)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	DailyQuestGroup:AddChild(desc)
	local label = AceGUI:Create("Label")
	label:SetText("Weekly M+ Chests")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	DailyQuestGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.weekly_chest)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	DailyQuestGroup:AddChild(desc)


	--Dungeon Bosses Group
	local DungeonBossesGroup = AceGUI:Create("InlineGroup")
	DungeonBossesGroup:SetLayout("Flow")
	DungeonBossesGroup:SetTitle("Dungeons")
	DungeonBossesGroup:SetFullWidth(true);

	local label = AceGUI:Create("Label")
	label:SetText("Normal Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	DungeonBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.normal_dungeon )
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	DungeonBossesGroup:AddChild(desc)

	local label = AceGUI:Create("Label")
	label:SetText("Heroic Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	DungeonBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.heroic_dungeon )
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	DungeonBossesGroup:AddChild(desc)

	local label = AceGUI:Create("Label")
	label:SetText("Mythic Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	DungeonBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.mythic_dungeon)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	DungeonBossesGroup:AddChild(desc)

	local label = AceGUI:Create("Label")
	label:SetText("Mythic+ Chests")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	DungeonBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.mythic_plus_dungeon)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	DungeonBossesGroup:AddChild(desc)


	--Raid Bosses Group
	local RaidBossesGroup = AceGUI:Create("InlineGroup")
	RaidBossesGroup:SetLayout("Flow")
	RaidBossesGroup:SetTitle("Raids")
	RaidBossesGroup:SetFullWidth(true);

	local label = AceGUI:Create("Label")
	label:SetText("LFR Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	RaidBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.lfr_raid)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	RaidBossesGroup:AddChild(desc)

	local label = AceGUI:Create("Label")
	label:SetText("Normal Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	RaidBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.normal_raid)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	RaidBossesGroup:AddChild(desc)

	local label = AceGUI:Create("Label")
	label:SetText("Heroic Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	RaidBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.heroic_raid)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	RaidBossesGroup:AddChild(desc)

	local label = AceGUI:Create("Label")
	label:SetText("Mythic Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	RaidBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.mythic_raid)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	RaidBossesGroup:AddChild(desc)

	local label = AceGUI:Create("Label")
	label:SetText("World Bosses")
	label:SetRelativeWidth(0.5);
	label:SetFullWidth(false)
	RaidBossesGroup:AddChild(label)
	local desc = AceGUI:Create("Label")
	desc:SetText(chance_counts.world_bosses)
	desc:SetWidth(50);
	desc:SetFullWidth(false)
	RaidBossesGroup:AddChild(desc)
	
	

	--Add all containers to frame
	frame:AddChild(DailyQuestGroup);
	frame:AddChild(DungeonBossesGroup);
	frame:AddChild(RaidBossesGroup);
	
	if IsInGuild() then
		local button = AceGUI:Create("Button")
		button:SetText("Share data with guild")
		button:SetCallback("OnClick", SendUpdateToGuildChat)
		button:SetFullWidth(true)
		frame:AddChild(button);
	end 

end

function SendUpdateToGuildChat()

	PityMe:print("Sending message to guild");

	local message = "It's been " .. PityMe:GetTotalChances() .. " chances since my last legendary. Data captured by PityMe Addon";

	SendChatMessage(message,"GUILD", nil)

end



function PityMe:SetupGUI()
	local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
	 frame:SetTitle("PityMe Guild Legendary Chances")
	-- frame:SetStatusText("AceGUI-3.0 Example Container Frame")
	 frame:SetLayout("Fill")

	 frame:EnableResize(false)
	--UIPanelWindows["oRA3Frame"] = { area = "left", pushable = 3, whileDead = 1, yoffset = 12, xoffset = -16 }
	--HideUIPanel(oRA3Frame)

	 frame:SetWidth(770)
	 frame:ApplyStatus()
	 frame:Hide();
	-- frame:SetHeight(512)


	local st_rowheight         = 16
	local st_displayed_rows    = 25 --math.floor(366/st_rowheight)
	local st_colwidth          = 80 --65
	local cols = {
		{
			name = "Character",
			width = 130,
		},
		{
			name = "Daily Cache",
			width = 70,
			align="CENTER"
		},
		{
			name = "Weekly Cache",
			width = 80,
			align="CENTER"
		},
		{
			name = "Dungeon Boss",
			width = 90,
			align="CENTER"
		},
		{
			name = "M+ Chest",
			width = 75,
			align="CENTER"
		},
		{
			name = "Raid Boss",
			width = 70,
			align="CENTER"
		},
		{
			name = "World Boss",
			width = 70,
			align="CENTER"
		},
		{
			name = "Total",
			width = 40,
			align="CENTER"
		}
	}

	

	local ScrollingTable = LibStub("ScrollingTable");
	local guildtable = ScrollingTable:CreateST(cols, st_displayed_rows, st_rowheight, --[[highlight=]]nil, frame.content);
	
	--local guildtable = ScrollingTable:CreateST(cols);
	--frame:AddChild(guildtable)
	guildtable.frame:SetPoint("TOPLEFT", frame.content, 0,-20);

	local dataToShow = {};
	for _,v in pairs(PityMeDB.active) do
	 	table.insert(dataToShow,PityMe:FormatForDisplay(v))
	 end

--	print(formatMyData())
	--table.insert(dataToShow, PityMe:FormatMyData())

	guildtable:SetData(dataToShow, true);
	--frame:AddChild( table.frame )

	frame:Show();
end


function PityMe:FormatMyData()

	-- local formattedData = {
	-- 			GetUnitName("player"), 
	-- 			chance_counts.daily_chest ,
	-- 		    chance_counts.weekly_chest, 
	-- 		    tostring(chance_counts.normal_dungeon) .. "-" .. tostring(chance_counts.heroic_dungeon) .. "-" .. tostring(chance_counts.mythic_dungeon),
	-- 			--tostring(chance_counts.heroic_dungeon).."-"..tostring(chance_counts.mythic_dungeon),
	-- 			chance_counts.mythic_plus_dungeon,
	-- 			chance_counts.lfr_raid .. "-" .. chance_counts.normal_raid .. "-" .. chance_counts.heroic_raid .. "-" .. chance_counts.mythic_raid,
	-- 			0,
	-- 			PityMe:GetTotalChances()	
	-- 			}
	local formattedData = {};
	formattedData.playerName 	= GetUnitName("player"); 
	formattedData.daily_chest	= chance_counts.daily_chest;
	formattedData.weekly_chest	= chance_counts.weekly_chest; 
	formattedData.normal_dungeon= chance_counts.normal_dungeon;
	formattedData.heroic_dungeon= chance_counts.heroic_dungeon;
	formattedData.mythic_dungeon= chance_counts.mythic_dungeon;
	formattedData.mythic_plus_dungeon= chance_counts.mythic_plus_dungeon;
	formattedData.lfr_raid		= chance_counts.lfr_raid;
	formattedData.normal_raid	= chance_counts.normal_raid;
	formattedData.heroic_raid	= chance_counts.heroic_raid;
	formattedData.mythic_raid	= chance_counts.mythic_raid;
	formattedData.world_bosses	= chance_counts.world_bosses;
	formattedData.pvp			= chance_counts.pvp;
	formattedData.total 		= PityMe:GetTotalChances();

	return formattedData;

end

function PityMe:FormatForDisplay(data)
local formattedData = {
				data.playerName, 
				data.daily_chest ,
			    data.weekly_chest, 
			    tostring(data.normal_dungeon) .. "-" .. tostring(data.heroic_dungeon) .. "-" .. tostring(data.mythic_dungeon),
				--tostring(chance_counts.heroic_dungeon).."-"..tostring(chance_counts.mythic_dungeon),
				data.mythic_plus_dungeon,
				data.lfr_raid .. "-" .. data.normal_raid .. "-" .. data.heroic_raid .. "-" .. data.mythic_raid,
				data.world_bosses,
				data.total	
				}

	return formattedData;

end
