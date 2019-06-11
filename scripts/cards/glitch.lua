local this = {}
this.id = Isaac.GetCardIdByName("Glitch")
this.description = "Triggers random tarot card effect"

function this.cardCallback(cardId)
    Isaac.GetPlayer(0):UseCard(math.random(1, 21))
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
end

return this