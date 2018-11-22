local this = {}

function this:transform(npc)
  local sprite = npc:GetSprite()
  if utils.chancep(10) then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/variants/dukie.png")
    sprite:LoadGraphics()
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transform, 288)
end

return this
