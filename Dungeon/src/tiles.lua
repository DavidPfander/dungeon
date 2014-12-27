local P = {}
tiles = P

function tiles.newFloor()
  local newTile = {
    walkable = true,
    monster = nil,
    loot = {},
    type = "floor",
    visible = false,
    hasPlayer = false
  }
  return newTile
end


function tiles.newWall()
  local newTile = {
    walkable = false,
    monster = nil,
    loot = {},
    type = "wall",
    visible = false,
    hasPlayer = false
  }
  return newTile
end
