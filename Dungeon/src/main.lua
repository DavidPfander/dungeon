require "players"
require "enemies"
require "maps"
require "table_save"
require "config"

function love.load()

  math.randomseed(os.time())
  hasPlayerPerformedAction = false
  gameWon = false
  dungeon = {}
  for clevel=1,dungeonDepth do
    level = clevel
    dungeon[clevel] = maps.generate(gridSizeX, gridSizeY)
  end

  map = dungeon[1]
  level = 1
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
    players.update(dt)
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
  maps.draw()

  for i = 1, #enemyList do
    enemies.draw(enemyList[i])
  end

  players.draw()

  if gameWon then
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print('You win!!', 400, 300)
  elseif moveDown then
    love.graphics.setColor(200,200,200)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print("Deeper into darkness...", 400, 300)
  elseif moveUp then
    love.graphics.setColor(200,200,200)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print("Out of this hellhole...", 400, 300)
  end
end

function love.keypressed(key)
  if gameWon then
    return
  end

  if not hasPlayerPerformedAction then
    players.keypressed(key)
  end
end
