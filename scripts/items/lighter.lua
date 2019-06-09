local this = {}
this.id = Isaac.GetItemIdByName("Lighter")
this.description = "Sets all enemies on fire"

function this.use()
  sfx:Play(Isaac.GetSoundIdByName("Firestarter") , 0.75, 0, false, 1)
  for e, entity in pairs(Isaac.GetRoomEntities()) do 
     if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then 
        entity:AddBurn(EntityRef(nil), 1800, 1.5) 
     end 
  end
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
