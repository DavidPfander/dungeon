local P = {}
util = P

util.pixelPerCellX = 32
util.pixelPerCellY = 32

function util.getPixelLocation(cellX, cellY)
  return cellX * util.pixelPerCellX, cellY * util.pixelPerCellY
end

return util