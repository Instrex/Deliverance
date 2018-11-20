local this = {}
this.id = Isaac.GetItemIdByName("Lucky Saucer")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    player:AddNullCostume(content.costumes.luckySaucer)
    if player:HasCollectible(202) then  
      player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(content.costumes.luckySaucer), "gfx/costumes/sheet_costume_luckySaucerG.png", 0)
    end
    if flag == CacheFlag.CACHE_LUCK then
     player.Luck = player.Luck + 3; 
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
end

return this
