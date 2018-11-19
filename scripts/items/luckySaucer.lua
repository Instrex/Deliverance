local this = {}
this.id = Isaac.GetItemIdByName("Lucky Saucer")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    player:AddNullCostume(content.costumes.luckySaucer)
    if flag == CacheFlag.CACHE_LUCK then
     player.Luck = player.Luck + 3; 
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
end

return this
