require "util"
require "fights"
require "console"
require "inventories"

local P = {}
players = P

local playerStatsOriginX = 550
local playerStatsOriginY = 300
local playerStatsFontSize = 15

function players.new(playerX, playerY)
  local newplayers = {
    gridX = playerX,
    gridY = playerY,
    aimX = playerX,
    aimY = playerY,
    actualX = 200,
    actualY = 200,
    speed = 10,
    health = 100,
    damage = 20,
    armor = 0,
    items = {["helmet"] = nil, ["chestArmor"] = nil, ["weapon"] = nil},
    aimPath = nil
  }
  return newplayers
end

function players.update(dt)
  local pixelX, pixelY = util.getPixelLocation(player.gridX, player.gridY)
  player.actualY = player.actualY - ((player.actualY - pixelY) * player.speed * dt)
  player.actualX = player.actualX - ((player.actualX - pixelX) * player.speed * dt)
end

function players.draw()
  local lighting = util.getEnemyLighting(player.gridX, player.gridY)
  love.graphics.setColor(lighting, lighting, lighting)

  -- love.graphics.rectangle("fill", player.actualX, player.actualY, util.pixelPerCellX, util.pixelPerCellY)
  local heroImage = love.graphics.newImage("hero.png")
  love.graphics.draw(heroImage, player.actualX, player.actualY)

  -- draw stats
  love.graphics.setColor(150, 200, 150)
  love.graphics.setFont(love.graphics.newFont(fontSize))

  love.graphics.rectangle("line", playerStatsOriginX , playerStatsOriginY, 75, 20)
  love.graphics.print("h: " .. player.health, playerStatsOriginX + 5, playerStatsOriginY + 5)
  love.graphics.rectangle("line", playerStatsOriginX + 85 , playerStatsOriginY, 75, 20)
  love.graphics.print("d: " .. player.damage, playerStatsOriginX + 5 + 85, playerStatsOriginY + 5)
  love.graphics.rectangle("line", playerStatsOriginX + 170 , playerStatsOriginY, 75, 20)
  love.graphics.print("a: " .. player.armor, playerStatsOriginX + 5 + 170, playerStatsOriginY + 5)

  -- draw slot
  love.graphics.rectangle("line", playerStatsOriginX , playerStatsOriginY + 30, 75, 20)
  love.graphics.print("helmet", playerStatsOriginX + 5, playerStatsOriginY + 5 + 30)

  if player.items["helmet"] == nil then
    love.graphics.rectangle("line", playerStatsOriginX + 21 , playerStatsOriginY + 55 + 10, 32, 32)
  else
    local image = love.graphics.newImage(player.items["helmet"].image)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(image, playerStatsOriginX + 21 , playerStatsOriginY + 55 + 10)
  end

  love.graphics.setColor(150, 200, 150)
  love.graphics.rectangle("line", playerStatsOriginX + 85 , playerStatsOriginY + 30, 75, 20)
  love.graphics.print("chest", playerStatsOriginX + 85 + 5, playerStatsOriginY + 5 + 30)

  if player.items["chestArmor"] == nil then
    love.graphics.rectangle("line", playerStatsOriginX + 21 + 75 + 10 , playerStatsOriginY + 55 + 10, 32, 32)
  else
    local image = love.graphics.newImage(player.items["chestArmor"].image)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(image, playerStatsOriginX + 21 + 75 + 10 , playerStatsOriginY + 55 + 10)
  end

  love.graphics.setColor(150, 200, 150)
  love.graphics.rectangle("line", playerStatsOriginX + 170, playerStatsOriginY + 30, 75, 20)
  love.graphics.print("weapon", playerStatsOriginX + 5 + 170, playerStatsOriginY + 5 + 30)

  if player.items["weapon"] == nil then
    love.graphics.rectangle("line", playerStatsOriginX + 21 + 20 + 150 , playerStatsOriginY + 55 + 10, 32, 32)
  else
    local image = love.graphics.newImage(player.items["weapon"].image)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(image, playerStatsOriginX + 21 + 20 + 150 , playerStatsOriginY + 55 + 10)
  end

  -- if in "aim" mode, render currently targeted field
  if running == "aim" then
    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle("fill",  player.aimX * 32, player.aimY * 32, 32, 32)
  end

  --  if player.aimPath ~= nil then
  --    for i = 1,#player.aimPath do
  --      local pointOnPath = player.aimPath[i]
  --      love.graphics.setColor(255, 0, 255)
  --      love.graphics.rectangle("fill", pointOnPath[1] * 32, pointOnPath[2] * 32, 32, 32)
  --    end
  --  end
end

