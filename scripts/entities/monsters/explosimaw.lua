local this = {}
this.id = Isaac.GetEntityTypeByName("Explosimaw")
this.variant = Isaac.GetEntityVariantByName("Explosimaw")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()
  
  if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * (0.33 + npc.StateFrame/55) + npc.Velocity * 0.85 end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    if data.Smol == nil then data.Smol = false end
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS 

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_MOVE then

    sprite:Play("Fly")

    if npc.Position:Distance(target.Position) <= 150 then
      npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame>=60 then
      npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("Attack")

    if sprite:IsEventTriggered("Dash") then
       npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
       npc.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND 
       sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_1 , 1.2, 0, false, 1.1)
       Game():ShakeScreen(5)
       npc.StateFrame = 75
    end

    if sprite:IsEventTriggered("Fall") then
       npc.StateFrame = 25
       npc.Velocity = npc.Velocity * 0.6
    end

    if sprite:IsEventTriggered("Explode") then
       npc.Velocity = npc.Velocity * (5+math.random(1, 3)) + Vector.FromAngle(math.random(0, 360))
       Isaac.Explode(npc.Position, npc, 1.0)
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
       Game():ShakeScreen(16)
       data.Smol = true
    end

    if data.Smol then  
      npc.SizeMulti = npc.SizeMulti - Vector(0.1,0.1)
    end

    if sprite:IsFinished("Attack") then
       npc:Remove()
    end
  end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
end

return this
