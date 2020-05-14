local this = {}
this.id = Isaac.GetItemIdByName("The Covenant")
this.description = "Devil room contain more things, but all hearts are replaced by other pickups"
this.rusdescription ={"The Covenant /Завет", "Комната дьявола содержит больше наград, но все сердца заменяются на другие подбираемые предметы"}

-- Replace all hearts to their corresponding reward --
function this:pickupMorph(pickup)
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(this.id) and pickup.Variant == PickupVariant.PICKUP_HEART then
        
        local data = pickup:GetData()
        if data.time == nil then data.time = math.random(-10,0) end

        pickup.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        if data.time <= 40 then data.time = data.time + 1
        else local variant, subType = getSubstitution(pickup)
            if variant > -1 then
                Isaac.Spawn(5, variant, subType, pickup.Position, vectorZero, nil)

                Isaac.Spawn(1000, 97, 0, Vector(pickup.Position.X, pickup.Position.Y-4), vectorZero, nil)
                sfx:Play(SoundEffect.SOUND_SATAN_SPIT, 0.6, 0, false, math.random(10, 12) / 10)

                pickup:Remove()
            end
        end
    end
end

local function getSubstitution(pickup)
    if pickup.SubType == HeartSubType.HEART_FULL or
        pickup.SubType == HeartSubType.HEART_SCARED or
        pickup.SubType == HeartSubType.HEART_HALF then return 20, 1
    
    elseif pickup.SubType == HeartSubType.HEART_SOUL or
        pickup.SubType == HeartSubType.HEART_HALF_SOUL or
        pickup.SubType == HeartSubType.HEART_BLENDED then return 30, 1

    elseif pickup.SubType == HeartSubType.HEART_BLACK then return 40, 1
    elseif pickup.SubType == HeartSubType.HEART_ETERNAL then return 30, 2
    elseif pickup.SubType == HeartSubType.HEART_BONE then return 30, 4
    elseif pickup.SubType == HeartSubType.HEART_DOUBLEPACK then return 20, 4
    elseif pickup.SubType == HeartSubType.HEART_GOLDEN then return 20, 5
    elseif pickup.SubType == 4000 then return 70, math.random(1, 10)
    else return -1, 0
    end
end

function this:update()
     local player = Isaac.GetPlayer(0)
     local room = game:GetRoom()
-- print(deliveranceData.temporary.devilPrize)
     if room:GetType() == RoomType.ROOM_DEVIL and not deliveranceData.temporary.devilPrize then  
         if player:HasCollectible(this.id) then
                Game():ShakeScreen(20) 
                sfx:Play(SoundEffect.SOUND_SATAN_GROW , 0.6, 0, false, math.random(10, 12) / 10)
                local pos = Isaac.GetFreeNearPosition(room:GetCenterPos(), 1)  
                if utils.chancep(30) then
                    if utils.chancep(75) then
                         Isaac.Spawn(5, 150, 0, pos, vectorZero, nil)
                    else
                         Isaac.Spawn(5, 100, 0, pos, vectorZero, nil)
                    end
                    if utils.chancep(50) then
                         Isaac.Spawn(5, 69, 0, room:GetCenterPos() + Vector(65, 0), vectorZero, nil)
                         Isaac.Spawn(5, 69, 0, room:GetCenterPos() - Vector(65, 0), vectorZero, nil)
                    end
                else
                    Isaac.Spawn(5, 360, 0, room:GetCenterPos() + Vector(65, 0), vectorZero, nil)
                    Isaac.Spawn(5, 360, 0, room:GetCenterPos() - Vector(65, 0), vectorZero, nil)
                    if utils.chancep(30) then
                         Isaac.Spawn(5, Utils.choose(51, 60), 0, room:GetCenterPos() + Vector(85, 40), vectorZero, nil)
                         Isaac.Spawn(5, Utils.choose(51, 60), 0, room:GetCenterPos() + Vector(-85, 40), vectorZero, nil)
                    end
                    if utils.chancep(50) then
                         Isaac.Spawn(5, 360, 0, room:GetCenterPos() + vectorZero, vectorZero, nil)
                    else
                         if utils.chancep(50) then
                                Isaac.Spawn(5, 350, 0, room:GetCenterPos() + vectorZero, vectorZero, nil)
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
     if deliveranceData.temporary.devilPrize~=nil then
            deliveranceData.temporary.devilPrize=false
            deliveranceDataHandler.directSave()
     end
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, this.pickupMorph)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.update)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.nullDevilPrize)
end

return this
