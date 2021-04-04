local this = {}
this.cardSubtypes = {}

function this.init(cards)
    mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.updateSprites)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateSprites)
    mod:AddCallback(ModCallbacks.MC_GET_CARD, this.getCard)
    for name, class in pairs(cards) do
        if not class.noCardAppearance then
            table.insert(this.cardSubtypes, {id = class.id, sprite = class.cardImage or 'gfx/items/pick ups/pickup_card.png', animate = class.getFrame})
        end
    end
end

function this.updateSprites()
    for i, card in pairs(Isaac.GetRoomEntities()) do
        if card.Type == EntityType.ENTITY_PICKUP and card.Variant == PickupVariant.PICKUP_TAROTCARD then
            for x, cardInfo in pairs(this.cardSubtypes) do
                if card.SubType == cardInfo.id then 
                    local spr = card:GetSprite()
                    if cardInfo.animate then
                        spr:ReplaceSpritesheet(0, cardInfo.animate())
                    else
                        spr:ReplaceSpritesheet(0, cardInfo.sprite)
                    end

                    spr:LoadGraphics()
                end
            end
        end
    end
end

local glitchedItems = {
    CollectibleType.COLLECTIBLE_MISSING_NO,
    CollectibleType.COLLECTIBLE_GB_BUG,
    CollectibleType.COLLECTIBLE_DATAMINER,
    CollectibleType.COLLECTIBLE_CHAOS,
    CollectibleType.COLLECTIBLE_UNDEFINED
}

function this._calculateAbyssCardRate()
    if not deliveranceData.temporary.abyssCard then 
        return 3
    else 
        return 3 + math.min(20, (#deliveranceData.temporary.abyssCard * 2))
    end
end

function this._calculateGlitchCardRate(player)
    local base = 3
    for _, item in pairs(glitchedItems)do
        if player:HasCollectible(item) then 
            base = base * 2.5
        end
    end

    return base
end

function this.getCard(rng)
    -- Purely random card drops --
    if utils.chancep(3) then
        return deliveranceContent.cards.farewellStone.id
        
    elseif utils.chancep(3) then 
        return deliveranceContent.cards.firestorms.id 
    end

    -- Chance increases when you have 'glitched' items --
    if utils.chancep(this._calculateGlitchCardRate(Isaac.GetPlayer(0))) then 
        return deliveranceContent.cards.glitch.id
    end
    
    -- Chance increases the more you have consumed cards --
    if utils.chancep(this._calculateAbyssCardRate()) then 
        return deliveranceContent.cards.abyss.id
    end
end
print("card loaded")
return this