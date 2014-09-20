scriptId = 'com.thalmic.openelec'

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

    if pose == "thumbToPinky" then
        if not unlocked then
        	if edge == "off" then
            -- Unlock when pose is released in case the user holds it for a while.
           		unlock()
           		myo.debug("ON")
           	end
        elseif unlocked then
        	if edge == "off" then
            	-- Vibrate twice on unlock.
            	-- We do this when the pose is made for better feedback.
            	myo.vibrate("short")
            	myo.vibrate("short")
            	lock()
            	myo.debug("OFF")
            end
        end
    end

    -- Other poses only when active
        -- Left key
    if unlock then
	    if pose == "waveIn" and edge == "on" then
	        myo.vibrate("short")
	        myo.keyboard("left_arrow","press")
	        myo.debug("LEFT")
	    end

	        -- Right key
	    if pose == "waveOut" and edge == "on" then
	        myo.keyboard("right_arrow","press")
	        myo.debug("RIGHT")
	    end

	    if pose == "fingersSpread" and edge == "on" then
	    	myo.keyboard("return", "press")
	     	myo.debug("RETURN")
	    end


	    if pose == "fist" and edge == "on" then
	     	myo.keyboard("escape", "press")
	      	myo.debug("ESCAPE")
	    end
	end

end

-- Other callbacks

function onPeriodic()
end

function onForegroundWindowChange(app, title)
    return true
end

function activeAppName()
    return "OpenELEC"
end

function onActiveChange(isActive)
end
