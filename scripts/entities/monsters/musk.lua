local this = {}
this.id = Isaac.GetEntityTypeByName("Musk")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

  if npc.Variant == 4000 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/musk.png")
    sprite:ReplaceSpritesheet(1,"gfx/monsters/musk.png")
    sprite:LoadGraphics()
  elseif npc.Variant == 4001 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/dusk.png")
    sprite:ReplaceSpritesheet(1,"gfx/monsters/dusk.png")
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE;
    npc.StateFrame = Utils.choose(-10, -5, 0)
  
  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_IDLE then

    sprite:Play("Flying");
    if npc.Position:Distance(target.Position) <= 150 then
       npc.StateFrame = npc.StateFrame + 1
    end
    npc.StateFrame = npc.StateFrame + 1
    
    if target.Position.X<npc.Position.X then sprite.FlipX=true else sprite.FlipX=false end

    if not target:IsDead() and npc.StateFrame>0 then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * (1+npc.StateFrame/22) end

    if npc.StateFrame>=30 and sprite:IsEventTriggered("Char") then
      npc.State = NpcState.STATE_ATTACK
      sfx:Play(SoundEffect.SOUND_LOW_INHALE , 1, 0, false, 1) 
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    if npc.Variant == 4000 then sprite:Play("FlyingCharge") else sprite:Play("FlyingChargePurple") end
    
    if not target:IsDead() and npc.StateFrame>0 then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * (1+npc.StateFrame/22) end
    if target.Position.X<npc.Position.X then sprite.FlipX=true else sprite.FlipX=false end
    if npc.StateFrame>0 then npc.StateFrame = npc.StateFrame - 3 end

    if sprite:IsFinished("FlyingCharge") or sprite:IsFinished("FlyingChargePurple") then
      npc.State = NpcState.STATE_ATTACK2
      sfx:Play(SoundEffect.SOUND_GHOST_ROAR , 1, 0, false, 1) 
      npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 25
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then

    sprite:Play("Charge")

    local room = game:GetRoom()
    if npc:CollidesWithGrid() then
        for i=10, 20 do
           local params = ProjectileParams() 
           params.FallingSpeedModifier = math.random(-28, -14) 
           params.FallingAccelModifier = 1.2 
           local velocity = (target.Position - npc.Position):Rotated(math.random(-18, 18)) * 0.05 * math.random(6, 13) * 0.1
           if npc.Variant == 4001 then 
             params.BulletFlags = ProjectileFlags.SMART 
             velocity = (target.Position - npc.Position):Rotated(math.random(-16, 16)) * 0.05 * math.random(4, 10) * 0.1
           end
           npc:FireProjectiles(npc.Position + utils.vecToPos(target.Position, npc.Position, 36), velocity, 0, params)
        end
        npc.State = NpcState.STATE_ATTACK3
        Game():ShakeScreen(20) 
        sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
        sfx:Play(SoundEffect.SOUND_SATAN_HURT , 1, 0, false, 1) 
        npc.Velocity = Vector(0,0)
    end

  elseif npc.State == NpcState.STATE_ATTACK3 then
 
    sprite:Play("Shock")
    npc.Velocity = Vector(0,0)
    if sprite:IsFinished("Shock") then
      npc.State = NpcState.STATE_IDLE
    end
  end
end

function this:die(npc)
    sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
    local prj = Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), player)
    if npc.Variant == 4001 then prj.Color = Color(0, 0, 0, 1, 90, 0, 90) end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
