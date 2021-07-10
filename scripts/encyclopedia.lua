local this = {}
if Encyclopedia then

	--items
	local items = {
		{
			id = deliveranceContent.items.cainsKey.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_KEY_MASTER,
			}
		},
		{
			id = deliveranceContent.items.arterialHeart.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.specialDelivery.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
			}
		},
		{
			id = deliveranceContent.items.capBrooch.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
			}
		},
		{
			id = deliveranceContent.items.theApple.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.lighter.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
			}
		},
		{
			id = deliveranceContent.items.shrinkRay.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			},
			Desc = "You know, Im something of a scientist myself",
		},
		{
			id = deliveranceContent.items.sailorHat.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.dheart.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			},
			Name = "Dc3"
		},
		{
			id = deliveranceContent.items.saltySoup.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.gasoline.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
			}
		},
		{
			id = deliveranceContent.items.luckySaucer.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.bloodyStream.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
			}
		},
		{
			id = deliveranceContent.items.theCovenant.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
			}
		},
		{
			id = deliveranceContent.items.adamsRib.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
			}
		},
		{
			id = deliveranceContent.items.goodOldFriend.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
			}
		},
		{
			id = deliveranceContent.items.hotMilk.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.battleRoyale.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
			}
		},
		{
			id = deliveranceContent.items.sage.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.rottenPorkChop.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_ROTTEN_BEGGAR,
			}
		},
		{
			id = deliveranceContent.items.lilTummy.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.scaredyShroom.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.drMedicine.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.manuscript.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.roundBattery.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_BATTERY_BUM,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.airStrike.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
			}
		},
		{
			id = deliveranceContent.items.lawful.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.bileKnight.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.dangerRoom.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.theThreater.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.beanborne.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BABY_SHOP,
			}
		},
		{
			id = deliveranceContent.items.theDivider.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
				Encyclopedia.ItemPools.POOL_CRANE_GAME,
				Encyclopedia.ItemPools.POOL_WOODEN_CHEST,
			}
		},
		{
			id = deliveranceContent.items.sinisterChalk.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
				Encyclopedia.ItemPools.POOL_CURSE,
				Encyclopedia.ItemPools.POOL_GREED_CURSE,
				Encyclopedia.ItemPools.POOL_RED_CHEST,
			}
		},
		{
			id = deliveranceContent.items.momsEarrings.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_GOLDEN_CHEST,
				Encyclopedia.ItemPools.POOL_MOMS_CHEST,
				Encyclopedia.ItemPools.POOL_OLD_CHEST,
			}
		},
		{
			id = deliveranceContent.items.timeGal.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_DEVIL,
			}
		},
		{
			id = deliveranceContent.items.silverBar.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		},
		{
			id = deliveranceContent.items.urnOfWant.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SECRET,
				Encyclopedia.ItemPools.POOL_GREED_SECRET,
			}
		},
		{
			id = deliveranceContent.items.encharmedPenny.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.obituary.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
				Encyclopedia.ItemPools.POOL_RED_CHEST,
			}
		},
		{
			id = deliveranceContent.items.shamrockLeaf.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
			}
		},
		{
			id = deliveranceContent.items.mysteryBag.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_BOSS,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		},
		{
			id = deliveranceContent.items.glassCrown.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		},
		{
			id = deliveranceContent.items.corrosiveBombs.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
				Encyclopedia.ItemPools.POOL_BOMB_BUM,
			}
		},
		{
			id = deliveranceContent.items.yumRib.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
		},
	}
	
	for _,item in ipairs(items) do
		Encyclopedia.AddItem({
			ModName = "Deliverance",
			Class = "Deliverance",
			Title = "Deliverance",
			ID = item.id,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidItemDescriptions[item.id]),
			Pools = item.Pools,
			Description = item.Desc,
			Name = item.Name
		})
	end

	local trinkets = {
		{
			id = deliveranceContent.trinkets.uncertainty.id
		},
		{
			id = deliveranceContent.trinkets.appleCore.id
		},
		{
			id = deliveranceContent.trinkets.krampusHorn.id
		},
		{
			id = deliveranceContent.trinkets.discountBrochure.id
		},
		{
			id = deliveranceContent.trinkets.darkLock.id
		},
		{
			id = deliveranceContent.trinkets.specialPenny.id
		},
		{
			id = deliveranceContent.trinkets.littleTransducer.id
		},
		{
			id = deliveranceContent.trinkets.extinguisher.id
		},
	}

	for _, trinket in pairs(trinkets) do
		Encyclopedia.AddTrinket({
			ModName = "Deliverance",
			Class = "Deliverance",
			ID = trinket.id,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidTrinketDescriptions[trinket.id]),
		})
	end

	--cards
	local cards = {
		{
			id = deliveranceContent.cards.farewellStone.id,
			sprite = Encyclopedia.RegisterSprite("../content/gfx/ui_cardfronts.anm2", "FarewellStone")
		},
		{
			id = deliveranceContent.cards.firestorms.id,
			sprite = Encyclopedia.RegisterSprite("../content/gfx/ui_cardfronts.anm2", "Firestorms")
		},
		{
			id = deliveranceContent.cards.glitch.id,
			sprite = Encyclopedia.RegisterSprite("../content/gfx/ui_cardfronts.anm2", "Glitch")
		},
		{
			id = deliveranceContent.cards.abyss.id,
			sprite = Encyclopedia.RegisterSprite("../content/gfx/ui_cardfronts.anm2", "Abyss")
		},
	}

	for _, card in pairs(cards) do
		Encyclopedia.AddCard({
			ModName = "Deliverance",
			Class = "Deliverance",
			ID = card.id,
			Spr = card.sprite,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidCardDescriptions[card.id])
		})
	end

	--pills

	Encyclopedia.AddPill({
		ModName = "Deliverance",
		Class = "Deliverance",
		ID = deliveranceContent.pills.dissReaction.id,
		WikiDesc = Encyclopedia.EIDtoWiki(__eidPillDescriptions[deliveranceContent.pills.dissReaction.id]),
		Color = 10,
		Description = "Neutral"
	})

	--characters
	Encyclopedia.AddCharacter({
		ModName = "Deliverance",
		Name = "Awan",
		ID = deliveranceContent.characters.awan,
		Sprite = Encyclopedia.RegisterSprite("../content/gfx/CharacterPortraits.anm2", "Awan", 0),

		UnlockFunc = function (self)
			self.Name = "Awan"
			self.Desc = "Unlocks when the time comes..."

			return self
		end
	})
end

return this