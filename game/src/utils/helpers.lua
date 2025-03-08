-- File: src/utils/helpers.lua
-- Helper functions for the game

local Helpers = {}

-- Check if two rectangles are colliding (AABB collision detection)
function Helpers.checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

-- Linear interpolation
function Helpers.lerp(a, b, t)
	return a + (b - a) * t
end

-- Clamp a value between min and max
function Helpers.clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

-- Get angle between two points
function Helpers.angleBetween(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end

-- Random value between min and max
function Helpers.random(min, max)
	return min + math.random() * (max - min)
end

-- Random integer between min and max (inclusive)
function Helpers.randomInt(min, max)
	return math.floor(min + math.random() * (max - min + 1))
end

-- Format score with commas
function Helpers.formatScore(score)
	local formatted = tostring(score)
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

return Helpers
