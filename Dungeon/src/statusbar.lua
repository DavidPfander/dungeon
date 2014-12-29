local P = {}
statusbar = P

local message = ""
local statusbarOriginX = 5
local statusbarOriginY = 550
local statusbarInnerBoundary = 5
local fontSize = 15

function statusbar.draw()
  love.graphics.setColor(100, 150, 100)
  love.graphics.rectangle("line", statusbarOriginX , statusbarOriginY, 540, 45)

  love.graphics.setColor(150, 200, 150) 
  love.graphics.setFont(love.graphics.newFont(fontSize))
  love.graphics.print(message, statusbarOriginX + statusbarInnerBoundary, statusbarOriginY + statusbarInnerBoundary)
end

function statusbar.setMessage(newMessage)
  message = newMessage
end

return console
