require "figure"
require "adversary"
require "maps"

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
  -- drawing all cells at same priority right now
  love.graphics.setColor(255, 255, 255)
  for y=1, #map do
    for x=1, #map[y] do
      if map[x][y] == 1 then
        love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
      end
    end
  end
  
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

function testMap(map, x, y)
  if map[x][y] == 1 then
    return false
  end
  return true
end

function registerEnemyMap(map, x, y)
  map[x][y] = 2
end

function moveEnemyMap(map, oldX, oldY, x, y)
  map[oldX][oldY] = 0
  map[x][y] = 2
end

function enemyHitMap(map, x, y)
  if map[x][y] == 2 then
    return true
  else
    return false
  end
end
