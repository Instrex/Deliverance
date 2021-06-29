local this = {}
this.id = Isaac.GetItemIdByName("Captain's Brooch")
this.description = "Creates a treasure chest nearby"
this.rusdescription ={"Captain's Brooch /Капитанская брошь", "Создает сундук рядом"}
this.isActive = true

function this.use()
  local player = Utils.GetPlayersItemUse()
  local room = game:GetRoom()
  sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 0.8, 0, false, 1)
  local chest = Isaac.Spawn(5, utils.chance(4, 60, 50), 0,
  room:FindFreePickupSpawnPosition(player.Position, 32, true), vectorZero, player);

  chest:GetSprite():ReplaceSpritesheet(0,"gfx/items/pick ups/cbrooch_chests.png")
  chest:GetSprite():LoadGraphics()

  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
