local this = {}
this.id = Isaac.GetItemIdByName("Hot Milk")
this.description = "\1+0.45 Damage Up#Makes tear damage vary a bit"
this.rusdescription ={"Hot Milk /Горячее молоко", "©+0.45 к урону#Урон от слез становится немного случайным"}


function this:cache(player, flag)
  if player:HasCollectible(this.id) then
    if flag == CacheFlag.CACHE_DAMAGE then player.Damage = player.Damage + 0.45 end
  end
end

function this:hotMilkUpdate(tear)
  if tear.Parent and tear.Parent.Type == EntityType.ENTITY_PLAYER then
    local player = tear.Parent:ToPlayer()
    if player:HasCollectible(this.id) then
      local tr = math.random(75,125)/100
      tear.Scale = tear.Scale*tr
      tear.CollisionDamage = tear.CollisionDamage*tr
    end
  end
end

function this:update(player)
  if player:HasCollectible(this.id) then
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
  end
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR , this.hotMilkUpdate)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.update)
end

return this
