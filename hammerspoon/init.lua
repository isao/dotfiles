--
-- Watch ~/.hammerspoon/*.lua files, and reload when they change.
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == '.lua' then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig):start()
hs.alert.show('Hammerspoon config loaded.')

-- Enable Spoons to reload configuration when added.
--hs.loadSpoon('ReloadConfiguration')
--spoon.ReloadConfiguration:start()



--
-- On wake/sleep, turn on/off lights (when connected to the office monitor).
--
function caffeinateWatcher(eventType)
    local screen = hs.screen.primaryScreen()
    local myScreenId = 458658833

    print ('caffeinateWatcher event received: ' .. hs.caffeinate.watcher[eventType])

    -- Check if we're connected to the monitor, next to the lights.
    if (screen:id() == myScreenId) then

        if (eventType == hs.caffeinate.watcher.screensDidSleep) then
            hs.execute('nanoleaf off', true)

        elseif (eventType == hs.caffeinate.watcher.screensDidWake) then
            local screenBrightness = screen:getBrightness()
            local lightsBrightness = math.min(math.floor(screenBrightness * 110), 100)
            hs.execute('nanoleaf brightness ' .. lightsBrightness, true)
            print ('Brightness set to ' .. lightsBrightness)
        end

    end
end

sleepWatcher = hs.caffeinate.watcher.new(caffeinateWatcher)
sleepWatcher:start()
