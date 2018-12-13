local this = {}
this.id = Isaac.GetItemIdByName("The Covenant")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    if not deliveranceData.temporary.hasCovenant then
      deliveranceData.temporary.devilPrize=false
      deliveranceData.temporary.hasCovenant = true
      deliveranceDataHandler.directSave()

      player:AddNullCostume(content.costumes.theCovenant)
      if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then  
        player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(content.costumes.theCovenant), "gfx/costumes/sheet_costume_theCovenant_forgotten.png", 0)
      end
    end
  end
end

-- Replace all hearts to their corresponding reward --
function this:pickupMorph(pickup)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) and pickup.Variant == PickupVariant.PICKUP_HEART then
    
    local data = pickup:GetData()
    if data.time == nil then data.time = math.random(-10,0) end

    pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

    if data.time <= 40 then data.time = data.time + 1
    else
      Isaac.Spawn(1000, 97, 0, Vector(pickup.Position.X, pickup.Position.Y-4), Vector(0, 0), nil)
      SFXManager():Play(SoundEffect.SOUND_SATAN_SPIT , 0.6, 0, false, math.random(10, 12) / 10)
      if pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_SCARED or pickup.SubType == HeartSubType.HEART_HALF then
        Isaac.Spawn(5, 20, 1, pickup.Position, Vector(0, 0), nil)
        pickup:Remove()

      elseif pickup.SubType == HeartSubType.HEART_BLACK then
        Isaac.Spawn(5, 40, 1, pickup.Position, Vector(0, 0), nil)
        pickup:Remove()

      elseif pickup.SubType == HeartSubType.HEART_ETERNAL then
        Isaac.Spawn(5, 30, 2, pickup.Position, Vector(0, 0), nil)
        pickup:Remove()

      elseif pickup.SubType == HeartSubType.HEART_SOUL or pickup.SubType == HeartSubType.HEART_HALF_SOUL or pickup.SubType == HeartSubType.HEART_BLENDED then
        Isaac.Spawn(5, 30, 1, pickup.Position, Vector(0, 0), nil)
        pickup:Remove()

      elseif pickup.SubType == HeartSubType.HEART_BONE then
        Isaac.Spawn(5, 30, 4, pickup.Position, Vector(0, 0), nil)
        pickup:Remove()

      elseif pickup.SubType == HeartSubType.HEART_DOUBLEPACK then
        Isaac.Spawn(5, 20, 4, pickup.Position, Vector(0, 0), nil)
        pickup:Remove()

      elseif pickup.SubType == HeartSubType.HEART_GOLDEN then
        Isaac.Spawn(5, 20, 5, pickup.Position, Vector(0, 0), nil)
        pickup:Remove()

      end
    end
  end
end

function this:update()
   local player = Isaac.GetPlayer(0)
   local room = game:GetRoom()
-- print(data.temporary.devilPrize)
   if room:GetType() == RoomType.ROOM_DEVIL and not deliveranceData.temporary.devilPrize then  
     if player:HasCollectible(this.id) then
        Game():ShakeScreen(20) 
        SFXManager():Play(SoundEffect.SOUND_SATAN_GROW , 0.6, 0, false, math.random(10, 12) / 10)
        local pos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 1)  
        if utils.chancep(30) then
          if utils.chancep(75) then
             Isaac.Spawn(5, 150, 0, pos, Vector(0, 0), nil)
          else
             Isaac.Spawn(5, 100, 0, pos, Vector(0, 0), nil)
          end
          if utils.chancep(50) then
             Isaac.Spawn(5, 69, 0, room:GetCenterPos() + Vector(65, 0), Vector(0, 0), nil)
             Isaac.Spawn(5, 69, 0, room:GetCenterPos() - Vector(65, 0), Vector(0, 0), nil)
          end
        else
          Isaac.Spawn(5, 360, 0, room:GetCenterPos() + Vector(65, 0), Vector(0, 0), nil)
          Isaac.Spawn(5, 360, 0, room:GetCenterPos() - Vector(65, 0), Vector(0, 0), nil)
          if utils.chancep(30) then
             Isaac.Spawn(5, Utils.choose(51, 60), 0, room:GetCenterPos() + Vector(85, 40), Vector(0, 0), nil)
             Isaac.Spawn(5, Utils.choose(51, 60), 0, room:GetCenterPos() + Vector(-85, 40), Vector(0, 0), nil)
          end
          if utils.chancep(50) then
             Isaac.Spawn(5, 360, 0, room:GetCenterPos() + Vector(0, 0), Vector(0, 0), nil)
          else
             if utils.chancep(50) then
                Isaac.Spawn(5, 350, 0, room:GetCenterPos() + Vector(0, 0), Vector(0, 0), nil)
             end
          end
        end
        player:AddHearts(20)
        player:AddSoulHearts(2)
        player:AddBlackHearts(2)
        deliveranceData.temporary.devilPrize=true
        deliveranceDataHandler.directSave()
     end
   end
end

function this:nullDevilPrize()     
   deliveranceData.temporary.devilPrize=false
   deliveranceDataHandler.directSave()
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.pickupMorph)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.nullDevilPrize)
end

return this
