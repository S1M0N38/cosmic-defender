-- File: src/entities/enemy_manager.lua
-- Manages all enemies in the game

local Class = require("lib.external.libraries.class")
local Enemy = require("src.entities.enemy")
local Helpers = require("src.utils.helpers")
local Timer = require("lib.external.libraries.timer")
local EnemyManager = Class:extend()

function EnemyManager:init(assets, bulletManager)
	self.enemies = {}
	self.assets = assets
	self.bulletManager = bulletManager

	-- Spawn management
	self.timer = Timer:new()
	self.spawnRate = 1.5
	self.difficultyTimer = 0
	self.difficultyInterval = 10
	self.waveSize = 3
	self.maxEnemies = 10

	-- Start spawning
	self:startSpawning()
end

function EnemyManager:update(dt, player)
	-- Update all enemies
	for i = #self.enemies, 1, -1 do
		local enemy = self.enemies[i]
		enemy:update(dt, player, self.bulletManager)

		-- Remove inactive enemies
		if not enemy:isActive() then
			table.remove(self.enemies, i)
		end
	end

	-- Update timer
	self.timer:update(dt)

	-- Update difficulty
	self.difficultyTimer = self.difficultyTimer + dt
	if self.difficultyTimer >= self.difficultyInterval then
		self:increaseDifficulty()
		self.difficultyTimer = 0
	end
end

function EnemyManager:draw()
	for _, enemy in ipairs(self.enemies) do
		enemy:draw()
	end
end

function EnemyManager:createEnemy(x, y, type)
	local enemy = Enemy:new(x, y, type, self.assets)
	table.insert(self.enemies, enemy)
	return enemy
end

function EnemyManager:startSpawning()
	-- Clear any existing timer
	self.timer:clear()

	-- Start spawning enemies regularly
	self.timer:every(self.spawnRate, function()
		self:spawnWave()
	end)
end

function EnemyManager:spawnWave()
	-- Skip if at max enemies
	if #self.enemies >= self.maxEnemies then
		return
	end

	-- Spawn a wave of enemies
	for i = 1, self.waveSize do
		-- Skip if at max enemies
		if #self.enemies >= self.maxEnemies then
			break
		end

		-- Determine spawn position
		local x = Helpers.random(50, love.graphics.getWidth() - 50)
		local y = -50 - i * 30

		-- Determine enemy type (weighted random)
		local rand = math.random()
		local type
		if rand < 0.6 then
			type = 1 -- Common small enemy
		elseif rand < 0.9 then
			type = 2 -- Medium enemy
		else
			type = 3 -- Rare large enemy
		end

		-- Create the enemy
		self:createEnemy(x, y, type)
	end
end

function EnemyManager:increaseDifficulty()
	-- Make game harder over time
	self.spawnRate = math.max(0.5, self.spawnRate * 0.9)
	self.waveSize = math.min(6, self.waveSize + 1)
	self.maxEnemies = math.min(20, self.maxEnemies + 2)

	-- Restart spawning with new rates
	self:startSpawning()
end

function EnemyManager:getAllEnemies()
	return self.enemies
end

function EnemyManager:reset()
	self.enemies = {}
	self.spawnRate = 1.5
	self.difficultyTimer = 0
	self.waveSize = 3
	self.maxEnemies = 10
	self:startSpawning()
end

return EnemyManager
