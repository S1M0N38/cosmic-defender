-- File: src/systems/particles/thruster.lua
-- Creates thruster particle effects

local Class = require("lib.external.libraries.class")
local Thruster = Class:extend()

function Thruster:init(particleImage)
	self.active = true

	-- Create the particle system
	self.ps = love.graphics.newParticleSystem(particleImage, 100)

	-- Configure particle system
	self.ps:setParticleLifetime(0.1, 0.3)
	self.ps:setEmissionRate(50)
	self.ps:setEmissionArea("uniform", 2, 2)
	self.ps:setSizes(2, 1, 0.5)
	self.ps:setColors(
		0.8,
		0.8,
		1,
		1, -- Light blue
		0.4,
		0.4,
		1,
		0.8, -- Medium blue
		0.2,
		0.2,
		0.8,
		0 -- Dark blue fading out
	)
	self.ps:setLinearAcceleration(-10, 50, 10, 100)
	self.ps:setRotation(0, math.pi * 2)
	self.ps:setSpin(1, 3)
	self.ps:setSpeed(50, 100)
end

function Thruster:update(dt, x, y)
	self.ps:update(dt)
	-- Only update position if x and y are provided
	if x and y then
		self.ps:setPosition(x, y + 15)
	end
end

function Thruster:draw()
	love.graphics.draw(self.ps)
end

function Thruster:isActive()
	return self.active
end

return Thruster
