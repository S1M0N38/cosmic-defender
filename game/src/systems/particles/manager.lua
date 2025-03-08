-- File: src/systems/particles/manager.lua
-- Manages all particle effects in the game

local Class = require("lib.external.libraries.class")
local Explosion = require("src.systems.particles.explosion")
local Thruster = require("src.systems.particles.thruster")
local ParticleManager = Class:extend()

function ParticleManager:init(assets)
	self.assets = assets
	self.particles = {}
	self.particleImage = assets.images.particle

	-- Create player thruster
	self.playerThruster = Thruster:new(self.particleImage)
end

function ParticleManager:update(dt, player)
	-- Update player thruster if player exists
	if player then
		local pos = player:getPosition()
		self.playerThruster:update(dt, pos.x, pos.y)
	end

	-- Update all particles
	for i = #self.particles, 1, -1 do
		local particle = self.particles[i]
		particle:update(dt)

		-- Remove inactive particles
		if not particle:isActive() then
			table.remove(self.particles, i)
		end
	end
end

function ParticleManager:draw()
	-- Draw player thruster
	self.playerThruster:draw()

	-- Draw all particles
	for _, particle in ipairs(self.particles) do
		particle:draw()
	end
end

function ParticleManager:createExplosion(x, y, size)
	local explosion = Explosion:new(x, y, size, self.particleImage)
	table.insert(self.particles, explosion)
	return explosion
end

function ParticleManager:createHitEffect(x, y)
	local hitEffect = Explosion:new(x, y, 0.5, self.particleImage)
	table.insert(self.particles, hitEffect)
	return hitEffect
end

function ParticleManager:updatePlayerThruster(x, y)
	self.playerThruster:update(x, y)
end

function ParticleManager:reset()
	self.particles = {}
end

return ParticleManager
