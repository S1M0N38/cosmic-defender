-- File: src/utils/vector.lua
-- 2D vector implementation with common operations

local Class = require("lib.external.libraries.class")
local Vector = Class:extend()

function Vector:init(x, y)
	self.x = x or 0
	self.y = y or 0
end

function Vector:clone()
	return Vector:new(self.x, self.y)
end

function Vector:add(other)
	return Vector:new(self.x + other.x, self.y + other.y)
end

function Vector:subtract(other)
	return Vector:new(self.x - other.x, self.y - other.y)
end

function Vector:multiply(scalar)
	return Vector:new(self.x * scalar, self.y * scalar)
end

function Vector:divide(scalar)
	if scalar ~= 0 then
		return Vector:new(self.x / scalar, self.y / scalar)
	else
		error("Cannot divide vector by zero")
	end
end

function Vector:magnitude()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:normalize()
	local mag = self:magnitude()
	if mag > 0 then
		return self:divide(mag)
	else
		return Vector:new(0, 0)
	end
end

function Vector:dot(other)
	return self.x * other.x + self.y * other.y
end

function Vector:distance(other)
	local dx = self.x - other.x
	local dy = self.y - other.y
	return math.sqrt(dx * dx + dy * dy)
end

function Vector:limit(max)
	if self:magnitude() > max then
		return self:normalize():multiply(max)
	end
	return self:clone()
end

return Vector
