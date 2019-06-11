local this = {}
this.cardSubtypes = {}

function this.init(cards)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.updateSprites)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateSprites)
    for name, class in pairs(cards) do
        if not class.noCardAppearance then
            table.insert(this.cardSubtypes, class.id)
        end
    end
end

function this.updateSprites()
    for i, card in pairs(Isaac.GetRoomEntities()) do
        if card.Type == EntityType.ENTITY_PICKUP and card.Variant == PickupVariant.PICKUP_TAROTCARD then
            for x, subtype in pairs(this.cardSubtypes) do
                if card.SubType == subtype then 
                    local spr = card:GetSprite()
                    spr:ReplaceSpritesheet(0,"gfx/items/pick ups/pickup_card.png")
                    spr:LoadGraphics()
                end
            end
        end
    end
end

return this