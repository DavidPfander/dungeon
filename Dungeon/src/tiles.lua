local P = {}
tiles = P

function tiles.newFloor()
  local newTile = {
    walkable = true,
    monster = {},
    loot = {},
    type = "floor",
    visible = false,
<<<<<<< HEAD
    hasPlayer = false
=======
    stairs = 0
>>>>>>> branch 'master' of https://github.com/DavidPfander/dungeon
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
<<<<<<< HEAD
    hasPlayer = false
=======
    stairs = 0
>>>>>>> branch 'master' of https://github.com/DavidPfander/dungeon
  }
  return newTile
end
