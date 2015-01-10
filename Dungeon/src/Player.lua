require "util"
require "fights"
require "console"
require "inventories"

local Player = {}
Player.__index = Player

local PlayertatsOriginX = 550
local PlayertatsOriginY = 300
local PlayertatsFontSize = 15

function Player.new(playerX, playerY)
  local self = setmetatable({}, Player)
  local pixelX, pixelY = util.getPixelLocation(playerX, playerY)
  self.gridX = playerX
  self.gridY = playerY
  self.aimX = playerX
  self.aimY = playerY
  self.actualX = pixelX
  self.actualY = pixelY
  -- speed = 10,
  self.speed = 100
  self.health = 100
  self.damage = 20
  self.armor = 0
  self.items = {["helmet"] = nil, ["chestArmor"] = nil, ["weapon"] = nil}
  self.aimPath = nil
  self.image = love.graphics.newImage("hero.png")

  return self
end

function Player.update(self, dt)
  local pixelX, pixelY = util.getPixelLocation(self.gridX, self.gridY)

  self.actualX, self.actualY = util.moveLinear(
    self.actualX, self.actualY,
    pixelX, pixelY, self.speed, dt)

  if self.actualX == pixelX and
    self.actualY == pixelY then
    self.actualY = pixelY
    self.actualX = pixelX
    return true
  else
    return false
  end
end

function Player.draw(self)
  local lighting = util.getEnemyLighting(self.gridX, self.gridY)
  love.graphics.setColor(lighting, lighting, lighting)

  love.graphics.draw(self.image, self.actualX, self.actualY)

  -- draw stats
  love.graphics.setColor(150, 200, 150)
  love.graphics.setFont(love.graphics.newFont(fontSize))

  love.graphics.rectangle("line", PlayertatsOriginX , PlayertatsOriginY, 75, 20)
  love.graphics.print("h: " .. self.health, PlayertatsOriginX + 5, PlayertatsOriginY + 5)
  love.graphics.rectangle("line", PlayertatsOriginX + 85 , PlayertatsOriginY, 75, 20)
  love.graphics.print("d: " .. self.damage, PlayertatsOriginX + 5 + 85, PlayertatsOriginY + 5)
  love.graphics.rectangle("line", PlayertatsOriginX + 170 , PlayertatsOriginY, 75, 20)
  love.graphics.print("a: " .. self.armor, PlayertatsOriginX + 5 + 170, PlayertatsOriginY + 5)

  -- draw slot
  love.graphics.rectangle("line", PlayertatsOriginX , PlayertatsOriginY + 30, 75, 20)
  love.graphics.print("helmet", PlayertatsOriginX + 5, PlayertatsOriginY + 5 + 30)

  if self.items["helmet"] == nil then
    love.graphics.rectangle("line", PlayertatsOriginX + 21 , PlayertatsOriginY + 55 + 10, 32, 32)
  else
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.items["helmet"].image, PlayertatsOriginX + 21 , PlayertatsOriginY + 55 + 10)
  end

  love.graphics.setColor(150, 200, 150)
  love.graphics.rectangle("line", PlayertatsOriginX + 85 , PlayertatsOriginY + 30, 75, 20)
  love.graphics.print("chest", PlayertatsOriginX + 85 + 5, PlayertatsOriginY + 5 + 30)

  if self.items["chestArmor"] == nil then
    love.graphics.rectangle("line", PlayertatsOriginX + 21 + 75 + 10 , PlayertatsOriginY + 55 + 10, 32, 32)
  else
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.items["chestArmor"].image, PlayertatsOriginX + 21 + 75 + 10 , PlayertatsOriginY + 55 + 10)
  end

  love.graphics.setColor(150, 200, 150)
  love.graphics.rectangle("line", PlayertatsOriginX + 170, PlayertatsOriginY + 30, 75, 20)
  love.graphics.print("weapon", PlayertatsOriginX + 5 + 170, PlayertatsOriginY + 5 + 30)

  if self.items["weapon"] == nil then
    love.graphics.rectangle("line", PlayertatsOriginX + 21 + 20 + 150 , PlayertatsOriginY + 55 + 10, 32, 32)
  else
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.items["weapon"].image, PlayertatsOriginX + 21 + 20 + 150 , PlayertatsOriginY + 55 + 10)
  end

  -- if in "aim" mode, render currently targeted field
  if screen == "aim" then
    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle("fill",  self.aimX * 32, self.aimY * 32, 32, 32)
  end

  --  if self.aimPath ~= nil then
  --    for i = 1,#self.aimPath do
  --      local pointOnPath = self.aimPath[i]
  --      love.graphics.setColor(255, 0, 255)
  --      love.graphics.rectangle("fill", pointOnPath[1] * 32, pointOnPath[2] * 32, 32, 32)
  --    end
  --  end
end

