local this = {}
this.id = Isaac.GetItemIdByName("Shamrock Leaf")
this.variant = Isaac.GetEntityVariantByName("Shamrock Leaf Effect")
this.description = "Grants prizes upon defeating the boss without being hit"
this.rusdescription ={"Shamrock Leaf /Трилистник", "Дарует призы после уничтожения босса без получения урона"}

-- ITEM LOGIC
function this.onRoomEnter() -- MC_POST_NEW_ROOM
    local room = Game():GetRoom()
    if Isaac.GetPlayer(0):HasCollectible(this.id) and not room:IsClear() then
        deliveranceData.temporary.shamrockReward = room:GetType() == RoomType.ROOM_BOSS
    end
end

function this:updateEffect() -- MC_POST_UPDATE
    if deliveranceData.temporary.shamrockReward and Game():GetRoom():IsClear() then
        this.spawnReward()
        this.reset()
    end
end

function this:onPlayerDamage(player) -- MC_ENTITY_TAKE_DMG (EntityType.ENTITY_PLAYER)
    if deliveranceData.temporary.shamrockReward and Isaac.GetPlayer(0):HasCollectible(this.id) then
        this.reset()
    end
end

function this.spawnReward()
    sfx:Play(Isaac.GetSoundIdByName("Ding"), 0.8, 0, false, 1)
    local room = Game():GetRoom()
    for i = 0, math.random(3, 6) do 
        local variant, subtype = this.getReward()
        Isaac.Spawn(5, variant, subtype, room:FindFreePickupSpawnPosition(room:GetCenterPos(), 0, false),
            vectorZero, nil)
    end
end

function this.getReward()
    if utils.chancep(4) then return  PickupVariant.PICKUP_TRINKET, 0  end
    if utils.chancep(5) then return  PickupVariant.PICKUP_CHEST, 1  end
    if utils.chancep(2) then return  PickupVariant.PICKUP_LOCKEDCHEST, 1  end
    if utils.chancep(8) then return  PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL  end
    if utils.chancep(8) then return  PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL  end
    return PickupVariant.PICKUP_COIN, utils.choose(CoinSubType.COIN_PENNY, CoinSubType.COIN_LUCKYPENNY) 
end

function this.reset()
    deliveranceData.temporary.shamrockReward = false
end

function this:Init()
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.updateEffect)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.onRoomEnter)
    mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onPlayerDamage, EntityType.ENTITY_PLAYER)
end

return this