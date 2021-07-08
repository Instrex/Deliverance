local this = {}
this.id = Isaac.GetItemIdByName("Obituary")
this.description = "Gives a huge damage bonus after killing the enemy, which quickly disappears#Gives you a small damage bonus for each monster you kill"
this.rusdescription ={"Obituary /Некролог", "Дает огромный, временный бонус при убийстве врага#Немного увеличивает постоянный урон при убийстве"}

this.superObituaryBonus=1

function this:cache(player)
  local data = player:GetData()
  if player:GetCollectibleNum(this.id) > 0 and not data.damageBonus then
    data.damageBonus = 1
  end

  if player:HasCollectible(this.id) and data.damageBonus then
    player.Damage = player.Damage * data.damageBonus * this.superObituaryBonus
  end
end

--[[function this:playerUpdate(player)
    if player:HasCollectible(this.id) then
            if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then  
                player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.obituary), "gfx/characters/costumes_forgotten/sheet_costume_obituary_forgotten.png", 0)
            end
    end
end--]]

function this:update(player)
  if player:HasCollectible(this.id) then
    if this.superObituaryBonus>1 then this.superObituaryBonus=this.superObituaryBonus-0.05 else this.superObituaryBonus=1 end
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:EvaluateItems()
  end
end

function this:die(npc)
  if Utils.GetPlayers() then
    for _, player in pairs(Utils.GetPlayers()) do
      if player:HasCollectible(this.id) then
        local data = player:GetData()
        this.superObituaryBonus=3
        if data.damageBonus<1.5 then
          data.damageBonus=data.damageBonus+0.01
        end
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
      end
    end
  end
end

function this.trigger(_,player)
    local player = player:ToPlayer()
    if player:HasCollectible(this.id) then
      local data = player:GetData()
      data.damageBonus=1
      player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
      player:EvaluateItems()
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache, CacheFlag.CACHE_DAMAGE)
  mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
  --mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.playerUpdate)
end

return this