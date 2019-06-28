local this = {}
this.id = Isaac.GetItemIdByName("Sinister Shalk")
this.description = "gives ass"
this.silhouette = Isaac.GetEntityVariantByName("Silhouette")

function this:updateSilhouette(npc)
 if npc.Variant == this.silhouette then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    if data.silType == nil then 
       npc:ClearEntityFlags(npc:GetEntityFlags()) 
       npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_RENDER_FLOOR)
       data.silType=Utils.choose(0,1,2) 
       sprite:ReplaceSpritesheet(0, "gfx/effects/silhouette" .. data.silType .. "type.png")
       sprite:LoadGraphics()
    end 
    sprite:Play("Idle")
  end
end

function this:updateRoom()
   local room = game:GetRoom()
   local player = Isaac.GetPlayer(0)
   if player:HasCollectible(this.id) then
     if room:IsFirstVisit() and not room:IsClear() then 
      local pos = Isaac.GetFreeNearPosition(room:GetCenterPos()+Vector(math.random(-300,300),math.random(-300,300)), 1)  
      Isaac.Spawn(1000, this.silhouette, 0, pos, vectorZero, nil)
     end
   end
end

function this:die(entity) 
  for e, npc in pairs(Isaac.GetRoomEntities()) do 
    if npc.Type==1000 and npc.Variant==this.silhouette and npc.Position:Distance(entity.Position) <= 32 then
     Isaac.Spawn(1000, 15, 0, npc.Position, vectorZero, npc)
     local clone = Game():Spawn(entity.Type, entity.Variant, entity.Position, vectorZero, entity, 0, 1):ToNPC()
     clone:AddCharmed(-1)
     clone:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
     clone:SetColor(Color(0,0,0,0.75,0,0,0),0,0,false,false)
     clone.Scale = entity.Scale
     npc.Remove()
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateRoom)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateSilhouette)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die)
end

return this
 