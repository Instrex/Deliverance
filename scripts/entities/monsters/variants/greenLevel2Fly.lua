local this = {}

function this:behaviour(npc)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()
  if data.trytochange == nil and utils.chancep(16) then
    data.greenFly = 1
    sprite:ReplaceSpritesheet(0,"gfx/monsters/variants/level2fly.png") sprite:LoadGraphics()
  end
   data.trytochange = 1

  if npc:IsDead() and data.greenFly then
    Isaac.Spawn(1000, 34, 0, npc.Position, vectorZero, player)
    for i=1, math.random(2, 3) do
--    npc:ThrowSpider(npc.Position, npc, vectorZero, false, 0)	
      EntityNPC.ThrowSpider(npc.Position, npc, room:FindFreePickupSpawnPosition(npc.Position, 160, true), false, 1.0)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, 214)
end

return this
