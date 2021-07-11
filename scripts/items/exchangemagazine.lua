local this ={
    id = Isaac.GetItemIdByName("Exchange Magazine"),
    description = "When used, items may fall or rise in price by half",
    rusdescription = {""}
}

function this:magazuse()
    for _, pickup in pairs(Isaac.FindByType(5,-1,-1)) do
        pickup = pickup:ToPickup()
        if pickup:IsShopItem() and pickup.Price > 0 then
            pickup.AutoUpdatePrice = false
            local choose = math.random(0,1)
            if choose == 0 then
                pickup.Price = pickup.Price * 2
            else
                pickup.Price = math.floor(pickup.Price / 2)
            end
        end
    end
    return true
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.magazuse, this.id)
end

return this