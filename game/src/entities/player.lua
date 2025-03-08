-- File: src/entities/player.lua
-- Player entity implementation

local Class = require("lib.external.libraries.class")
local Vector = require("src.utils.vector")
local Player = Class:extend()

function Player:init(x, y, assets)
	self.position = Vector:new(x, y)
	self.velocity = Vector:new(0, 0)
	self.assets = assets

	-- Player properties
	self.width = 32
	self.height = 32
	self.speed = 300
	self.fireRate = 0.2
	self.fireTimer = 0
	self.health = 100
	self.maxHealth = 100
	self.lives = 3
	self.invulnerable = false
	self.invulnerableTimer = 0
	self.invulnerableDuration = 2

	-- Animation properties
	self.alpha = 1
	self.rotation = 0
	self.thrusterOffset = 0
end

function Player:update(dt, bulletManager)
	-- Update invulnerability
	if self.invulnerable then
		self.invulnerableTimer = self.invulnerableTimer - dt
		self.alpha = math.sin(self.invulnerableTimer * 10) * 0.5 + 0.5
		if self.invulnerableTimer <= 0 then
			self.invulnerable = false
			self.alpha = 1
		end
	end

	-- Reset velocity
	self.velocity.x = 0
	self.velocity.y = 0

	-- Handle keyboard input
	if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
		self.velocity.x = -self.speed
		self.rotation = -0.1
	elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
		self.velocity.x = self.speed
		self.rotation = 0.1
	else
		self.rotation = 0
	end

	if love.keyboard.isDown("up") or love.keyboard.isDown("w") then
		self.velocity.y = -self.speed
		self.thrusterOffset = 5
	elseif love.keyboard.isDown("down") or love.keyboard.isDown("s") then
		self.velocity.y = self.speed
		self.thrusterOffset = -2
	else
		self.thrusterOffset = 0
	end

	-- Update position
	self.position.x = self.position.x + self.velocity.x * dt
	self.position.y = self.position.y + self.velocity.y * dt

	-- Keep player within screen bounds
	self.position.x = math.max(self.width / 2, math.min(love.graphics.getWidth() - self.width / 2, self.position.x))
	self.position.y = math.max(self.height / 2, math.min(love.graphics.getHeight() - self.height / 2, self.position.y))

	-- Handle shooting
	self.fireTimer = self.fireTimer - dt
	if (love.keyboard.isDown("space")) and self.fireTimer <= 0 then
		self:shoot(bulletManager)
		self.fireTimer = self.fireRate
	end
end

function Player:draw()
	-- Skip drawing if player is dead
	if self:isDead() then
		return
	end

	-- Draw player ship with current alpha (for invulnerability effect)
	love.graphics.setColor(1, 1, 1, self.alpha)

	-- Apply rotation and draw the player image
	love.graphics.draw(
		self.assets.images.player,
		self.position.x,
		self.position.y,
		self.rotation,
		1,
		1,
		self.width / 2,
		self.height / 2
	)

	-- Reset color
	love.graphics.setColor(1, 1, 1, 1)

	-- Draw health bar
	self:drawHealthBar()
end

function Player:drawHealthBar()
	local barWidth = 40
	local barHeight = 4

	-- Background (red)
	love.graphics.setColor(0.8, 0, 0, 1)
	love.graphics.rectangle(
		"fill",
		self.position.x - barWidth / 2,
		self.position.y + self.height / 2 + 5,
		barWidth,
		barHeight
	)

	-- Foreground (green)
	local healthPercentage = self.health / self.maxHealth
	love.graphics.setColor(0, 0.8, 0, 1)
	love.graphics.rectangle(
		"fill",
		self.position.x - barWidth / 2,
		self.position.y + self.height / 2 + 5,
		barWidth * healthPercentage,
		barHeight
	)

	-- Reset color
	love.graphics.setColor(1, 1, 1, 1)
end

function Player:shoot(bulletManager)
	-- Create a new bullet at the player's position
	local bulletX = self.position.x
	local bulletY = self.position.y - self.height / 2
	bulletManager:createPlayerBullet(bulletX, bulletY)

	-- Play shoot sound
	self.assets:playSound(self.assets.sounds.shoot)
end

function Player:takeDamage(amount)
	-- Skip damage if invulnerable
	if self.invulnerable then
		return
	end

	-- Apply damage
	self.health = self.health - amount

	-- Play hit sound
	self.assets:playSound(self.assets.sounds.hit)

	-- Check if player lost a life
	if self.health <= 0 and self.lives > 0 then
		self.lives = self.lives - 1

		-- If player has lives left, reset health and make invulnerable
		if self.lives > 0 then
			self.health = self.maxHealth
			self.invulnerable = true
			self.invulnerableTimer = self.invulnerableDuration
		end
	end
end

function Player:isDead()
	return self.health <= 0 and self.lives <= 0
end

function Player:getPosition()
	return self.position
end

function Player:getBoundingBox()
	return {
		x = self.position.x - self.width / 2,
		y = self.position.y - self.height / 2,
		width = self.width,
		height = self.height,
	}
end

function Player:reset(x, y)
	self.position.x = x
	self.position.y = y
	self.velocity.x = 0
	self.velocity.y = 0
	self.health = self.maxHealth
	self.lives = 3
	self.invulnerable = true
	self.invulnerableTimer = self.invulnerableDuration
	self.rotation = 0
	self.thrusterOffset = 0
end

return Player
