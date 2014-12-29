local P = {}
inventories = P

local inventorySizeX = 6
local inventorySizeY = 4

local inventoryOriginX = 565
local inventoryOriginY = 450

local cursorX = 1
local cursorY = 1

function inventories.load()
  inventory = {}
  for i = 1, inventorySizeX do
    inventory[i] = {}     -- create a new row
    for j = 1, inventorySizeY do
      inventory[i][j] = nil
    end
  end
end

function inventories.keypressed(key)
  if key == "escape" then
    running = "play"
    return
  end

  if key == "up" then
    cursorY = math.max(1, cursorY - 1)
  elseif key == "down" then
    cursorY = math.min(inventorySizeY, cursorY + 1)
  elseif key == "left" then
    cursorX = math.max(1, cursorX - 1)
  elseif key == "right" then
    cursorX = math.min(inventorySizeX, cursorX + 1)
  elseif key == "return" then
    if inventory[cursorX][cursorY] == nil then
      return
    end
    local item = inventory[cursorX][cursorY]
    inventory[cursorX][cursorY] = nil
    local oldItem = nil
    if players.slotOccupied(item.slot) then
      inventory[cursorX][cursorY] = players.itemTakeOff(item.slot)
    end
    players.itemPutOn(item)
  end

end

function inventories.update(inventory)

end

function inventories.gridToPixel(x, y)
  return inventoryOriginX + (32 + 5) * (x - 1), inventoryOriginY + (32 + 5) * (y - 1)
end

function inventories.put(item)
  local placed = false
  for y = 1, inventorySizeY do
    for x = 1, inventorySizeX do
      if inventory[x][y] == nil then
        inventory[x][y] = item
        placed = true
        break
      end
    end
    if placed then
      break
    end
  end
end

function inventories.draw()
  -- draw outer borders
  -- love.graphics.setColor(100, 150, 100)
  -- love.graphics.rectangle("line", inventoryOriginX , inventoryOriginY, 245, 190)

  for i = 1, inventorySizeX do
    for j = 1, inventorySizeY do
      local pixelX, pixelY = inventories.gridToPixel(i, j)
      if inventory[i][j] == nil then
        love.graphics.setColor(100, 150, 100)
        love.graphics.rectangle("line", pixelX, pixelY, 32, 32)
      else
        local item = inventory[i][j]
        local image = love.graphics.newImage(item.image)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(image, pixelX, pixelY)
      end
    end
  end

  love.graphics.setColor(255, 255, 255)
  if running == "inventory" then
    local pixelX, pixelY = inventories.gridToPixel(cursorX, cursorY)
    love.graphics.rectangle("line", pixelX - 2, pixelY - 2, 32 + 4, 32 + 4)
  end

end

return inventories
