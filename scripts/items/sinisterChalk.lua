local this = {}
this.id = Isaac.GetItemIdByName("Sinister Chalk")
this.description = "Draws silhouettes on the floor in every room#Stand for a second on the silhouette to summon the shadow#Type of shadow depends on the floor you are on#When room is cleaned, the silhouette disappears"
this.rusdescription ={"Sinister Chalk /Зловещий мел", "Рисует силуэты на полу в каждой комнате#Стоя на силуэтах, вы будете призывать тени.#Тип тени зависит от этажа на котором вы находитесь# Когда комната зачищена, силуэт исчезает"}
this.silhouette = Isaac.GetEntityVariantByName("Silhouette")
this.silhouette2 = Isaac.GetEntityVariantByName("Silhouette 2")

function this:updateSilhouette(npc)
 if npc.Type == 1000 and npc.Variant == this.silhouette2 then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = game:GetRoom()
    local level = game:GetLevel()
    local stage = level:GetStage()
    if data.checkForSilhouette == nil then 
        local sil = Isaac.Spawn(1000, this.silhouette, 0, npc.Position, vectorZero, nil)
        local silType=Utils.choose(1,2,3,4,5) 
        sil:GetSprite():ReplaceSpritesheet(0, "gfx/effects/silhouette" .. silType .. "type.png")
        sil:GetSprite():LoadGraphics()
        sil:GetSprite():Play("Idle")
        sil:ClearEntityFlags(npc:GetEntityFlags()) 
        sil:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_RENDER_FLOOR )
        data.checkForSilhouette = true
    end
    if deliveranceData.temporary.shadowTimer == nil then 
       deliveranceData.temporary.shadowTimer = 0 
    end
    npc:ClearEntityFlags(npc:GetEntityFlags()) 
    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    npc.Visible=false
    if npc.Position:Distance(player.Position+Vector(0,0)) <= 25 then
       deliveranceData.temporary.shadowTimer = deliveranceData.temporary.shadowTimer + 1
    else
       deliveranceData.temporary.shadowTimer = 0
    end
    if deliveranceData.temporary.shadowTimer>=34 then
       local cloneType = 10
       if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 or (stage == LevelStage.STAGE1_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
          cloneType = Utils.choose(10,15,23,40,305)
       elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 or (stage == LevelStage.STAGE2_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
          cloneType = Utils.choose(38,32,40,87,24,204,227,229)
       elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
          cloneType = Utils.choose(90,39,38,55,247)
       elseif stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2 or (stage == LevelStage.STAGE4_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
          cloneType = Utils.choose(39,59,219,224,225,259)
       else
          cloneType = Utils.choose(219,224,225,259,285)
       end
       local clone = Game():Spawn(cloneType, 0, npc.Position, vectorZero, npc, 0, 1):ToNPC()
       clone:AddCharmed(-1)
       clone:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
       clone:SetColor(Color(0,0,0,0.75,0,0,0),0,0,false,false)
       clone.MaxHitPoints = clone.MaxHitPoints*1
       clone.HitPoints = clone.HitPoints*1
       clone.CollisionDamage = clone.CollisionDamage*1
       deliveranceData.temporary.shadowTimer = 0
       Isaac.Spawn(1000, 18, 0, npc.Position, vectorZero, player)
       sfx:Play(SoundEffect.SOUND_HELLBOSS_GROUNDPOUND, 0.66, 0, false, 1) 
       npc:Remove()
    end
    if room:IsClear() then 
       deliveranceData.temporary.shadowTimer = 0 
       sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1)
       Isaac.Spawn(1000, 15, 0, npc.Position, vectorZero, player)
       Isaac.Spawn(1000, 18, 0, npc.Position, vectorZero, player)
       npc:Remove()
    end
  end
end

function this:updateRoom()
   local room = game:GetRoom()
   local player = Isaac.GetPlayer(0)
   if player:HasCollectible(this.id) then
     if room:IsFirstVisit() and not room:IsClear() then 
      local pos = Isaac.GetFreeNearPosition(room:GetCenterPos()+Vector(math.random(-150,150),math.random(-150,150)), 1)  
      Isaac.Spawn(1000, this.silhouette2, 0, pos, vectorZero, nil)
     end
   end
end

function this.checkForSilhouette()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e.Type == 1000 and e.Variant == this.silhouette2 then count = count + 1 end
  end

  return count
end

function this:Update()
  local player = Isaac.GetPlayer(0)
  local level = game:GetLevel()
  local stage = level:GetStage()
  local room = game:GetRoom()
  if player:HasCollectible(this.id) then
     if deliveranceData.temporary.sinisterTimer==nil then
        deliveranceData.temporary.sinisterTimer=0
        deliveranceDataHandler.directSave() 
     end
     if deliveranceData.temporary.sinisterTimer<500 and not room:IsClear() and (game.Difficulty==2 or game.Difficulty==3 or room:GetType() == RoomType.ROOM_BOSSRUSH) and this.checkForSilhouette()<=0 then
        deliveranceData.temporary.sinisterTimer=deliveranceData.temporary.sinisterTimer+1
     end
     if deliveranceData.temporary.sinisterTimer>=500 then
        local pos = Isaac.GetFreeNearPosition(room:GetCenterPos()+Vector(math.random(-250,250),math.random(-250,250)), 1)  
        Isaac.Spawn(1000, this.silhouette2, 0, pos, vectorZero, nil)
        Isaac.Spawn(1000, 15, 0, pos, vectorZero, nil)
        deliveranceData.temporary.sinisterTimer=0
        deliveranceDataHandler.directSave() 
     end
  end
end

local ShalkBar = Sprite() ShalkBar:Load("gfx/ui/sinisterShalk_bar.anm2", true)
function this:onRender()
   local player = Isaac.GetPlayer(0)
   local room = game:GetRoom()
   if player:HasCollectible(this.id) then
      if deliveranceData.temporary.shadowTimer~=nil and deliveranceData.temporary.shadowTimer>0 and not player:IsDead() then
         local pos = room:WorldToScreenPosition(player.Position)
         ShalkBar:SetFrame("Idle", deliveranceData.temporary.shadowTimer)
         ShalkBar:RenderLayer(2, Vector(pos.X,pos.Y))
         ShalkBar:RenderLayer(0, Vector(pos.X,pos.Y))
         ShalkBar:RenderLayer(1, Vector(pos.X,pos.Y))
         ShalkBar:RenderLayer(3, Vector(pos.X,pos.Y))
      end
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateRoom)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateSilhouette)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.onRender)
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.Update)
end

return this
 