require "players"
require "enemies"
require "maps"
require "table_save"
require "config"

function love.load()

  math.randomseed(os.time())
  hasPlayerPerformedAction = false
  gameEnded = false
  gameWon = false
  dungeon = {}
  for clevel=1,dungeonDepth do
    level = clevel
    dungeon[clevel] = maps.generate(gridSizeX, gridSizeY)
  end

  map = dungeon[1]
  level = 1
  enemies.placeEnemies(map, enemyCount, gridSizeX, gridSizeY)
end

function getEnemy(map, gridX, gridY)
  return map[gridX][gridY].monster
end

function love.update(dt)
  if enemyCount == 0 then
    gameWon = true
  else
    players.update(dt)
    -- animate the enemies
    for i = 1, #map do
      for j = 1, #map[i] do
        if map[i][j].monster ~= nil then
          enemies.update(dt, map, map[i][j].monster)
        end
      end
    end

    if hasPlayerPerformedAction then
      -- after the players has moved, it's the enemies turn
      for i = 1, #map do
        for j = 1, #map[i] do
          if map[i][j].monster ~= nil then
            enemies.turn(dt, map, map[i][j].monster)
          end
        end
      end
      hasPlayerPerformedAction = false
    end
  end
end

function love.draw()
  maps.draw()

  for i = 1, #map do
    for j = 1, #map[i] do
      if map[i][j].monster ~= nil then
        enemies.draw(map[i][j].monster)
      end
    end
  end

  players.draw()

  if gameEnded then
    love.graphics.setFont(love.graphics.newFont(40))
    if gameWon then
      love.graphics.print('You win!!', 400, 300)
    else
      love.graphics.print('You lost!!', 400, 300)
    end
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
