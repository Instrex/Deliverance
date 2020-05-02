local this = {}
this.id = Isaac.GetEntityTypeByName("Jester")
this.variant = Isaac.GetEntityVariantByName("Jester")

function this.checkEnemies()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e:GetData().smol then count = count + 1 end
    --if data.boneupd == nil then data.boneupd = 0 end
  end

  return count
end

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()

  if data.RealHp == nil then data.RealHp = npc.HitPoints end

  npc:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-10, 0, 15, 30)
    if data.dead == nil then data.dead = false end

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
   
    npc.Pathfinder:FindGridPath(target.Position, 0.725, 1, false)
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

    if npc.Position:Distance(target.Position) <= 250 then
      npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame >= 50 then
       sfx:Play(SoundEffect.SOUND_FAT_GRUNT , 1, 0, false, 1)
       if this.checkEnemies() <= 2 then
          npc.State = NpcState.STATE_ATTACK;
       else
          npc.State = NpcState.STATE_ATTACK3;
       end
       npc.StateFrame = Utils.choose(-10, -5, 0)
    end

  -- Charges --
  elseif npc.State == NpcState.STATE_ATTACK then
   
    sprite:Play("Charge");
    npc.Velocity = vectorZero

    if(sprite:IsFinished("Charge")) then
        npc.State = NpcState.STATE_ATTACK2;
        sfx:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1)
           local urod = Game():Spawn(227, 0, npc.Position, vectorZero, npc, 0, 1):ToNPC()
           urod.HitPoints = 4
           urod.State = 0
           urod:SetSize(9, Vector(1,1), 12)
           urod.Scale = 0.75
           urod:GetData().smol = true
           urod:GetSprite():ReplaceSpritesheet(1,"gfx/monsters/lilBoney.png")
           urod:GetSprite():LoadGraphics()
        Isaac.Spawn(1000, 15, 0, npc.Position+Vector(0, 20), vectorZero, nil)
        game:ShakeScreen(3)
--      if utils.chancep(20) then game:Darken(1, 90) end
    end

  -- Summons tiny Bony --
  elseif npc.State == NpcState.STATE_ATTACK2 then
        sprite:Play("Summon");

        if(sprite:IsFinished("Summon")) then
            npc.State = NpcState.STATE_MOVE;
        end

  -- Explodes all bonies --
  elseif npc.State == NpcState.STATE_ATTACK3 then
        sprite:Play("Order");
        
        npc.Velocity = npc.Velocity * 0.85

        if sprite:IsEventTriggered("Stomp") then
           sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 0.75)
        end

        if sprite:IsEventTriggered("Order") then
           npc.Velocity = npc.Velocity * 0
           game:ShakeScreen(20)
           sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
           for _, e in pairs(Isaac.GetRoomEntities()) do
             if e:GetData().smol then 
                game:Spawn(Isaac.GetEntityTypeByName("Lil Bony Dies"), Isaac.GetEntityVariantByName("Lil Bony Dies"), e.Position, vectorZero, e, 0, 1)
                e:Remove()
             end
           end
        end

        if sprite:IsEventTriggered("AnimeScream") then
           sfx:Play(SoundEffect.SOUND_RAGMAN_2 , 1.25, 0, false, 0.8)
        end

        if(sprite:IsFinished("Order")) then
            npc.State = NpcState.STATE_MOVE;
        end
  end
  
  if data.dead then
    npc.State = NpcState.STATE_UNIQUE_DEATH;
    npc.StateFrame = -666
    npc.Velocity = vectorZero

    sprite:Play("Death");

    if sprite:IsEventTriggered("HatDrop") then
        sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 0.75)
        game:ShakeScreen(5) 
    end

    if sprite:IsFinished("Death") then
       npc:Remove()
    end
  end
 end
end

--[[function this:boneprojupdate(proj)
you'll need to manually set SpawnerEntity in the parent entity's code because this API is fucked up
    local spawner = proj.SpawnerEntity
 this code will also continuously replace the spritesheet for a single entity which has perf implications; you should add a field on GetData indicating you've already checked this projectile
 spawner.Type == 227 and spawner.SpawnerType == 742 then
          local sprite = proj:GetSprite()
          sprite:ReplaceSpritesheet(0,"gfx/projectiles/lilboney_projectile.png")
          sprite:LoadGraphics()
    end
end--]]



function this:onHitNPC(npc, dmgAmount, flags, source, frames)
 if npc.Variant == this.variant then
  local data = npc:GetData()
  if npc.Type == this.id then
    if data.RealHp == nil then
      data.RealHp = npc.HitPoints
    end
    data.RealHp = data.RealHp - dmgAmount
    if data.RealHp <= 0 and not data.dead then
       data.dead=true
       npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
       sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
     
       for i=1, 5+math.random(0, 3) do
          Isaac.Spawn(1000, 35, 0, npc.Position, - npc.Velocity + Vector(math.random(-3,3), math.random(-3,3)), npc)
       end
       return false
    end
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, this.boneprojupdate, 1)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 27)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this