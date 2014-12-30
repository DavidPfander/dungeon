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
require "effects"

-- TODO order action for effects

function love.load()

  items.buildItemLibrary()

  inventories.load()
  
  effects.load()

  math.randomseed(os.time())
  hasPlayerPerformedAction = false
  gameEnded = false
  gameWon = false
  gameUpdateFrequency = 1.0 / 60.0
  disableEnemyTurn = false

  running = "menu" -- | "play" | "inventory" | "aim" | "effect"

  menu.generateMainMenu()

end

function getEnemy(map, gridX, gridY)
  return map[gridX][gridY].monster
end

function love.update(dt)
  local startTimer = love.timer.getTime()
  if running == "play" then
    if enemyCount == 0 then
      gameWon = true
    else
      players.update(dt)

      if not disableEnemyTurn then
        for i = 1, #map do
          for j = 1, #map[i] do
            if map[i][j].monster ~= nil then
              enemies.update(dt, map, map[i][j].monster)
            end
          end
        end
      end
    end
    console.update()
    effects.update(dt)
  else
    menu.mainMenu:update(dt)
  end
  local stopTimer = love.timer.getTime()
  local sleepTime = math.max(0, gameUpdateFrequency - (stopTimer - startTimer))
  love.timer.sleep(sleepTime)
end

testCount = 0

function love.draw()

  -- love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

  if running == "play" or running == "inventory" or running == "aim" then

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
    
    effects.draw()

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
    else
      players.keypressed(key)

      -- after the players has moved, it's the enemies turn
      actionPerformed = {}
      for i = 1, #map do
        for j = 1, #map[i] do
          if map[i][j].monster ~= nil then
            local enemy = map[i][j].monster
            if actionPerformed[enemy] == nil then
              enemies.turn(dt, enemy)
              -- so that the enemy doesn't get another turn should he move in the
              -- direction of the iteration
              actionPerformed[enemy] = true
            end
          end
        end
      end
    end
  elseif running == "inventory" then
    inventories.keypressed(key)
  elseif running == "menu" then
    menu.mainMenu:keypressed(key)
  elseif running == "aim" then
    players.aim(key)
  end
end
