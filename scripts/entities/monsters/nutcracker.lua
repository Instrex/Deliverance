local this = {}
this.id = Isaac.GetEntityTypeByName("Nutcracker")
this.variant = Isaac.GetEntityVariantByName("Nutcracker")

function this:behaviour(npc)
  if npc.Variant == this.variant then
    local target = npc:GetPlayerTarget()
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = game:GetRoom()
    if data.goreTimer == nil then data.goreTimer = 0 end
    if data.projectilemode == nil then data.projectilemode = 0 end

    -- Begin --
    if npc.State == NpcState.STATE_INIT then
      npc.State = NpcState.STATE_MOVE
      npc.StateFrame = Utils.choose(-10, -5, 0)


      -- Move and wait for player to get closer --
    elseif npc.State == NpcState.STATE_MOVE then

      if room:CheckLine(npc.Position,target.Position,0,1,false,false) then
        npc.Pathfinder:FindGridPath(target.Position, math.random(5, 7) / 10, 2, false)
      else
        npc.Pathfinder:MoveRandomly(false)
      end

      if npc.Velocity.Y>0 then
        npc:AnimWalkFrame("WalkHori", "WalkVertUp", 0.1)
      else
        npc:AnimWalkFrame("WalkHori", "WalkVertDown", 0.1)
      end

      npc.StateFrame = npc.StateFrame + 1

      if npc.StateFrame>=35 then
        if npc.Position:Distance(target.Position) <= 275 then
          sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.25, 0, false, 0.8)
          npc.State = NpcState.STATE_ATTACK
        end
      end

      -- Chases the player and destroys objects on the way --
    elseif npc.State == NpcState.STATE_ATTACK then

      if npc.Velocity.Y>0 then
        npc:AnimWalkFrame("WalkHoriRage", "WalkVertUpRage", 0.1)
      else
        npc:AnimWalkFrame("WalkHoriRage", "WalkVertDownRage", 0.1)
      end

      if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1.3 + npc.Velocity * 0.875 end

      if sprite:IsEventTriggered("Stop") then
        npc.State = NpcState.STATE_MOVE;
        npc.StateFrame = Utils.choose(-45, -35, -25)
      end

      if sprite:IsEventTriggered("Shake") then
        Game():ShakeScreen(5)
        sfx:Play(SoundEffect.SOUND_POT_BREAK, 0.5, 0, false, math.random(10, 20) / 10)

        for e, food in pairs(Isaac.FindInRadius(npc.Position, 30, EntityPartition.ENEMY)) do
          if food.Type == 10 or food.Type == 13 or food.Type == 18 or food.Type == 222 or food.Type == 256 or food.Type == 281 or food.Type == 296 or food.Type == 80 or food.Type == 14 or food.Type == 85 or food.Type == 94 then
            data.projectilemode = 0
            if food.Type == 10 then
              data.projectilemode = 1
              food.HitPoints = npc.MaxHitPoints
              food:ToNPC():Morph(11, 0, 0,-1)
              for j=1, 9 do
                local params = ProjectileParams()
                params.FallingSpeedModifier = math.random(-28, -4)
                params.FallingAccelModifier = 1.2
                params.Variant = Utils.choose(0, 1)

                local velocity = Vector(Utils.choose(math.random(-5, -1), math.random(1, 5)), Utils.choose(math.random(-5, -1), math.random(1, 5)))
                npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
              end
            end
            data.goreTimer = 100
            food:TakeDamage(10, 0, EntityRef(nil), 0)
            Isaac.Spawn(1000, 49, 0, Vector(npc.Position.X,npc.Position.Y-16), vectorZero, nil)
            sfx:Play(SoundEffect.SOUND_VAMP_GULP , 1.25, 0, false, 0.8)
            npc.HitPoints = npc.MaxHitPoints
            sprite:ReplaceSpritesheet(1,"gfx/monsters/gluttyb.png")
            sprite:LoadGraphics()
          end
        end
      end

      for i = 1, Game():GetRoom():GetGridSize() do
        local grid = room:GetGridEntity(i)
        if grid and (grid.Desc.Type==2 or grid.Desc.Type==3 or grid.Desc.Type==4 or grid.Desc.Type==5 or grid.Desc.Type==6 or grid.Desc.Type==14 or grid.Desc.Type==22) then
          if npc.Position:Distance(grid.Position) <= 42 then
            room:DestroyGrid(i, true)
          end
        end
      end
      if data.goreTimer > 0 then
        data.goreTimer = data.goreTimer - 1
        if data.goreTimer % 20 == 0 then
          for j=1, 3 do
            local params = ProjectileParams()
            params.FallingSpeedModifier = math.random(-28, -4)
            params.FallingAccelModifier = 1.2
            if data.projectilemode == 1 then
              params.Variant = Utils.choose(0, 1)
            elseif data.projectilemode == 0 then
              params.Scale = 0.5
            end

            local velocity = Vector(Utils.choose(math.random(-5, -1), math.random(1, 5)), Utils.choose(math.random(-5, -1), math.random(1, 5)))
            npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
          end
        end
      end
      --[[if data.goreTimer <= 0 then
        data.goreTimer = 100
      end--]]
    end
  end
end

--function this:transformation(npc)
--  if utils.chancep(20) then
--    npc:Morph(this.id, 0, 0, 0)
--  end
--end

--[[function this:die(npc)
sfx:Play(SoundEffect.SOUND_MEAT_IMPACTS, 0.9, 0, false, 1)
for j=1, 9 do
  local params = ProjectileParams()
  params.FallingSpeedModifier = math.random(-28, -4)
  params.FallingAccelModifier = 1.2
  params.Variant = Utils.choose(0, 1)

  local velocity = Vector(Utils.choose(math.random(-5, -1), math.random(1, 5)), Utils.choose(math.random(-5, -1), math.random(1, 5)))
  npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
end
end--]]

function this.Init()
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 16)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this