require "players"
require "enemies"
require "maps"
require "table_save"
require "config"
require "console"
require "items"
require "menu"
require "statusbar"
require "inventories"

function love.load()

  items.buildItemLibrary()

  inventories.load()

  math.randomseed(os.time())
  hasPlayerPerformedAction = false
  gameEnded = false
  gameWon = false

  running = "menu" -- | "play" | "inventory

  menu.generateMainMenu()

end

function getEnemy(map, gridX, gridY)
  return map[gridX][gridY].monster
end

function love.update(dt)
  if running == "play" then
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
    console.update()
  else
    menu.mainMenu:update(dt)
  end
end

testCount = 0

function love.draw()
  if running == "play" or running == "inventory" then

    statusbar.draw()

    inventories.draw()

    maps.draw()

    for i = 1, #map do
      for j = 1, #map[i] do
        if map[i][j].monster ~= nil then
          enemies.draw(map[i][j].monster)
        end
      end
    end

    items.draw(map)

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
    console.draw()
  else
    menu.mainMenu:draw(10, 10)
  end
end

function love.keypressed(key)
  if running == "play" then
    if key == "escape" then
      running = "menu"
    elseif gameWon then
      return
    elseif key == "i" then  
      -- make "running" a string and use it to dispatch modes
      running = "inventory"
    elseif not hasPlayerPerformedAction then
      players.keypressed(key)
    end
  elseif running == "inventory" then
    inventories.keypressed(key)
  elseif running == "menu" then
    menu.mainMenu:keypressed(key)
  end
end
