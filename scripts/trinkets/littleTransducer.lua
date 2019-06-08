local this = {}
this.id = Isaac.GetTrinketIdByName("Lil Transducer")
this.description = "Charges active item even if room doesn't contain any enemies"

function this.onNewRoom()
    local player = Isaac.GetPlayer(0)
    if player:HasTrinket(this.id) and player:NeedsCharge() then
        local room = game:GetRoom()
        if room:GetType() == RoomType.ROOM_DEFAULT and room:IsFirstVisit() and room:IsClear() then
            Isaac.Spawn(1000, 48, 0, Vector(player.Position.X, player.Position.Y - 32), vectorZero, nil)
            player:SetActiveCharge(player:GetActiveCharge() + 1)
        end
    end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.onNewRoom)
end

return this