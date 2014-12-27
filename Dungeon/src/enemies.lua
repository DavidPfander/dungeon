require "util"
require "maps"

local P = {}
enemies = P

function enemies.new(gridX, gridY)
  pixelX, pixelY = util.getPixelLocation(gridX, gridY)
  local newenemies = {
    gridX = gridX,
    gridY = gridY,
    actualX = pixelX,
    actualY = pixelY,
    speed = 10,
    lastActionTime = love.timer.getTime()
  }
  return newenemies
end

function enemies.update(dt, map, enemy)
  local pixelX, pixelY = util.getPixelLocation(enemy.gridX, enemy.gridY)
  enemy.actualY = enemy.actualY - ((enemy.actualY - pixelY) * enemy.speed * dt)
  enemy.actualX = enemy.actualX - ((enemy.actualX - pixelX) * enemy.speed * dt)
end

function enemies.turn(dt, map, enemy)
  local oldX, oldY = enemy.gridX, enemy.gridY
  offset = math.random(0, 1)
  if offset == 0 then
    offset = -1
  end
  if math.random() > 0.5 then
    if maps.test(map, enemy.gridX + offset, enemy.gridY) then
      enemy.gridX = enemy.gridX + offset
      enemy.lastActionTime = currentTime
      maps.moveEnemy(map, oldX, oldY, enemy.gridX, enemy.gridY, enemy)
    end
  else
    if maps.test(map, enemy.gridX, enemy.gridY + offset) then
      enemy.gridY = enemy.gridY + offset
      enemy.lastActionTime = currentTime
      maps.moveEnemy(map, oldX, oldY, enemy.gridX, enemy.gridY, enemy)
    end
  end

end

function enemies.draw(enemy)
  -- local pixelX, pixelY = util.getPixelLocation(enemy.gridX, enemy.gridY)
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", enemy.actualX, enemy.actualY, util.pixelPerCellX, util.pixelPerCellY)
  -- love.graphics.setColor(oldColor)
end

function enemies.placeEnemies(map, enemyCount, gridSizeX, gridSizeY)
  local enemyList = {}
  local enemiesPlaced = 0
  while enemiesPlaced < enemyCount do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if (maps.test(map, enemyX, enemyY)) then
      local newEnemy = enemies.new(enemyX, enemyY)
      enemyList[#enemyList + 1] = newEnemy
      maps.registerEnemy(map, enemyX, enemyY, newEnemy)
      enemiesPlaced = enemiesPlaced + 1
    end
  end
  return enemyList
end

return enemies
