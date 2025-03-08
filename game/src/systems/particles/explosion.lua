-- File: src/systems/particles/explosion.lua
-- Creates explosion particle effects

local Class = require("lib.external.libraries.class")
local Explosion = Class:extend()

function Explosion:init(x, y, size, particleImage)
	self.x = x
	self.y = y
	self.size = size
	self.lifetime = 0.8
	self.timer = 0
	self.active = true

	-- Create the particle system
	self.ps = love.graphics.newParticleSystem(particleImage, 100)

	-- Configure particle system based on size
	self.ps:setParticleLifetime(0.3, 0.8)
	self.ps:setEmissionRate(0)
	self.ps:setEmissionArea("uniform", size * 5, size * 5)
	self.ps:setSizes(size * 0.5, size * 0.3, size * 0.1)
	self.ps:setColors(
		1,
		1,
		0.5,
		1, -- Yellow
		1,
		0.5,
		0,
		1, -- Orange
		0.8,
		0.2,
		0,
		0.5 -- Red with transparency
	)
	self.ps:setLinearAcceleration(-50, -50, 50, 50)
	self.ps:setRotation(0, math.pi * 2)
	self.ps:setSpin(1, 3)
	self.ps:setSpeed(50, 100)

	-- Emit a single burst of particles
	self.ps:emit(50 * size)
end

function Explosion:update(dt)
	self.timer = self.timer + dt
	self.ps:update(dt)

	if self.timer >= self.lifetime then
		self.active = false
	end
end

function Explosion:draw()
	love.graphics.draw(self.ps, self.x, self.y)
end

function Explosion:isActive()
	return self.active
end

return Explosion
