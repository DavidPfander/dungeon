local P = {}
inventories = P

local inventorySizeX = 6
local inventorySizeY = 4

local inventoryOriginX = 565
local inventoryOriginY = 450

function inventories.load()
  inventory = {}
  for i = 1, inventorySizeX do
    inventory[i] = {}     -- create a new row
    for j = 1, inventorySizeY do
      inventory[i][j] = nil
    end
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
end

return inventories
