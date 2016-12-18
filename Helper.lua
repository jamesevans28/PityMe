local debug = PityMe.debug

function PityMe:print(msg)
	if debug then
		self:Print(msg)
	end
end
