require "util"
require "maps"

local P = {}
adversary = P

function adversary.new(gridX, gridY)
  pixelX, pixelY = util.getPixelLocation(gridX, gridY)
  local newadversary = {
    gridX = gridX,
    gridY = gridY,
    actualX = pixelX,
    actualY = pixelY,
    speed = 10,
    lastActionTime = love.timer.getTime()
  }
  return newadversary
end

function adversary.update(dt, map, enemy)
  -- move every dt > epsilon
  -- also check for actualX == pixelX
  local currentTime = love.timer.getTime()
  local oldX, oldY = enemy.gridX, enemy.gridY
  if currentTime - enemy.lastActionTime >= 1.0 then
    offset = math.random(0, 1)
    if offset == 0 then
      offset = -1
    end
    if math.random() > 0.5 then
      if maps.testMap(map, enemy.gridX + offset, enemy.gridY) then
        enemy.gridX = enemy.gridX + offset
        enemy.lastActionTime = currentTime
        maps.moveEnemyMap(map, oldX, oldY, enemy.gridX, enemy.gridY, enemy)
      end
    else
      if maps.testMap(map, enemy.gridX, enemy.gridY + offset) then
        enemy.gridY = enemy.gridY + offset
        enemy.lastActionTime = currentTime
        maps.moveEnemyMap(map, oldX, oldY, enemy.gridX, enemy.gridY, enemy)
      end
    end
    
  end

  local pixelX, pixelY = util.getPixelLocation(enemy.gridX, enemy.gridY)
  enemy.actualY = enemy.actualY - ((enemy.actualY - pixelY) * enemy.speed * dt)
  enemy.actualX = enemy.actualX - ((enemy.actualX - pixelX) * enemy.speed * dt)
end

function adversary.draw(enemy)
  -- local pixelX, pixelY = util.getPixelLocation(enemy.gridX, enemy.gridY)
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", enemy.actualX, enemy.actualY, util.pixelPerCellX, util.pixelPerCellY)
  -- love.graphics.setColor(oldColor)
end

function adversary.placeEnemies(map, enemyCount, gridSizeX, gridSizeY)
  local enemies = {}
  local enemiesPlaced = 0
  while enemiesPlaced < 10 do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if (maps.testMap(map, enemyX, enemyY)) then
      local newEnemy = adversary.new(enemyX, enemyY)
      enemies[#enemies + 1] = newEnemy
      maps.registerEnemyMap(map, enemyX, enemyY, newEnemy)
      enemiesPlaced = enemiesPlaced + 1
    end
  end
  return enemies
end

return adversary
