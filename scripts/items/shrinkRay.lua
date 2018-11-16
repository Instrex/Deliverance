local this = {}
this.id = Isaac.GetItemIdByName("Shrink Ray")

function this.use()
  SFXManager():Play(SoundEffect.SOUND_POWERUP_SPEWER , 0.8, 0, false, 1)
  for e, entity in pairs(Isaac.GetRoomEntities()) do 
     if entity:IsVulnerableEnemy() then 
        entity:AddShrink(EntityRef(nil), 300) 
     end 
  end
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
