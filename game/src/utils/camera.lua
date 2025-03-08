-- File: src/utils/camera.lua
-- Simple camera implementation with screen shake effect

local Class = require("lib.external.libraries.class")
local Helpers = require("src.utils.helpers")
local Camera = Class:extend()

function Camera:init()
	self.x = 0
	self.y = 0
	self.scale = 1
	self.rotation = 0

	-- Screen shake properties
	self.shakeAmount = 0
	self.shakeDuration = 0
	self.shakeTimer = 0
end

function Camera:update(dt)
	-- Update screen shake
	if self.shakeTimer > 0 then
		self.shakeTimer = self.shakeTimer - dt
		if self.shakeTimer <= 0 then
			self.shakeAmount = 0
		end
	end
end

function Camera:apply()
	love.graphics.push()

	-- Apply screen shake
	local dx = 0
	local dy = 0
	if self.shakeAmount > 0 then
		dx = Helpers.random(-self.shakeAmount, self.shakeAmount)
		dy = Helpers.random(-self.shakeAmount, self.shakeAmount)
	end

	-- Apply camera transformations
	love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	love.graphics.scale(self.scale)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-love.graphics.getWidth() / 2 + dx, -love.graphics.getHeight() / 2 + dy)
end

function Camera:reset()
	love.graphics.pop()
end

function Camera:shake(amount, duration)
	self.shakeAmount = amount
	self.shakeDuration = duration
	self.shakeTimer = duration
end

return Camera
