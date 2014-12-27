require "players"
require "enemies"
require "maps"
require "table_save"


function love.load()
  hasPlayerPerformedAction = false
  map = maps.generateMap(gridSizeX,gridSizeY)

  gameWon = false

  enemyList = enemies.placeEnemies(map, enemyCount, gridSizeX, gridSizeY)
end

function removeEnemy(gridX, gridY)
  for i = 1, #enemyList do
    local enemy = enemyList[i]
    if enemy.gridX == gridX and enemy.gridY == gridY then
      table.remove(enemyList, i)
      enemyCount = enemyCount - 1
      break
    end
  end
end

function love.update(dt)
  if enemyCount == 0 then
    gameWon = true
  else
    players.update(dt, player)
    -- animate the enemies
    for i = 1, #enemyList do
      enemies.update(dt, map, enemyList[i])
    end
    if hasPlayerPerformedAction then
      -- after the players has moved, it's the enemies turn
      for i = 1, #enemyList do
        enemies.turn(dt, map, enemyList[i])
      end
      hasPlayerPerformedAction = false
    end
  end
end

function love.draw()
  maps.draw(map, vision)

  for i = 1, #enemyList do
    enemies.draw(enemyList[i])
  end

  players.draw(player)

  if gameWon then
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print('You win!!', 400, 300)
  end
end

function love.keypressed(key)
  if gameWon then
    return
  end

  if not hasPlayerPerformedAction then
    players.keypressed(player, key, map)
  end
end
