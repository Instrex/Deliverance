local this = {}
this.id = Isaac.GetCardIdByName("Firestorms")
this.description = "Sets all enemies on fire#Grants Fire Mind effect for one room"
this.isActive = false

function this:cardCallback(cardId)
    if cardId == this.id then 
        deliveranceContent.items.lighter.use()
        this.isActive = true
    end
end

function this:onTear(tear)
    if this.isActive then 
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BURN
        tear:ChangeVariant(TearVariant.FIRE_MIND)
    end
end

function this.reset()
    this.isActive = false
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, this.onTear)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.reset)
end

return this