local this = {}
this.id = Isaac.GetEntityTypeByName("Grilly")
this.variant = Isaac.GetEntityVariantByName("Grilly")

function this:behaviour(npc)
  if npc.Variant == this.variant then
    local target = npc:GetPlayerTarget()
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = game:GetRoom()
	
	npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)

    --Begin--
    if npc.State == NpcState.STATE_INIT then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(0, 10, 20)
      -- Move and attack--

    elseif npc.State == NpcState.STATE_MOVE then
			if data.GridCountdown == nil then data.GridCountdown = 0 end
			if npc:CollidesWithGrid() or data.GridCountdown > 0 then
        npc.Pathfinder:FindGridPath(target.Position, 0.8, 1, false)
        if data.GridCountdown <= 0 then
          data.GridCountdown = 45
        else
          data.GridCountdown = data.GridCountdown - 1
        end
      else
        npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1 + npc.Velocity * 0.8
		end
			npc:AnimWalkFrame("WalkHori", "WalkVert", 0,1)
			if npc.Position:Distance(target.Position) <= 200 then
        npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
      end
      npc.StateFrame = npc.StateFrame + Utils.choose(0, 1)
			if npc.StateFrame >= 100 then
				npc.State = NpcState.STATE_ATTACK
			end

      elseif npc.State == NpcState.STATE_ATTACK then

        npc.Velocity = npc.Velocity * 0.85

        sprite:Play("Shoot");

        if sprite:IsEventTriggered("Hmm") then
          sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_2 , 1.2, 0, false, 1)
        end
		 if sprite:IsEventTriggered("Roar") then
          sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A, 1, 0, false, 1)
        end
        if sprite:IsEventTriggered("Shoot") then
          if (target.Position - npc.Position).X > 0 then
            npc:GetSprite().FlipX = true
          else
            npc:GetSprite().FlipX = false
          end
          npc.Velocity = vectorZero
      for i= 1,3 do
      local prj = Isaac.Spawn(9,0,0,Vector(npc.Position.X, npc.Position.Y),(utils.vecToPos(target.Position, npc.Position) * math.random(5,13)):Rotated(math.random(-16, 16)),npc):ToProjectile()
        if Utils.chancep(30) then
          prj:AddProjectileFlags(ProjectileFlags.EXPLODE)
        end
        prj.Scale = math.random(80, 160) * 0.01
        prj.FallingSpeed = -4
		prj:SetColor(Color(1, 1, 1, 2, 255, 140, 0), 10, 10, true, false)
        sfx:Play(SoundEffect.SOUND_BOSS2_BUBBLES, ((math.random(170, 190))/180), 0, false, ((math.random(220, 240))/180))
       end 
      end  
        if(sprite:IsFinished("Shoot")) then
          npc.State = NpcState.STATE_MOVE;
          npc.StateFrame = Utils.choose(0, 10, 20)
         end
      end
   end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_,prj)
  if prj.SpawnerType == this.id and prj.SpawnerVariant == this.variant then
    local InitSpeed = prj.Velocity
    prj.Velocity = InitSpeed * 0.95
    if prj:IsDead() and prj.ProjectileFlags == ProjectileFlags.EXPLODE then
      local fire = Isaac.Spawn(1000,51,0, prj.Position, vectorZero,prj)
      fire.SpriteScale = Vector(0.75,0.75)
      local fireData = fire:GetData()
      fireData.damageFire = true
    end
  end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect) --taked from REVELATIONS mod :v
  local data = effect:GetData()
  if data.damageFire then
    effect:GetSprite().Color = Color(1,0.65,0.32,1,0,0,0)
    if effect.FrameCount == 360 then
      effect:Remove()
    end
    local player = Isaac.GetPlayer(0)
    local dis = player.Position:Distance(effect.Position)
    local sizeCheck = player.Size + effect.Size
    if dis < sizeCheck then
      player:TakeDamage(1, 0, EntityRef(effect), 30)
    end
  end
end)

function this:onHitNPC(npc, dmgAmount, flags, source, frames)
  if npc.Variant == Isaac.GetEntityVariantByName("Grilly") then
   local data = npc:GetData()
   if npc.Type == this.id then
   if flags == DamageFlag.DAMAGE_EXPLOSION then
     return false
   elseif flags == DamageFlag.DAMAGE_FIRE then
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