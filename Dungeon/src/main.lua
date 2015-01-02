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
require "animations"

-- TODO order action for effects

function love.load()

  items.buildItemLibrary()

  inventories.load()

  animations.load()

  math.randomseed(os.time())
  hasPlayerPerformedAction = false
  gameEnded = false
  gameWon = false
  -- gameUpdateFrequency = 1.0 / 60.0
  -- disableEnemyTurn = false

  -- turn: action -> animations -> enemy -> animations -> enemy -> animations ... -> finish -> action ..
  turnStates = {ACTION = "action", ENEMY = "enemy"}
  turnState = turnStates.ACTION

  screen = "menu" -- | "play" | "inventory" | "aim" | "animation"

  menu.generateMainMenu()

  turn = 1

end

function getEnemy(map, gridX, gridY)
  return map[gridX][gridY].monster
end

function love.update(dt)
  print("dt: " .. dt)
  -- local startTimer = love.timer.getTime()
  if screen == "play" then
    if turnState == turnStates.ENEMY then
      allEnemiesProcessed = processEnemies()
      if allEnemiesProcessed then
        turnState = turnStates.ACTION
        actionPerformed = {}
      end
    end

  elseif screen == "animation" then
    animations.update(dt)
  elseif screen == "menu" then
    menu.mainMenu:update(dt)
  end
  -- local stopTimer = love.timer.getTime()
  -- local sleepTime = math.max(0, gameUpdateFrequency - (stopTimer - startTimer))
  -- love.timer.sleep(sleepTime)
end

-- player
-- player effect
-- updates only after effects
-- player ememies
-- player enemy effects
-- updates only after effects

actionPerformed = {}

function processEnemies()
  -- after the players has moved, it's the enemies turn
  for i = 1, #map do
    for j = 1, #map[i] do
      if map[i][j].monster ~= nil then
        local enemy = map[i][j].monster
        if actionPerformed[enemy] == nil then
          hasAnimation = enemies.turn(dt, enemy)
          -- so that the enemy doesn't get another turn should he move in the
          -- direction of the iteration
          actionPerformed[enemy] = true
          print("action performed")

          if hasAnimation then
            print("with animation")
            return false
          end
        end
      end
    end
  end
  return true
end

function love.keypressed(key)
  if screen == "play" then
    if key == "escape" then
      screen = "menu"
    elseif gameWon then
      return
    elseif turnState == turnStates.ACTION then
      players.keypressed(key)
    end
    
    print("player action callback finished")

    --      processEnemies()

    --      -- after the players has moved, it's the enemies turn
    --      actionPerformed = {}
    --      for i = 1, #map do
    --        for j = 1, #map[i] do
    --          if map[i][j].monster ~= nil then
    --            local enemy = map[i][j].monster
    --            if actionPerformed[enemy] == nil then
    --              enemies.turn(dt, enemy)
    --              -- so that the enemy doesn't get another turn should he move in the
    --              -- direction of the iteration
    --              actionPerformed[enemy] = true
    --            end
    --          end
    --        end
    --      end

  elseif screen == "inventory" then
    inventories.keypressed(key)
  elseif screen == "menu" then
    menu.mainMenu:keypressed(key)
  elseif screen == "aim" then
    players.aim(key)
        print("player action  aim callback finished")
  end
end

function love.draw()

  -- love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

  if screen == "play" or screen == "inventory" or screen == "aim" or screen == "animation" then
--    print("drawing..")
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

    animations.draw()

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
