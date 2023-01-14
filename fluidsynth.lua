-- norns fluidsynth

local pid
local sf2_filepath = _path.this.path.."full-grand-piano.sf2"

function process_status(pid)
  return util.os_capture("ps -q "..pid.." -o comm=")
end

function fluidsynth_start()
  if pid == nil then
    pid = util.os_capture('fluidsynth -is -C0 -R0 -r48000 -c 2 -z 64 -a jack -m alsa_seq -o synth.polyphony=64 '..sf2_filepath..' > /dev/null 2>&1 & echo "$!"')
    os.execute("sleep 0.1")

    while true do
      local list = util.os_capture("aconnect -o")
      local a, b = string.find(list, "FLUID Synth")
      if a then
        break
      else
        os.execute("sleep 0.25")
      end
    end

    -- connect Virtual RawMIDI to FLUID Synth
    os.execute("aconnect 128:0 129:0")

    -- route fluidsynth audio to norns
    --
    -- FIXME are these the correct ports?
    --
    os.execute("jack_connect fluidsynth:left crone:input_5")
    os.execute("jack_connect fluidsynth:right crone:input_6")
  end
end

function fluidsynth_stop()
  if pid ~= nil then
    os.execute("aconnect -d 128:0 129:0")
    os.execute("jack_disconnect fluidsynth:left crone:input_5")
    os.execute("jack_disconnect fluidsynth:right crone:input_6")
    os.execute("sleep 0.25")

    os.execute("kill "..pid)
    os.execute("sleep 0.25")
    pid = nil
  end
end

function redraw()
  screen.clear()

  screen.level(15)
  screen.move(55, 40)
  screen.font_size(8)
  screen.text_right("fluidsynth: ")
  local status = process_status(pid)
  if status then
    screen.text("on")
  else
    screen.text("off")
  end
  screen.update()
end

function init()
  redraw()
  re = metro.init()
  re.time = 1.0 * 5
  re.event = function()
    redraw()
  end

  fluidsynth_start()
end

function cleanup()
  fluidsynth_stop()
end
