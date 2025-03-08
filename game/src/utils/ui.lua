-- File: src/utils/ui.lua
-- User interface rendering

local Class = require("lib.external.libraries.class")
local Helpers = require("src.utils.helpers")
local UI = Class:extend()

function UI:init(assets, gameState)
	self.assets = assets
	self.gameState = gameState
end

function UI:update(dt)
	-- Update UI animations if needed
end

function UI:draw()
	-- Draw different UI based on game state
	if self.gameState:isMenu() then
		self:drawMenu()
	elseif self.gameState:isPlaying() then
		self:drawHUD()
	elseif self.gameState:isGameOver() then
		self:drawGameOver()
	end
end

function UI:drawMenu()
	-- Draw game title
	love.graphics.setFont(self.assets.fonts.huge)
	love.graphics.setColor(0, 0.7, 1, 1)
	love.graphics.print(
		"COSMIC DEFENDER",
		love.graphics.getWidth() / 2 - self.assets.fonts.huge:getWidth("COSMIC DEFENDER") / 2,
		150
	)

	-- Draw instructions
	love.graphics.setFont(self.assets.fonts.medium)
	love.graphics.setColor(1, 1, 1, 1)
	local instructions = "Press ENTER to start"
	love.graphics.print(
		instructions,
		love.graphics.getWidth() / 2 - self.assets.fonts.medium:getWidth(instructions) / 2,
		350
	)

	-- Draw controls
	love.graphics.setFont(self.assets.fonts.small)
	love.graphics.setColor(0.8, 0.8, 0.8, 1)
	local controls = "Controls: WASD/Arrow Keys to move, SPACE to shoot"
	love.graphics.print(controls, love.graphics.getWidth() / 2 - self.assets.fonts.small:getWidth(controls) / 2, 450)
end

function UI:drawHUD()
	-- Draw score
	love.graphics.setFont(self.assets.fonts.medium)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.print("SCORE: " .. Helpers.formatScore(self.gameState:getScore()), 20, 20)
end

function UI:drawGameOver()
	-- Draw game over screen
	love.graphics.setFont(self.assets.fonts.large)
	love.graphics.setColor(1, 0.3, 0.3, 1)
	local gameOverText = "GAME OVER"
	love.graphics.print(
		gameOverText,
		love.graphics.getWidth() / 2 - self.assets.fonts.large:getWidth(gameOverText) / 2,
		150
	)

	-- Draw final score
	love.graphics.setFont(self.assets.fonts.medium)
	love.graphics.setColor(1, 1, 1, 1)
	local scoreText = "SCORE: " .. Helpers.formatScore(self.gameState:getScore())
	love.graphics.print(scoreText, love.graphics.getWidth() / 2 - self.assets.fonts.medium:getWidth(scoreText) / 2, 250)

	-- Draw high score
	local highScoreText = "HIGH SCORE: " .. Helpers.formatScore(self.gameState:getHighScore())
	love.graphics.print(
		highScoreText,
		love.graphics.getWidth() / 2 - self.assets.fonts.medium:getWidth(highScoreText) / 2,
		300
	)

	-- Draw restart instructions
	love.graphics.setFont(self.assets.fonts.small)
	love.graphics.setColor(0.8, 0.8, 0.8, 1)
	local instructions = "Press ENTER to return to menu"
	love.graphics.print(
		instructions,
		love.graphics.getWidth() / 2 - self.assets.fonts.small:getWidth(instructions) / 2,
		400
	)
end

return UI
