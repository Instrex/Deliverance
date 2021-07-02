local this = {
    id = Isaac.GetItemIdByName("Chaotic D6"),
    --description =
}

function this:onUse()
    for _, item in ipairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, -1)) do
        local collect = item:ToPickup()
        if collect.SubType ~= 0 then
            local poolPick = math.random(0, 30)

            if poolPick == ItemPoolType.POOL_24 or poolPick == ItemPoolType.POOL_SHELL_GAME then
                return ItemPoolType.POOL_TREASURE
            end
            
            local randPool = game:GetItemPool():GetCollectible(poolPick, true, collect.SubType)
            collect:Morph(EntityType.ENTITY_PICKUP,PickupVariant.PICKUP_COLLECTIBLE,randPool,true,true,true)
        end
    end
    return true
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.onUse, this.id)
end

return this
