require "save"

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


function util.getEnemyLighting(gridX, gridY)

  local distance = math.sqrt(
    math.abs(gridX - player.gridX) * math.abs(gridX - player.gridX) +
    math.abs(gridY - player.gridY) * math.abs(gridY - player.gridY))

  local lighting = math.min(255, 50 + 30 * (vision - distance))
  if distance > vision or not util.checkPathVisible(player.gridX, player.gridY, gridX, gridY) then
    lighting = 0
  end
  return lighting
end

function util.checkPathVisible(x,y,tileX,tileY)
  local visible = true
  local visionPathX = x
  local visionPathY = y
  local distanceX = math.abs(tileX - x)
  local distanceY = math.abs(tileY - y)
  local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY)
  local factor = 1.0
  while(math.abs(visionPathX - tileX) > 1 or math.abs(visionPathY - tileY) > 1) do
    visionPathX = util.round(x + (factor * (tileX - x)) / distance)
    visionPathY = util.round(y + (factor * (tileY - y)) / distance)
    if map[util.round(visionPathX)][util.round(visionPathY)].type == "wall" then
      visible = false
    end
    factor = factor + 1.0
  end
  return visible
end

function util.getMoveDistance(x, y, tileX, tileY)
  return math.abs(x - tileX) + math.abs(y - tileY)
end

function util.getFirstElementOnPath(x, y, tileX, tileY)
  local visionPathX = x
  local visionPathY = y
  if math.random() > 0.5 then
    if x - tileX > 0 then
      visionPathX = x - 1
    else
      visionPathX = x + 1
    end
  else
    if y - tileY > 0 then
      visionPathY = y - 1
    else
      visionPathY = y + 1
    end
  end
  if map[visionPathX][visionPathY].type == "wall" then
    return util.getFirstElementOnPath(x, y, tileX, tileY)
  else
    return visionPathX, visionPathY
  end
end

function util.getTileLighting(x, y)
  local visible = true
  local visionPathX = player.gridX
  local visionPathY = player.gridY
  local lighting = 0

  local distanceX = math.abs(x - player.gridX)
  local distanceY = math.abs(y - player.gridY)
  local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY)
  if distance > vision then
    visible = false
  else
    visible = util.checkPathVisible(player.gridX, player.gridY, x, y)
  end

  if visible then
    -- Tile is in vision
    lighting = 10 + 15 * (vision - distance)
  else
    lighting = 0
  end
  return lighting
end

function util.saveGame()
  local saveFile = save.new(player, enemyCount, dungeon, level)
  table.save(saveFile, saveFileName)
end

function util.loadGame()
  saveStatus = table.load(saveFileName)
  player = saveStatus.player
  enemyCount = saveStatus.enemyCount
  dungeon = saveStatus.dungeon
  level = saveStatus.level
  map = dungeon[level]
end

return util
