local this = {}
this.id = Isaac.GetItemIdByName("The Divider")
this.description = "Brings pickups lying on floor to their simplest form - #Nickel turns into five coins, hearts - into two halves, etc"
this.isActive = true

this.hammer = Isaac.GetEntityVariantByName("The Divider")

function this:updateHammer(npc)
 if npc.Variant == this.hammer then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    sprite:Play("Idle")
    
    if sprite:IsFinished("Idle") then 
      npc:Remove()
    end
  end
end

-- TODO: rewrite this mess
function this.use()
  local player = Isaac.GetPlayer(0)
  for _, e in pairs(Isaac:GetRoomEntities()) do
    local pickup = e:ToPickup()
    if pickup and not pickup:IsShopItem() then
      if pickup:CanReroll() then
         if pickup.Variant==20 and pickup.SubType==4 then --double penny
            for i=1, 2 do
               Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==20 and (pickup.SubType==2 or pickup.SubType==6) then --nickel
            for i=1, 5 do
               Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==20 and pickup.SubType==3 then --dime
            if utils.chancep(50) then
               for i=1, 5 do
                  Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
               end
               Isaac.Spawn(5, 20, 2, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            else
               if utils.chancep(50) then
                  for i=1, 10 do
                     Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
                  end
               else
                  for i=1, 2 do
                     Isaac.Spawn(5, 20, 2, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
                  end
               end
            end
            this.divide(pickup)

         elseif pickup.Variant==40 and pickup.SubType==2 then --double bomb
            for i=1, 2 do
               Isaac.Spawn(5, 40, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==10 and (pickup.SubType==1 or pickup.SubType==9) then --red hearts
            for i=1, 2 do
               Isaac.Spawn(5, 10, 2, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==10 and pickup.SubType==5 then --double hearts
            for i=1, 2 do
               Isaac.Spawn(5, 10, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==10 and pickup.SubType==4000 then --rainbow hearts
            for i=1, 3 do
               Isaac.Spawn(5, 10, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==10 and pickup.SubType==3 then --soul hearts
            for i=1, 2 do
               Isaac.Spawn(5, 10, 8, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==10 and pickup.SubType==10 then --blended hearts
            Isaac.Spawn(5, 10, 2, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            Isaac.Spawn(5, 10, 8, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            this.divide(pickup)

         elseif pickup.Variant==10 and pickup.SubType==6 then --black hearts
            for i=1, 2 do
               Isaac.Spawn(5, 10, 3, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)

         elseif pickup.Variant==10 and pickup.SubType==6 then --gold heart
            for i=1, 5 do
               Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            Isaac.Spawn(5, 10, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            this.divide(pickup)

         elseif pickup.Variant==40 and pickup.SubType==4 then --golden bomb
            for i=1, 5 do
               Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            Isaac.Spawn(5, 40, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            this.divide(pickup)

         elseif pickup.Variant == 30 and pickup.SubType == 3 then --key ring
            Isaac.Spawn(5, 30, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            Isaac.Spawn(5, 30, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            this.divide(pickup)

         elseif pickup.Variant==30 and pickup.SubType==2 then --golden key
            for i=1, 5 do
               Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            Isaac.Spawn(5, 30, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            this.divide(pickup)

         elseif pickup.Variant==60 then --golden chest
            for i=1, 5 do
               Isaac.Spawn(5, 20, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            Isaac.Spawn(5, 50, 0, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            this.divide(pickup)

         elseif pickup.Variant==51 or pickup.Variant==52 or pickup.Variant==54 then --bomb chest, spiked chest, mimic chest
            for i=1, 2 do
               Isaac.Spawn(5, 50, 0, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)
            
         elseif pickup.Variant==360 then --red chest
            Isaac.Spawn(5, 50, 0, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            for i=1, Utils.choose(1,2) do
               Isaac.Spawn(5, 10, 1, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)
            
         elseif pickup.Variant==53 then --eternal chest
            for i=1, 2 do
               Isaac.Spawn(5, 60, 0, pickup.Position, Vector.FromAngle(math.random(0, 360)):Resized(1), pickup)
            end
            this.divide(pickup)
         end
      end
    end
  end
  return true
end

function this.divide(pickup)
   Game():ShakeScreen(20) 
   Isaac.Spawn(1000, 15, 0, pickup.Position, vectorZero, pickup)
   local hammo = Isaac.Spawn(1000, this.hammer, 0, pickup.Position, vectorZero, nil)
   local sprite = hammo:GetSprite()
   if utils.chancep(50) then sprite.FlipX = true end
   sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 0.66, 0, false, 1) 
   pickup:Remove()
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateHammer)
end

return this
