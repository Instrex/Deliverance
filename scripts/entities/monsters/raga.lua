local this = {}
this.id = Isaac.GetEntityTypeByName("Raga")
this.variant = Isaac.GetEntityVariantByName("Raga")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-24, -6, 12)

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_MOVE then
    sprite:Play("Idle")
    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1 + npc.Velocity * 0.825 end

    npc.StateFrame = npc.StateFrame + 1
    if npc.StateFrame>=60 then
      sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_2 , 1.2, 0, false, 1)
      npc.State = utils.choose(NpcState.STATE_ATTACK, NpcState.STATE_ATTACK2)
    end

  -- Spit Attack --
  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("Spit")
    if npc.StateFrame < 70 then 
       if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1 + npc.Velocity * 0.825 end
    end

    if sprite:IsEventTriggered("ShootRoar") then
       npc.StateFrame = 70
       sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A, 1, 0, false, 1)
       npc.Velocity = npc.Velocity - utils.vecToPos(target.Position, npc.Position) * 8
    end

    if sprite:IsEventTriggered("Shoot") then
       for i=1, 2 do
          local prj = Isaac.Spawn(9, 0, 0, Vector(npc.Position.X,npc.Position.Y + 7.5), (utils.vecToPos(target.Position, npc.Position) * math.random(10,13)):Rotated(math.random(-16, 16)), npc):ToProjectile()
          prj:AddProjectileFlags(ProjectileFlags.SMART)
          prj:AddProjectileFlags(ProjectileFlags.BOOMERANG)
          prj:AddProjectileFlags(ProjectileFlags.NO_WALL_COLLIDE )
          prj.Scale = Utils.choose(0.8, 1, 1.2)
       end

       sfx:Play(SoundEffect.SOUND_WORM_SPIT, 1, 0, false, 1.5)
    end

    if sprite:IsFinished("Spit") then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(-24, -6, 12)
    end

  -- Flamethrower --
  elseif npc.State == NpcState.STATE_ATTACK2 then
    sprite:Play("Firethrower")
    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1.25 + npc.Velocity * 0.825 end
 
    if sprite:IsEventTriggered("Blurb") then
       npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
       sfx:Play(SoundEffect.SOUND_SINK_DRAIN_GURGLE, 1, 0, false, 1)
    end

    if sprite:IsEventTriggered("FireStart") then
       npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
       sfx:Play(Isaac.GetSoundIdByName("Firethrower"), 0.8, 0, false, 1)
    end

    if sprite:IsEventTriggered("Fire") then
       local params = ProjectileParams() 
       params.Variant = 2
       params.Scale = Utils.choose(0.8, 1, 1.2)

       local velocity = Vector(Utils.choose(math.random(-4, -1), math.random(1, 4)), Utils.choose(math.random(-4, -1), math.random(1, 4))):Rotated(math.random(-30, 30))
       npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y+25), velocity, 0, params)

--     sfx:Play(SoundEffect.SOUND_SINK_DRAIN_GURGLE, 1, 0, false, 1)
--     sfx:Play(43, 0.8, 0, false, math.random(8, 12) / 10)
    end

    if sprite:IsFinished("Firethrower") then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(-12, -8, -4)
    end
  end
 end
end

--function this:transformation(npc)
--  if utils.chancep(20) then
--    npc:Morph(this.id, 0, 0, 0)
--  end
--end

function this:die(npc)
 if npc.Variant == this.variant then
    Isaac.Spawn(1000, 77, 0, npc.Position, vectorZero, player).Color = Color(0, 0, 0, 1, 90, 0, 90)
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 252)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
