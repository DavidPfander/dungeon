require "util"

local P = {}
players = P

function players.new(playerX, playerY)
  local newplayers = {
    gridX = playerX,
    gridY = playerY,
    actualX = 200,
    actualY = 200,
    speed = 10
  }
  return newplayers
end

function players.update(dt, player)
  local pixelX, pixelY = util.getPixelLocation(player.gridX, player.gridY)
  player.actualY = player.actualY - ((player.actualY - pixelY) * player.speed * dt)
  player.actualX = player.actualX - ((player.actualX - pixelX) * player.speed * dt)
end

function players.draw(player)
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", player.actualX, player.actualY, util.pixelPerCellX, util.pixelPerCellY)
end

function players.keypressed(player, key, map)

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

  if maps.testMap(map, newX, newY) then
    player.gridX = newX
    player.gridY = newY
    hasPerformedAction = true
  else
    return
  end

  -- check whether enemy was hit
  if maps.enemyHitMap(map, player.gridX, player.gridY) then
    removeEnemy(player.gridX, player.gridY)
  end

  -- make sure that the enemies get a move after the player
  if hasPerformedAction then
    hasPlayerPerformedAction = true
  end
end

return players