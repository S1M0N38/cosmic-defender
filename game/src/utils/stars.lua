-- File: src/utils/stars.lua
-- Creates a parallax starfield background

local Class = require("lib.external.libraries.class")
local Helpers = require("src.utils.helpers")
local Stars = Class:extend()

function Stars:init(count)
	self.stars = {}
	for i = 1, count do
		table.insert(self.stars, {
			x = math.random(0, love.graphics.getWidth()),
			y = math.random(0, love.graphics.getHeight()),
			size = math.random(1, 3),
			speed = Helpers.random(10, 50),
			alpha = Helpers.random(0.5, 1),
		})
	end
end

function Stars:update(dt)
	for i, star in ipairs(self.stars) do
		star.y = star.y + star.speed * dt
		if star.y > love.graphics.getHeight() then
			star.y = 0
			star.x = math.random(0, love.graphics.getWidth())
		end
	end
end

function Stars:draw()
	love.graphics.setColor(1, 1, 1, 1)
	for i, star in ipairs(self.stars) do
		love.graphics.setColor(1, 1, 1, star.alpha)
		love.graphics.rectangle("fill", star.x, star.y, star.size, star.size)
	end
	love.graphics.setColor(1, 1, 1, 1)
end

return Stars
