require "players"
require "enemies"
require "maps"
require "table_save"


function love.load()
  --    player = {
  --        grid_x = 256,
  --        grid_y = 256,
  --        act_x = 200,
  --        act_y = 200,
  --        speed = 10
  --    }


  -- place enemy
  enemyCount = 10
  gridSizeX = 16
  gridSizeY = 16

  hasPlayerPerformedAction = false

  map = {
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
    { 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
    { 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1 },
    { 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1 },
    { 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
  }

  -- map = table.load("test.map")

  map = maps.generateMap(gridSizeX,gridSizeY)

  table.save( map, "test.map")

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
  -- drawing all cells at same priority right now
  love.graphics.setColor(255, 255, 255)
  for y=1, #map do
    for x=1, #map[y] do
      if map[x][y].type == "wall" then
        love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
      end
    end
  end

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
