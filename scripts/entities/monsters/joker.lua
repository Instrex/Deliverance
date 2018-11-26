local this = {}
this.id = Isaac.GetEntityTypeByName("Joker")

local sfx = SFXManager()
function this:behaviour(npc)
  local target = Isaac.GetPlayer(0)
  local sprite = npc:GetSprite()
  local data = npc:GetData()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE
    npc.StateFrame = Utils.choose(-10, -5, 0)

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
   
    npc.Pathfinder:FindGridPath(target.Position, 0.8, 1, false)
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

    if npc.Position:Distance(target.Position) <= 250 then
      npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame >= 75 then
       sfx:Play(SoundEffect.SOUND_FAT_GRUNT , 1.2, 0, false, 1.12)
       if utils.chancep(50) then npc.State = NpcState.STATE_ATTACK else npc.State = NpcState.STATE_ATTACK3 end
       npc.StateFrame = 0;
    end

  -- Charges --
  elseif npc.State == NpcState.STATE_ATTACK then
   
    sprite:Play("Charge");
    npc.Velocity = Vector(0,0)

    if(sprite:IsFinished("Charge")) then
        npc.State = NpcState.STATE_ATTACK2;
        sfx:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1.12)
        local urod = Game():Spawn(277, 0, npc.Position, Vector(0,0), npc, 0, 1):ToNPC()
           urod.HitPoints = 4
           urod.State = 0
           urod:SetSize(9, Vector(1,1), 12)
           urod.Scale = 0.75
        Isaac.Spawn(1000, 15, 0, npc.Position+Vector(0, 15), Vector(0, 0), nil)
        game:ShakeScreen(3)
    end

  -- Summons tiny black Bony --
  elseif npc.State == NpcState.STATE_ATTACK2 then
    sprite:Play("Summon");

    if(sprite:IsFinished("Summon")) then
        npc.State = NpcState.STATE_MOVE;
    end

  -- Charges brimstone shot --
  elseif npc.State == NpcState.STATE_ATTACK3 then
    sprite:Play("Charge2");
    npc.Velocity = Vector(0,0)

    if(sprite:IsFinished("Charge2")) then

        npc.State = NpcState.STATE_ATTACK4;
        sfx:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_2 , 1, 0, false, 1)

        for i=1, 4 do
          local brimstone_laser = EntityLaser.ShootAngle(1, npc.Position, 45+i*90, 15, Vector(0,-20), npc)
          brimstone_laser.DepthOffset = 200
        end
    end

  -- After brimstone shot --
  elseif npc.State == NpcState.STATE_ATTACK4 then
    sprite:Play("Brimstone");

    if(sprite:IsFinished("Brimstone")) then
        npc.State = NpcState.STATE_MOVE;
    end
  end
end

--function this:transformation(npc)
--  if utils.chancep(15) then
--    npc:Morph(this.id, 0, 0, 0)
--  end
--end

function this:die(npc)
  Isaac.Explode(npc.Position, npc, 1.0)
  if utils.chancep(15) then
      proj = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Isaac.GetCardIdByName("Mannaz"), npc.Position, Vector(0, 0), player)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 27)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this