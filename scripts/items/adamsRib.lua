local this = {}
this.id = Isaac.GetItemIdByName("Adam's Rib")
this.variant = Isaac.GetEntityVariantByName("Adam's Knife")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if not deliveranceData.temporary.hasAdamsRib then
      deliveranceData.temporary.hasAdamsRib = true
      deliveranceDataHandler.directSave()
      player:AddNullCostume(deliveranceContent.costumes.adamsRib2)
      if player:GetPlayerType() == PlayerType.PLAYER_EVE then
         player:AddNullCostume(deliveranceContent.costumes.adamsRib)
      end
    end
  end
end

function this:onHitNPC(npc,damage,flags,source)
  local player = Isaac.GetPlayer(0)
  if npc:IsVulnerableEnemy() and player:HasCollectible(this.id) then
--     for e, entity in pairs(Isaac.GetRoomEntities()) do 
--        if source.Entity and source.Entity.Index == entity.Index and entity.SpawnerType == 1 then 
--           if math.random(1, 8-(math.min(player.Luck, 6))) == 2 then
--              sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
--              Isaac.Spawn(1000, this.variant, 0, npc.Position, vectorZero, nil)
--           end
--        end
--     end 
     if not npc:GetData().doubleDamaged then
        npc:GetData().doubleDamaged = true
        sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
        local knife = Isaac.Spawn(1000, this.variant, 0, npc.Position, vectorZero, nil)
        knife:GetData().dmg = damage*0.75
     end
  end
end

function this:update(npc)
  local data = npc:GetData()
  if npc.Variant == this.variant then
    local sprite = npc:GetSprite()

    if sprite:IsEventTriggered("Attack") then
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS, 1, 0, false, 0.8)
       for e, enemies in pairs(Isaac.FindInRadius(npc.Position, 45, EntityPartition.ENEMY)) do
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
