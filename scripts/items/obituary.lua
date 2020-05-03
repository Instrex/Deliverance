local this = {}
this.id = Isaac.GetItemIdByName("Obituary")
this.description = "Gives a huge damage bonus after killing the enemy, which quickly disappears#Gives you a small damage bonus for each monster you kill"

this.superObituaryBonus=1

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
 if flag == CacheFlag.CACHE_DAMAGE then
  if deliveranceData.temporary.damageBonus~=nil then
    player.Damage = player.Damage * deliveranceData.temporary.damageBonus * this.superObituaryBonus
  end

elseif flag == CacheFlag.CACHE_TEARCOLOR then
  player:AddNullCostume(deliveranceContent.costumes.obituary)
        end
    end
end

function this:playerUpdate(player)
    if player:HasCollectible(this.id) then
            if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then  
                player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.obituary), "gfx/characters/costumes_forgotten/sheet_costume_obituary_forgotten.png", 0)
            end
    end
end

function this:update(player)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if this.superObituaryBonus>1 then this.superObituaryBonus=this.superObituaryBonus-0.05 else this.superObituaryBonus=1 end
    if deliveranceData.temporary.damageBonus==nil then
       deliveranceData.temporary.damageBonus=1
    end
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
  end
end

function this:die(npc) 
   local player = Isaac.GetPlayer(0)
   if player:HasCollectible(this.id) then
      this.superObituaryBonus=3
      if deliveranceData.temporary.damageBonus<1.5 then
        deliveranceData.temporary.damageBonus=deliveranceData.temporary.damageBonus+0.01
        deliveranceDataHandler.directSave()
      end
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
   end
end

function this.trigger(id)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
     deliveranceData.temporary.damageBonus=1
     deliveranceDataHandler.directSave()
     player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
     player:EvaluateItems()
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.playerUpdate)
end

return this