local this = {}
this.id = Isaac.GetTrinketIdByName("Discount Brochure")
this.description = "Makes the shop your starting room#\3Will teleport into the random room if location has no shops"

function this.onNewFloor()
    local player = Isaac.GetPlayer(0)
    if player:HasTrinket(this.id) then 
        game:ChangeRoom(game:GetLevel():QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, RNG()))
    end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.onNewFloor)
end

return this
