local this = {}
this.id = Isaac.GetItemIdByName("Dr. Medicine")
this.description = "Restores half a heart each time you swallow a pill#Spawns a pill upon pickup"

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    --if not deliveranceData.temporary.hasDrMedicine then
      --deliveranceData.temporary.hasDrMedicine = true
      --deliveranceDataHandler.directSave()
      if flag == CacheFlag.CACHE_TEARCOLOR then
        player:AddNullCostume(deliveranceContent.costumes.adamsRib)
        if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
          player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(deliveranceContent.costumes.adamsRib), "gfx/characters/costumes_forgotten/sheet_costume_adamsRib_forgotten.png", 0)
        end
      end

      if utils.switchData('pickedUpDrMedicinePill') then
        Isaac.Spawn(5, 70, 0, Isaac.GetFreeNearPosition(player.Position, 1), Vector.FromAngle(math.random(360)):Resized(2.5), nil)
      end
    --end
  end
end

function this:usePill(pill)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
     player:AddHearts(1)
     local heart = Isaac.Spawn(1000, 49, 0, Vector(player.Position.X,player.Position.Y-96), vectorZero, nil)
     heart:GetSprite():ReplaceSpritesheet(0,"gfx/effects/hearteffect2.png")
     heart:GetSprite():LoadGraphics()
     sfx:Play(SoundEffect.SOUND_VAMP_GULP , 1.25, 0, false, 0.8)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_USE_PILL, this.usePill)
end

return this
