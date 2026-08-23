local function selectOriginalAudio()
	local tracks = mp.get_property_native("track-list")
	if not tracks then
		return
	end

	for _, track in ipairs(tracks) do
		if track.type == "audio" and track.title then
			if track.title:lower():find("original") then
				mp.set_property("aid", track.id)
				return
			end
		end
	end
end

mp.register_event("file-loaded", selectOriginalAudio)
