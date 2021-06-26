local this = {}
if Encyclopedia then
	local items = {
		{
			id = deliveranceContent.items.cainsKey.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.arterialHeart.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_DEVIL,
				Encyclopedia.ItemPools.POOL_GREED_DEVIL,
			}
		},
		{
			id = deliveranceContent.items.specialDelivery.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
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
			}
		},
		{
			id = deliveranceContent.items.shrinkRay.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_TREASURE,
				Encyclopedia.ItemPools.POOL_GREED_TREASURE,
			}
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
			}
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
			}
		},
		{
			id = deliveranceContent.items.sage.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.rottenPorkChop.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.lilTummy.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.scaredyShroom.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.drMedicine.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.manuscript.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.roundBattery.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.airStrike.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.lawful.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.bileKnight.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.dangerRoom.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.theThreater.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.beanborne.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.theDivider.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.sinisterChalk.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.momsEarrings.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.timeGal.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.silverBar.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.urnOfWant.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.encharmedPenny.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.obituary.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.shamrockLeaf.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.mysteryBag.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.corrosiveBombs.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
		{
			id = deliveranceContent.items.yumRib.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_ANGEL,
				Encyclopedia.ItemPools.POOL_GREED_ANGEL,
			}
		},
	}
	
	for _,item in ipairs(items) do
		Encyclopedia.AddItem({
			Class = "Deliverance",
			ID = item.id,
			WikiDesc = Encyclopedia.EIDtoWiki(__eidItemDescriptions[item.id]),
			Pools = item.Pools
		})
	end
	
end

return this