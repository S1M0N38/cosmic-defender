-- File: src/entities/bullet_manager.lua
-- Manages all bullets in the game

local Class = require("lib.external.libraries.class")
local Bullet = require("src.entities.bullet")
local BulletManager = Class:extend()

function BulletManager:init(assets)
	self.bullets = {}
	self.assets = assets
end

function BulletManager:update(dt)
	for i = #self.bullets, 1, -1 do
		local bullet = self.bullets[i]
		bullet:update(dt)

		-- Remove inactive bullets
		if not bullet:isActive() then
			table.remove(self.bullets, i)
		end
	end
end

function BulletManager:draw()
	for _, bullet in ipairs(self.bullets) do
		bullet:draw()
	end
end

function BulletManager:createPlayerBullet(x, y)
	local bullet = Bullet:new(
		x,
		y,
		500, -- Speed
		10, -- Damage
		true, -- Is player bullet
		self.assets.images.playerBullet
	)
	table.insert(self.bullets, bullet)
end

function BulletManager:createEnemyBullet(x, y)
	local bullet = Bullet:new(
		x,
		y,
		300, -- Speed
		5, -- Damage
		false, -- Is player bullet
		self.assets.images.enemyBullet
	)
	table.insert(self.bullets, bullet)
end

function BulletManager:getPlayerBullets()
	local playerBullets = {}
	for _, bullet in ipairs(self.bullets) do
		if bullet:isFromPlayer() then
			table.insert(playerBullets, bullet)
		end
	end
	return playerBullets
end

function BulletManager:getEnemyBullets()
	local enemyBullets = {}
	for _, bullet in ipairs(self.bullets) do
		if not bullet:isFromPlayer() then
			table.insert(enemyBullets, bullet)
		end
	end
	return enemyBullets
end

function BulletManager:reset()
	self.bullets = {}
end

return BulletManager
