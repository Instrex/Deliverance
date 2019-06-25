local this = {
    variant = 10,
    subtype = 4000
}

-- MC_PRE_PICKUP_COLLISION 
function this:collision(pickup, collider, low)
    if pickup.Variant == this.variant and pickup.SubType == this.subtype then 
        pickup:GetSprite():Play('Collect')
    end
end

function this.Init() 
    mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, this.collision, this.variant)
end

return this