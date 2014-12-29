require "util"

local P = {}
items = P

local allItems = {}

function items.buildItemLibrary()

  local ironSword = {
    slot = "weapon",
    name = "iron sword",
    damage = 15,
    armor = 0,
    image = "ironSword.png"
  }
  allItems[#allItems + 1] = ironSword

  local ironChestPlate = {
    slot = "chestArmor",
    name = "iron chest plate",
    damage = 0,
    armor = 50,
    image = "ironChestPlate.png"
  }
  allItems[#allItems + 1] = ironChestPlate

  local ironHelmet = {
    slot = "helmet",
    name = "iron helmet",
    damage = 0,
    armor = 20,
    image = "ironHelmet.png"
  }
  allItems[#allItems + 1] = ironHelmet
end

function items.placeItems(map)
  local itemsPlaced = 0
  while itemsPlaced < itemsOnLevel do
    local item = allItems[math.random(1, #allItems)]
    local gridX = math.random(2, gridSizeX - 1)
    local gridY = math.random(2, gridSizeY - 1)
    if maps.testMove(map, gridX, gridY) then
      map[gridX][gridY].items[#map[gridX][gridY].items + 1] = item
      itemsPlaced = itemsPlaced + 1
    end
  end
end

function items.draw(map)
  for x = 1, #map do
    for y = 1, #map[x] do
      if math.abs(player.gridX - x) > vision or math.abs(player.gridY - y) > vision then
        -- skip
      else
        for i = 1, #map[x][y].items do
          local item = map[x][y].items[i]
          local lighting = util.getEnemyLighting(x, y)
          --local lighting = 255
          love.graphics.setColor(lighting, lighting, lighting)
          local image = love.graphics.newImage(item.image)
          love.graphics.draw(image, x * util.pixelPerCellX, y * util.pixelPerCellY)
        end

      end
    end
  end
end

return items
