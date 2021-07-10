local this = {}
this.id = Isaac.GetTrinketIdByName("Special Penny")
this.description = "Shopkeepers now always have coins in their eyes"
this.rusdescription ={"Special Penny /ќсоба€ монета", "Ћавочники всегда по€вл€ютс€ с монеткой в глазах"}

function this.special()
  for _, player in pairs(Utils.GetPlayers()) do
    if player:HasTrinket(this.id) then
      for e, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type==17 then
          if entity.Variant==0 then
            Isaac.Spawn(17,3,0,entity.Position, vectorZero, player); entity:Remove();
          end
          if entity.Variant==1 then
            Isaac.Spawn(17,4,0,entity.Position, vectorZero, player); entity:Remove();
          end
        end
      end
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.special)
end

return this
