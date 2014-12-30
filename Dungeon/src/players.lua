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
    actualX = 200,
    actualY = 200,
    speed = 10,
    health = 100,
    damage = 20,
    armor = 0,
    items = {["helmet"] = nil, ["chestArmor"] = nil, ["weapon"] = nil}
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
end

function players.keypressed(key)

  local hasPerformedAction = false

  local newX
  local newY
  if key == "up" then
    newX = player.gridX
    newY = player.gridY - 1
  elseif key == "down" then
    newX = player.gridX
    newY = player.gridY + 1
  elseif key == "left" then
    newX = player.gridX - 1
    newY = player.gridY
  elseif key == "right" then
    newX = player.gridX + 1
    newY = player.gridY
  end

  -- check whether enemy was hit
  if maps.testEnemy(map, newX, newY) then
    local enemy = getEnemy(map, newX, newY)
    -- enemies.die(enemy, map)
    fights.playerAttack(player, enemy, map)
  elseif maps.testMove(map, newX, newY) then
    if maps.testItem(newX, newY) then
      local items = maps.takeItems(newX, newY)
      for i = 1, #items do
        local item = items[i]
        -- players.itemPutOn(items[i])
        if player.items[item.slot] == nil then
          players.itemPutOn(item)
        else
          inventories.put(item)
        end
      end
    end
    maps.movePlayer(player.gridX, player.gridY, newX, newY)
  else
    return
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

return players
