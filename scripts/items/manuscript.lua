local this = {}
this.id = Isaac.GetItemIdByName("The Manuscript")

local sfx = SFXManager()

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if not deliveranceData.temporary.hasManuscript then
      deliveranceData.temporary.hasManuscript = true
      deliveranceDataHandler.directSave()
      player:AddNullCostume(deliveranceContent.costumes.manuscript)
      local card = Isaac.Spawn(5, 300, 0, Isaac.GetFreeNearPosition(player.Position, 1), Vector.FromAngle(math.random(360)):Resized(2.5), nil)
    end
  end
end

function this:useCard(card)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
     player:AddSoulHearts(1)
     local heart = Isaac.Spawn(1000, 49, 0, Vector(player.Position.X,player.Position.Y-96), Vector(0,0), nil)
     heart:GetSprite():ReplaceSpritesheet(0,"gfx/effects/hearteffect3.png")
     heart:GetSprite():LoadGraphics()
     sfx:Play(Isaac.GetSoundIdByName("Spawn"), 1.2, 0, false, 1.1)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_USE_CARD, this.useCard)
end

return this
 