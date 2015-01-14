require "table_save"
require "util"
require "items"

local P = {}
menu = P
--[[
Simple Menu Library
by nkorth

Requires: love2d
Recommended: hump.gamestate

Public Domain - feel free to hack and redistribute this as much as you want.
]]--
menu.new = function()
  return {
    items = {},
    selected = 1,
    animOffset = 0,
    addItem = function(self, item)
      table.insert(self.items, item)
    end,
    update = function(self, dt)
      self.animOffset = self.animOffset / (1 + dt*10)
    end,
    draw = function(self, x, y)
      local height = 20
      local width = 300

      love.graphics.setColor(255, 255, 255, 128)
      love.graphics.rectangle('fill', x, y + height*(self.selected-1) + (self.animOffset * height), width, height)

      for i, item in ipairs(self.items) do
        if self.selected == i then
          love.graphics.setColor(255, 255, 255)
        else
          love.graphics.setColor(255, 255, 255, 128)
        end
        love.graphics.print(item.name, x + 5, y + height*(i-1) + 5)
      end
    end,
    keypressed = function(self, key)
      if key == 'up' then
        if self.selected > 1 then
          self.selected = self.selected - 1
          self.animOffset = self.animOffset + 1
        else
          self.selected = #self.items
          self.animOffset = self.animOffset - (#self.items-1)
        end
      elseif key == 'down' then
        if self.selected < #self.items then
          self.selected = self.selected + 1
          self.animOffset = self.animOffset - 1
        else
          self.selected = 1
          self.animOffset = self.animOffset + (#self.items-1)
        end
      elseif key == 'return' then
        if self.items[self.selected].action then
          self.items[self.selected]:action()
        end
      end
    end
  }
end

function menu.generateMainMenu()
  menu.mainMenu = menu.new()
  menu.mainMenu:addItem{
    name = 'New Game',
    action = function()
      dungeon = {}
      for clevel=1,dungeonDepth do
        print("level: " .. clevel)
        level = clevel
        dungeon[clevel] = Map.new(gridSizeX, gridSizeY)
        Enemy.placeEnemies(dungeon[clevel])
        items.placeItems(dungeon[clevel])
      end

      map = dungeon[1]
      level = 1

      screen = "play"
    end
  }
  menu.mainMenu:addItem{
    name = 'Load Game',
    action = function()
      util.loadGame()
      screen = "play"
    end
  }
  menu.mainMenu:addItem{
    name = 'Quit',
    action = function()
      util.saveGame()
      love.event.quit()
    end
  }
end

return menu
