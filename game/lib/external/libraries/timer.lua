-- File: lib/external/libraries/timer.lua
-- Simple timer utility for delayed and periodic function calls

local Class = require("lib.external.libraries.class")
local Timer = Class:extend()

function Timer:init()
	self.timers = {}
end

function Timer:update(dt)
	for i = #self.timers, 1, -1 do
		local timer = self.timers[i]
		timer.time = timer.time - dt

		if timer.time <= 0 then
			timer.callback()

			if timer.isRepeating then
				timer.time = timer.duration
			else
				table.remove(self.timers, i)
			end
		end
	end
end

function Timer:after(duration, callback)
	table.insert(self.timers, {
		time = duration,
		duration = duration,
		callback = callback,
		isRepeating = false,
	})
end

function Timer:every(duration, callback)
	table.insert(self.timers, {
		time = duration,
		duration = duration,
		callback = callback,
		isRepeating = true,
	})

	return #self.timers
end

function Timer:cancel(id)
	if id then
		table.remove(self.timers, id)
	end
end

function Timer:clear()
	self.timers = {}
end

return Timer
