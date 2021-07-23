local this = {}
this.id = Isaac.GetEntityTypeByName("Fistulauncher")
this.variant = Isaac.GetEntityVariantByName("Fistulauncher")

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
    npc.StateFrame = Utils.choose(-10, -5, 0)
    if data.GridCountdown == nil then data.GridCountdown = 0 end

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    
    if not target:IsDead() then 
       if npc:CollidesWithGrid() or data.GridCountdown > 0 then
          npc.Pathfinder:FindGridPath(target.Position, 0.75, 1, false)
          if data.GridCountdown <= 0 then
              data.GridCountdown = 30
          else
              data.GridCountdown = data.GridCountdown - 1
          end
       else
          if npc.StateFrame>=0 then
             npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 0.35 + npc.Velocity * 0.95
          else
             npc.Velocity = utils.vecToPos(npc.Position, target.Position) * 0.325 + npc.Velocity * 0.95
          end
       end
    end
    
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

    if npc.Position:Distance(target.Position) <= 200 then
      npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
    end
    npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)

    if npc.StateFrame>=50 then
         sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.25, 0, false, 0.8)
         npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then
    
    npc.Velocity = npc.Velocity * 0.85

    sprite:Play("Attack");

    if sprite:IsEventTriggered("Gulp") then
        sfx:Play(Isaac.GetSoundIdByName("Fistulauncher"), 0.7, 0, false, 1)
    end

    if sprite:IsEventTriggered("Shoot") then
        npc.Velocity = vectorZero
        sfx:Play(Isaac.GetSoundIdByName("Fistulauncher2"), 0.7, 0, false, 1)
        Game():Spawn(Isaac.GetEntityTypeByName("Fistubomb"), Isaac.GetEntityVariantByName("Fistubomb"), npc.Position, vectorZero, npc, 0, 1)
    end

    if(sprite:IsFinished("Attack")) then
       npc.State = NpcState.STATE_MOVE;
       npc.StateFrame = Utils.choose(-100, -75, -50)
    end

  end

  if data.dead then
    npc.State = NpcState.STATE_UNIQUE_DEATH;
    npc.StateFrame = -666
    npc.Velocity = vectorZero

    sprite:Play("Death");

    if sprite:IsFinished("Death") then
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
       local RCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, vectorZero, nil)
       RCreep.SpriteScale = Vector(2.1,2.1) 
       RCreep:Update()
       Isaac.Spawn(1000, 16, 5, npc.Position, vectorZero, npc)
       Game():ShakeScreen(16)
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
       sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
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