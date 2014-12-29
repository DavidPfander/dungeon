local P = {}
inventories = P

local inventorySizeX = 5
local inventorySizeY = 5

local inventoryOriginX = 550
local inventoryOriginY = 370

inventory = {}

function inventories.load()
  for i = 1, inventorySizeX do
    inventory[i] = {}     -- create a new row
    for j = 1, inventorySizeY do
      inventory[i][j] = nil
    end
  end
  return inventory
end


function inventories.update(inventory)

end

function inventories.gridToPixel(x, y)
  return inventoryOriginX + (32 + 5) * (x - 1) + 5, inventoryOriginY + (32 + 5) * (y - 1) + 5
end

function inventories.draw(inventory)
  -- draw outer borders
  love.graphics.setColor(100, 150, 100)
  love.graphics.rectangle("line", inventoryOriginX , inventoryOriginY, 245, 245)

  for i = 1, inventorySizeX do
    inventory[i] = {}     -- create a new row
    for j = 1, inventorySizeY do
      local pixelX, pixelY = inventories.gridToPixel(i, j)
      if inventory[i][j] == nil then
        love.graphics.rectangle("line", pixelX, pixelY, 32, 32)
      else
        local item = inventory[i][j]
        local image = love.graphics.newImage(item.image)
        love.graphics.draw(image, pixelX, pixelY)
      end
    end
  end
end

return inventories
