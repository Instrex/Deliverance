local this = {}
this.id = Isaac.GetItemIdByName("Salty Soup")
this.description = "\1 Tears up#Slightly higher chance to miss"
this.rusdescription ={"Salty Soup /Пересоленная похлёбка", "©Увеличивает скорострельность#Шанс промахнуться немного выше"}

function this:cache(player, flag)
  if player:HasCollectible(this.id) then
      if flag == CacheFlag.CACHE_SPEED then player.MoveSpeed = player.MoveSpeed - 0.09
      elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay = Utils.tearsUp(player.MaxFireDelay,0.70)
      end
  end
end

function this:update(player)
  if player:HasCollectible(this.id) then
      player:AddCacheFlags(CacheFlag.CACHE_SPEED)
      player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
      player:EvaluateItems()
  end
end

function this:saltyTearUpdate(tear)
  if tear.Parent and tear.Parent.Type == EntityType.ENTITY_PLAYER then
    local player = tear.Parent:ToPlayer()
    if player:HasCollectible(this.id) then
      tear.Velocity = tear.Velocity:Rotated(math.random(-8,8))
    end
  end
end

function this:saltyLaserUpdate(laser)
  if laser.Parent and laser.Parent.Type == EntityType.ENTITY_PLAYER then
    local plr = laser.Parent:ToPlayer()
    if plr:HasCollectible(this.id) then
      if laser.SpawnerType == EntityType.ENTITY_PLAYER then
        laser.Angle = laser.Angle + math.random(-6,6)
      end
    end
  end
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, this.saltyTearUpdate)
  mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, this.saltyLaserUpdate)
end

return this
