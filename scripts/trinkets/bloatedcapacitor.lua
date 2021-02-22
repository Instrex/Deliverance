local this = {
	id = Isaac.GetTrinketIdByName("Bloated Capacitor")
}

local function checkroomsize()
	local room = game:GetRoom()
	local shape = room:GetRoomShape()
	if shape == RoomShape.ROOMSHAPE_2x2 or shape == RoomShape.ROOMSHAPE_LTL or shape == RoomShape.ROOMSHAPE_LTR or shape == RoomShape.ROOMSHAPE_LBL or shape == RoomShape.ROOMSHAPE_LBR then
		return 2
	end
	return 1
end

function this:capacitor()
	local player = Isaac.GetPlayer(0)
	local room = game:GetRoom()
	if player:HasTrinket(this.id) then
		if player:NeedsCharge() then
			if deliveranceData.temporary.capacitordamage then
				if sfx:IsPlaying(171) then
					sfx:Stop(171)
				end
				if player:GetBatteryCharge() > 0 then
					local charge = player:GetActiveCharge() + player:GetBatteryCharge()
					player:DischargeActiveItem()
					player:SetActiveCharge(charge-checkroomsize())
				else
					player:SetActiveCharge(player:GetActiveCharge()-checkroomsize())
				end
			else
				player:SetActiveCharge(player:GetActiveCharge()+1)
			end
		end
	end
end

function this:takedamage()
	local player = Isaac.GetPlayer(0)
	if player:HasTrinket(this.id) then
		if player:GetBatteryCharge() > 0 then
			local charge =  player:GetActiveCharge() + player:GetBatteryCharge()
			player:DischargeActiveItem()
			player:SetActiveCharge(charge-1)
		else
			player:SetActiveCharge(player:GetActiveCharge()-1)
		end
		if (deliveranceData.temporary.capacitordamage == nil or deliveranceData.temporary.capacitordamage == false) then
			deliveranceData.temporary.capacitordamage = true 
		end
		deliveranceDataHandler.directSave()
	end
end

function this:newroom()
	local player = Isaac.GetPlayer(0)
		if player:HasTrinket(this.id) then
			if (deliveranceData.temporary.capacitordamage == nil or deliveranceData.temporary.capacitordamage == true) then
				deliveranceData.temporary.capacitordamage = false
			end
		end
end

function this.Init()
	mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, this.capacitor)
	mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.takedamage, EntityType.ENTITY_PLAYER)
	mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.newroom)
end

return this