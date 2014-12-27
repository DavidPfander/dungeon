require "tiles"

local P = {}
maps = P

maps.fillFactor = .2 -- Percentage of floor tiles


maps.currentFactor = 0.0
maps.numFloorTiles = 0.0
maps.mapSize = 0.0
maps.roomCount = 0

function maps.generate(sizeX, sizeY)

  maps.currentFactor = 0.0
  maps.numFloorTiles = 0.0
  maps.mapSize = 0.0
  maps.roomCount = 0

  local roomX local roomY

  if sizeX < 5 or sizeY < 5 then
    print("Error: Map size too small.")
    return 1
  end

  maps.map = {}
  maps.mapSize = sizeX * sizeY
  for curX = 0,sizeX,1 do
  maps.map[curX] = {}
    for curY = 0,sizeY,1 do 
      -- default: Fill with walls
      maps.map[curX][curY] = tiles.newWall()
    end  
  end
  
  local curX local curY
  
  -- Now generate rooms as long as the map has not enough floor tiles
  while (maps.currentFactor < maps.fillFactor) do
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
        elseif maps.map[roomX][roomY].type ~= "wall" then
          roomValid = false
        end
      end
    end
    
    if roomValid then
      for roomX = roomLowerX,roomLowerX + roomSizeX,1 do
        for roomY = roomLowerY,roomLowerY + roomSizeY,1 do
          maps.map[roomX][roomY] = tiles.newFloor()
        end
      end      
      maps.numFloorTiles = maps.numFloorTiles + roomSizeX * roomSizeY
      
      maps.roomCount = maps.roomCount + 1
      roomX = math.random(roomLowerX, roomLowerX + roomSizeX)
      roomY = math.random(roomLowerY, roomLowerY + roomSizeY)
      curX = roomX 
      curY = roomY 
      
-- Place the player
      if maps.roomCount == 1 and level == 1 then
        player = players.new(curX, curY)
        maps.map[curX][curY] = tiles.newStairsUp()
        maps.map[curX][curY].hasPlayer = true
      end      
      
-- If there is more then one room, make sure they are connected      
      if maps.roomCount > 1 then
        while(maps.oldRoomX ~= curX or maps.oldRoomY ~= curY) do
        
          if maps.oldRoomX == curX then
            if maps.oldRoomY > curY then
              curY = curY + 1
            else
              curY = curY - 1
            end
          elseif maps.oldRoomY == curY then
            if maps.oldRoomX > curX then
              curX = curX + 1
            else
              curX = curX - 1
            end
          else
            local rnd = math.random(0,1)
            if rnd == 0 then
              if maps.oldRoomX > curX then
                curX = curX + 1
              else
                curX = curX - 1
              end
            else
              if maps.oldRoomY > curY then
                curY = curY + 1
              else
                curY = curY - 1
              end
            end
          end   
             
          if maps.map[curX][curY].type == "wall" then
            maps.map[curX][curY] = tiles.newFloor()
            maps.numFloorTiles = maps.numFloorTiles + 1
          end     
        end
      end

      maps.oldRoomX = roomX
      maps.oldRoomY = roomY
      
    end
  
    maps.currentFactor = maps.numFloorTiles / maps.mapSize
  end
  
  maps.map[curX][curY] = tiles.newStairsDown()
  
  return maps.map
end

-- Returns true if the tile is not walkable or there is a monster on the field 
function maps.test(map, x, y)
  if map[x][y].walkable == true or next(map[x][y].monster) then
    return true
  end
  return false
end

-- Returns true if there is a monster on the field
function maps.testEnemy(map, x, y)
  if next(map[x][y].monster) then
    return true
  end
  return false
end

-- Places a new monster "newMonster" on the coordinates "x","y"
function maps.registerEnemy(map, x, y, newMonster)
  map[x][y].monster = newMonster
end

-- Moves the monster "movingMonster" from "oldX","oldY" to "x","y"
function maps.moveEnemy(map, oldX, oldY, x, y, movingMonster)
  map[oldX][oldY].monster = {}
  map[x][y].monster = movingMonster
end

-- Returns true iff the tile at "x","y" is not walkable
function maps.enemyHit(map, x, y)
  if map[x][y].isWalkable == true then
    return false
  else
    return true
  end
end

function maps.movePlayer(map, oldX, oldY, x, y)
  map[oldX][oldY].hasPlayer = false
  map[x][y].hasPlayer = true
  
  if tostring(map[x][y].type) == "stairsup" then
    maps.moveUp(x,y)
  elseif map[x][y].type == "stairsdown" then
    maps.moveDown(x,y)
  end
  
  if moveUp or moveDown then
    for stairsX=1,gridSizeX,1 do
      for stairsY=1,gridSizeY,1 do
        if (moveUp and map[stairsX][stairsY].tile == "stairsdown") or
           (moveDown and map[stairsX][stairsY].tile == "stairsup") then
          map[stairsX][stairsY].hasPlayer = true
          map[oldX][oldY].hasPlayer = false
          player.gridX = x
          player.gridY = y
        end
      end
    end
  end
    
end

function maps.draw()
  for y=1, #map do
    for x=1, #map[y] do
      if math.abs(x - player.gridX) <= vision and
        math.abs(y - player.gridY) <= vision then
      -- Tile is in vision  
        local lighting = 30 + 15 * ((2 - math.abs(x - player.gridX)) + (2 - math.abs(y - player.gridY)))
        love.graphics.setColor(lighting, lighting, lighting)
        love.graphics.rectangle("fill",  x * 32, y * 32, 32, 32)
        if map[x][y].type == "floor" then
          
        elseif map[x][y].type == "wall" then
          love.graphics.setColor(150,150,150)
          love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
        
        elseif map[x][y].type == "stairsup" then
          stairsUpImage = love.graphics.newImage( "stone_stairs_up.png" )
          love.graphics.draw(stairsUpImage, x * 32, y * 32, 0, 1, 1, 0, 0) 
        elseif map[x][y].type == "stairsdown" then
          stairsUpImage = love.graphics.newImage( "stone_stairs_down.png" )
          love.graphics.draw(stairsUpImage, x * 32, y * 32, 0, 1, 1, 0, 0) 
        else
          print("Unknown tile type.")
        end
      else
      -- Tile is out of vision
        love.graphics.setColor(10, 10, 10)
        love.graphics.rectangle("fill",  x * 32, y * 32, 32, 32)
      end    
    end
  end
end

function maps.moveUp(oldX, oldY)
  if level == 1 then
  
  else
    level = level - 1
    map = dungeon[level]
    moveUp = true
  end
end

function maps.moveDown()
  if level == dungeonDepth then
    
  else
    level = level + 1
    map = dungeon[level]
    moveDown = true
  end
end