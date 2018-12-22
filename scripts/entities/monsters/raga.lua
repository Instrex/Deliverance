local this = {}
this.id = Isaac.GetEntityTypeByName("Raga")
this.variant = Isaac.GetEntityVariantByName("Raga")

local sfx = SFXManager()
function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE

  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_MOVE then
    sprite:Play("Fly")
    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 4 end

    if utils.chancep(4) then
      sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_0 , 1.2, 0, false, 1)
      npc.State = NpcState.STATE_ATTACK
    end

  -- Play charge animation and select attack --
  elseif npc.State == NpcState.STATE_ATTACK then
    sprite:Play("Charge")
    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 2 end

    if sprite:IsFinished("Charge") then
      npc.State = utils.choose(NpcState.STATE_ATTACK2, NpcState.STATE_ATTACK3)
    end

  -- Perform first attack: spawn some files --
  elseif npc.State == NpcState.STATE_ATTACK2 then
    sprite:Play("Summon")

    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) end
    if npc.StateFrame == 0 then
      sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A , 0.8, 0, false, 1)

      for i = 0, math.random(1, 2), 1 do
        Isaac.Spawn(222, 0, 0, npc.Position, Vector.FromAngle(math.random(1, 359)) * math.random(5, 10), nil);
      end

      npc.StateFrame = 1

    elseif sprite:IsFinished("Summon") then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = 0

    end

  -- Perform second attack: shoot purple homing tears --
  elseif npc.State == NpcState.STATE_ATTACK3 then
    sprite:Play("Attack")

    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) end
    if npc.StateFrame == 0 then
      sfx:Play(SoundEffect.SOUND_RAGMAN_1 , 1, 0, false, 1)

      for w = -1, 1, 2 do
        for q = -1, 1, 2 do
          local prj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 6, 0, npc.Position, Vector(7.5 * w, 7.5 * q), npc):ToProjectile()
          prj:AddProjectileFlags(ProjectileFlags.SMART)
          prj:AddHeight(-20)
        end
      end

      npc.StateFrame = 1

    elseif sprite:IsFinished("Attack") then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = 0

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
    Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), player).Color = Color(0, 0, 0, 1, 90, 0, 90)
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 252)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
