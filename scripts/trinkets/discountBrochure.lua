local this = {}
this.id = Isaac.GetTrinketIdByName("Discount Brochure")
this.description = "Makes the Member Card {{Collectible602}} shop your starting room"
this.rusdescription ={"Discount Brochure /Скидочная Брошюра", "Телепортирует в магазин Членской Карты в начале каждого этажа"}

function this.onNewFloor()
    for _, player in pairs(Utils.GetPlayers()) do
        if player:HasTrinket(this.id) and game:GetLevel():GetStage() ~= LevelStage.STAGE8 then
            game:ChangeRoom(GridRooms.ROOM_SECRET_SHOP_IDX,0)
            if game:GetRoom():IsFirstVisit() then
                deliveranceData.temporary.discountshop = true
            end
    
            player.Position = Vector(320,235)
            --player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_STEAM_SALE, false)
            if player:HasCollectible(CollectibleType.COLLECTIBLE_STAIRWAY) then
                Isaac.Spawn(1000,156,1,Vector(175,165),Vector.Zero,nil)
            end
    
            if player:HasCollectible(CollectibleType.COLLECTIBLE_CARD_READING)  then
                Isaac.Spawn(1000,161,math.random(0,2),Vector(320,285),Vector.Zero,nil)
            end
        end
    end
end

function this.ladderhelper(_,eff)
    if eff.SubType == 0 and game:GetLevel():GetCurrentRoomIndex() == -13 and deliveranceData.temporary.discountshop then
        game:StartRoomTransition(game:GetLevel():GetStartingRoomIndex(), Direction.NO_DIRECTION, "2")
        deliveranceData.temporary.discountshop = nil
    end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.onNewFloor)
    mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, this.ladderhelper,156)
end

return this
