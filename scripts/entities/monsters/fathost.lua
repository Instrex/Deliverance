local this = {}
this.id = Isaac.GetEntityTypeByName("Fat Host")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
  npc.Velocity = Vector(0,0)

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE;
    npc.StateFrame = Utils.choose(-10, -5, 0)
  
  -- Seek for a moment to attack --
  elseif npc.State == NpcState.STATE_IDLE then

    sprite:Play("Idle");
    if npc.Position:Distance(target.Position) <= 150 then
       npc.StateFrame = npc.StateFrame + 1
    end
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=50 then
      npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    sprite:Play("Shoot")

    if sprite:IsEventTriggered("Cough") then
       sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.1, 0, false, 0.8)
    end

    if sprite:IsEventTriggered("Attack") then 
       for i=1, 8 do
          local params = ProjectileParams() 
          params.FallingSpeedModifier = math.random(-28, -4) 
          params.FallingAccelModifier = 1.2 

          local velocity = Vector(Utils.choose(math.random(-6, -1), math.random(1, 6)), Utils.choose(math.random(-6, -1), math.random(1, 6))):Rotated(math.random(-30, 30))
          npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)

          local velocity2 = (target.Position - npc.Position):Rotated(math.random(-10, 10)) * 0.05 * 9 * 0.1
          npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y-4), velocity2, 0, params)
       end
       Game():ShakeScreen(20) 
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 1, 0, false, 1) 
    end

    if sprite:IsFinished("Shoot") then
      npc.State = NpcState.STATE_IDLE
      npc.StateFrame = Utils.choose(-15, -10, -5)
    end
  end
end

function this:die(npc)
    sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
    Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), player).Color = Color(0, 0, 0, 1, 69, 56, 52)
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