function players.keypressed(key)
  local newX
  local newY
  local isMove = false
  if key == "up" then
    newX = player.gridX
    newY = player.gridY - 1
    isMove = true
  elseif key == "down" then
    newX = player.gridX
    newY = player.gridY + 1
    isMove = true
  elseif key == "left" then
    newX = player.gridX - 1
    newY = player.gridY
    isMove = true
  elseif key == "right" then
    newX = player.gridX + 1
    newY = player.gridY
    isMove = true
  end

  if isMove then
    -- check whether enemy was hit
    if maps.testEnemy(map, newX, newY) then
      local enemy = getEnemy(map, newX, newY)
      fights.playerAttack(player, enemy, map)
    elseif maps.testMove(map, newX, newY) then
      maps.movePlayer(player.gridX, player.gridY, newX, newY)
    end
  end

  if key == "t" then
    if maps.testItem(player.gridX, player.gridY) then
      local items = maps.takeItems(player.gridX, player.gridY)
      for i = 1, #items do
        local item = items[i]
        inventories.put(item)
      end
    end
  end

  if key == "a" then
    -- how to aim?
    running = "aim"
  end
end

function players.slotOccupied(slot)
  if player.items[slot] == nil then
    return false
  end
  return true
end

function players.itemTakeOff(slot)
  local item = player.items[slot]
  player.damage = player.damage - item.damage
  player.armor = player.armor - item.armor
  player.items[slot] = nil
  return item
end

function players.itemPutOn(item)
  -- remove old item (if any)
  if players.slotOccupied(item.slot) then
    players.itemTakeOff(item.slot)
  end

  player.items[item.slot] = item
  player.damage = player.damage + item.damage
  player.armor = player.armor + item.armor
end

function players.die()
  gameEnded = true
  console.pushMessage("You died!")
  console.pushMessage("GAME OVER")
end

function players.itemConsume(item)
  player.health = player.health + item.health
  player.damage = player.damage + item.damage
  player.armor = player.armor + item.armor
end

function players.aim(key)
  if key == "escape" then
    running = "play"
    disableEnemyTurn = false
    return
  end

  if key == "up" then
    player.aimY = math.max(1, player.aimY - 1)
  elseif key == "down" then
    player.aimY = math.min(gridSizeY, player.aimY + 1)
  elseif key == "left" then
    player.aimX = math.max(1, player.aimX - 1)
  elseif key == "right" then
    player.aimX = math.min(gridSizeX, player.aimX + 1)
  elseif key == "return" then
    players.fire()
    running = "play"
    disableEnemyTurn = false
  end
end

function players.getOffset(a, b)
  local offset
  if a == b then
    offset = 0
  elseif a - b > 0 then
    offset = 1
  else
    offset = -1
  end
  return offset
end

function players.getDistance(x1, y1, x2, y2)
  local diffX = x1 - x2
  local diffY = y1 - y2
  return math.sqrt((diffX * diffX) + (diffY * diffY))
end

function players.getNextOnPath(originX, originY, aimX, aimY, pathX, pathY)
  local offsetX = players.getOffset(aimX, pathX)
  local offsetY = players.getOffset(aimY, pathY)

  local x1 = pathX + offsetX
  local y1 = pathY

  local x2 = pathX
  local y2 = pathY + offsetY

  if offsetX == 0 then
    return x2, y2
  elseif offsetY == 0 then
    return x1, y1
  end

  local totalDistance1 = players.getDistance(player.gridX, player.gridY, x1, y1) + players.getDistance(x1, y1, aimX, aimY)
  local totalDistance2 = players.getDistance(player.gridX, player.gridY, x2, y2) + players.getDistance(x2, y2, aimX, aimY)

  if totalDistance1 < totalDistance2 then
    return x1, y1
  else
    return x2, y2
  end
end

function players.getAimPath()
  local pathX = player.gridX
  local pathY = player.gridY
  player.aimPath = {}
  while true do
    player.aimPath[#player.aimPath + 1] = {pathX, pathY}
    pathX, pathY = players.getNextOnPath(player.gridX, player.gridY, player.aimX, player.aimY, pathX, pathY)
    if (pathX == player.aimX and pathY == player.aimY) or retry == 0 then
      break
    end
  end
    player.aimPath[#player.aimPath + 1] = {player.aimX, player.aimY}  
  return player.aimPath
end

function players.fire()
  -- local pathX = player.gridX
  -- local pathY = player.gridY

  -- pathX, pathY = players.getNextOnPath(player.gridX, player.gridY, player.aimX, player.aimY, pathX, pathY)

  local aimPath = players.getAimPath()

  local hitWall = false
  local actualHitIndex = -1
  for i = 1,#aimPath do
    local pathX = aimPath[i][1]
    local pathY = aimPath[i][2]
    if map[pathX][pathY].type == "wall" then
      actualHitIndex = i
      break
    elseif map[pathX][pathY].monster ~= nil then
      fights.playerRangedAttack(player, map[pathX][pathY].monster, projectile)
      actualHitIndex = i
      break
    end
  end
  if actualHitIndex == -1 then
    actualHitIndex = #aimPath
  end

  print(#aimPath)
  if #aimPath > 0 then
    print(actualHitIndex)
    print(aimPath[actualHitIndex][1])
    effects.addProjectile("stone", player.gridX, player.gridY, aimPath[actualHitIndex][1], aimPath[actualHitIndex][2])
  end
end

return players
