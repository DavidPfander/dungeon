require "util"

local P = {}
adversary = P

function adversary.new(gridX, gridY)
  pixelX, pixelY = util.getPixelLocation(gridX, gridY)
  local newadversary = {
    gridX = gridX,
    gridY = gridY,
    actualX = pixelX,
    actualY = pixelY,
    speed = 10
  }
  return newadversary
end

function adversary.update(dt, player)
  -- move every dt > epsilon
  -- also check for actualX == pixelX
  -- TODO
  
  local pixelX, pixelY = util.getPixelLocation(player.gridX, player.gridY)
  player.actualY = player.actualY - ((player.actualY - pixelY) * player.speed * dt)
  player.actualX = player.actualX - ((player.actualX - pixelX) * player.speed * dt)
end

function adversary.draw(player)
  local pixelX, pixelY = util.getPixelLocation(player.gridX, player.gridY)
  oldColor = love.graphics.getColor()
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("fill", pixelX, pixelY, util.pixelPerCellX, util.pixelPerCellY)
  -- love.graphics.setColor(oldColor)
end

function adversary.placeEnemies(map, enemyCount, gridSizeX, gridSizeY) 
  local enemies = {}
  local enemiesPlaced = 0
  while enemiesPlaced < 10 do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if (testMap(map, enemyX, enemyY)) then
      enemies[#enemies + 1] = adversary.new(enemyX, enemyY)
      registerEnemyMap(map, enemyX, enemyY)
      enemiesPlaced = enemiesPlaced + 1
    end
  end
  return enemies
end

return adversary
