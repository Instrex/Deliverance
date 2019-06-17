local this = {}
this.id = Isaac.GetItemIdByName('Lawful')
this.description = 'All items on floors will be of same item pool#Item pool is randomly choosen at the start of level'

-- MC_POST_NEW_LEVEL
function this.onNewFloor() 
    deliveranceData.temporary.lawfulPool = math.random(0, ItemPoolType.NUM_ITEMPOOLS)
    deliveranceDataHandler.directSave()
end

-- MC_POST_PICKUP_SELECTION 
function this:postPickupSelection(pickup, variant, subtype) 
    local player = Isaac.GetPlayer(0)
    if variant == PickupVariant.PICKUP_COLLECTIBLE then 
        local pool = game:GetItemPool()
        pool:AddRoomBlacklist(CollectibleType.COLLECTIBLE_CHAOS)

        if player:HasCollectible(CollectibleType.COLLECTIBLE_CHAOS) and subtype == this.id then
            -- заменить POOL_SHOP на пул лавфула
            return { variant, pool:GetCollectible(ItemPoolType.POOL_SHOP, true, math.random(0, 10000))}
        end

        deliveranceData.temporary.lawItems = deliveranceData.temporary.lawItems or {}
        if player:HasCollectible(this.id) and utils.contains(deliveranceData.temporary.lawItems, subtype) then 
            if not deliveranceData.temporary.lawfulPool then 
                this.onNewFloor()
            end

            local newID = pool:GetCollectible(deliveranceData.temporary.lawfulPool, true, math.random(10000))
            table.insert(deliveranceData.temporary.lawItems, newID)

            deliveranceDataHandler.directSave()

            return { variant, newID}
        end
    end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.onNewFloor)
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, this.postPickupSelection)
end

return this