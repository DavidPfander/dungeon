local P = {}
util = P

util.pixelPerCellX = 32
util.pixelPerCellY = 32

function util.getPixelLocation(cellX, cellY)
  return cellX * util.pixelPerCellX, cellY * util.pixelPerCellY
end

function util.getCellLighting(gridX, gridY)
  local distance = math.sqrt(
    math.abs(gridX - player.gridX) * math.abs(gridX - player.gridX) +
    math.abs(gridY - player.gridY) * math.abs(gridY - player.gridY))
  
  local lighting = math.min(255, 50 + 30 * (vision - distance))
  if distance > vision then
    lighting = 0
  end
  return lighting
end

return util