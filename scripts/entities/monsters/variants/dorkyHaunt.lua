local this = {}

function this:transform(npc)
  local data = npc:GetData() local sprite = npc:GetSprite()
  if utils.chancep(20) and npc.Variant == 10 then
    data.dorky = 1
    sprite:ReplaceSpritesheet(0,"gfx/monsters/variants/lilhaunt.png") sprite:LoadGraphics()
  end
end

function this:die(npc)
  local data = npc:GetData()
  if data.dorky and npc.Variant == 10 then
    for i=1, 4 do
      Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(i*90):Resized(8), npc)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transform, 260)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die, 260)
end

return this
