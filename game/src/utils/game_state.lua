-- File: src/utils/game_state.lua
-- Manages the game state (menu, playing, game over)

local Class = require("lib.external.libraries.class")
local GameState = Class:extend()

-- Game states
local MENU = "menu"
local PLAYING = "playing"
local GAME_OVER = "game_over"

function GameState:init()
	self.currentState = MENU
	self.score = 0
	self.highScore = 0
end

function GameState:update(dt)
	-- State-specific update logic can be added here
end

function GameState:setMenu()
	self.currentState = MENU
end

function GameState:setPlaying()
	self.currentState = PLAYING
end

function GameState:setGameOver()
	self.currentState = GAME_OVER
	-- Update high score if current score is higher
	if self.score > self.highScore then
		self.highScore = self.score
	end
end

function GameState:isMenu()
	return self.currentState == MENU
end

function GameState:isPlaying()
	return self.currentState == PLAYING
end

function GameState:isGameOver()
	return self.currentState == GAME_OVER
end

function GameState:addScore(points)
	self.score = self.score + points
end

function GameState:getScore()
	return self.score
end

function GameState:getHighScore()
	return self.highScore
end

function GameState:resetScore()
	self.score = 0
end

function GameState:keypressed(key)
	-- Handle key presses based on game state
	-- This is a hook for key handling specific to game state
end

return GameState
