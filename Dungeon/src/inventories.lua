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

  selectedItems = {
    ["helmet"] = nil,
    ["chestArmor"] = nil,
    ["weapon"] = nil
  }
end

function inventories.keypressed(key)
  if key == "escape" then
    screen = "play"
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

    if item.consumable then
      player:itemConsume(item)
      inventory[cursorX][cursorY] = nil
      return
    end

    if player:slotOccupied(item.slot) then
      local oldItem = player:itemTakeOff(item.slot)
      inventory[cursorX][cursorY] = oldItem
    end
    player:itemPutOn(item)
    selectedItems[item.slot] = {
      inventoryX = cursorX,
      inventoryY = cursorY
    }
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
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(item.image, pixelX, pixelY)
      end
    end
  end

  love.graphics.setColor(180, 180, 180)  
  for slot, location in pairs(selectedItems) do
    local pixelX, pixelY = inventories.gridToPixel(location.inventoryX, location.inventoryY)
    love.graphics.rectangle("line", pixelX - 2, pixelY - 2, 32 + 4, 32 + 4)    
  end

  love.graphics.setColor(255, 255, 255)
  if screen == "inventory" then
    local pixelX, pixelY = inventories.gridToPixel(cursorX, cursorY)
    love.graphics.rectangle("line", pixelX - 2, pixelY - 2, 32 + 4, 32 + 4)
  end

end

return inventories
