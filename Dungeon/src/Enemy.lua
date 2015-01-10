require "util"
require "console"
require "config"

Enemy = {}
Enemy.__index = Enemy

local goblinImage = love.graphics.newImage("goblin.png")
local dragonImage = love.graphics.newImage("golden_dragon.png")

function Enemy.newGoblin(gridX, gridY)
  local self = setmetatable({}, Enemy)
  local pixelX, pixelY = util.getPixelLocation(gridX, gridY)

  self.gridX = gridX
  self.gridY = gridY
  self.actualX = pixelX
  self.actualY = pixelY
  self.speed = 100
  self.health = 100
  self.damage = 5
  self.name = "goblin"
  self.image = goblinImage

  return self
end

function Enemy.newDragon(gridX, gridY)
  local self = setmetatable({}, Enemy)
  local pixelX, pixelY = util.getPixelLocation(gridX, gridY)

  self.gridX = gridX
  self.gridY = gridY
  self.actualX = pixelX
  self.actualY = pixelY
  self.speed = 100
  self.health = 500
  self.damage = 50
  self.name = "dragon"
  self.image = dragonImage

  return newEnemy
end


function Enemy.update(self, dt)
  local pixelX, pixelY = util.getPixelLocation(self.gridX, self.gridY)

  self.actualX, self.actualY = util.moveLinear(
    self.actualX, self.actualY,
    pixelX, pixelY, self.speed, dt)

  if self.actualX == pixelX and
    self.actualY == pixelY then
    self.actualY = pixelY
    self.actualX = pixelX
    return true
  else
    return false
  end
end

function Enemy.turn(self, dt)

  local oldX, oldY = self.gridX, self.gridY
  local offset = math.random(0, 1)
  if offset == 0 then
    offset = -1
  end

  hasAnimation = false

  if util.checkPathVisible(player.gridX, player.gridY, self.gridX, self.gridY) then
    console.pushMessage(self.name .. " sees player")
    if util.getMoveDistance(self.gridX, self.gridY, player.gridX, player.gridY) > 1 then
      local found, pathX, pathY = util.tryFindNextOnPath(self.gridX, self.gridY, player.gridX, player.gridY)
      if found then
        maps.moveEnemy(self, pathX, pathY)
        animations.addMovement("enemy", self)
        hasAnimation = true
      end
    else
      fights.playerDefend(self)
    end

  else

    if math.random() > 0.5 then
      if maps.testMove(map, self.gridX + offset, self.gridY) then
        maps.moveEnemy(self, self.gridX + offset, self.gridY)
        animations.addMovement("enemy", self)
        hasAnimation = true
      end
    else
      if maps.testMove(map, self.gridX, self.gridY + offset) then
        maps.moveEnemy(self, self.gridX, self.gridY + offset)
        animations.addMovement("enemy", self)
        hasAnimation = true
      end
    end
  end
  return hasAnimation
end

function Enemy.draw(self)
  if math.abs(player.gridX - self.gridX) > vision or math.abs(player.gridY - self.gridY) > vision then
    return
  end

  local lighting = util.getEnemyLighting(self.gridX, self.gridY)

  love.graphics.setColor(lighting, lighting, lighting)
  -- love.graphics.setColor(255, 255, 255)
  --love.graphics.setColor(255, 0, 0)
  -- love.graphics.rectangle("fill", enemy.actualX, enemy.actualY, util.pixelPerCellX, util.pixelPerCellY)
  -- local pixelX, pixelY = util.getPixelLocation(enemy.gridX, enemy.gridY)
  -- love.graphics.draw(goblinImage, pixelX, pixelY, 0, 1, 1, 0, 0)
  love.graphics.draw(self.image, self.actualX, self.actualY)
  -- love.graphics.setColor(oldColor)
end

function Enemy.placeEnemies()
  -- place goblins
  local EnemyPlaced = 0
  local enemyCount = enemiesOnLevel[level].goblinsOnLevel
  while EnemyPlaced < enemyCount do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if maps.testMove(enemyX, enemyY) and not maps.testEnemy(enemyX, enemyY) and not maps.testPlayer(enemyX, enemyY) then
      local newEnemy = Enemy.newGoblin(enemyX, enemyY)
      maps.registerEnemy(enemyX, enemyY, newEnemy)
      EnemyPlaced = EnemyPlaced + 1
    end
  end

  -- place dragons
  local EnemyPlaced = 0
  local enemyCount = enemiesOnLevel[level].dragonsOnLevel
  while EnemyPlaced < enemyCount do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if maps.testMove(map, enemyX, enemyY) and not maps.testEnemy(map, enemyX, enemyY) and not map[enemyX][enemyY].hasPlayer then
      local newEnemy = Enemy.newDragon(enemyX, enemyY)
      maps.registerEnemy(map, enemyX, enemyY, newEnemy)
      EnemyPlaced = EnemyPlaced + 1
    end
  end
end

function Enemy.die(self, map)
  maps.removeEnemy(map, self.gridX, self.gridY, self)
  console.pushMessage(self.name .. " dies!")
end

return Enemy
