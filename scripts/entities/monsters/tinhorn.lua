local this = {}
this.id = Isaac.GetEntityTypeByName("Tinhorn")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  if sprite:IsEventTriggered("ChangeColToNone") then
     npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
  end

  if sprite:IsEventTriggered("ChangeColToAll") then
     npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
  end

  if sprite:IsEventTriggered("WaterSound") then
     sfx:Play(212, 1.25, 0, false, math.random(8, 12) / 10)
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
    npc.State = NpcState.STATE_ATTACK4; npc.StateFrame = 0
    sprite:Play("Trick")
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
 

  elseif npc.State == NpcState.STATE_ATTACK then

    npc.StateFrame = npc.StateFrame + 1
    if npc.StateFrame<8 then npc.Velocity = Vector(0,0) end
    if npc.StateFrame==8 then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 4 end

    if sprite:IsEventTriggered("Scream") then
       sfx:Play(12, 1.25, 0, false, 0.8)
    end

    if sprite:IsEventTriggered("Shoot") then
       local params = ProjectileParams() 
       params.FallingSpeedModifier = math.random(-18, -14) 
       params.FallingAccelModifier = 1.2 
       params.Variant = 4

       local velocity = (target.Position - npc.Position):Rotated(math.random(-15, 15)) * 0.05 * 12 * 0.1
       local length = velocity:Length() 
       if length > 12 then 
         velocity = (velocity / length) * 12
       end 
       npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y-4), velocity, 0, params)
       sfx:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1)
    end

    if sprite:IsFinished("Attack") then
       if utils.chancep(80) then npc.State = NpcState.STATE_ATTACK2 sprite:Play("Attack2") else npc.State = NpcState.STATE_ATTACK3 sprite:Play("Attack3") end
    end

    if sprite:IsFinished("AttackUp") then
       if utils.chancep(80) then npc.State = NpcState.STATE_ATTACK2 sprite:Play("Attack2Up") else npc.State = NpcState.STATE_ATTACK3 sprite:Play("Attack3Up") end
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then

    npc.StateFrame = npc.StateFrame + 1
    if npc.StateFrame>38 then npc.Velocity = Vector(0,0) end

    if sprite:IsFinished("Attack2") or sprite:IsFinished("Attack2Up") then
       npc.Position = room:FindFreePickupSpawnPosition(npc.Position, 150, true)
       
       if utils.chancep(75) then
          npc.State = NpcState.STATE_ATTACK npc.StateFrame = 0
          if target.Position.Y>npc.Position.Y then sprite:Play("Attack") else sprite:Play("AttackUp") end
       else
          npc.State = NpcState.STATE_ATTACK4 npc.StateFrame = 0
          sprite:Play("Trick")
       end
    end

    if sprite:IsEventTriggered("ChangePower") then npc.Velocity = Vector(0,0) end

  elseif npc.State == NpcState.STATE_ATTACK3 then

    npc.StateFrame = npc.StateFrame + 1
    if npc.StateFrame>38 then npc.Velocity = Vector(0,0) end

    if sprite:IsEventTriggered("Mine") then
       sfx:Play(139, 1.25, 0, false, 1)
    end

    if sprite:IsFinished("Attack3") or sprite:IsFinished("Attack3Up") then
       for i=12, 24 do
         local params = ProjectileParams() 
         params.FallingSpeedModifier = math.random(-18, -14) 
         params.FallingAccelModifier = 1.2 
         params.Variant = 4

         local velocity = Vector(Utils.choose(math.random(-10, -1), math.random(1, 8)), Utils.choose(math.random(-10, -1), math.random(1, 8)))

         npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
       end
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
       Isaac.Spawn(1000, 34, 0, npc.Position, Vector(0, 0), player).Color = Color(0, 0, 0, 1, 132, 163, 244)
       npc:Remove()
    end
  elseif npc.State == NpcState.STATE_ATTACK4 then

    npc.Velocity = Vector(0,0)

    if sprite:IsFinished("Trick") then
       npc.Position = room:FindFreePickupSpawnPosition(npc.Position, 150, true)
       npc.State = NpcState.STATE_ATTACK npc.StateFrame = 0
       if target.Position.Y>npc.Position.Y then sprite:Play("Attack") else sprite:Play("AttackUp") end
    end

    if sprite:IsEventTriggered("Derp") then
       sfx:Play(197, 1.25, 0, false, math.random(9, 11) / 10)
    end

    if sprite:IsEventTriggered("ChangePower") then npc.Velocity = Vector(0,0) end
  end
end

function this:die(npc)       
    for i=4, 8 do
       local params = ProjectileParams() 
       params.FallingSpeedModifier = math.random(-18, -14) 
       params.FallingAccelModifier = 1.2 
       params.Variant = 4

       local velocity = Vector(Utils.choose(math.random(-8, -1), math.random(1, 8)), Utils.choose(math.random(-8, -1), math.random(1, 8)))

       npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
    end
    sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
    Isaac.Spawn(1000, 34, 0, npc.Position, Vector(0, 0), player).Color = Color(0, 0, 0, 1, 132, 163, 244)
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
