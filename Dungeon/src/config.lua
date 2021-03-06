-- Global definitions

-- Mapsize
gridSizeX = 16
gridSizeY = 16

-- Depth
dungeonDepth = 7

-- Hero vision
vision = 5

enemiesOnLevel = {
  {goblinsOnLevel = 0, dragonsOnLevel = 0}, -- level 1
  {goblinsOnLevel = 0, dragonsOnLevel = 0}, -- level 2
  {goblinsOnLevel = 0, dragonsOnLevel = 0}, -- level 3
  {goblinsOnLevel = 9, dragonsOnLevel = 1}, -- level 4
  {goblinsOnLevel = 9, dragonsOnLevel = 1}, -- level 5
  {goblinsOnLevel = 9, dragonsOnLevel = 1}, -- level 6
  {goblinsOnLevel = 9, dragonsOnLevel = 1}, -- level 7
}

itemsOnLevel = 10

fullscreen = false

saveFileName = "dungeon.sav"