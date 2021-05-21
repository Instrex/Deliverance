local this = {}
this.id = Isaac.GetEntityTypeByName("Gelatino")

function this:behaviour(npc)
 if npc.Variant == Isaac.GetEntityVariantByName("Gelatino") or npc.Variant == Isaac.GetEntityVariantByName("Mini Gelatino") then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()

  if data.RealHp == nil then data.RealHp = npc.HitPoints end

  local level = game:GetLevel()
  local stage = level:GetStage()

  npc:AddEntityFlags(EntityFlag.FLAG_NO_DEATH_TRIGGER)

  if npc.Variant == 4000 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino.png")
    if stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino_blue.png")
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino_red.png")
    elseif stage == LevelStage.STAGE5 or stage == LevelStage.STAGE6 or stage == LevelStage.STAGE7 or (stage == LevelStage.STAGE5_GREED or stage == LevelStage.STAGE6_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino2_gray.png")
    end
    sprite:ReplaceSpritesheet(1,"gfx/monsters/gelatino.png")
    sprite:LoadGraphics()
  elseif npc.Variant == 4001 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino2.png")
    if stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino2_blue.png")
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino2_red.png")
    elseif stage == LevelStage.STAGE5 or stage == LevelStage.STAGE6 or stage == LevelStage.STAGE7 or (stage == LevelStage.STAGE5_GREED or stage == LevelStage.STAGE6_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
        sprite:ReplaceSpritesheet(0,"gfx/monsters/gelatino2_gray.png")
    end
    sprite:ReplaceSpritesheet(1,"gfx/monsters/gelatino2.png")
    sprite:LoadGraphics()
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    if data.color == nil then data.color = Color(0, 0, 0, 0.75, 58/255, 140/255, 122/255) end
    if data.tearColor == nil then data.tearColor = Color(0, 0, 0, 1, 116/255, 280/255, 244/255) end
    if data.GridCountdown == nil then data.GridCountdown = 0 end

    if stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
       data.color = Color(0, 0, 0, 0.75, 58/255, 79/255, 140/255)
       data.tearColor = Color(0, 0, 0, 1, 87/255, 119/255, 210/255)
    elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
       data.color = Color(0, 0, 0, 0.75, 171/255, 47/255, 60/255)
       data.tearColor = Color(0, 0, 0, 1, 256/255, 64/255, 90/255)
    elseif stage == LevelStage.STAGE5 or stage == LevelStage.STAGE6 or stage == LevelStage.STAGE7 or (stage == LevelStage.STAGE5_GREED or stage == LevelStage.STAGE6_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
       data.color = Color(0, 0, 0, 0.75, 101/255, 71/255, 96/255)
       data.tearColor = Color(0, 0, 0, 1, 152/255, 104/255, 144/255)
    else
       data.color = Color(0, 0, 0, 0.75, 58/255, 140/255, 122/255)
       data.tearColor = Color(0, 0, 0, 1, 87/255, 210/255, 183/255)
    end
 
    if data.roll == nil then data.roll = npc:GetDropRNG():RandomInt(99) end
      if data.roll<10 then sprite:Play("WithSack");
        elseif data.roll<25 then sprite:Play("WithCoins");
        elseif data.roll<40 then sprite:Play("WithBombs");
        elseif data.roll<55 then sprite:Play("WithKeys");
        elseif data.roll<75 then sprite:Play("WithBoney");
        elseif data.roll<95 then sprite:Play("WithHeart");
        elseif data.roll==95 then sprite:Play("WithLibertyCap");
        elseif data.roll==96 then sprite:Play("WithCursedSkull");
        elseif data.roll==97 then sprite:Play("WithCallus");
        elseif data.roll>97 then sprite:Play("WithTick");
      end
    npc.State = NpcState.STATE_MOVE
  elseif npc.State == NpcState.STATE_MOVE then

    if not target:IsDead() then 
       if npc:CollidesWithGrid() or data.GridCountdown > 0 then
          npc.Pathfinder:FindGridPath(target.Position, 0.85, 1, false)
          if data.GridCountdown <= 0 then
              data.GridCountdown = 30
          else
              data.GridCountdown = data.GridCountdown - 1
          end
       else
          if npc.Variant == Isaac.GetEntityVariantByName("Gelatino") then
             npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 0.9 + npc.Velocity * 0.85 
          elseif npc.Variant == Isaac.GetEntityVariantByName("Mini Gelatino") then
             npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1.06 + npc.Velocity * 0.85
          end
       end
    end

    if utils.chancep(33) then
      local Creep = Isaac.Spawn(1000, 7, 0, npc.Position, vectorZero, nil)
      Creep.Color = data.color
      Creep:Update()
    end
  end  

  if data.dead then
    npc.State = NpcState.STATE_UNIQUE_DEATH;
    npc.StateFrame = -666
    npc.Velocity = vectorZero


    sprite:Play("Death");

    if sprite:IsFinished("Death") then
       npc:Remove()
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1, 0, false, 1)
       local Creep = Isaac.Spawn(1000, 77, 0, npc.Position, vectorZero, npc)
       Creep.Color = data.color
       Creep.SpriteScale = Vector(0.75,0.75) 
       for i=1, 8 do
          if npc.Variant == 4000 then Isaac.Spawn(9, 6, 0, npc.Position, Vector.FromAngle(i*45):Resized(10), npc).Color = data.tearColor end
       end
       for i=1, 4 do
          if npc.Variant == 4001 then Isaac.Spawn(9, 6, 0, npc.Position, Vector.FromAngle(45+i*90):Resized(10), npc).Color = data.tearColor end
       end
    end
  end
 end
end

function this:onHitNPC(npc, dmgAmount, flags, source, frames)
 if (npc.Variant == Isaac.GetEntityVariantByName("Gelatino") or npc.Variant == Isaac.GetEntityVariantByName("Mini Gelatino")) and npc.Type == this.id then
  local data = npc:GetData()
    if data.RealHp == nil then
      data.RealHp = npc.HitPoints
    end
    data.RealHp = data.RealHp - dmgAmount
    if data.RealHp <= 0 and not data.dead then
       data.dead=true
       npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
       sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
       if data.roll<10 then Isaac.Spawn(5, 69, 0, npc.Position, vectorZero, player);
         elseif data.roll<25 then if npc.Variant == 4000 then Isaac.Spawn(5, 20, 4, npc.Position, vectorZero, player) elseif npc.Variant == 4001 then Isaac.Spawn(5, 20, 1, npc.Position, vectorZero, player) end
         elseif data.roll<40 then if npc.Variant == 4000 then Isaac.Spawn(5, 40, 2, npc.Position, vectorZero, player) elseif npc.Variant == 4001 then Isaac.Spawn(5, 40, 1, npc.Position, vectorZero, player) end
         elseif data.roll<55 then if npc.Variant == 4000 then Isaac.Spawn(5, 30, 3, npc.Position, vectorZero, player) elseif npc.Variant == 4001 then Isaac.Spawn(5, 30, 1, npc.Position, vectorZero, player) end
         elseif data.roll<75 then if npc.Variant == 4000 then Isaac.Spawn(227, 0, 0, npc.Position, vectorZero, player) elseif npc.Variant == 4001 then Isaac.Spawn(215, 0, 0, npc.Position, vectorZero, player) end
         elseif data.roll<95 then if npc.Variant == 4000 then Isaac.Spawn(92, 0, 0, npc.Position, vectorZero, player) elseif npc.Variant == 4001 then Isaac.Spawn(26, 1, 0, npc.Position, vectorZero, player) end
         elseif data.roll==95 then Isaac.Spawn(5, 350, 32, npc.Position, vectorZero, npc);
         elseif data.roll==96 then Isaac.Spawn(5, 350, 43, npc.Position, vectorZero, player);
         elseif data.roll==97 then Isaac.Spawn(5, 350, 14, npc.Position, vectorZero, player) 
         elseif data.roll>97 then Isaac.Spawn(5, 350, 53, npc.Position, vectorZero, player);
       end
       return false
    end
 end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this