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
  local pixelX, pixelY = util.getPixelLocation(player.gridX, player.gridY)
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("fill", pixelX, pixelY, util.pixelPerCellX, util.pixelPerCellY)
end

function figure.keypressed(player, key, map)
  if key == "up" then
    if testMap(map, player.gridX, player.gridY - 1) then
      player.gridY = player.gridY - 1
    end
  elseif key == "down" then
    if testMap(map, player.gridX, player.gridY + 1) then
      player.gridY = player.gridY + 1
    end
  elseif key == "left" then
    if testMap(map, player.gridX - 1, player.gridY) then
      player.gridX = player.gridX - 1
    end
  elseif key == "right" then
    if testMap(map, player.gridX + 1, player.gridY) then
      player.gridX = player.gridX + 1
    end
  end
end

return figure
