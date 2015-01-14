require "util"

items = {}

local allItems = {}

function items.buildItemLibrary()

  local stone = {
    slot = "weapon",
    name = "stone",
    damage = 15,
    armor = 0,
    image = love.graphics.newImage("bullet.png"),
    consumable = false
  }
  allItems[#allItems + 1] = stone

  local ironSword = {
    slot = "weapon",
    name = "iron sword",
    damage = 15,
    armor = 0,
    image = love.graphics.newImage("ironSword.png"),
    consumable = false
  }
  allItems[#allItems + 1] = ironSword

  local enchantedIronSword = {
    slot = "weapon",
    name = "enchanted iron sword",
    damage = 25,
    armor = 0,
    image = love.graphics.newImage("enchantedIronSword.png"),
    consumable = false
  }
  allItems[#allItems + 1] = enchantedIronSword

  local ironChestPlate = {
    slot = "chestArmor",
    name = "iron chest plate",
    damage = 0,
    armor = 50,
    image = love.graphics.newImage("ironChestPlate.png"),
    consumable = false
  }
  allItems[#allItems + 1] = ironChestPlate

  local ironHelmet = {
    slot = "helmet",
    name = "iron helmet",
    damage = 0,
    armor = 20,
    image = love.graphics.newImage("ironHelmet.png"),
    consumable = false
  }
  allItems[#allItems + 1] = ironHelmet

  local potion = {
    name = "potion",
    health = 30,
    armor = 0,
    damage = 0,
    image = love.graphics.newImage("potion.png"),
    consumable = true
  }
  allItems[#allItems + 1] = potion
end

function items.placeItems(map)
  local itemsPlaced = 0
  while itemsPlaced < itemsOnLevel do
    local item = allItems[math.random(1, #allItems)]
    local gridX = math.random(2, gridSizeX - 1)
    local gridY = math.random(2, gridSizeY - 1)
    if map:testMove(gridX, gridY) then
      -- TODO remove direct access
      map.map[gridX][gridY].items[#map.map[gridX][gridY].items + 1] = item
      itemsPlaced = itemsPlaced + 1
    end
  end
end

function items.draw(map)
  for x = 1, #map.map do
    for y = 1, #map.map[x] do
      if math.abs(player.gridX - x) > vision or math.abs(player.gridY - y) > vision then
      -- skip
      else
        for i = 1, #map.map[x][y].items do
          local item = map.map[x][y].items[i]
          local lighting = util.getEnemyLighting(x, y)
          --local lighting = 255
          love.graphics.setColor(lighting, lighting, lighting)
          -- local image = love.graphics.newImage(item.image)
          love.graphics.draw(item.image, x * util.pixelPerCellX, y * util.pixelPerCellY)
        end

      end
    end
  end
end

return items
