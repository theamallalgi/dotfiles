local utils = require("mp.utils")
local msg = require("mp.msg")

-- Configuration
local OPENSUBTITLES_USER_AGENT = "mpv-subtitle-downloader"
local TEMP_DIR = "/tmp"

-- Function to get video file hash (OpenSubtitles hash)
function get_file_hash(filepath)
	local file = io.open(filepath, "rb")
	if not file then
		return nil
	end

	local filesize = file:seek("end")
	file:seek("set", 0)

	if filesize < 131072 then -- 128KB minimum
		file:close()
		return nil
	end

	-- Read first and last 64KB
	local head = file:read(65536)
	file:seek("end", -65536)
	local tail = file:read(65536)
	file:close()

	if not head or not tail then
		return nil
	end

	-- Simple hash calculation (simplified version)
	local hash = filesize
	for i = 1, #head, 8 do
		local chunk = head:sub(i, i + 7)
		if #chunk == 8 then
			hash = hash + string.unpack("<I8", chunk)
		end
	end
	for i = 1, #tail, 8 do
		local chunk = tail:sub(i, i + 7)
		if #chunk == 8 then
			hash = hash + string.unpack("<I8", chunk)
		end
	end

	return string.format("%016x", hash & 0xFFFFFFFFFFFFFFFF)
end

-- Function to extract filename without extension
function get_filename_base(filepath)
	local filename = filepath:match("([^/\\]+)$") or filepath
	return filename:match("(.+)%..+$") or filename
end

-- Function to download subtitles using curl
function download_subtitles()
	local filepath = mp.get_property("path")
	if not filepath then
		mp.osd_message("No file loaded", 2)
		return
	end

	-- Check if file exists locally
	local file = io.open(filepath, "r")
	if not file then
		mp.osd_message("Cannot access file for subtitle download", 2)
		return
	end
	file:close()

	mp.osd_message("Searching for subtitles...", 2)

	local filename_base = get_filename_base(filepath)
	local filesize = utils.file_info(filepath).size
	local filehash = get_file_hash(filepath)

	if not filehash then
		mp.osd_message("Could not generate file hash", 2)
		return
	end

	-- Try to download using subliminal (Python library) if available
	local subliminal_cmd = {
		"subliminal",
		"download",
		"-l",
		"en", -- Change language as needed
		"-p",
		"opensubtitles",
		filepath,
	}

	local result = utils.subprocess({
		name = "subliminal",
		args = subliminal_cmd,
		capture_stdout = true,
		capture_stderr = true,
	})

	if result.status == 0 then
		mp.osd_message("Subtitles downloaded successfully!", 3)
		-- Reload to pick up new subtitles
		mp.command("rescan-external-files")
		return
	end

	-- Fallback: try using curl with OpenSubtitles API
	local search_url = string.format("https://rest.opensubtitles.org/search/moviehash-%s/sublanguageid-eng", filehash)

	local curl_cmd = {
		"curl",
		"-s",
		"-H",
		"User-Agent: " .. OPENSUBTITLES_USER_AGENT,
		search_url,
	}

	local search_result = utils.subprocess({
		name = "curl",
		args = curl_cmd,
		capture_stdout = true,
		capture_stderr = true,
	})

	if search_result.status ~= 0 then
		mp.osd_message("Failed to search for subtitles", 2)
		return
	end

	-- Simple JSON parsing (looking for SubDownloadLink)
	local download_link = search_result.stdout:match('"SubDownloadLink":"([^"]+)"')
	if not download_link then
		mp.osd_message("No subtitles found", 2)
		return
	end

	-- Download the subtitle file
	local subtitle_path = filepath:gsub("(%.[^%.]+)$", ".srt")
	local download_cmd = {
		"curl",
		"-s",
		"-o",
		subtitle_path,
		download_link:gsub("\\/", "/"),
	}

	local download_result = utils.subprocess({
		name = "curl",
		args = download_cmd,
		capture_stdout = true,
		capture_stderr = true,
	})

	if download_result.status == 0 then
		mp.osd_message("Subtitles downloaded: " .. subtitle_path:match("([^/\\]+)$"), 3)
		mp.command("rescan-external-files")
	else
		mp.osd_message("Failed to download subtitles", 2)
	end
end

-- Bind the function to a key
mp.add_key_binding("ctrl+s", "download-subtitles", download_subtitles)
