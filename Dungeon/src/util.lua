local P = {}
util = P

util.pixelPerCellX = 32
util.pixelPerCellY = 32

function util.getPixelLocation(cellX, cellY)
  return cellX * util.pixelPerCellX, cellY * util.pixelPerCellY
end

function util.round(x)
  return math.floor(x + 0.5)
end
 

return util