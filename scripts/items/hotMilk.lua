local this = {}
this.id = Isaac.GetItemIdByName("Hot Milk")
this.description = "Makes tear damage vary a bit"

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    --if not deliveranceData.temporary.hasHotMilk then
    --   deliveranceData.temporary.hasHotMilk = true
    --   deliveranceDataHandler.directSave()
    --end
--  if flag == CacheFlag.CACHE_TEARCOLOR then player.TearColor = Color(219, 231, 251, 1, 0, 0, 0) end
    if flag == CacheFlag.CACHE_DAMAGE then player.Damage = player.Damage + 0.45
    elseif flag == CacheFlag.CACHE_TEARCOLOR then
       player:AddNullCostume(deliveranceContent.costumes.hotmilk)
    end
  end
end

function this:hotMilkUpdate(tear)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    local tr = math.random(75,125)/100
    tear.Scale = tear.Scale*tr
    tear.CollisionDamage = tear.CollisionDamage*tr
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
