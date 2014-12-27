require "config"
require "figure"
require "adversary"
require "maps"
require "table_save"


function love.load()
--  dungeon = {}
  
--  dungeon[1] = maps.generateMap(gridSizeX,gridSizeY)
  
  map = maps.generateMap(gridSizeX,gridSizeY)
  
  gameWon = false

  enemies = adversary.placeEnemies(map, enemyCount, gridSizeX, gridSizeY)
end

function removeEnemy(gridX, gridY)
  for i = 1, #enemies do
    local enemy = enemies[i]
    if enemy.gridX == gridX and enemy.gridY == gridY then
      table.remove(enemies, i)
      enemyCount = enemyCount - 1
      break
    end
  end
end

function love.update(dt)
  if enemyCount == 0 then
    gameWon = true
  else
    figure.update(dt, player)
    for i = 1, #enemies do
      adversary.update(dt, map, enemies[i])
    end
  end
end

function love.draw()
  maps.draw(map, vision)
  
  for i = 1, #enemies do
    adversary.draw(enemies[i])
  end

  figure.draw(player)

  if gameWon then
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print('You win!!', 400, 300)
  end
end

function love.keypressed(key)
  if gameWon then
    return
  end
  figure.keypressed(player, key, map)
end
