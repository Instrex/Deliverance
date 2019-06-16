local this = {}
this.id = Isaac.GetEntityTypeByName("Gappy")
this.variant = Isaac.GetEntityVariantByName("Gappy")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_MOVE

  -- Move and wait for player to get closer --
  elseif npc.State == NpcState.STATE_MOVE then
    
   if data.parent:Exists() and not data.parent:IsDead() then
    --if room:CheckLine(npc.Position,target.Position,0,1,false,false) then
      npc.Pathfinder:FindGridPath(data.parent.Position, math.random(5, 7) / 10, 2, false)
    --else
    --  npc.Pathfinder:MoveRandomly(false)
    --end
   end
    
    npc:AnimWalkFrame("WalkHori", "WalkVertDo", 0.1)

    if not data.parent:Exists() or data.parent:IsDead() then
       sfx:Play(SoundEffect.SOUND_BOSS_LITE_SLOPPY_ROAR , 0.5, 0, false, 1.25)
       npc.State = NpcState.STATE_ATTACK
    end

  elseif npc.State == NpcState.STATE_ATTACK then
    npc:AnimWalkFrame("WalkHoriRage", "WalkVertRage", 0.1)
    if not target:IsDead() then npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 1.15 + npc.Velocity * 0.85 end
  end
 end
end

function this.checkEnemies()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e.Type == this.id and e.Variant == this.Variant then count = count + 1 end
  end

  return count
end

function this:spawnGappies(npc)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  if data.spawnedGappies == nil then
     if utils.chancep(25) and this.checkEnemies() <= 8 then
        for i=1, 2+math.random(1, 3) do
           local gapp = Game():Spawn(this.id, this.variant, npc.Position, vectorZero, npc, 0, 1):ToNPC()
           gapp:GetData().parent=npc
           if npc.Type == 208 and npc.Variant == 1 then
              gapp:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/lilgapers_pale.png")
              gapp:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/lilgapers_pale.png")
              gapp:GetSprite():LoadGraphics() 
           end 
        end
     end
     data.spawnedGappies=true
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.spawnGappies, 208)
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.spawnGappies, 257)
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.spawnGappies, 16)
end

return this