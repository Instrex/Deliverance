local this = {}
this.id = Isaac.GetItemIdByName("Dr. Medicine")
this.description = "Restores half a heart each time you swallow a pill#Spawns a pill upon pickup"
this.rusdescription ={"Dr. Medicine /Доктор Врач", "Восстанавливает половину сердца каждый раз когда вы глотаете пилюлю#Cоздает одну пилюлю при подборе"}

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    --if not deliveranceData.temporary.hasDrMedicine then
      --deliveranceData.temporary.hasDrMedicine = true
      --deliveranceDataHandler.directSave()
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
