scriptId = 'com.thalmic.openelec'

local check = false
local counter = 0
local centre = 0

function conditionallySwapWave(pose)
    if myo.getArm() == "left" then
        if pose == "waveIn" then
            pose = "waveOut"
        elseif pose == "waveOut" then
            pose = "waveIn"
        end
    end
    return pose
end

function unlock()
    unlocked = true;
end

function lock()
    unlocked = false;
end

function onPoseEdge(pose, edge)

    pose = conditionallySwapWave(pose)
        -- Left key
    if unlock then
        if pose == "waveIn" and edge == "on" then
            myo.vibrate("short")
            myo.keyboard("left_arrow","press")
            myo.keyboard("comma", "press")
            myo.debug("LEFT")
        end

            -- Right key
        if pose == "waveOut" and edge == "on" then
            myo.vibrate("short")
            myo.keyboard("right_arrow","press")
            myo.keyboard("period", "press")
            myo.debug("RIGHT")
        end

        if pose == "fingersSpread" and edge == "on" then
            myo.vibrate("short")
            myo.keyboard("return", "press")
            myo.keyboard("space", "press")
            myo.debug("RETURN")
        end


        if (pose == "fist" or pose == "thumbToPinky") then
            myo.keyboard("x", "press")
            local now = myo.getTimeMilliseconds()
            if edge == "on" then
                myo.vibrate("short")
                centre = myo.getRoll()
                shuttleSince = now
                shuttleTimeout = SHUTTLE_CONTINUOUS_TIMEOUT
            end
            if edge == "off" then
                shuttleTimeout = nil
                if check then
                    check = false
                    myo.vibrate("short")
                    myo.keyboard("backspace", "press")
                    myo.debug("BACKSPACE")
                end
            end


            -- if edge == "on" then -- clicks down to drag
            --     check = true
            --     myo.debug(myo.getRoll())
            --     centre = myo.getRoll()
            --  elseif edge == "off" and counter <= 15 then
            --     counter = 0
            --     check = false
            --     myo.keyboard("backspace", "press")
            --     myo.debug("BACKSPACE")     
            --  elseif edge == "off" then -- release click
            --     check = false   
            -- end
        end
        
    end

end

SHUTTLE_CONTINUOUS_TIMEOUT = 1000

SHUTTLE_CONTINUOUS_PERIOD = 500

-- Other callbacks



function onPeriodic()
    local now = myo.getTimeMilliseconds()
    if shuttleTimeout then
        if (now - shuttleSince) > shuttleTimeout then
            if myo.getRoll() > (centre + 0.3) then
                myo.vibrate("short")
                myo.keyboard("up_arrow", "press")
                myo.debug("UP")
            end
            if myo.getRoll() < (centre - 0.3) then
                myo.vibrate("short")
                myo.keyboard("down_arrow", "press")
                myo.debug("DOWN")
            end
            check = false
            shuttleSince = now
        end
    else 
        check = true
    end

    -- if check == true then
    -- myo.debug(myo.getRoll())
    -- counter = counter + 1
    -- end

    -- if counter > 15 then
    --   if myo.getRoll() > (centre + 0.3) then
    --     myo.keyboard("up_arrow", "press")
    --     myo.debug("UP")
    --   elseif myo.getRoll() < (centre - 0.3) then
    --     myo.keyboard("down_arrow", "press")
    --     myo.debug("DOWN")
    --   end
    -- counter = 0
    -- end
end

function onForegroundWindowChange(app, title)
    return true
end

function activeAppName()
    return "OpenELEC"
end

function onActiveChange(isActive)
end