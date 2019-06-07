local this = {}
this.id = Isaac.GetItemIdByName("Lucky Saucer")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      if flag == CacheFlag.CACHE_LUCK then
         player.Luck = player.Luck + 3; 
      elseif flag == CacheFlag.CACHE_TEARCOLOR then
         player:AddNullCostume(deliveranceContent.costumes.luckySaucer)
      end
  end
end

function this:update(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if player:HasCollectible(202) then  
      player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.luckySaucer), "gfx/costumes/sheet_costume_luckySaucerG.png", 0)
    end
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.update)
end

return this
