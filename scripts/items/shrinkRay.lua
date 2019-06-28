local this = {}
this.id = Isaac.GetItemIdByName("Shrink Ray")
this.description = "Shrinks all enemies in the room"
this.isActive = true

function this.use()
  sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER , 0.8, 0, false, 1)
  for e, entity in pairs(Isaac.GetRoomEntities()) do 
     if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not entity:IsBoss() and not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and entity:IsVulnerableEnemy() then 
        entity:AddShrink(EntityRef(nil), 3600) 
     end 
  end
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
