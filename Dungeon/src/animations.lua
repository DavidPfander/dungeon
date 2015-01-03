local Player = require "Player"

local P = {}
animations = P

local runningAnimations = {}

local projectileTemplates = {}

function animations.load()
  projectileTemplates["stone"] = {
    type = "projectile",
    speed = 300,
    image = "bullet.png",
  }
end

function animations.addProjectile(name, gridX, gridY, aimX, aimY)

  local pixelX, pixelY = util.getPixelLocation(gridX, gridY)
  local aimPixelX, aimPixelY = util.getPixelLocation(aimX, aimY)

  local newProjectile = {}
  newProjectile.type = "projectile"
  newProjectile.speed = projectileTemplates[name].speed
  newProjectile.image = love.graphics.newImage(projectileTemplates[name].image)
  newProjectile.pixelX = pixelX
  newProjectile.pixelY = pixelY
  newProjectile.aimPixelX = aimPixelX
  newProjectile.aimPixelY = aimPixelY

  runningAnimations[#runningAnimations + 1] = newProjectile

  screen = "animation"
end

-- type can be "player" or "enemy" (until object orientation)
function animations.addMovement(type, being)
  local newMovement = {
    ["type"] = type,
    being = being
  }

  runningAnimations[#runningAnimations + 1] = newMovement

  screen = "animation"
end

-- updates the location of flying projectiles
function animations.update(dt)
  -- remove projectiles that have reached their destination
  for i = #runningAnimations, 1, -1 do
    if runningAnimations[i].type == "player" then
      local finished = player:update(dt)
      if finished then
        table.remove(runningAnimations, i)
      end
    elseif runningAnimations[i].type == "enemy" then
      local finished = runningAnimations[i].being:update(dt, map)
      if finished then
        table.remove(runningAnimations, i)
      end
    elseif runningAnimations[i].type == "projectile" then
      --      print("updating projectile")
      local projectile = runningAnimations[i]
      if projectile.pixelX == projectile.aimPixelX and
        projectile.pixelY == projectile.aimPixelY then
        table.remove(runningAnimations, i)
      end
    end
  end

  for i = 1,#runningAnimations do
    if runningAnimations[i].type == "projectile" then
      local projectile = runningAnimations[i]

      --      local directionX = projectile.aimPixelX - projectile.pixelX
      --      local directionY = projectile.aimPixelY - projectile.pixelY
      --      local length = math.sqrt(directionX * directionX + directionY * directionY)
      --      directionX = directionX / length
      --      directionY = directionY / length
      --      projectile.pixelX = projectile.pixelX + directionX * dt * projectile.speed
      --      projectile.pixelY = projectile.pixelY + directionY * dt * projectile.speed

      projectile.pixelX, projectile.pixelY = util.moveLinear(
        projectile.pixelX, projectile.pixelY,
        projectile.aimPixelX, projectile.aimPixelY, projectile.speed, dt)
    end
  end

  if #runningAnimations == 0 then
    screen = "play"
  end
end

-- draws flying projectiles
function animations.draw()
  for i = 1,#runningAnimations do
    if runningAnimations[i].type == "projectile" then
      local projectile = runningAnimations[i]
      love.graphics.draw(projectile.image, projectile.pixelX, projectile.pixelY)
    end
  end
end

return animations
