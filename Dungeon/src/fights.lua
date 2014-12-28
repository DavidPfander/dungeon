require "console"

local P = {}
fights = P

function fights.playerAttack(player, enemy, map)
  enemy.health = enemy.health - player.damage
  
  console.pushMessage("player hit enemy for " .. player.damage .. " damage")

  if enemy.health == 0 then
    enemies.die(enemy, map)
  end
end

function fights.playerDefend(enemy, player, map)
  player.health = player.health - enemy.damage
  
  console.pushMessage("player was hit by enemy for " .. enemy.damage .. " damage")
  
  if defender.health == 0 then
    players.die(player, map)
  end
end

return fights
