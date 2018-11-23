local this = {}

function this:behaviour(npc)
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  if data.trytochange == nil and utils.chancep(20) and npc.Variant == 10 then
    data.dorky = 1
    sprite:ReplaceSpritesheet(0,"gfx/monsters/variants/lilhaunt.png") sprite:LoadGraphics()
  end
   data.trytochange = 1

  if npc:IsDead() and data.dorky and npc.Variant == 10 then
    for i=1, 4 do
      Isaac.Spawn(9, 0, 0, npc.Position, Vector.FromAngle(i*90):Resized(11), npc)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, 260)
end

return this
