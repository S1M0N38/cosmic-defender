-- File: src/systems/collision.lua
-- Handles collision detection and resolution

local Class = require("lib.external.libraries.class")
local Helpers = require("src.utils.helpers")
local CollisionSystem = Class:extend()

function CollisionSystem:init(assets)
	self.player = nil
	self.bulletManager = nil
	self.enemyManager = nil
	self.assets = assets
end

function CollisionSystem:registerPlayer(player)
	self.player = player
end

function CollisionSystem:registerBulletManager(bulletManager)
	self.bulletManager = bulletManager
end

function CollisionSystem:registerEnemyManager(enemyManager)
	self.enemyManager = enemyManager
end

function CollisionSystem:checkCollisions(particleManager, gameState)
	-- Skip if any system is not registered
	if not self.player or not self.bulletManager or not self.enemyManager then
		return
	end

	-- Check player bullets vs enemies
	self:checkPlayerBulletsVsEnemies(particleManager, gameState)

	-- Check enemy bullets vs player
	self:checkEnemyBulletsVsPlayer(particleManager)

	-- Check enemies vs player
	self:checkEnemiesVsPlayer(particleManager)
end

function CollisionSystem:checkPlayerBulletsVsEnemies(particleManager, gameState)
	local playerBullets = self.bulletManager:getPlayerBullets()
	local enemies = self.enemyManager:getAllEnemies()

	for _, bullet in ipairs(playerBullets) do
		if bullet:isActive() then
			local bulletBox = bullet:getBoundingBox()

			for _, enemy in ipairs(enemies) do
				if enemy:isActive() then
					local enemyBox = enemy:getBoundingBox()

					if
						Helpers.checkCollision(
							bulletBox.x,
							bulletBox.y,
							bulletBox.width,
							bulletBox.height,
							enemyBox.x,
							enemyBox.y,
							enemyBox.width,
							enemyBox.height
						)
					then
						-- Apply damage to enemy
						enemy:takeDamage(bullet:getDamage())

						-- Deactivate bullet
						bullet:deactivate()

						-- Create hit particle effect
						particleManager:createHitEffect(bullet:getPosition().x, bullet:getPosition().y)

						-- Check if enemy was destroyed
						if not enemy:isActive() then
							-- Add score based on enemy type
							gameState:addScore(enemy:getScoreValue())

							-- Create explosion effect
							local pos = enemy:getPosition()
							particleManager:createExplosion(pos.x, pos.y, enemy:getType())

							-- Play explosion sound (only if assets exist)
							if self.assets and self.assets.sounds then
								print("Playing explosion sound")
								-- self.assets:playSound(self.assets.sounds.explosion)
							end
						end

						-- Break out of inner loop since bullet is now inactive
						break
					end
				end
			end
		end
	end
end

function CollisionSystem:checkEnemyBulletsVsPlayer(particleManager)
	if self.player:isDead() then
		return
	end

	local enemyBullets = self.bulletManager:getEnemyBullets()
	local playerBox = self.player:getBoundingBox()

	for _, bullet in ipairs(enemyBullets) do
		if bullet:isActive() then
			local bulletBox = bullet:getBoundingBox()

			if
				Helpers.checkCollision(
					bulletBox.x,
					bulletBox.y,
					bulletBox.width,
					bulletBox.height,
					playerBox.x,
					playerBox.y,
					playerBox.width,
					playerBox.height
				)
			then
				-- Apply damage to player
				self.player:takeDamage(bullet:getDamage())

				-- Deactivate bullet
				bullet:deactivate()

				-- Create hit particle effect
				particleManager:createHitEffect(bullet:getPosition().x, bullet:getPosition().y)

				-- If player destroyed, create explosion effect
				if self.player:isDead() then
					local pos = self.player:getPosition()
					particleManager:createExplosion(pos.x, pos.y, 3)
				end
			end
		end
	end
end

function CollisionSystem:checkEnemiesVsPlayer(particleManager)
	if self.player:isDead() then
		return
	end

	local enemies = self.enemyManager:getAllEnemies()
	local playerBox = self.player:getBoundingBox()

	for _, enemy in ipairs(enemies) do
		if enemy:isActive() then
			local enemyBox = enemy:getBoundingBox()

			if
				Helpers.checkCollision(
					enemyBox.x,
					enemyBox.y,
					enemyBox.width,
					enemyBox.height,
					playerBox.x,
					playerBox.y,
					playerBox.width,
					playerBox.height
				)
			then
				-- Apply damage to both player and enemy
				self.player:takeDamage(30)
				enemy:takeDamage(50)

				-- Create explosion effect
				local pos = enemy:getPosition()
				particleManager:createExplosion(pos.x, pos.y, enemy:getType())

				-- If player destroyed, create explosion effect
				if self.player:isDead() then
					local playerPos = self.player:getPosition()
					particleManager:createExplosion(playerPos.x, playerPos.y, 3)
				end
			end
		end
	end
end

return CollisionSystem
