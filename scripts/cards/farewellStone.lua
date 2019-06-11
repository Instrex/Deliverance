local this = {}
this.id = Isaac.GetCardIdByName("FarewellStone")
this.description = "Replaces all of your red hearts with twice amount of soul hearts"

function this:cardCallback(cardId)
    local player = Isaac.GetPlayer(0)
    local hearts = player:GetMaxHearts()
    player:AddSoulHearts(hearts * 2)
    player:AddMaxHearts(0 - hearts)
    sfx:Play(SoundEffect.SOUND_HOLY, 1, 0, false, 1.05)
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
end

return this
