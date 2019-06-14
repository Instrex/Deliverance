local this = {}
this.id = Isaac.GetCardIdByName("Abyss")
this.description = "Consumes all the cards and drops itself#Will trigger the effect of all consumed cards if used in a room without any cards#\3Will reset all the effects upon use"
this.cardImage = 'gfx/items/pick ups/pickup_card_abyss.png'

function this.cardCallback()
    deliveranceData.temporary.abyssCard = deliveranceData.temporary.abyssCard or {}

    local void = false
    for _, card in pairs(Isaac.GetRoomEntities()) do
        if card.SubType ~= this.id and not utils.contains(deliveranceData.temporary.abyssCard, card.SubType) and 
        card.Type == EntityType.ENTITY_PICKUP and card.Variant == PickupVariant.PICKUP_TAROTCARD then
            table.insert(deliveranceData.temporary.abyssCard, card.SubType)
            card:Remove()
            void = true
        end
    end

    if not void then 
        local player = Isaac.GetPlayer(0)
        for _, card in pairs(deliveranceData.temporary.abyssCard) do
            player:UseCard(card)
        end
        
        deliveranceData.temporary.abyssCard = {}
    else
        Isaac.Spawn(5, 300, this.id, Isaac.GetPlayer(0).Position, vectorZero, nil)
    end

    deliveranceDataHandler.directSave()
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
end

return this