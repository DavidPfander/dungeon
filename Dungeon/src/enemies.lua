require "util"
require "maps"
require "console"

local P = {}
enemies = P

function enemies.newGoblin(gridX, gridY)
  pixelX, pixelY = util.getPixelLocation(gridX, gridY)
  local newenemies = {
    gridX = gridX,
    gridY = gridY,
    actualX = pixelX,
    actualY = pixelY,
    speed = 10,
    health = 100,
    damage = 5,
    name = "goblin",
    picture = "goblin.png"
  }
  return newenemies
end

function enemies.newDragon(gridX, gridY)
  pixelX, pixelY = util.getPixelLocation(gridX, gridY)
  local newenemies = {
    gridX = gridX,
    gridY = gridY,
    actualX = pixelX,
    actualY = pixelY,
    speed = 10,
    health = 500,
    damage = 50,
    name = "dragon",
    picture = "golden_dragon.png"
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
  local offset = math.random(0, 1)
  if offset == 0 then
    offset = -1
  end
  if math.random() > 0.5 then
    if maps.test(map, enemy.gridX + offset, enemy.gridY) and not map[enemy.gridX + offset][enemy.gridY].hasPlayer then
      enemy.gridX = enemy.gridX + offset
      maps.moveEnemy(map, oldX, oldY, enemy.gridX, enemy.gridY, enemy)
    end
  else
    if maps.test(map, enemy.gridX, enemy.gridY + offset) and not map[enemy.gridX][enemy.gridY + offset].hasPlayer then
      enemy.gridY = enemy.gridY + offset
      maps.moveEnemy(map, oldX, oldY, enemy.gridX, enemy.gridY, enemy)
    end
  end
end

function enemies.draw(enemy)
  -- local pixelX, pixelY = util.getPixelLocation(enemy.gridX, enemy.gridY)
  -- print(enemy)
  -- print(enemy.gridX)
  -- love.graphics.rectangle("line", )

  if math.abs(player.gridX - enemy.gridX) > vision or math.abs(player.gridY - enemy.gridY) > vision then
    return
  end

  local lighting = util.getEnemyLighting(enemy.gridX, enemy.gridY)

  love.graphics.setColor(lighting, lighting, lighting)
  -- love.graphics.setColor(255, 255, 255)
  --love.graphics.setColor(255, 0, 0)
  -- love.graphics.rectangle("fill", enemy.actualX, enemy.actualY, util.pixelPerCellX, util.pixelPerCellY)
  local goblinImage = love.graphics.newImage(enemy.picture)
  -- local pixelX, pixelY = util.getPixelLocation(enemy.gridX, enemy.gridY)
  -- love.graphics.draw(goblinImage, pixelX, pixelY, 0, 1, 1, 0, 0)
  love.graphics.draw(goblinImage, enemy.actualX, enemy.actualY)
  -- love.graphics.setColor(oldColor)
end

function enemies.placeEnemies(map, gridSizeX, gridSizeY)
  -- place goblins
  local enemiesPlaced = 0
  local enemyCount = enemiesOnLevel[level].goblinsOnLevel
  while enemiesPlaced < enemyCount do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if maps.test(map, enemyX, enemyY) and not maps.testEnemy(map, enemyX, enemyY) and not map[enemyX][enemyY].hasPlayer then
      local newEnemy = enemies.newGoblin(enemyX, enemyY)
      maps.registerEnemy(map, enemyX, enemyY, newEnemy)
      enemiesPlaced = enemiesPlaced + 1
    end
  end

  -- place dragons
  local enemiesPlaced = 0
    local enemyCount = enemiesOnLevel[level].dragonsOnLevel
  while enemiesPlaced < 1 do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if maps.test(map, enemyX, enemyY) and not maps.testEnemy(map, enemyX, enemyY) and not map[enemyX][enemyY].hasPlayer then
      local newEnemy = enemies.newDragon(enemyX, enemyY)
      maps.registerEnemy(map, enemyX, enemyY, newEnemy)
      enemiesPlaced = enemiesPlaced + 1
    end
  end
end

function enemies.die(enemy, map)
  maps.removeEnemy(map, enemy.gridX, enemy.gridY, enemy)
  enemyCount = enemyCount - 1
  console.pushMessage(enemy.name .. " dies!")
end

return enemies
