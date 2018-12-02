local this = {}
this.id = Isaac.GetItemIdByName("Lighter")

function this.use()
  SFXManager():Play(SoundEffect.SOUND_FIRE_RUSH , 0.8, 0, false, 1)
  for e, entity in pairs(Isaac.GetRoomEntities()) do 
     if entity:IsActiveEnemy() then 
        entity:AddBurn(EntityRef(nil), 60, 5) 
     end 
  end
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
