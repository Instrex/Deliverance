local this = {}
this.id = Isaac.GetCardIdByName("Abyss")
this.description = "Consumes all the cards and drops itself#Will trigger the effect of all consumed cards if used in a room without any cards#\3Will reset all the effects upon use"
this.rusdescription ={"Abyss /������", "��������� � ���� ��� ����� � ������ �� ���#������� ������� ���� �������� ���� ���� ������������ � ������� ��� ����#������� ��� ������� ��� �������������"}
this.cardobjects = {
    [Card.CARD_DICE_SHARD] = true,
    [Card.CARD_CRACKED_KEY] = true
}

function this.cardCallback()
    local player = Utils.GetPlayersItemUse()
    local data = player:GetData()
    data.abyssCard = data.abyssCard or {}

    local void = false
    for _, card in pairs(Isaac.GetRoomEntities()) do
        if card.SubType ~= this.id and not utils.contains(data.abyssCard, card.SubType) and 
        card.Type == EntityType.ENTITY_PICKUP and card.Variant == PickupVariant.PICKUP_TAROTCARD and not this.cardobjects[card.SubType] then
            table.insert(data.abyssCard, card.SubType)
            card:Remove()
            void = true
        end
    end
    
    if not void then
        for _, card in pairs(data.abyssCard) do
            player:UseCard(card)
        end
        
        data.abyssCard = {}
    else
        Isaac.Spawn(5, 300, this.id, player.Position, vectorZero, nil)
    end

    deliveranceDataHandler.directSave()
end

if MinimapAPI then

	local minimapIcons = Sprite()
	minimapIcons:Load("gfx/ui/minimapapi/deliverance_icons.anm2", true)
	minimapIcons:Play("DeliveranceIconFarewellStoneCard", true)
	
	MinimapAPI:AddIcon(
		"DeliveranceAbyssCardIcon",
		minimapIcons,
		"DeliveranceIconAbussCard",
		0
	)
	
	MinimapAPI:AddPickup(
		"DeliveranceAbyssCard",
		"DeliveranceAbyssCardIcon",
		EntityType.ENTITY_PICKUP,
		PickupVariant.PICKUP_TAROTCARD,
		this.id,
		MinimapAPI.PickupNotCollected,
		"deliverancecards",
		1040
	)
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
end

return this