local this = {}
this.id = Isaac.GetItemIdByName("Lucky Saucer")
this.description = "\1 +3 Luck up"

this.luckBonus = 3

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      if flag == CacheFlag.CACHE_LUCK then
         player.Luck = player.Luck + this.luckBonus; 
      elseif flag == CacheFlag.CACHE_TEARCOLOR then
         player:AddNullCostume(deliveranceContent.costumes.luckySaucer)
      end
  end
end

function this:update(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if deliveranceData.temporary.poopOnHead==nil then
       deliveranceData.temporary.poopOnHead=true
       deliveranceDataHandler.directSave()
    end
    if deliveranceData.temporary.poopOnHead then
       this.luckBonus = 3
       if player:HasCollectible(202) then  
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.luckySaucer), "gfx/characters/costumes/sheet_costume_luckySaucerG.png", 0)
       else
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.luckySaucer), "gfx/characters/costumes/sheet_costume_luckySaucer.png", 0)
       end
    else
       this.luckBonus = 0
       if player:HasCollectible(202) then  
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.luckySaucer), "gfx/characters/costumes/sheet_costume_luckySaucerG2.png", 0)
       else
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.luckySaucer), "gfx/characters/costumes/sheet_costume_luckySaucer2.png", 0)
       end
    end
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
  end
end

function this:takeDamage(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if deliveranceData.temporary.poopOnHead then
       player:UseActiveItem(36,false,false,false,false)	
       sfx:Play(SoundEffect.SOUND_BIRD_FLAP, 0.8, 0, false, 1)
       deliveranceData.temporary.poopOnHead=false
       deliveranceDataHandler.directSave()
    end
  end
end

function this:updateRoom()
   local room = game:GetRoom()
   local player = Isaac.GetPlayer(0)
   if player:HasCollectible(this.id) then
     if room:IsFirstVisit() then 
        deliveranceData.temporary.poopOnHead=true
     end
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateRoom)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.takeDamage, EntityType.ENTITY_PLAYER)
end

return this