function Player.keypressed(self, key)

  local newX
  local newY
  local isMove = false

  if key == "up" then
    newX = self.gridX
    newY = self.gridY - 1
    isMove = true
  elseif key == "down" then
    newX = self.gridX
    newY = self.gridY + 1
    isMove = true
  elseif key == "left" then
    newX = self.gridX - 1
    newY = self.gridY
    isMove = true
  elseif key == "right" then
    newX = self.gridX + 1
    newY = self.gridY
    isMove = true
  elseif key == "i" then
    -- make "screen" a string and use it to dispatch modes
    screen = "inventory"
  elseif key == "t" then
    if maps.testItem(self.gridX, self.gridY) then
      local items = maps.takeItems(self.gridX, self.gridY)
      for i = 1, #items do
        local item = items[i]
        inventories.put(item)
      end
    end
    turnState = turnStates.ENEMY
  elseif key == "a" then
    -- how to aim?
    screen = "aim"
  end

  if isMove then
    -- check whether enemy was hit
    if maps.testEnemy(map, newX, newY) then
      local enemy = maps.getEnemy(map, newX, newY)
      fights.playerAttack(self, enemy, map)
    elseif maps.testMove(map, newX, newY) then
      maps.movePlayer(self.gridX, self.gridY, newX, newY)
      animations.addMovement("player", self)
    end
    turnState = turnStates.ENEMY
  end

end

function Player.slotOccupied(self, slot)
  if self.items[slot] == nil then
    return false
  end
  return true
end

function Player.itemTakeOff(self, slot)
  local item = self.items[slot]
  self.damage = self.damage - item.damage
  self.armor = self.armor - item.armor
  self.items[slot] = nil
  return item
end

function Player.itemPutOn(self, item)
  -- remove old item (if any)
  if self:slotOccupied(item.slot) then
    self.itemTakeOff(item.slot)
  end

  self.items[item.slot] = item
  self.damage = self.damage + item.damage
  self.armor = self.armor + item.armor
end

function Player.die(self)
  gameEnded = true
  console.pushMessage("You died!")
  console.pushMessage("GAME OVER")
end

function Player.itemConsume(self, item)
  self.health = self.health + item.health
  self.damage = self.damage + item.damage
  self.armor = self.armor + item.armor
end

function Player.aim(self, key)
  if key == "escape" then
    screen = "play"
    return
  end

  if key == "up" then
    self.aimY = math.max(1, self.aimY - 1)
  elseif key == "down" then
    self.aimY = math.min(gridSizeY, self.aimY + 1)
  elseif key == "left" then
    self.aimX = math.max(1, self.aimX - 1)
  elseif key == "right" then
    self.aimX = math.min(gridSizeX, self.aimX + 1)
  elseif key == "return" then
    self:fire()
    turnState = turnStates.ENEMY
  end
end

function Player.getOffset(self, a, b)
  local offset
  if a == b then
    offset = 0
  elseif a - b > 0 then
    offset = 1
  else
    offset = -1
  end
  return offset
end

function Player.getDistance(self, x1, y1, x2, y2)
  local diffX = x1 - x2
  local diffY = y1 - y2
  return math.sqrt((diffX * diffX) + (diffY * diffY))
end

function Player.getNextOnPath(self, originX, originY, aimX, aimY, pathX, pathY)
  local offsetX = self:getOffset(aimX, pathX)
  local offsetY = self:getOffset(aimY, pathY)

  local x1 = pathX + offsetX
  local y1 = pathY

  local x2 = pathX
  local y2 = pathY + offsetY

  if offsetX == 0 then
    return x2, y2
  elseif offsetY == 0 then
    return x1, y1
  end

  local totalDistance1 = self:getDistance(self.gridX, self.gridY, x1, y1) + self:getDistance(x1, y1, aimX, aimY)
  local totalDistance2 = self:getDistance(self.gridX, self.gridY, x2, y2) + self:getDistance(x2, y2, aimX, aimY)

  if totalDistance1 < totalDistance2 then
    return x1, y1
  else
    return x2, y2
  end
end

function Player.getAimPath(self)
  local pathX = self.gridX
  local pathY = self.gridY
  self.aimPath = {}
  while true do
    self.aimPath[#self.aimPath + 1] = {pathX, pathY}
    pathX, pathY = self:getNextOnPath(self.gridX, self.gridY, self.aimX, self.aimY, pathX, pathY)
    if (pathX == self.aimX and pathY == self.aimY) or retry == 0 then
      break
    end
  end
  self.aimPath[#self.aimPath + 1] = {self.aimX, self.aimY}
  return self.aimPath
end

function Player.fire(self)
  -- local pathX = self.gridX
  -- local pathY = self.gridY

  -- pathX, pathY = self.getNextOnPath(self.gridX, self.gridY, self.aimX, self.aimY, pathX, pathY)

  local aimPath = self:getAimPath()

  local hitWall = false
  local actualHitIndex = -1
  for i = 1,#aimPath do
    local pathX = aimPath[i][1]
    local pathY = aimPath[i][2]
    if map[pathX][pathY].type == "wall" then
      actualHitIndex = i
      break
    elseif maps.testEnemy(map, pathX, pathY) then
      fights.playerRangedAttack(self, maps.testEnemy(map, pathX, pathY), projectile)
      actualHitIndex = i
      break
    end
  end
  if actualHitIndex == -1 then
    actualHitIndex = #aimPath
  end

  if #aimPath > 0 then
    animations.addProjectile("stone", self.gridX, self.gridY, aimPath[actualHitIndex][1], aimPath[actualHitIndex][2])
  end
end

return Player
