local normalSpeed = 1.0

local function makeHold(targetSpeed)
  return function(e)
    if e.event == "down" or e.event == "repeat" then
      if e.event == "down" then
        normalSpeed = mp.get_property_number("speed")
      end
      mp.set_property("speed", targetSpeed)
    elseif e.event == "up" then
      mp.set_property("speed", normalSpeed)
    end
  end
end

mp.add_key_binding("=", "speed-fast", makeHold(2.0), { complex = true })
mp.add_key_binding("-", "speed-slow", makeHold(0.5), { complex = true })
