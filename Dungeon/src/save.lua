local P = {}
save = P

function save.new(player, enemyCount, dungeon, level)
  local save = {
    enemyCount = enemyCount,
    player = player,
    dungeon = dungeon,
    level = level
  }
  return save
end



return save