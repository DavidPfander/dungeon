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
--    speed = 10,
    speed = 100,
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

  --  enemy.actualY = util.moveWithSpeed(enemy.actualY, pixelY, player.speed, dt)
  --  enemy.actualX = util.moveWithSpeed(enemy.actualX, pixelX, player.speed, dt)
  --
  --  if math.abs(enemy.actualX - pixelX) < 2 and
  --    math.abs(enemy.actualY - pixelY) < 2 then
  --    enemy.actualY = pixelY
  --    enemy.actualX = pixelX
  --    return true
  --  else
  --    return false
  --  end
  --
  enemy.actualX, enemy.actualY = util.moveLinear(
    enemy.actualX, enemy.actualY,
    pixelX, pixelY, enemy.speed, dt)

  if enemy.actualX == pixelX and
    enemy.actualY == pixelY then
    enemy.actualY = pixelY
    enemy.actualX = pixelX
    return true
  else
    return false
  end
end

function enemies.turn(dt, enemy)

  local oldX, oldY = enemy.gridX, enemy.gridY
  local offset = math.random(0, 1)
  if offset == 0 then
    offset = -1
  end

  hasAnimation = false

  if util.checkPathVisible(player.gridX, player.gridY, enemy.gridX, enemy.gridY) then
    console.pushMessage(enemy.name .. " sees player")
    if util.getMoveDistance(enemy.gridX, enemy.gridY, player.gridX, player.gridY) > 1 then
      local found, pathX, pathY = util.tryFindNextOnPath(enemy.gridX, enemy.gridY, player.gridX, player.gridY)
      if found then
        maps.moveEnemy(enemy, pathX, pathY)
        animations.addMovement("enemy", enemy)
        screen = "animation"
        hasAnimation = true
      end
    else
      fights.playerDefend(enemy)
    end

  else

    if math.random() > 0.5 then
      if maps.testMove(map, enemy.gridX + offset, enemy.gridY) then
        maps.moveEnemy(enemy, enemy.gridX + offset, enemy.gridY)
        animations.addMovement("enemy", enemy)
        screen = "animation"
        hasAnimation = true
      end
    else
      if maps.testMove(map, enemy.gridX, enemy.gridY + offset) then
        maps.moveEnemy(enemy, enemy.gridX, enemy.gridY + offset)
        animations.addMovement("enemy", enemy)
        screen = "animation"
        hasAnimation = true
      end
    end
  end
  return hasAnimation
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

function enemies.placeEnemies(map)
  -- place goblins
  local enemiesPlaced = 0
  local enemyCount = enemiesOnLevel[level].goblinsOnLevel
  while enemiesPlaced < enemyCount do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if maps.testMove(map, enemyX, enemyY) and not maps.testEnemy(map, enemyX, enemyY) and not map[enemyX][enemyY].hasPlayer then
      local newEnemy = enemies.newGoblin(enemyX, enemyY)
      maps.registerEnemy(map, enemyX, enemyY, newEnemy)
      enemiesPlaced = enemiesPlaced + 1
    end
  end

  -- place dragons
  local enemiesPlaced = 0
  local enemyCount = enemiesOnLevel[level].dragonsOnLevel
  while enemiesPlaced < enemyCount do
    local enemyX = math.random(1, gridSizeX)
    local enemyY = math.random(1, gridSizeY)
    if maps.testMove(map, enemyX, enemyY) and not maps.testEnemy(map, enemyX, enemyY) and not map[enemyX][enemyY].hasPlayer then
      local newEnemy = enemies.newDragon(enemyX, enemyY)
      maps.registerEnemy(map, enemyX, enemyY, newEnemy)
      enemiesPlaced = enemiesPlaced + 1
    end
  end
end

function enemies.die(enemy, map)
  maps.removeEnemy(map, enemy.gridX, enemy.gridY, enemy)
  console.pushMessage(enemy.name .. " dies!")
end

return enemies
