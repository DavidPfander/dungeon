local P = {}
maps = P

maps.fillFactor = .7 -- Percentage of floor tiles

function maps.generateMap(sizeX, sizeY)
  map = {}
  math.randomseed(os.time())
  for curX = 0,sizeX,1 do
  map[curX] = {}
    for curY = 0,sizeY,1 do 
      isFieldFilled = math.random(0,1)
      map[curX][curY] = isFieldFilled
    end  
  end
  return map
end