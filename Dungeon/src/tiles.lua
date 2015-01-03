local P = {}
tiles = P

function tiles.newFloor()
  local newTile = {
    walkable = true,
    enemy = nil,
    items = {},
    type = "floor",
    visible = false,
    hasPlayer = false
  }
  return newTile
end

function tiles.newWall()
  local newTile = {
    walkable = false,
    enemy = nil,
    items = {},
    type = "wall",
    visible = false,
    hasPlayer = false
  }
  return newTile
end

function tiles.newStairsUp()
  local newTile = {
    walkable = true,
    enemy = nil,
    items = {},
    type = "stairsup",
    visible = false,
    hasPlayer = false
  }
  return newTile
end

function tiles.newStairsDown()
  local newTile = {
    walkable = true,
    enemy = nil,
    items = {},
    type = "stairsdown",
    visible = false,
    hasPlayer = false
  }
  return newTile
end
