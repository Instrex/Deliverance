local this = {}
this.id = Isaac.GetEntityTypeByName("Fat Host")

function this:behaviour(npc)
 if npc.Variant == Isaac.GetEntityVariantByName("Fat Host") or npc.Variant == Isaac.GetEntityVariantByName("Red Fat Host") then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
  npc.Velocity = vectorZero

  if npc.Variant == 4000 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/fathost.png")
    sprite:LoadGraphics()
  elseif npc.Variant == 4001 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/redFathost.png")
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE;
    npc.StateFrame = Utils.choose(0, 5, 10)
    if data.Shielded == nil then data.Shielded = true end
    if data.HTimer == nil then data.HTimer = 0 end
  
  -- Seek for a moment to attack --
  elseif npc.State == NpcState.STATE_IDLE then
    sprite:Play("Idle");
    if npc.Position:Distance(target.Position) <= 240 then
       data.HTimer = data.HTimer + 1
    end

    if data.HTimer>=24 then
      npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    sprite:Play("Shoot")

    if sprite:IsEventTriggered("CanBeAttacked") then
       sfx:Play(SoundEffect.SOUND_MEAT_JUMPS , 1.1, 0, false, 0.8)
       data.Shielded = false
    end

    if sprite:IsEventTriggered("CantBeAttacked") then
       data.Shielded = true
    end

    if sprite:IsEventTriggered("Attack") then 
       for i=1, 8 do
          local params = ProjectileParams() 
          params.FallingSpeedModifier = math.random(-28, -4) 
          params.FallingAccelModifier = 1.2 

          local velocity = Vector(Utils.choose(math.random(-6, -1), math.random(1, 6)), Utils.choose(math.random(-6, -1), math.random(1, 6))):Rotated(math.random(-30, 30))
          npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)

          local velocity2 = (target.Position - npc.Position):Rotated(math.random(-10, 10)) * 0.05 * 9 * 0.1
          if npc.Variant == 4001 then 
             velocity2 = (target.Position - npc.Position):Rotated(math.random(-10, 10)) * 0.05 * 11 * 0.1
          end
          npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y-4), velocity2, 0, params)
       end
       Game():ShakeScreen(20) 
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 1, 0, false, 1) 
    end

    if sprite:IsFinished("Shoot") then
      npc.State = NpcState.STATE_IDLE
      data.HTimer  = math.random(-45, -25) 
    end
  end
 end
end

function this:onHitNPC(npc)
 if npc.Type == Isaac.GetEntityTypeByName("Fat Host") then
 if npc.Variant == Isaac.GetEntityVariantByName("Fat Host") or npc.Variant == Isaac.GetEntityVariantByName("Red Fat Host") then
  local data = npc:GetData()
  if npc.Type == this.id and npc.Variant == Isaac.GetEntityVariantByName("Fat Host") then
    if npc.State == NpcState.STATE_IDLE or data.Shielded then
--    data.HTimer = math.random(-10, 5) 
--    data.HTimer = data.HTimer - 5
      return false
    end
  end
 end
 end
end

function this:die(npc)
 if npc.Variant == Isaac.GetEntityVariantByName("Fat Host") or npc.Variant == Isaac.GetEntityVariantByName("Red Fat Host") then
    sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
    Isaac.Spawn(1000, 77, 0, npc.Position, vectorZero, player)
    Game():ShakeScreen(10) 
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
