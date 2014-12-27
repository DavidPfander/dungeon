local P = {}
tiles = P

function tiles.newFloor()
  local newTile = {
    walkable = true,
    monster = {},
    loot = {},
    type = "floor",
    visible = false
  }
  return newTile
end

function tiles.newWall()
  local newTile = {
    walkable = false,
    monster = {},
    loot = {},
    type = "wall",
    visible = false
  }
  return newTile
end

function tiles.newStairsUp()
  local newTile = {
    walkable = true,
    monster = {},
    loot = {},
    type = "stairsup",
    visible = false
  }
  return newTile
end

function tiles.newStairsDown()
  local newTile = {
    walkable = true,
    monster = {},
    loot = {},
    type = "stairsdown",
    visible = false
  }
  return newTile
end