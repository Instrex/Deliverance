local this = {}
this.id = Isaac.GetItemIdByName("Hot Milk")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    player:AddNullCostume(content.costumes.hotmilk)
    if player:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN then
      player:AddNullCostume(content.costumes.hotmilk)
    end
--  if flag == CacheFlag.CACHE_TEARCOLOR then player.TearColor = Color(219, 231, 251, 1, 0, 0, 0) end

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
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR , this.hotMilkUpdate)
end

return this
