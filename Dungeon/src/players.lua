require "util"
require "fights"
require "console"

local P = {}
players = P

function players.new(playerX, playerY)
  local newplayers = {
    gridX = playerX,
    gridY = playerY,
    actualX = 200,
    actualY = 200,
    speed = 10,
    health = 100,
    damage = 20
  }
  return newplayers
end

function players.update(dt)
  local pixelX, pixelY = util.getPixelLocation(player.gridX, player.gridY)
  player.actualY = player.actualY - ((player.actualY - pixelY) * player.speed * dt)
  player.actualX = player.actualX - ((player.actualX - pixelX) * player.speed * dt)
end

function players.draw()
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", player.actualX, player.actualY, util.pixelPerCellX, util.pixelPerCellY)
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
  elseif maps.test(map, newX, newY) then
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

function players.die(player, map)
  gameEnded = true
  console.pushMessage("You died!")
end

return players
