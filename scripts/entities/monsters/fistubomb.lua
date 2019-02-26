local this = {}
this.id = Isaac.GetEntityTypeByName("Fistubomb")
this.variant = Isaac.GetEntityVariantByName("Fistubomb")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
 
    
  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_IDLE then
    
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    npc.GridCollisionClass = GridCollisionClass.COLLISION_NONE 
    if data.GridCountdown == nil then data.GridCountdown = 0 end
    sprite:Play("Start")

    if sprite:IsFinished("Start") then
      npc.State = NpcState.STATE_ATTACK
    end

    npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 0.6 + npc.Velocity

  elseif npc.State == NpcState.STATE_ATTACK then

    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS 

    sprite:Play("Start2")

    if sprite:IsFinished("Start2") then
      npc.State = NpcState.STATE_ATTACK2
    end

    if sprite:IsEventTriggered("Drop") then
       sfx:Play(3, 1.25, 0, false, 0.8)
       npc.Velocity = npc.Velocity * 0.5
    end

    if utils.chancep(60) then
      local RCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, vectorZero, nil)
      RCreep.SpriteScale = Vector(0.75,0.75) 
      RCreep:Update()
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then

    npc.GridCollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER

    sprite:Play("Pulse")

    if sprite:IsFinished("Pulse") then
      npc.State = NpcState.STATE_ATTACK3
      npc.Velocity = npc.Velocity * 0.6
    end

    if utils.chancep(60) then
      local RCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, vectorZero, nil)
      RCreep.SpriteScale = Vector(0.75,0.75) 
      RCreep:Update()
    end

  elseif npc.State == NpcState.STATE_ATTACK3 then

    sprite:Play("Explode")

    if sprite:IsFinished("Explode") then
--     Isaac.Explode(npc.Position, npc, 1.0)

       Isaac.Spawn(1000, 34, 0, npc.Position, vectorZero, player).Color = Color(0, 0, 0, 1, 217, 2, 24)
--     Isaac.Spawn(1000, 77, 0, npc.Position, vectorZero, player)
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
       local RCreep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CREEP_RED, 0, npc.Position, vectorZero, nil)
       RCreep.SpriteScale = Vector(2.1,2.1) 
       RCreep:Update()
       Game():ShakeScreen(16)
       npc:Remove()
    end
  end

  if npc.State == NpcState.STATE_ATTACK or npc.State == NpcState.STATE_ATTACK2 then
    if not target:IsDead() then 
       if npc:CollidesWithGrid() or data.GridCountdown > 0 then
          npc.Pathfinder:FindGridPath(target.Position, 0.85, 1, false)
          if data.GridCountdown <= 0 then
              data.GridCountdown = 30
          else
              data.GridCountdown = data.GridCountdown - 1
          end
       else
          npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 0.9 + npc.Velocity * 0.925 
       end
    end
  end
 end
end

function this:onHitNPC(npc)
  if npc.Type == Isaac.GetEntityTypeByName("Fistubomb") and npc.Variant == Isaac.GetEntityVariantByName("Fistubomb") then
    return false
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
