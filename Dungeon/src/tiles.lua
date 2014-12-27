local P = {}
tiles = P

function tiles.newFloor()
  local newTile = {
    walkable = true,
    monster = {},
    loot = {},
    type = "floor"
  }
  return newTile
end


function tiles.newWall()
  local newTile = {
    walkable = false,
    monster = {},
    loot = {},
    type = "wall"
  }
  return newTile
end