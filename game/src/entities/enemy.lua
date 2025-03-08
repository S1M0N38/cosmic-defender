-- File: src/entities/enemy.lua
-- Enemy entity implementation

local Class = require("lib.external.libraries.class")
local Vector = require("src.utils.vector")
local Enemy = Class:extend()

function Enemy:init(x, y, type, assets)
	self.position = Vector:new(x, y)
	self.velocity = Vector:new(0, 0)
	self.type = type
	self.assets = assets

	-- Set properties based on enemy type
	self:setPropertiesByType()

	-- Enemy state
	self.active = true
	self.health = self.maxHealth

	-- Animation properties
	self.rotation = 0
	self.scale = 1
	self.alpha = 1

	-- AI state
	self.aiState = "spawning"
	self.aiTimer = 0
	self.targetPosition = Vector:new(x, y + 100)
end

function Enemy:setPropertiesByType()
	if self.type == 1 then
		-- Small fast enemy
		self.width = 24
		self.height = 24
		self.speed = 150
		self.maxHealth = 30
		self.scoreValue = 100
		self.fireRate = 2
		self.image = self.assets.images.enemy1
	elseif self.type == 2 then
		-- Medium enemy
		self.width = 32
		self.height = 32
		self.speed = 100
		self.maxHealth = 60
		self.scoreValue = 200
		self.fireRate = 1.5
		self.image = self.assets.images.enemy2
	else
		-- Large slow enemy
		self.width = 48
		self.height = 48
		self.speed = 75
		self.maxHealth = 100
		self.scoreValue = 300
		self.fireRate = 1
		self.image = self.assets.images.enemy3
	end

	-- Initialize fire timer with random offset
	self.fireTimer = self.fireRate * math.random()
end

function Enemy:update(dt, player, bulletManager)
	-- Update AI state machine
	self:updateAI(dt, player, bulletManager)

	-- Update position
	self.position.x = self.position.x + self.velocity.x * dt
	self.position.y = self.position.y + self.velocity.y * dt

	-- Update animation
	self.rotation = self.rotation + dt * 0.5

	-- Update fire timer
	self.fireTimer = self.fireTimer - dt
	if self.fireTimer <= 0 and self.aiState ~= "spawning" then
		self:fire(bulletManager)
		self.fireTimer = self.fireRate * (0.8 + math.random() * 0.4) -- Add some randomness to fire rate
	end

	-- Deactivate if enemy goes off screen
	if self.position.y > love.graphics.getHeight() + self.height then
		self.active = false
	end
end

function Enemy:updateAI(dt, player, bulletManager)
	-- Update AI timer
	self.aiTimer = self.aiTimer + dt

	if self.aiState == "spawning" then
		-- Move to initial position
		local direction = self.targetPosition:subtract(self.position)
		if direction:magnitude() < 5 then
			self.aiState = "attacking"
			self.aiTimer = 0
		else
			direction = direction:normalize():multiply(self.speed)
			self.velocity = direction
		end
	elseif self.aiState == "attacking" then
		-- Different movement patterns based on enemy type
		if self.type == 1 then
			-- Small enemies move in a sine wave pattern
			self.velocity.x = math.sin(self.aiTimer * 2) * self.speed
			self.velocity.y = self.speed * 0.5
		elseif self.type == 2 then
			-- Medium enemies track player horizontally with limited speed
			if player then
				local targetX = player:getPosition().x
				local dx = targetX - self.position.x
				self.velocity.x = math.min(self.speed, math.max(-self.speed, dx))
				self.velocity.y = self.speed * 0.3
			else
				self.velocity.x = 0
				self.velocity.y = self.speed * 0.3
			end
		else
			-- Large enemies move slowly downward with occasional direction changes
			if self.aiTimer > 2 then
				self.velocity.x = (math.random() * 2 - 1) * self.speed * 0.5
				self.aiTimer = 0
			end
			self.velocity.y = self.speed * 0.2
		end
	end
end

function Enemy:fire(bulletManager)
	-- Create a new bullet at the enemy's position
	bulletManager:createEnemyBullet(self.position.x, self.position.y + self.height / 2)

	-- Play shoot sound
	self.assets:playSound(self.assets.sounds.shoot)
end

function Enemy:draw()
	-- Skip drawing if not active
	if not self.active then
		return
	end

	-- Draw enemy with current alpha
	love.graphics.setColor(1, 1, 1, self.alpha)

	-- Draw the enemy image with rotation
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

	-- Draw health bar
	self:drawHealthBar()
end

function Enemy:drawHealthBar()
	local barWidth = self.width * 0.8
	local barHeight = 3

	-- Background (red)
	love.graphics.setColor(0.8, 0, 0, 0.7)
	love.graphics.rectangle(
		"fill",
		self.position.x - barWidth / 2,
		self.position.y + self.height / 2 + 5,
		barWidth,
		barHeight
	)

	-- Foreground (green)
	local healthPercentage = self.health / self.maxHealth
	love.graphics.setColor(0, 0.8, 0, 0.7)
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

function Enemy:takeDamage(amount)
	-- Apply damage
	self.health = self.health - amount

	-- Check if enemy is destroyed
	if self.health <= 0 then
		self.active = false
	end
end

function Enemy:isActive()
	return self.active
end

function Enemy:deactivate()
	self.active = false
end

function Enemy:getBoundingBox()
	return {
		x = self.position.x - self.width / 2,
		y = self.position.y - self.height / 2,
		width = self.width,
		height = self.height,
	}
end

function Enemy:getScoreValue()
	return self.scoreValue
end

function Enemy:getPosition()
	return self.position
end

function Enemy:getType()
	return self.type
end

return Enemy
