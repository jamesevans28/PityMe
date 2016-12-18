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

function PityMe:PityMeLOG_Received(prefix, message, distribution, sender)

 local success, o = self:Deserialize(message)
 if success == false then
  return -- Failure
 else
  	PityMe:print("Receiving LOOT data from " .. sender);
		PityMe:AddRecordToDBLog(o);
 end
end

function PityMe:PityMeCHANCE_Received(prefix, message, distribution, sender)

	--if its from the same player, then just bail
	if sender == GetUnitName("player") then
		return
	end

 local success, o = self:Deserialize(message)
 if success == false then
  return -- Failure
 else
  	PityMe:print("Receiving CHANCE data from " .. sender);
	PityMe:AddRecordToDBActive(o);
	PityMe:ShareData("PityMeSYNC", PityMe:FormatMyData());
 end
end

function PityMe:PityMeSYNC_Received(prefix, message, distribution, sender)

 local success, o = self:Deserialize(message)
 if success == false then
  return -- Failure
 else
  	PityMe:print("Receiving SYNC data from " .. sender);
	PityMe:AddRecordToDBActive(o);
 end
end

--function to push the legendary event with all details to others in your guild
function PityMe:ShareData(type, eventData)

	if IsInGuild() then 
		PityMe:print("Sharing Data with guild (" .. type .. ")");
		eventData = self:Serialize(eventData)
		SendAddonMessage(type, eventData, "GUILD");
	end

end