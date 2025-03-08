-- File: src/entities/bullet.lua
-- Bullet entity implementation

local Class = require("lib.external.libraries.class")
local Vector = require("src.utils.vector")
local Bullet = Class:extend()

function Bullet:init(x, y, speed, damage, isPlayerBullet, image)
	self.position = Vector:new(x, y)
	self.velocity = Vector:new(0, isPlayerBullet and -speed or speed)
	self.damage = damage
	self.isPlayerBullet = isPlayerBullet
	self.image = image

	-- Bullet properties
	self.width = 8
	self.height = 16
	self.active = true

	-- Animation properties
	self.rotation = 0
	self.scale = 1
end

function Bullet:update(dt)
	-- Update position
	self.position.x = self.position.x + self.velocity.x * dt
	self.position.y = self.position.y + self.velocity.y * dt

	-- Deactivate if bullet goes off screen
	if self.position.y < -self.height or self.position.y > love.graphics.getHeight() + self.height then
		self.active = false
	end

	-- Update animation
	self.rotation = self.rotation + dt * (self.isPlayerBullet and 2 or -2)
end

function Bullet:draw()
	-- Skip drawing if not active
	if not self.active then
		return
	end

	-- Set color based on bullet type
	if self.isPlayerBullet then
		love.graphics.setColor(0, 1, 1, 1)
	else
		love.graphics.setColor(1, 0.5, 0, 1)
	end

	-- Draw bullet with rotation
	love.graphics.draw(
		self.image,
		self.position.x,
		self.position.y,
		self.rotation,
		self.scale,
		self.scale,
		self.width / 2,
		self.height / 2
	)

	-- Reset color
	love.graphics.setColor(1, 1, 1, 1)
end

function Bullet:isActive()
	return self.active
end

function Bullet:deactivate()
	self.active = false
end

function Bullet:getBoundingBox()
	return {
		x = self.position.x - self.width / 2,
		y = self.position.y - self.height / 2,
		width = self.width,
		height = self.height,
	}
end

function Bullet:getDamage()
	return self.damage
end

function Bullet:isFromPlayer()
	return self.isPlayerBullet
end

function Bullet:getPosition()
	return self.position
end

return Bullet
