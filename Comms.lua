--function to receive data shared
function PityMe:CHAT_MSG_ADDON(prefix, msg, channel, sender)

	if prefix == "PityMeLOOT" then
		PityMe:print("Receiving LOOT data from " .. sender);
		PityMe:AddRecordToDBLog(msg);

	end

	if prefix == "PityMeCHANCE" then
		PityMe:print("Receiving CHANCE data from " .. sender);
		PityMe:print(msg);

		PityMe:AddRecordToDBActive(msg);
		PityMe:ShareData("PityMeSYNC", PityMe:FormatMyData());
	end

	if prefix == "PityMeSYNC" then
		PityMe:print("Receiving SYNC data from " .. sender);
		PityMe:AddRecordToDBActive(msg);
	end

end


--function to push the legendary event with all details to others in your guild
function PityMe:ShareData(type, eventData)

	if IsInGuild() then 
		PityMe:print("Sharing Data with guild (" .. type .. ")");
		SendAddonMessage(type, eventData, "GUILD");
	end

end