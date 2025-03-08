-- File: src/utils/assets.lua
-- Handles loading and managing game assets

local Class = require("lib.external.libraries.class")
local Assets = Class:extend()

function Assets:init()
	self.images = {}
	self.sounds = {}
	self.fonts = {}
end

function Assets:load()
	-- Load images
	self:loadImages()

	-- Load sounds
	self:loadSounds()

	-- Load fonts
	self:loadFonts()
end

function Assets:loadImages()
	-- In a real implementation, we would load actual image files
	-- For this example, we'll create placeholder images

	-- Player ship
	self.images.player = self:createPlaceholderImage(32, 32, { 0, 0.7, 1 })

	-- Enemy ships
	self.images.enemy1 = self:createPlaceholderImage(24, 24, { 1, 0.3, 0.3 })
	self.images.enemy2 = self:createPlaceholderImage(32, 32, { 1, 0.5, 0.2 })
	self.images.enemy3 = self:createPlaceholderImage(48, 48, { 0.8, 0.2, 0.8 })

	-- Bullets
	self.images.playerBullet = self:createPlaceholderImage(8, 16, { 0, 1, 1 })
	self.images.enemyBullet = self:createPlaceholderImage(8, 16, { 1, 0.5, 0 })

	-- Particles
	self.images.particle = self:createPlaceholderImage(8, 8, { 1, 1, 1 })
end

function Assets:loadSounds()
	-- In a real implementation, we would load actual sound files
	-- For this example, we'll just define the sound names

	self.sounds.shoot = "shoot.wav" -- Player shooting sound
	self.sounds.explosion = "explosion.wav" -- Explosion sound
	self.sounds.hit = "hit.wav" -- Hit sound
	self.sounds.powerup = "powerup.wav" -- Power-up sound
end

function Assets:loadFonts()
	-- Load fonts at different sizes
	self.fonts.small = love.graphics.newFont(14)
	self.fonts.medium = love.graphics.newFont(24)
	self.fonts.large = love.graphics.newFont(36)
	self.fonts.huge = love.graphics.newFont(72)
end

function Assets:createPlaceholderImage(width, height, color)
	-- Create a placeholder image with the given color
	local image = love.graphics.newCanvas(width, height)
	love.graphics.setCanvas(image)
	love.graphics.clear()
	love.graphics.setColor(color[1], color[2], color[3])
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()
	return image
end

function Assets:playSound(name)
	-- In a real implementation, we would play the actual sound
	-- For this example, we'll just log the sound name
	print("Playing sound: " .. name)
end

return Assets
