require "figure"
require "adversary"

function love.load()
  --    player = {
  --        grid_x = 256,
  --        grid_y = 256,
  --        act_x = 200,
  --        act_y = 200,
  --        speed = 10
  --    }

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

  -- place player
  player = figure.new()

  -- place enemy
  enemyCount = 10
  gridSizeX = 13
  gridSizeY = 13
  enemies = adversary.placeEnemies(map, enemyCount, gridSizeX, gridSizeY)
end


function love.update(dt)
  figure.update(dt, player)
end

function love.draw()
  -- drawing all cells at same priority right now

  love.graphics.setColor(255, 255, 255)
  for y=1, #map do
    for x=1, #map[y] do
      if map[y][x] == 1 then
        love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
      end
    end
  end
  
  for i = 1, #enemies do
    adversary.draw(enemies[i])
  end
  
  figure.draw(player)
end

function love.keypressed(key)
  figure.keypressed(player, key, map)
end

function testMap(map, x, y)
--  print("printing map")
--  for i = 0, #map do
--    for j = 0, #map[i] do
--      print(map[i][j])
--    end
--  end
--  print (map[y])
  if map[y][x] == 1 then
    return false
  end
  return true
end

function registerEnemyMap(map, x, y)
  map[y][x] = 2
end
