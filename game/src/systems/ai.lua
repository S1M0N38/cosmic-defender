-- File: src/systems/ai.lua
-- Artificial intelligence system for enemies

local Class = require("lib.external.libraries.class")
local Vector = require("src.utils.vector")
local AI = Class:extend()

function AI:init()
	-- AI behavior configuration
	self.aggressiveness = 0.5
	self.difficulty = 1.0
end

function AI:setAggressiveness(value)
	self.aggressiveness = value
end

function AI:setDifficulty(value)
	self.difficulty = value
end

function AI:calculateBehavior(enemy, player)
	-- Skip if player is nil
	if not player then
		return { moveDirection = Vector:new(0, 1), shouldShoot = false }
	end

	local enemyPos = enemy:getPosition()
	local playerPos = player:getPosition()

	-- Calculate direction to player
	local direction = Vector:new(playerPos.x - enemyPos.x, playerPos.y - enemyPos.y)
	local distance = direction:magnitude()
	direction = direction:normalize()

	-- Adjust direction based on enemy type and AI settings
	local moveDirection = Vector:new(0, 0)
	local shouldShoot = false

	-- Different behavior based on enemy type
	local enemyType = enemy:getType()

	if enemyType == 1 then
		-- Small enemies move more erratically
		moveDirection.x = direction.x * 0.5 + math.sin(love.timer.getTime() * 3) * 0.5
		moveDirection.y = 0.8 -- Always move downward
		shouldShoot = distance < 200 and math.random() < 0.7 * self.difficulty
	elseif enemyType == 2 then
		-- Medium enemies try to line up with the player
		moveDirection.x = direction.x * 0.8
		moveDirection.y = 0.5
		shouldShoot = distance < 300 and math.random() < 0.5 * self.difficulty
	else
		-- Large enemies move slowly but are very aggressive
		moveDirection.x = direction.x * 0.3
		moveDirection.y = 0.3
		shouldShoot = distance < 400 and math.random() < 0.3 * self.difficulty
	end

	-- Adjust behavior based on aggressiveness
	moveDirection.y = moveDirection.y * (2 - self.aggressiveness)
	shouldShoot = shouldShoot or (math.random() < 0.05 * self.aggressiveness * self.difficulty)

	return {
		moveDirection = moveDirection,
		shouldShoot = shouldShoot,
	}
end

return AI
