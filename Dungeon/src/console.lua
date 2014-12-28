local P = {}
console = P

local messageStack = {}
local consoleOriginX = 550
local consoleOriginY = 5
local consolveInnerBoundary = 5
local consoleIncrementY = 20
local maxMessages = 20
local fontSize = 15

function console.update()
--  local currentTime = love.timer.getTime()
--  for i = #messageStack, 1, -1 do
--    local message = messageStack[i]
--    if math.abs(currentTime - message.time) > 5.0 then
--      table.remove(messageStack, i)
--    end
--  end
end

function console.draw()
  love.graphics.setColor(100, 150, 100)
  love.graphics.rectangle("line", consoleOriginX , consoleOriginY, 245, 300)

  local offset = 0
  for i = 1, #messageStack do
    local message = messageStack[i]
    love.graphics.setColor(150, 200, 150)
    love.graphics.setFont(love.graphics.newFont(fontSize))
    love.graphics.print(message.text, consoleOriginX + consolveInnerBoundary, consoleOriginY + consolveInnerBoundary + offset)
    offset = offset + consoleIncrementY
  end
end

function console.pushMessage(message)
  if #messageStack > 10 then
    table.remove(messageStack, 1)
  end
  -- local currentTime = love.timer.getTime()
  messageStack[#messageStack + 1] = {text = message}
end

return console
