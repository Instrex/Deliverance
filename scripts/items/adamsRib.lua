local this = {}
this.id = Isaac.GetItemIdByName("Adam's Rib")
this.variant = Isaac.GetEntityVariantByName("Adam's Knife")
this.description = "Enemies with full health take extra damage"
this.rusdescription ={"Adam's Rib /Ребро Адама", "Враги с полным здоровьем получают дополнительный урон"}

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    --if not deliveranceData.temporary.hasAdamsRib then
      --deliveranceData.temporary.hasAdamsRib = true
      --deliveranceDataHandler.directSave()
      if flag == CacheFlag.CACHE_TEARCOLOR then
      player:AddNullCostume(deliveranceContent.costumes.adamsRib2)
       if player:GetPlayerType() == PlayerType.PLAYER_EVE then
         player:AddNullCostume(deliveranceContent.costumes.adamsRib)
       end
      end
    --end 
  end
end

function this:onHitNPC(npc,damage,flags,source)
  local player = Isaac.GetPlayer(0)
  if npc:IsVulnerableEnemy() and player:HasCollectible(this.id) then
     if not npc:GetData().doubleDamaged then
        npc:GetData().doubleDamaged = true
        sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
        local knife = Isaac.Spawn(1000, this.variant, 0, npc.Position, vectorZero, nil)
        knife:GetData().dmg = damage*0.75
     end
  end
end

function this:update(npc)
  if npc.Variant == this.variant then
    local data = npc:GetData()
    local sprite = npc:GetSprite()

    if sprite:IsEventTriggered("Attack") then
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 0.8)
       for e, enemies in pairs(Isaac.FindInRadius(npc.Position, 60, EntityPartition.ENEMY)) do
         enemies:TakeDamage(data.dmg, 0, EntityRef(nil), 0)
       end

       local room = game:GetRoom()
       for i = 1, room:GetGridSize() do
          local grid = room:GetGridEntity(i)
          if grid and (grid.Desc.Type==2 or grid.Desc.Type==3 or grid.Desc.Type==4 or grid.Desc.Type==5 or grid.Desc.Type==6 or grid.Desc.Type==14 or grid.Desc.Type==22) then 
             if npc.Position:Distance(grid.Position) <= 66 then
                room:DestroyGrid(i, true) 
             end
          end
       end
    end

    if sprite:IsEventTriggered("Die") then
      npc:Remove()
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.update)
end

return this
