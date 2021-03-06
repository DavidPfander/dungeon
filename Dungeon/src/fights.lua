require "console"

local P = {}
fights = P

function fights.playerRangedAttack(player, enemy, projectile)
  enemy.health = enemy.health - player.damage

  console.pushMessage("player hit enemy for " .. player.damage .. " damage")

  if enemy.health <= 0 then
    enemy:die(map)
  end
end

function fights.playerAttack(player, enemy, map)
  enemy.health = enemy.health - player.damage

  console.pushMessage("player hit enemy for " .. player.damage .. " damage")

  if enemy.health <= 0 then
    enemy:die(map)
  end
end

function fights.playerDefend(enemy)
  player.health = player.health - enemy.damage

  console.pushMessage("player was hit by enemy for " .. enemy.damage .. " damage")

  if player.health <= 0 then
    player:die()
  end
end

return fights
