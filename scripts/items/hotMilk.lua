local this = {}
this.id = Isaac.GetItemIdByName("Hot Milk")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if not deliveranceData.temporary.hasHotMilk then
      deliveranceData.temporary.hasHotMilk = true
      deliveranceDataHandler.directSave()
      player:AddNullCostume(deliveranceContent.costumes.hotmilk)
      if player:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN then
        player:AddNullCostume(deliveranceContent.costumes.hotmilk)
      end
    end
--  if flag == CacheFlag.CACHE_TEARCOLOR then player.TearColor = Color(219, 231, 251, 1, 0, 0, 0) end
    if flag == CacheFlag.CACHE_DAMAGE then player.Damage = player.Damage + 0.45 end
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
