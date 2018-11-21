local this = {}
this.id = Isaac.GetEntityTypeByName("Jester")

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
   
    npc.Pathfinder:FindGridPath(target.Position, 0.75, 1, false)
    npc:AnimWalkFrame("WalkHori", "WalkVert", 0.1)

    if npc.Position:Distance(target.Position) <= 250 then
      npc.StateFrame = npc.StateFrame + 1
    end

    if npc.StateFrame >= 50 then
       sfx:Play(SoundEffect.SOUND_FAT_GRUNT , 1.2, 0, false, 1)
       npc.State = NpcState.STATE_ATTACK;
       npc.StateFrame = 0;
    end

  -- Charges --
  elseif npc.State == NpcState.STATE_ATTACK then
   
    sprite:Play("Charge");
    npc.Velocity = Vector(0,0)

    if(sprite:IsFinished("Charge")) then
        npc.State = NpcState.STATE_ATTACK2;
        sfx:Play(SoundEffect.SOUND_ULTRA_GREED_ROAR_1 , 1, 0, false, 1)
        local urod = Game():Spawn(227, 0, npc.Position, Vector(0,0), npc, 0, 1):ToNPC()
           urod.HitPoints = 4
           urod.State = 0
           urod:SetSize(9, Vector(1,1), 12)
           urod.Scale = 0.75
        Isaac.Spawn(1000, 15, 0, npc.Position+Vector(0, 15), Vector(0, 0), nil)
        game:ShakeScreen(3)
    end

  -- Summons tiny Bony --
  elseif npc.State == NpcState.STATE_ATTACK2 then
        sprite:Play("Summon");

        if(sprite:IsFinished("Summon")) then
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
  if utils.chancep(20) then
      proj = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, card_mannaz, npc.Position, Vector(0, 0), player)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
--  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 27)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, this.id)
end

return this