local P = {}
tiles = P

function tiles.newFloor()
  local newTile = {
    walkable = true,
    monster = {},
    loot = {},
    type = "floor",
    visible = false,
    stairs = 0
  }
  return newTile
end


function tiles.newWall()
  local newTile = {
    walkable = false,
    monster = {},
    loot = {},
    type = "wall",
    visible = false,
    stairs = 0
  }
  return newTile
end