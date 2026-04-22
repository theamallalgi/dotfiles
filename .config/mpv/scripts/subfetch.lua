-- NOTE: python library `subliminal` should be installed.
-- TODO: create file ~/.configs/subliminal.toml, with details given below;
-- [opensubtitles]
-- username = "username"
-- password = "password"
-- NOTE: press Ctrl+Shift+S to fetch subtitles.

local mp = require("mp")
local utils = require("mp.utils")

local function fetchSubs()
  local path = mp.get_property("path")
  if not path then
    mp.osd_message("No file loaded")
    return
  end

  mp.osd_message("Downloading subtitles...")

  local result = utils.subprocess({
    args = {
      "subliminal",
      "download",
      "-l", "en",
      "-f",
      "-p", "opensubtitles",
      path
    },
    capture_stdout = true,
    capture_stderr = true,
  })

  print("[subFetch] STDOUT:\n" .. (result.stdout or ""))
  print("[subFetch] STDERR:\n" .. (result.stderr or ""))

  if result.status ~= 0 then
    mp.osd_message("Subtitle download failed")
    return
  end

  mp.commandv("rescan_external_files")
  mp.osd_message("Subtitles loaded")
end

mp.add_key_binding("ctrl+shift+s", "fetch-subs", fetchSubs)
