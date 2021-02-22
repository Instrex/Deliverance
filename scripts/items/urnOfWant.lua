local this = {}
this.id = Isaac.GetItemIdByName("Urn of Want")
this.description = "Charging by killing monsters#Upon using gives effects of random pill and random card, #and spawns random pickup"
this.rusdescription ={"Urn of Want /Урна желаний", "Заряжается убийством врагов#При использовании даёт эффект случайной пилюли и случайной карты,#и создаёт случайный подбираемый предмет"}
this.isActive = true

this.effect = Isaac.GetEntityVariantByName("Urn of Want Effect")

function this:updateEffect(npc)
 if npc.Variant == this.effect then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    sprite:Play("Idle")
    
    if sprite:IsFinished("Idle") then 
      npc:Remove()
    end
  end
end

function this.use()
   local player = Isaac.GetPlayer(0)
   local effecto = Isaac.Spawn(1000, this.effect, 0, player.Position, vectorZero, nil)
   sfx:Play(Isaac.GetSoundIdByName("Urn"), 1, 0, false, 1)
   player:UseActiveItem(97,false,false,false,false)
   if utils.chancep(50) then 
       player:UseActiveItem(97,false,false,false,false)
   end
   if utils.chancep(50) then
       player:UseCard(Utils.choose(Card.CARD_EMPRESS,Card.CARD_HANGED_MAN,Card.CARD_DEVIL,Card.CARD_TOWER,
                               Card.CARD_JUDGEMENT,Card.CARD_CLUBS_2,Card.CARD_SPADES_2,Card.CARD_HEARTS_2,
                               Card.CARD_ACE_OF_CLUBS,Card.CARD_ACE_OF_DIAMONDS,Card.CARD_ACE_OF_SPADES,Card.CARD_ACE_OF_HEARTS)
       )
   else
       player:UsePill(Utils.choose(PillEffect.PILLEFFECT_BOMBS_ARE_KEYS,PillEffect.PILLEFFECT_PUBERTY,PillEffect.PILLEFFECT_RANGE_DOWN,
                               PillEffect.PILLEFFECT_RANGE_UP,PillEffect.PILLEFFECT_SPEED_DOWN,PillEffect.PILLEFFECT_SPEED_UP,
                               PillEffect.PILLEFFECT_TEARS_DOWN,PillEffect.PILLEFFECT_TEARS_UP,PillEffect.PILLEFFECT_LUCK_DOWN,
                               PillEffect.PILLEFFECT_LUCK_UP,PillEffect.PILLEFFECT_BAD_GAS),0)
   end
   return true
end

function this:updateCollectible(collect)
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  if player:HasCollectible(this.id) then
   if collect.Type == 5 then 
     if collect.Variant == 90 then 
        if room:GetType() == RoomType.ROOM_SHOP then
           local pick = Isaac.Spawn(5, 20, 1, collect.Position, vectorZero, collect)
           pick:ToPickup().Price = PickupPrice.PRICE_TWO_HEARTS
        else
           Isaac.Spawn(5, 20, 1, collect.Position, vectorZero, collect)
        end
        collect:Remove()
     end
   end
  end
end

function this:die(npc) 
   local player = Isaac.GetPlayer(0)
   if player:HasCollectible(this.id) then
      player:SetActiveCharge(player:GetActiveCharge()+1)
   end
end

local function checkroomsize()
	local room = game:GetRoom()
	local shape = room:GetRoomShape()
	if shape == RoomShape.ROOMSHAPE_2x2 or shape == RoomShape.ROOMSHAPE_LTL or shape == RoomShape.ROOMSHAPE_LTR or shape == RoomShape.ROOMSHAPE_LBL or shape == RoomShape.ROOMSHAPE_LBR then
		return 2
	end
	return 1
end

function this:decreasecharge()
	local player = Isaac.GetPlayer(0)
	if player:HasCollectible(this.id) and player:NeedsCharge() then
		if sfx:IsPlaying(171) then
			sfx:Stop(171)
		end
		if player:GetBatteryCharge() > 0 then
			local charge = player:GetActiveCharge() + player:GetBatteryCharge()
			player:DischargeActiveItem()
			player:SetActiveCharge(charge-checkroomsize())
		else
			player:SetActiveCharge(player:GetActiveCharge()-checkroomsize())
		end
	end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.updateCollectible)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateEffect)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, this.die)
  mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, this.decreasecharge)
end

return this
