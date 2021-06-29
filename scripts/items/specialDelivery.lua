local this = {}
this.id = Isaac.GetItemIdByName("Special Delivery")
this.description = "Summons a box with random things"
this.rusdescription ={"Special Delivery /Специальная доставка", "Призывает коробку с разными вещами"}
this.isActive = true

local specialDel_target = Isaac.GetEntityVariantByName("Special Delivery Target")
local specialDel = Isaac.GetEntityVariantByName("Special Delivery")

function this:updatetarget(s)
 if s.Variant == specialDel_target then
  local sprite = s:GetSprite()
  local data = s:GetData()
  local player = Isaac.GetPlayer(0)

  s.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND

  if data.time == nil then data.time = 0 end

  if data.time ~= -1 then data.time = data.time + 1
    if data.time < 30  then sprite:Play("Idle")
    elseif data.time < 40 then sprite:Play("Explode")
    elseif data.time == 40 then sprite:Play("Die") data.time = -1 end
  end
  
  if data.boxvec == nil then data.boxvec = vectorZero end

  if player:HasCollectible(356) then  
     data.boxvec = Vector.FromAngle(math.random(360)):Resized(24)
  end
  if sprite:IsFinished("Die") then
     s:Remove()
     local box = Isaac.Spawn(1000, specialDel, 0, s.Position + data.boxvec, vectorZero, nil)
     
     if utils.chancep(1) and utils.chancep(1) then 
        box:GetData().typ=3
     else 
        box:GetData().typ=math.random(0,3)
     end 
     player:AnimateCollectible(this.id, "HideItem", "Idle") 
  end

  if Input.IsMouseBtnPressed(0) then s.Velocity = (Input.GetMousePosition(true) - s.Position) / 6
    elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then s.Velocity = player:GetAimDirection()*13
    else s.Velocity = Vector.Zero
  end
 end
end

function this:updatebox(npc)
 if npc.Variant == specialDel then
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    
    if data.typ == 0 then 
        sprite:ReplaceSpritesheet(0,"gfx/projectiles/proj_special_delivery.png")
        sprite:LoadGraphics()
    elseif data.typ == 1 then 
        sprite:ReplaceSpritesheet(0,"gfx/projectiles/proj_special_delivery2.png")
        sprite:LoadGraphics()
    elseif data.typ == 2 then 
        sprite:ReplaceSpritesheet(0,"gfx/projectiles/proj_special_delivery3.png")
        sprite:LoadGraphics()
    elseif data.typ == 3 then 
        sprite:ReplaceSpritesheet(0,"gfx/projectiles/proj_special_delivery4.png")
        sprite:LoadGraphics()
    end

    if sprite:IsEventTriggered("Land") then
       sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1, 0, false, 1)
    end

    if sprite:IsEventTriggered("Explode") then
       Isaac.Explode(npc.Position, nil, 60)
       if data.typ == 0 then
          local rand = math.random(0, 3)
          if rand == 0 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, math.random(0, 2), npc.Position, vectorZero, nil) end
          if rand == 1 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, math.random(0, 2), npc.Position, vectorZero, nil) end
          if rand == 2 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 1, npc.Position, vectorZero, nil) end
          if rand == 3 then Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, math.random(0, 11), npc.Position, vectorZero, nil) end
       elseif data.typ == 1 then
          for i=1, 5+math.random(0, 3) do
             Isaac.Spawn(3, 73, 0, npc.Position, vectorZero, nil)
          end
       elseif data.typ == 2 then
          local rand2 = math.random(1, 13)
          for i=1, 3 do
             Isaac.Spawn(EntityType.ENTITY_PICKUP, 70, rand2, npc.Position, Vector.FromAngle(i*120):Resized(5), nil)
          end
       elseif data.typ == 3 then
          Isaac.Spawn(5, 350, 0, npc.Position, vectorZero, nil)
       end
    end

    if sprite:IsEventTriggered("Die") then
      npc:Remove()
    end
  end
end

function this.use()
  local player = Utils.GetPlayersItemUse()
  player:AnimateCollectible(this.id, "LiftItem", "Idle")
  Isaac.Spawn(1000, specialDel_target, 0, player.Position, vectorZero, nil)
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updatetarget)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updatebox)
end

return this
