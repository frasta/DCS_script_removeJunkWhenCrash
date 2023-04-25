-- Remove junk script from Asta, if any question, find me here: https://discord.gg/ZUZdMzQ
local blueUnits = mist.makeUnitTable({'[blue][plane]','[blue][helicopter]'})
local units = nil
local zone_names = {'cleanSochi','cleanGudauta','cleanSukhumi','cleanKvitiri','cleanSmallAirfield','cleanAnapa','cleanNovo','cleanHelicamp'}
local eventListener = {}
local coordinatesCrash = nil
local currentZone = nil
local volumeToPurify = nil


function eventListener:onEvent(event)
	if event.id == 5 then --https://wiki.hoggitworld.com/view/DCS_event_crash
		coordinatesCrash = event.initiator:getPoint()
		for i = 1, #zone_names do 
			currentZone = trigger.misc.getZone(zone_names[i])
			if currentZone~=nil and distance(currentZone.point.x, currentZone.point.z,coordinatesCrash.x,coordinatesCrash.z)<currentZone.radius then
				currentZone.point.y = land.getHeight({x = currentZone.point.x, y = currentZone.point.z})
				volumeToPurify = {
					id = world.VolumeType.SPHERE,
					params = {
						point = currentZone.point,
						radius = currentZone.radius
					}
				}
				mist.scheduleFunction(purifaction, {volumeToPurify}, timer.getTime() + 3)
			end
		end
		coordinatesCrash = nil
		volumeToPurify = nil
		currentZone = nil
	end
end
world.addEventHandler(eventListener)

function distance(x1,y1,x2,y2)
	local dx = x1 - x2
	local dy = y1 - y2
	return math.sqrt(dx*dx + dy*dy)
end

function purifaction(volumeToPurify)
	world.removeJunk(volumeToPurify) --https://wiki.hoggitworld.com/view/DCS_func_removeJunk
end