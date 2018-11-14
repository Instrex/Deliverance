local this = {}
this.id = Isaac.GetItemIdByName("Captain's Brooch")

function this.use()
  SFXManager():Play(SoundEffect.SOUND_SUMMONSOUND  , 0.8, 0, false, 1)
  local sprite = Isaac.Spawn(5, utils.chance(4, 60, 50), 0,
                  Isaac.GetFreeNearPosition(game:GetRoom():GetCenterPos(), 1), Vector(0, 0), Isaac.GetPlayer(0)):GetSprite();

  sprite:ReplaceSpritesheet(0,"gfx/items/pick ups/cbrooch_chests.png")
  sprite:LoadGraphics()

  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
