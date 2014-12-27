require "util"

local P = {}
figure = P

function figure.new(playerX, playerY)
  local newFigure = {
    gridX = playerX,
    gridY = playerY,
    actualX = 200,
    actualY = 200,
    speed = 10
  }
  return newFigure
end

function figure.update(dt, player)
  local pixelX, pixelY = util.getPixelLocation(player.gridX, player.gridY)
  player.actualY = player.actualY - ((player.actualY - pixelY) * player.speed * dt)
  player.actualX = player.actualX - ((player.actualX - pixelX) * player.speed * dt)
end

function figure.draw(player)
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", player.actualX, player.actualY, util.pixelPerCellX, util.pixelPerCellY)
end

function figure.keypressed(player, key, map)

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
  else
    return
  end

  -- check whether enemy was hit
  if maps.enemyHitMap(map, player.gridX, player.gridY) then
    removeEnemy(player.gridX, player.gridY)
  end
end

return figure
