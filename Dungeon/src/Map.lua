require "tiles"
local Player = require "Player"
local Enemy = require "Enemy"

Map = {}
Map.__index = Map

-- was "generate"
function Map.new(sizeX, sizeY)
  local self = setmetatable({}, Map)
  local fillFactor = .2 -- Percentage of floor tiles
  local currentFactor = 0.0
  local numFloorTiles = 0.0
  local mapSize = 0.0
  local roomCount = 0
  self.level = level

  local roomX, roomY, curX, curY, oldRoomX, oldRoomY

  if sizeX < 5 or sizeY < 5 then
    print("Error: Map size too small.")
    return 1
  end

  self.map = {}
  mapSize = sizeX * sizeY
  for curX = 0,sizeX,1 do
    self.map[curX] = {}
    for curY = 0,sizeY,1 do
      -- default: Fill with walls
      self.map[curX][curY] = tiles.newWall()
    end
  end

  -- Now generate rooms as long as the map has not enough floor tiles
  while (currentFactor < fillFactor) do
    --    print(level)
    local roomLowerX = math.random(2, sizeX - 2)
    local roomLowerY = math.random(2, sizeY - 2)

    local roomSizeX = math.random(1,5)
    local roomSizeY = math.random(1,5)


    local roomValid = true
    for roomX = roomLowerX,roomLowerX + roomSizeX,1 do
      for roomY = roomLowerY,roomLowerY + roomSizeY,1 do
        if roomX > sizeX - 1 or roomY > sizeY - 1 then
          roomValid = false
        elseif self.map[roomX][roomY].type ~= "wall" then
          roomValid = false
        end
      end
    end

    if roomValid then
      for roomX = roomLowerX,roomLowerX + roomSizeX,1 do
        for roomY = roomLowerY,roomLowerY + roomSizeY,1 do
          self.map[roomX][roomY] = tiles.newFloor()
        end
      end
      numFloorTiles = numFloorTiles + roomSizeX * roomSizeY

      roomCount = roomCount + 1
      roomX = math.random(roomLowerX, roomLowerX + roomSizeX)
      roomY = math.random(roomLowerY, roomLowerY + roomSizeY)
      curX = roomX
      curY = roomY

      -- Place the player
      if level == 1 and roomCount == 1 then
        -- player = players.new(curX, curY)
        player = Player.new(curX, curY)
        self.map[curX][curY].hasPlayer = true
      end

      -- Place stairs up
      if roomCount == 1 and level ~= 1 then
        self.map[curX][curY] = tiles.newStairsUp()
        self.map[curX][curY].hasPlayer = true
      end

      -- If there is more then one room, make sure they are connected
      if roomCount > 1 then
        while(oldRoomX ~= curX or oldRoomY ~= curY) do

          if oldRoomX == curX then
            if oldRoomY > curY then
              curY = curY + 1
            else
              curY = curY - 1
            end
          elseif oldRoomY == curY then
            if oldRoomX > curX then
              curX = curX + 1
            else
              curX = curX - 1
            end
          else
            local rnd = math.random(0,1)
            if rnd == 0 then
              if oldRoomX > curX then
                curX = curX + 1
              else
                curX = curX - 1
              end
            else
              if oldRoomY > curY then
                curY = curY + 1
              else
                curY = curY - 1
              end
            end
          end

          if self.map[curX][curY].type == "wall" then
            self.map[curX][curY] = tiles.newFloor()
            numFloorTiles = numFloorTiles + 1
          end
        end
      end

      oldRoomX = roomX
      oldRoomY = roomY

    end

    currentFactor = numFloorTiles / mapSize
  end

  self.map[curX][curY] = tiles.newStairsDown()

  return self
end

-- Returns true if the tile is not walkable or there is a enemy on the field
function Map.testMove(self, x, y)
  if self.map[x][y].walkable == true and self.map[x][y].enemy == nil and self.map[x][y].hasPlayer == false then
    return true
  end
  --  if not map[x][y].walkable then
  --    console.pushMessage("not walkable")
  --  elseif map[x][y].enemy ~= nil then
  --    console.pushMessage("enemy")
  --  elseif map[x][y].hasPlayer == true then
  --    console.pushMessage("player")
  --  end
  return false
end

function Map.getEnemy(self, x, y)
  return self.map[x][y].enemy
