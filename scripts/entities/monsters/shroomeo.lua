local this = {}
this.id = Isaac.GetEntityTypeByName("Shroomeo")
this.variant = Isaac.GetEntityVariantByName("Shroomeo")

local sfx = SFXManager()
function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  local level = game:GetLevel()
  local stage = level:GetStage()
  if stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
    sprite:ReplaceSpritesheet(0, "gfx/monsters/shroomeo_depths.png")
    sprite:LoadGraphics()
  end

  npc.Velocity = Vector(0,0)

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE;
    npc.StateFrame = Utils.choose(10, 15, 20)
  
  -- Move and seek for a moment to attack --
  elseif npc.State == NpcState.STATE_IDLE then

    sprite:Play("Idle");
    if npc.Position:Distance(target.Position) <= 150 then
       npc.StateFrame = npc.StateFrame + 1
    end
    npc.StateFrame = npc.StateFrame + 1

    if npc.StateFrame>=50 and sprite:IsEventTriggered("Transit") then
      if utils.chancep(85) then npc.State = NpcState.STATE_ATTACK else npc.State = NpcState.STATE_ATTACK2 end
    end

  elseif npc.State == NpcState.STATE_ATTACK then

    sprite:Play("Attack")

    if sprite:IsEventTriggered("Cough") then
       sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.1, 0, false, 0.8)
    end

    if sprite:IsEventTriggered("Wave") then 
       sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1) 
       local t = Isaac.Spawn(1000, 1, 0, npc.Position+Vector(math.cos(math.rad((target.Position-npc.Position):GetAngleDegrees()))*15,math.sin(math.rad((target.Position-npc.Position):GetAngleDegrees()))*15-20), Vector(math.cos(math.rad((target.Position-npc.Position):GetAngleDegrees()))*15,math.sin(math.rad((target.Position-npc.Position):GetAngleDegrees()))*15), npc) 
       t.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY 
       t.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND 
       t:GetData().Shroomwave = true 
       t.Visible = false 
       Game():ShakeScreen(20) 
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND , 1, 0, false, 1) 
    end

    if sprite:IsFinished("Attack") then
      npc.State = NpcState.STATE_IDLE
      npc.StateFrame = Utils.choose(-15, -10, -5)
    end
  elseif npc.State == NpcState.STATE_ATTACK2 then

    sprite:Play("Fart")

    if sprite:IsEventTriggered("Cough") then
       sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 1.1, 0, false, 0.8)
    end

    if sprite:IsEventTriggered("Wave") then
       Isaac.Spawn(1000, 34, 0, npc.Position, Vector(0, 0), player)
       Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, Isaac.GetFreeNearPosition(npc.Position,64), true)
       Game():ShakeScreen(5)
    end

    if sprite:IsFinished("Fart") then
      npc.State = NpcState.STATE_IDLE
      npc.StateFrame = Utils.choose(-10, -5, 0)
    end
  end
 end
end

function this:die(npc)
 if npc.Variant == this.variant then
    sfx:Play(SoundEffect.SOUND_MAGGOT_ENTER_GROUND, 1, 0, false, 1)
    Isaac.Spawn(1000, 77, 0, npc.Position, Vector(0, 0), player).Color = Color(0, 0, 0, 1, 69, 56, 52)
 end
end

function this:shroomBreakUpdate()
    local player = Isaac.GetPlayer(0);
    local room = Game():GetRoom()
	for _,sbreak in ipairs(Isaac.GetRoomEntities()) do
		if sbreak:GetData().IsShockwave then
                  if sbreak:GetSprite():IsFinished("Break") then
                  	sbreak:Remove()
                  end
                  if (player.Position-sbreak.Position):Length() <= 30 then
                      player:TakeDamage(1,EntityFlag.FLAG_POISON,EntityRef(sbreak),0)
                  end
                  for i = 1, room:GetGridSize() do
                      local grid = room:GetGridEntity(i)
                      if grid and (grid.Desc.Type==2 or grid.Desc.Type==3 or grid.Desc.Type==4 or grid.Desc.Type==5 or grid.Desc.Type==6 or grid.Desc.Type==14 or grid.Desc.Type==22) then 
                         if sbreak.Position:Distance(grid.Position) <= 42 then
                            room:DestroyGrid(i, true) 
                         end
                      end
                  end
	      end
	end
	for _,s in ipairs(Isaac.GetRoomEntities()) do
        local data = s:GetData()
	   if data.Shockwave and s.FrameCount%5 == 0 or data.Shroomwave and (s.FrameCount%2 == 0 or s.FrameCount == 0) then
	      local sbreak = Isaac.Spawn(EntityType.ENTITY_EFFECT, 6, 0, s.Position, Vector(0,0), v)
	      sbreak:GetSprite():Load("gfx/1000.062_groundbreak.anm2", true)
	      sbreak:GetSprite():Play("Break")
	      sbreak:GetData().IsShockwave = true
	   end
	      if data.Shockwave or data.Shroomwave then
                  if ((s.FrameCount == 25 and not data.ShockwaveTimeout) or (data.ShockwaveTimeout and s.FrameCount == data.ShockwaveTimeout)) then
                       s:Remove()
                  end
              end
	end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.shroomBreakUpdate)
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this
