--function to receive data shared
function PityMe:CHAT_MSG_ADDON(prefix, msg, ...)

	if prefix == "PityMeLOOT" then
		
		PityMe:AddRecordToDBLog(msg);

	end

	if prefix == "PityMeCHANCE" then

		PityMe:AddRecordToDBActive(msg);

	end

end


--function to push the legendary event with all details to others in your guild
function PityMe:ShareData(type, eventData)

	if IsInGuild() then 
		self:Print("Sharing Data with guild (" .. type .. ")");
		SendAddonMessage(type, eventData, "GUILD");
	end

end