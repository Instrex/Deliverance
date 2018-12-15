local this = {}
this.id = Isaac.GetItemIdByName("Lucky Saucer")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if not deliveranceData.temporary.hasLuckySaucer then
      deliveranceData.temporary.hasLuckySaucer = true
      deliveranceDataHandler.directSave()
      player:AddNullCostume(deliveranceContent.costumes.luckySaucer)
      if flag == CacheFlag.CACHE_LUCK then
       player.Luck = player.Luck + 3; 
      end
    end
  end
end

function this:update(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if player:HasCollectible(202) then  
      player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.luckySaucer), "gfx/costumes/sheet_costume_luckySaucerG.png", 0)
    end
  end
--for k, v in pairs(data.temporary) do print(k..' = '..tostring(v)) end
--print(' loaded '..tostring(dataHandler.loaded))
--print(' unsaved '..tostring(dataHandler.unsaved))
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.update)
end

return this
