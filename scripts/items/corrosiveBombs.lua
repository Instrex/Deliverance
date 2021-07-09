local this = {}
this.id = Isaac.GetItemIdByName("Corrosive Bombs")
this.description = "+3 bombs#Bombs can explode metal blocks and key blocks#Can open any doors"
this.rusdescription ={"Corrosive Bombs /Разъедающие бомбы", "+3 бомбы#Бомбы могут взрывать металлические блоки и блоки для которых нужен ключ#Может открывать любые двери"}

function this:cache(bomb)
  if bomb.SpawnerType == 1 then
	bomb.Parent = Utils.GetPlayersPlacingBomb()
	if bomb.Parent:ToPlayer():HasCollectible(this.id) then
		local room = Game():GetRoom()
		local bombsprite = bomb:GetSprite()
		--update sprite--
		--[[if (bomb.Variant > 4 or bomb.Variant < 3) then
			if bomb.FrameCount < 2 and bomb.Variant ~= 2 then
				bomb:Morph(bomb.Type,4000,0,false,false,true)
			end
		end--]]
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
		--open chest--
		for i, ent in pairs(Isaac.GetRoomEntities()) do
			if bomb.Position:Distance(ent.Position) <=65 and bombsprite:IsPlaying("Explode") and ent.Type==EntityType.ENTITY_PICKUP and (ent.Variant == 50 or ent.Variant == 52 or ent.Variant == 53 or ent.Variant == 54 or ent.Variant == 60 or ent.Variant == 360 ) then
				ent:ToPickup():TryOpenChest()
			end
		end
		--destroy blocks--
		for i = 1, room:GetGridSize() do
			local grid = room:GetGridEntity(i)
			if grid and (grid.Desc.Type==11 or grid.Desc.Type == 3)  then
			 local gridIndex = grid:GetGridIndex()
			  if bomb.Position:Distance(grid.Position) <= 65 and bombsprite:IsPlaying("Explode") then
				room:RemoveGridEntity(gridIndex, 0, false)
			  end
			end
		  end
		end 
  end
end

function this:morphbomb(bomb)
  if bomb.SpawnerType == 1 then
	local player = Utils.GetPlayersPlacingBomb()
	if player:HasCollectible(this.id) then
		--update sprite--
		if (bomb.Variant > 4 or bomb.Variant < 3) then
			if bomb.Variant == 0 then
				bomb.Variant = 4000
			end
		end
	   end  
  end
end
 
function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_BOMB_INIT,this.morphbomb)
  mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, this.cache)
end

return this