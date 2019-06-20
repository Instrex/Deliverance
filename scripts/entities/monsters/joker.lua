local this = {}
this.id = Isaac.GetEntityTypeByName("Joker")
this.variant = Isaac.GetEntityVariantByName("Joker")

function this.checkEnemies()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e:GetData().bsmol then count = count + 1 end
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
    npc.StateFrame = Utils.choose(-10, 3, 16)

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
   
    npc.Pathfinder:FindGridPath(target.Position, 0.8, 1, false)
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

    if npc.Position:Distance(target.Position) <= 250 then
      npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame >= 75 then
       sfx:Play(SoundEffect.SOUND_FAT_GRUNT , 1, 0, false, 1.12)
       if this.checkEnemies() <= 2 then npc.State = NpcState.STATE_ATTACK else npc.State = NpcState.STATE_ATTACK3 end
       npc.StateFrame = Utils.choose(-10, -5, 0)
    end

  -- Charges --
  elseif npc.State == NpcState.STATE_ATTACK then
   
    sprite:Play("Charge");
    npc.Velocity = vectorZero

    if(sprite:IsFinished("Charge")) then
        npc.State = NpcState.STATE_ATTACK2;
        sfx:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1.12)
        local urod = Game():Spawn(277, 0, npc.Position, vectorZero, npc, 0, 1):ToNPC()
           urod.HitPoints = 4
           urod.State = 0
           urod:SetSize(9, Vector(1,1), 12)
           urod.Scale = 0.75
           urod:GetData().bsmol = true
           urod:GetSprite():ReplaceSpritesheet(1,"gfx/monsters/lilBlackBoney.png")
           urod:GetSprite():LoadGraphics()
        Isaac.Spawn(1000, 15, 0, npc.Position+Vector(0, 15), vectorZero, nil)
        game:ShakeScreen(3)
        if utils.chancep(50) then game:Darken(1, 90) end
    end

  -- Summons tiny black Bony --
  elseif npc.State == NpcState.STATE_ATTACK2 then
    sprite:Play("Summon");

    if(sprite:IsFinished("Summon")) then
        npc.State = NpcState.STATE_MOVE;
    end

  -- Charges brimstone shot --
  elseif npc.State == NpcState.STATE_ATTACK3 then
    sprite:Play("Charge2");
    npc.Velocity = vectorZero

    if(sprite:IsFinished("Charge2")) then

        npc.State = NpcState.STATE_ATTACK4;
        sfx:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_2 , 1, 0, false, 1)

         for i=1, 4 do
           local brimstone_laser = EntityLaser.ShootAngle(1, npc.Position, 45+i*90, 15, Vector(0,-20), npc)
           brimstone_laser.DepthOffset = 200
         end
    end

  -- After brimstone shot --
  elseif npc.State == NpcState.STATE_ATTACK4 then
    sprite:Play("Brimstone");

    if(sprite:IsFinished("Brimstone")) then
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
       Isaac.Explode(npc.Position, npc, 1.0)
       sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
       if utils.chancep(25) then
          proj = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, npc.Position, vectorZero, player)
       end
       return false
    end
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 27)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this