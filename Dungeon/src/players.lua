require "util"
require "fights"
require "console"

local P = {}
players = P

local playerStatsOriginX = 550
local playerStatsOriginY = 400
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
    items = {helmet = nil, chestArmor = nil, weapon = nil}
    
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
  love.graphics.setColor(100, 150, 100)
  love.graphics.rectangle("line", playerStatsOriginX , playerStatsOriginY, 245, 195)

  love.graphics.setColor(150, 200, 150)
  love.graphics.setFont(love.graphics.newFont(fontSize))
  
  love.graphics.print("health: " .. player.health, playerStatsOriginX + 5, playerStatsOriginY + 5)
  love.graphics.print("damage: " .. player.damage, playerStatsOriginX + 5, playerStatsOriginY + 5 + 20)
  love.graphics.print("armor: " .. player.armor, playerStatsOriginX + 5, playerStatsOriginY + 5 + 40)
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
    hasPerformedAction = true
  elseif maps.testMove(map, newX, newY) then
    maps.movePlayer(player.gridX, player.gridY, newX, newY)
    hasPerformedAction = true
  else
    return
  end

  -- make sure that the enemies get a move after the player
  if hasPerformedAction then
    hasPlayerPerformedAction = true
  end
end

function players.itemTakeOff(slot)
  if player.items[slot] == nil then
    return
  end
  local item = player.items[slot] 
  player.damage = player.damage - item.damage
  player.armor = player.armor - item.armor
  player.items[slot] = nil
end

function players.itemPutOn(item) 
  -- remove old item (if any)
  player.itemTakeOff(item.slot)
  
  player.items[item.slot] = item
  player.damage = player.damage + item.damage
  player.armor = player.armor + item.armor
end

function players.die(player, map)
  gameEnded = true
  console.pushMessage("You died!")
  console.pushMessage("GAME OVER")
end

return players
