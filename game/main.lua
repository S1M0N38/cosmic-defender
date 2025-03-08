-- File: main.lua
-- Main entry point for the Cosmic Defender game

-- Import required modules
local Player = require("src.entities.player")
local EnemyManager = require("src.entities.enemy_manager")
local BulletManager = require("src.entities.bullet_manager")
local CollisionSystem = require("src.systems.collision")
local ParticleManager = require("src.systems.particles.manager")
local GameState = require("src.utils.game_state")
local Camera = require("src.utils.camera")
local Stars = require("src.utils.stars")
local Assets = require("src.utils.assets")
local UI = require("src.utils.ui")

-- Global game variables
local player
local enemyManager
local bulletManager
local collisionSystem
local particleManager
local gameState
local camera
local stars
local assets
local ui

function love.load()
	-- Set default filter mode
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- Initialize random seed
	math.randomseed(os.time())

	-- Load assets (images, sounds, fonts)
	assets = Assets:new()
	assets:load()

	-- Initialize game components
	camera = Camera:new()
	stars = Stars:new(200)
	gameState = GameState:new()
	ui = UI:new(assets, gameState)

	-- Initialize game systems
	particleManager = ParticleManager:new(assets)
	collisionSystem = CollisionSystem:new()

	-- Initialize game entities
	player = Player:new(400, 550, assets)
	bulletManager = BulletManager:new(assets)
	enemyManager = EnemyManager:new(assets, bulletManager)

	-- Register entities with collision system
	collisionSystem:registerPlayer(player)
	collisionSystem:registerBulletManager(bulletManager)
	collisionSystem:registerEnemyManager(enemyManager)
end

function love.update(dt)
	-- Update based on game state
	if gameState:isPlaying() then
		-- Update game components
		camera:update(dt)
		stars:update(dt)

		-- Update game entities
		player:update(dt, bulletManager)
		bulletManager:update(dt)
		enemyManager:update(dt, player)

		-- Check collisions
		collisionSystem:checkCollisions(particleManager, gameState)

		-- Update particle effects
		particleManager:update(dt, player)

		-- Check for game over condition
		if player:isDead() then
			gameState:setGameOver()
		end
	end

	-- Update UI
	ui:update(dt)
end

function love.draw()
	-- Apply camera transformations
	camera:apply()

	-- Draw background
	stars:draw()

	-- Draw game entities if playing or game over
	if gameState:isPlaying() or gameState:isGameOver() then
		bulletManager:draw()
		enemyManager:draw()
		player:draw()
		particleManager:draw()
	end

	-- Reset camera for UI elements
	camera:reset()

	-- Draw UI elements
	ui:draw()
end

function love.keypressed(key)
	-- Global key handling
	if key == "escape" then
		love.event.quit()
	end

	-- Pass key press to game state
	gameState:keypressed(key)

	-- Handle key press based on game state
	if gameState:isMenu() and key == "return" then
		gameState:setPlaying()
		resetGame()
	elseif gameState:isGameOver() and key == "return" then
		gameState:setMenu()
	end
end

function resetGame()
	-- Reset game entities and state
	player:reset(400, 550)
	bulletManager:reset()
	enemyManager:reset()
	particleManager:reset()
	gameState:resetScore()
end
