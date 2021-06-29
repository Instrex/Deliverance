local this = {}
this.id = Isaac.GetItemIdByName("Air Strike!")
this.description = "Summon a line of exploding missiles"
this.rusdescription ={"Air Strike! /Воздушный удар!", "Вызывает очередь взрывающихся ракет"}
this.isActive = true

local airStrike_target = Isaac.GetEntityVariantByName("Air Strike Target")
local airStrike = Isaac.GetEntityVariantByName("Air Strike Missile")

function this:updatetarget(s)
 if s.Variant == airStrike_target then
  local sprite = s:GetSprite()
  local data = s:GetData()
  local player = Utils.GetPlayersItemUse()

  s.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_GROUND 

  if data.timer == nil then data.timer = 0 end
  if data.timer2 == nil then data.timer2 = -1 end

  if data.timer2 ~= -1 then data.timer2 = data.timer2 + 1 end
  if data.timer < 45 and data.timer>=0 then sprite:Play("Idle") end
  if data.timer >=45 then sprite:Play("Die") end
  if data.timer == 45 then sfx:Play(Isaac.GetSoundIdByName("BombWhistle"), 0.8, 0, false, 1) end
  if sprite:IsEventTriggered("Rocket1") then 
       data.timer = -1 data.timer2 = 0 
  end
  
  if data.timer2 == 8 or data.timer2 == 16 or data.timer2 == 24 or data.timer2 == 32 or data.timer2 == 40 then
     Isaac.Spawn(1000, airStrike, 0, s.Position + Vector(-240+data.timer2*10, 0), vectorZero, nil) 
     if data.timer2==40 then 
        player:AnimateCollectible(this.id, "HideItem", "Idle") 
        s:Remove() 
     end
  end

  if data.timer ~= -1 then 
    data.timer = data.timer + 1
    if Input.IsMouseBtnPressed(0) then s.Velocity = (Input.GetMousePosition(true) - s.Position) / 6
       elseif player:GetFireDirection() ~= Direction.NO_DIRECTION then s.Velocity = player:GetAimDirection()*13
       else s.Velocity = vectorZero 
    end
  else s.Velocity = vectorZero 
  end
 end
end

function this:updatemissile(npc)
 if npc.Variant == airStrike then
    local sprite = npc:GetSprite()
    sprite:Play("Idle")
    
    if sprite:IsFinished("Idle") then 
       Isaac.Explode(npc.Position, nil, 60)
      npc:Remove()
    end
  end
end

function this.use()
  local player = Utils.GetPlayersItemUse()
  player:AnimateCollectible(this.id, "LiftItem", "Idle")
  Isaac.Spawn(1000, airStrike_target, 0, player.Position, vectorZero, nil)
  sfx:Play(Isaac.GetSoundIdByName("Bomber"), 0.8, 0, false, 1) 
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updatetarget)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updatemissile)
end

return this
