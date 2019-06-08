local this = {}
this.id = Isaac.GetEntityTypeByName("Seraphim")
this.variant = Isaac.GetEntityVariantByName("Seraphim")

local Number = 0

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  if data.RealHp == nil then data.RealHp = npc.HitPoints end

  npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | 
                     EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | 
                     EntityFlag.FLAG_NO_BLOOD_SPLASH |
                     EntityFlag.FLAG_NO_DEATH_TRIGGER | 
                     EntityFlag.FLAG_NO_STATUS_EFFECTS  
  )

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE;
    npc.StateFrame = Utils.choose(0, 10, 20)
    if data.dead == nil then data.dead = false end
    if data.hitWall == nil then data.hitWall = false end
    --local fly = Isaac.Spawn(EntityType.ENTITY_ETERNALFLY, 0 , 0, npc.Position, vectorZero, nil)
    --fly.Parent = npc

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_MOVE then
     
    data.hitWall = false
    sprite:Play("Idle");
    if target.Position.X<npc.Position.X then sprite.FlipX=false else sprite.FlipX=true end
    npc.StateFrame = npc.StateFrame + 1

    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1 + npc.Velocity * 0.8 end

    if npc.StateFrame>=45 then
        npc.State = utils.choose(NpcState.STATE_ATTACK, NpcState.STATE_ATTACK2) 
    end

  elseif npc.State == NpcState.STATE_ATTACK3 then

    sprite:Play("AttackLeft")

    if sprite:IsEventTriggered("Dash") then
      sfx:Play(Isaac.GetSoundIdByName("Charge"), 1, 0, false, 1)
      npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 20
    end

    if(sprite:IsFinished("AttackLeft")) then
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = Utils.choose(-10, -5, 0)
    end
    
    if npc:CollidesWithGrid() then
       if not data.hitWall then
          data.hitWall=true
          Game():ShakeScreen(14) 
          sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 0.8, 0, false, 1.5) 
          --npc.Velocity = vectorZero
          npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 9
       end
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then

    sprite:Play("Attack")
    if target.Position.X<npc.Position.X then sprite.FlipX=false else sprite.FlipX=true end

    if(sprite:IsFinished("Attack")) then
       npc.State = NpcState.STATE_ATTACK3
       npc.StateFrame = Utils.choose(-10, -5, 0)
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 0.5 + npc.Velocity * 0.5 end
    sprite:Play("Attack2")

    if sprite:IsEventTriggered("HolyCross") then
      sfx:Play(SoundEffect.SOUND_1UP, 0.8, 0, false, 0.8)
       npc.Velocity = vectorZero
    end

    if sprite:IsEventTriggered("CrossShot1") then
      sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 0.8, 0, false, 1.5)
      sfx:Play(Isaac.GetSoundIdByName("Whoosh"), 0.7, 0, false, 1.5)
      Game():ShakeScreen(6) 
      
      for i=1, 3 do
         Isaac.Spawn(9, 6, 0, Vector(npc.Position.X,npc.Position.Y + 2), (utils.vecToPos(target.Position, npc.Position) * 13):Rotated(-24+i*12), npc)
      end
    end

    if sprite:IsEventTriggered("CrossShot2") then
      sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 0.8, 0, false, 1.25)
      sfx:Play(Isaac.GetSoundIdByName("Whoosh"), 0.7, 0, false, 1.25)
      Game():ShakeScreen(6) 
      
      for i=1, 4 do
         Isaac.Spawn(9, 6, 0, Vector(npc.Position.X,npc.Position.Y + 2), (utils.vecToPos(target.Position, npc.Position) * 13):Rotated(-30+i*12), npc)
      end
    end

    if(sprite:IsFinished("Attack2")) then
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = Utils.choose(-20, -15, -10)
    end
  end
  if data.dead then
    npc.State = NpcState.STATE_UNIQUE_DEATH;
    npc.StateFrame = -666
    npc.Velocity = npc.Velocity * 0.9

    if sprite:IsEventTriggered("Died") then
      sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE , 1, 0, false, 1)
      game:ShakeScreen(15) 
    end

    if sprite:IsEventTriggered("Teleport") then
      sfx:Play(SoundEffect.SOUND_HELL_PORTAL1 , 0.8, 0, false, 1)
    end

    sprite:Play("Death");

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
       return false
    end
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
