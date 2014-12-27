local P = {}
maps = P

maps.fillFactor = .2 -- Percentage of floor tiles
maps.currentFactor = 0.0
maps.numFloorTiles = 0.0
maps.mapSize = 0.0
maps.roomCount = 0

function maps.generateMap(sizeX, sizeY)

  local roomX local roomY

  if sizeX < 5 or sizeY < 5 then
    print("Error: Map size too small.")
    return 1
  end

  maps.map = {}
  math.randomseed(os.time())
  maps.mapSize = sizeX * sizeY
  for curX = 0,sizeX,1 do
  maps.map[curX] = {}
    for curY = 0,sizeY,1 do 
      maps.map[curX][curY] = 1 -- default: Fill with walls
    end  
  end
  
  
  -- Now generate rooms as long as the map has not enough floor tiles
  while (maps.currentFactor < maps.fillFactor) do
    local roomLowerX = math.random(2, sizeX - 2)
    local roomLowerY = math.random(2, sizeY - 2)
    
    local roomSizeX = math.random(1,5)
    local roomSizeY = math.random(1,5)
    
    local roomValid = true
    for roomX = roomLowerX,roomLowerX + roomSizeX,1 do
      for roomY = roomLowerY,roomLowerY + roomSizeY,1 do
        if roomX > sizeX - 1 or roomY > sizeY - 1 then
          roomValid = false
        elseif maps.map[roomX][roomY] ~= 1 then
          roomValid = false
        end
      end
    end
    
    if roomValid then
      for roomX = roomLowerX,roomLowerX + roomSizeX,1 do
        for roomY = roomLowerY,roomLowerY + roomSizeY,1 do
          maps.map[roomX][roomY] = 0
        end
      end      
      maps.numFloorTiles = maps.numFloorTiles + roomSizeX * roomSizeY
      
      maps.roomCount = maps.roomCount + 1
      roomX = math.random(roomLowerX, roomLowerX + roomSizeX)
      roomY = math.random(roomLowerY, roomLowerY + roomSizeY)
      local curX = roomX 
      local curY = roomY 
      
-- Place the player
      if maps.roomCount == 1 then
        player = figure.new(curX, curY)
        maps.map[curX][curY] = 100
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
             
          if maps.map[curX][curY] == 1 then
            maps.map[curX][curY] = 0
            maps.numFloorTiles = maps.numFloorTiles + 1
          end     
        end
      end

      maps.oldRoomX = roomX
      maps.oldRoomY = roomY
      
    end
  
    maps.currentFactor = maps.numFloorTiles / maps.mapSize

    -- print(maps.currentFactor)    
  end
  
  return maps.map
end

