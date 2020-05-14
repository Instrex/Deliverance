local this = {}
this.id = Isaac.GetItemIdByName("Corrosive Bombs")
this.description = "+3 Bombs"
this.rusdescription ={"Corrosive Bombs /Разъедающие бомбы", "-"}

function this:cache(bomb)
  local player = Isaac.GetPlayer(0) --Курочка обидется...
  if player:HasCollectible(this.id) then
	local room = Game():GetRoom()
	local bombsprite = bomb:GetSprite()
	--update sprite--
	if (bomb.Variant > 4 or bomb.Variant < 3) then
		if bomb.FrameCount < 2 and bomb.Variant ~= 2 then
			bombsprite:Load("gfx/items/effects/corrosive_bomb.anm2",true)
			bombsprite:LoadGraphics()
		end
	end
	--unlock doors--
	for i = 0, 7 do
		local door = room:GetDoor(i)
		if door ~= nil and door:IsLocked(i) then
			if bomb.Position:DistanceSquared(door.Position) <= 55 ^ 2 and bombsprite:IsPlaying("Explode") then
				if door:TryUnlock(true) then
					door:SpawnDust()
				end
			end
		end
	end
end
  --[[local entities = Isaac.GetRoomEntities()
   for ent = 1, #entities do
	local entity = entities[ent]
    if entity:GetSprite():IsPlaying("Explode") and entity:GetSprite():GetFrame() == 1 then
    function this.cache(bomb)
        for p = 0, game:GetNumPlayers() - 1 do
           local player = Isaac.GetPlayer(p)
             local room = Game():GetRoom()      
                for i = 0, 7 do
                   local door = room:GetDoor(i)
                    if door ~= nil and door:IsLocked(i) then
                        if bomb.Position:DistanceSquared(door.Position) <= 55 ^ 2 then
                            if door:TryUnlock(true) then
                                door:SpawnDust()
					        end 
						end 
                    end 
				end 	      
			end
		end
    end
end
    function this.cache(pickup)
        for _, player in pairs(Isaac.FindInRadius(pickup.Position, 110, EntityPartition.PLAYER)) do
		             if entity.Type == EntityType.ENTITY_PICKUP then
					   if entity.Variant == PickupVariant.PICKUP_LOCKEDCHEST or entity.Variant == PickupVariant.PICKUP_ETERNALCHEST then
					     if pickup.Position:Distance(entity.Position) <= 110 then
                           entity:ToPickup():TryOpenChest()
	                    end 
	                end 
	            end  
			end
		end	
    end--]]
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, this.cache) 
  --mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.cache, PickupVariant.PICKUP_LOCKEDCHEST)
  --mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.cache, PickupVariant.PICKUP_ETERNALCHEST)
end

return this