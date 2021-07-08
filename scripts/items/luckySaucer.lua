local this = {}
this.id = Isaac.GetItemIdByName("Lucky Saucer")
this.description = "\1 +3 Luck up"
this.rusdescription ={"Lucky Saucer /—частливое блюдце", "©+3 к удаче"}

this.luckBonus = 3

function this:cache(player, flag)
   local data = player:GetData()
   if player:GetCollectibleNum(this.id) > 0 and data.poopOnHead == nil then
      data.poopOnHead = true
   end

   if player:HasCollectible(this.id) and data.poopOnHead then
     player.Luck = player.Luck + this.luckBonus;
   end
 end

function this:update(player)
  local data = player:GetData()
  if player:HasCollectible(this.id) then
    if data.poopOnHead then
       this.luckBonus = 3
       if player:HasCollectible(202) then  
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetCollectible(this.id), "gfx/characters/deliverance/costumes/sheet_costume_luckySaucerG.png", 0)
       else
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetCollectible(this.id), "gfx/characters/deliverance/costumes/sheet_costume_luckySaucer.png", 0)
       end
    else
       this.luckBonus = 0
       if player:HasCollectible(202) then  
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetCollectible(this.id), "gfx/characters/deliverance/costumes/sheet_costume_luckySaucerG2.png", 0)
       else
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetCollectible(this.id), "gfx/characters/deliverance/costumes/sheet_costume_luckySaucer2.png", 0)
       end
    end
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
  end
end

function this:takeDamage(player)
  local player = player:ToPlayer()
  if player:HasCollectible(this.id) then
   local data = player:GetData()
    if data.poopOnHead then
       player:UseActiveItem(36)
       sfx:Play(SoundEffect.SOUND_BIRD_FLAP, 0.8, 0, false, 1)
       data.poopOnHead = false
    end
  end
end

function this:updateRoom()
   local room = game:GetRoom()
   if Utils.GetPlayers() then
      for _, player in pairs(Utils.GetPlayers()) do
         if player:HasCollectible(this.id) then
            local data = player:GetData()
            if room:IsFirstVisit() then
              data.poopOnHead=true
            end
          end
      end
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache, CacheFlag.CACHE_LUCK)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.takeDamage, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateRoom)
end

return this
