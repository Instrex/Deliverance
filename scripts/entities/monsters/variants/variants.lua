local this = {}

function this:dukieform(npc)
  local sprite = npc:GetSprite()
  if utils.chancep(10) then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/variants/dukie.png")
    sprite:LoadGraphics()
  end
end

function this:lilhauntform(npc)
  local sprite = npc:GetSprite()
  if utils.chancep(30) and npc.Variant == 10 then
    sprite:ReplaceSpritesheet(0,"gfx/monsters/variants/lilhaunt.png")
    sprite:LoadGraphics()
  end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.dukieform, 288) 
    mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.lilhauntform, 260) 
end

return this