local P = {}
maps = P

maps.fillFactor = .5 -- Percentage of floor tiles
maps.currentFactor = 0
maps.numFloorTiles = 0

function maps.generateMap(sizeX, sizeY)

  if sizeX < 5 or sizeY < 5 then
    print("Error: Map size too small.")
    return 1
  end

  map = {}
  math.randomseed(os.time())
  maps.mapSize = sizeX * sizeY
  for curX = 0,sizeX,1 do
  map[curX] = {}
    for curY = 0,sizeY,1 do 
      map[curX][curY] = 1 -- default: Fill with walls
    end  
  end
  
  -- Now generate rooms as long as the map has not enough floor tiles
  while (currentFactor < fillFactor) do
    roomLowerX = math.rand(1, sizeX - 2)
    roomLowerY = math.rand(1, sizeY - 2)
    
    
  end
  
  return map
end