end

-- Returns true if there is a enemy on the field
function Map.testEnemy(self, x, y)
  if self.map[x][y].enemy ~= nil then
    return true
  end
  return false
end

-- Returns true if there is a enemy on the field
function Map.testPlayer(self, x, y)
  if self.map[x][y].hasPlayer then
    return true
  end
  return false
end

-- Places a new enemy "newEnemy" on the coordinates "x","y"
function Map.registerEnemy(self, x, y, newEnemy)
  self.map[x][y].enemy = newEnemy
end

-- Places a new enemy "newEnemy" on the coordinates "x","y"
function Map.removeEnemy(self, x, y, enemy)
  self.map[x][y].enemy = nil
end

-- Moves the enemy "movingEnemy" from "oldX","oldY" to "x","y"
function Map.moveEnemy(self, enemy, x, y)
  self.map[enemy.gridX][enemy.gridY].enemy = nil
  self.map[x][y].enemy = enemy
  enemy.gridX = x
  enemy.gridY = y
end

-- Returns true iff the tile at "x","y" is not walkable
function Map.enemyHit(self, x, y)
  if self.map[x][y].isWalkable == true then
    return false
  else
    return true
  end
end

-- always return the map object in case the player moved on a stair
function Map.movePlayer(self, oldX, oldY, x, y)
  self.map[oldX][oldY].hasPlayer = false

  map = self
  local mapChange = false

  if tostring(self.map[x][y].type) == "stairsup" then
    map = self:moveUp(x,y)
    mapChange = true
  elseif self.map[x][y].type == "stairsdown" then
    map = self:moveDown(x,y)
    mapChange = true
  else
    player.gridX = x
    player.gridY = y
    self.map[x][y].hasPlayer = true
  end

  moveUp = false
  moveDown = false

  return mapChange
end

function Map.draw(self)
  for y=1, #self.map do
    for x=1, #self.map[y] do
      local lighting = util.getTileLighting(x, y)
      love.graphics.setColor(lighting, lighting, lighting)
      love.graphics.rectangle("fill",  x * 32, y * 32, 32, 32)

      if lighting ~= 0 then
        if self.map[x][y].type == "floor" then

        elseif self.map[x][y].type == "wall" then
          love.graphics.setColor(150,150,150)
          love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
        elseif self.map[x][y].type == "stairsup" then
          local stairsUpImage = love.graphics.newImage( "stone_stairs_up.png" )
          love.graphics.draw(stairsUpImage, x * 32, y * 32, 0, 1, 1, 0, 0)
        elseif self.map[x][y].type == "stairsdown" then
          local stairsUpImage = love.graphics.newImage( "stone_stairs_down.png" )
          love.graphics.draw(stairsUpImage, x * 32, y * 32, 0, 1, 1, 0, 0)
        end
      end

      --      if #map[x][y].items > 0 then
      --        love.graphics.setColor(255,255,25)
      --        love.graphics.print('I', x * 32, y * 32)
      --      end

    end
  end
end

function Map.testItem(self, x, y)
  if #self.map[x][y].items > 0 then
    return true
  end
  return false
end

function Map.takeItems(self, x, y)
  local items = self.map[x][y].items
  self.map[x][y].items = {}
  return items
end


function Map.moveUp(self, oldX, oldY)
  if level == 1 then

  else
    level = level - 1
    -- map = dungeon[level]
    moveUp = true
  end
  map = dungeon[level]
  map:placePlayerOnStairs("up")
  print("up -> now on level: " .. level)
  return dungeon[level]
end

function Map.moveDown(self)
  if level == dungeonDepth then

  else
    level = level + 1
    -- map = dungeon[level]
    moveDown = true
  end
  map = dungeon[level]
  print("down -> now on level: " .. level)
  print(map)
  map:placePlayerOnStairs("down")
  return dungeon[level]
end

-- type == "up" or "down"
function Map.placePlayerOnStairs(self, type)
  for stairsX=1, gridSizeX do
    for stairsY=1, gridSizeY do
      if (type == "up" and self.map[stairsX][stairsY].type == "stairsdown") or
        (type == "down" and self.map[stairsX][stairsY].type == "stairsup") then
        self.map[stairsX][stairsY].hasPlayer = true
        player:place(stairsX, stairsY)
      end
    end
  end
end

return Map
