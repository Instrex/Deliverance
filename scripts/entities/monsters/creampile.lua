local this = {}
this.id = Isaac.GetEntityTypeByName("Creampile")
this.variant = Isaac.GetEntityVariantByName("Creampile")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  local level = game:GetLevel()
  local stage = level:GetStage()

  if data.hits == nil then data.hits = 1 end
  if data.creampileSet == nil then data.creampileSet = Utils.choose(0, 1, 2, 3, 4, 5) end
  if data.cpFirst == nil then data.cpFirst=1 end 
  if data.cpSecond == nil then data.cpSecond=2 end 
  if data.cpLast == nil then data.cpLast=3 end
  if data.creampileSet == 0 then data.cpFirst=1 data.cpSecond=2 data.cpLast=3 end
  if data.creampileSet == 1 then data.cpFirst=2 data.cpSecond=3 data.cpLast=1 end
  if data.creampileSet == 2 then data.cpFirst=3 data.cpSecond=1 data.cpLast=2 end
  if data.creampileSet == 3 then data.cpFirst=1 data.cpSecond=3 data.cpLast=2 end
  if data.creampileSet == 4 then data.cpFirst=2 data.cpSecond=1 data.cpLast=3 end
  if data.creampileSet == 5 then data.cpFirst=3 data.cpSecond=2 data.cpLast=1 end
  if data.thisHead == nil then data.thisHead = data.cpFirst end
  sprite:ReplaceSpritesheet(0, "gfx/monsters/cream" .. data.cpFirst .. "pile.png") sprite:ReplaceSpritesheet(1, "gfx/monsters/cream" .. data.cpSecond .. "pile.png") sprite:ReplaceSpritesheet(2, "gfx/monsters/cream" .. data.cpLast .. "pile.png")
  sprite:LoadGraphics()

  npc.Velocity = vectorZero
  
  if data.hits==1 and npc.HitPoints<30 and npc.HitPoints>=15 then npc.State = NpcState.STATE_ATTACK2 data.hits=2 data.thisHead=data.cpSecond end
  if data.hits==2 and npc.HitPoints<15 then npc.State = NpcState.STATE_ATTACK2 data.hits=3 data.thisHead=data.cpLast end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE;
    npc.StateFrame = Utils.choose(5, 15, 25)
  
  elseif npc.State == NpcState.STATE_IDLE then

    sprite:Play("Idle" .. data.hits .. "");
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=50 then
      npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    sprite:Play("Attack" .. data.hits .. "");

    if sprite:IsFinished("Attack" .. data.hits .. "") then
      npc.State = NpcState.STATE_IDLE
      npc.StateFrame = Utils.choose(-15, -10, -5, 0, 5)
    end

    if sprite:IsEventTriggered("Shoot") then
       if data.thisHead==1 then
        for i=1, Utils.choose(1, 2) do
         local params = ProjectileParams() 
         params.FallingSpeedModifier = math.random(-14, -10) 
         params.FallingAccelModifier = 1.2 
         params.Variant = 1

         local velocity = (target.Position - npc.Position):Rotated(math.random(-15, 15)) * 0.06 * 1.2
         local length = velocity:Length() 
         if length > 12 then 
           velocity = (velocity / length) * 12
         end 
         npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
        end
        sfx:Play(SoundEffect.SOUND_WHEEZY_COUGH, 1, 0, false, 1)
       end
       if data.thisHead==2 then
        local rnd = math.random(-10, 10)
        for i=1, 4 do
         Isaac.Spawn(9, 3, 0, npc.Position, Vector.FromAngle(45+i*90+rnd):Resized(10), npc)
        end
        sfx:Play(SoundEffect.SOUND_FART, 1.25, 0, false, 1.2)
       end
       if data.thisHead==3 then
         sfx:Play(SoundEffect.SOUND_BLOODSHOOT, 1.25, 0, false, 0.8)
         local prj = Isaac.Spawn(9, 0, 0, Vector(npc.Position.X,npc.Position.Y), (utils.vecToPos(target.Position, npc.Position) * math.random(7,9)):Rotated(math.random(-16, 16)), npc):ToProjectile()
          prj:AddProjectileFlags(ProjectileFlags.SMART)
          prj.Scale = Utils.choose(2.75, 3, 3.25, 3.5)
       end
    end

    if sprite:IsEventTriggered("Grunt") then
       sfx:Play(SoundEffect.SOUND_FAT_GRUNT , 1, 0, false, 1.12)
    end

    if sprite:IsEventTriggered("MeatLand") then
        sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 1.2, 0, false, 1)
    end

  elseif npc.State == NpcState.STATE_ATTACK2 then

    sprite:Play("Death" .. data.hits .. "")

    if sprite:IsFinished("Death" .. data.hits .. "") then
      npc.State = NpcState.STATE_IDLE
      npc.StateFrame = 49
    end

    if sprite:IsEventTriggered("Death") then
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
       local RCreep = Isaac.Spawn(1000, 77, 0, npc.Position, vectorZero, player)
       RCreep.SpriteScale = Vector(0.6,0.6)
    end
  end
 end
end

function this:die(npc)
 if npc.Variant == this.variant then
    sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
    local RCreep = Isaac.Spawn(1000, 77, 0, npc.Position, vectorZero, player)
    RCreep.SpriteScale = Vector(0.85,0.85)
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
