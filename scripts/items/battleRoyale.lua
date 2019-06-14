local this = {}
this.id = Isaac.GetItemIdByName("Battle Royale")
this.description = "Summons a friendly copy of every enemy in the room, making them fight each other"
this.isActive = true

function this.use()
  sfx:Play(Isaac.GetSoundIdByName("Spawn"), 1, 0, false, 1)
  for e, entity in pairs(Isaac.GetRoomEntities()) do 
     if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not entity:IsBoss() then 
        local clone = Game():Spawn(entity.Type, entity.Variant, entity.Position, vectorZero, entity, 0, 1):ToNPC()
--      clone.HitPoints = entity.HitPoints/1.25
        clone:SetSize(9, Vector(1,1), 12)
        clone.Scale = 0.75
	clone:AddCharmed(-1)
	clone:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
        clone:SetColor(Color(10,10,10,0.75,0,0,0),0,0,false,false)
        clone:GetData().battleRoyaled = true
     end
  end
  return true
end

function this:update(clone)
    local data = clone:GetData()
    local chanse = clone.HitPoints*60 + math.random(-5,5)
    if data.battleRoyaled then
       if data.time == nil then data.time = math.random(-10,0) end
       if data.time <= chanse then data.time = data.time + 1 
       else
           Isaac.Spawn(1000, 19, 0, Vector(clone.Position.X, clone.Position.Y-4), vectorZero, clone)
           sfx:Play(SoundEffect.SOUND_1UP, 0.5, 0, false, math.random(8, 12) / 10)
           clone:Remove()
       end
    end
end

function this:updateRoom()
  for e, entity in pairs(Isaac.GetRoomEntities()) do 
     if entity:GetData().battleRoyaled then
        entity:Remove()
     end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateRoom)
end

return this
