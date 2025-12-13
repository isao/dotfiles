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
    local myScreen1 = 'EDC6BEEE-ECAD-44F5-B745-C3F7479874C9'

    print ('caffeinateWatcher event received: ' .. hs.caffeinate.watcher[eventType])

    -- Check if we're connected to the monitor, next to the lights.
    if (screen:getUUID() == myScreen1) then

        if (eventType == hs.caffeinate.watcher.systemWillSleep) then
            hs.execute('shortcuts run "office lights off"')
            print 'Lights off'
            -- hs.execute('nanoleaf off', true)

        elseif (eventType == hs.caffeinate.watcher.screensDidUnlock or eventType == hs.caffeinate.watcher.systemDidWake) then
            -- local screenBrightness = screen:getBrightness()
            -- local lightsBrightness = math.min(math.floor(screenBrightness * 70), 100)
            hs.execute('shortcuts run "office lights on low"')
            print 'Lights on'
            -- hs.execute('nanoleaf brightness ' .. lightsBrightness, true)
            -- print ('Brightness set to ' .. lightsBrightness)
        end

    end
end

sleepWatcher = hs.caffeinate.watcher.new(caffeinateWatcher)
sleepWatcher:start()
