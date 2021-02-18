local this = {}
if Encyclopedia then
	local items = {
		{
			id = deliveranceContent.items.sistersKey.id,
			Pools = { 
				Encyclopedia.ItemPools.POOL_SHOP,
				Encyclopedia.ItemPools.POOL_GREED_SHOP,
			}
		},
		{
			id = deliveranceContent.items.sistersHeart.id,
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
	}
	
	for _,item in ipairs(items) do
		Encyclopedia.AddItem({
			Class = "Deliverance",
			ID = item.id,
			--WikiDesc = Encyclopedia.EIDtoWiki(__eidItemDescriptions[ID]),
			Pools = item.Pools
		})
	end
	
end

return this