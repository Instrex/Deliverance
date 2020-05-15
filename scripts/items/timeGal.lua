local this = {}
this.id = Isaac.GetItemIdByName("Time Gal")
this.description = "A ghost spawns in each room holding a pickup#If you clean room in time, he will give that pickup"
this.rusdescription ={"Time Gal /Временной гал", "Призрак поялвяется в комнате держа подбираемый предмет#Если вы вовремя зачистите комнату, то он даст этот предмет"}
this.timeGal = Isaac.GetEntityVariantByName("Time Gal")

this.timer=32

function this:updateSilhouette(npc)
 if npc.Type == 1000 and npc.Variant == this.timeGal then
    local player = Isaac.GetPlayer(0)
    local sprite = npc:GetSprite()
    local data = npc:GetData()
    local room = game:GetRoom()
    local level = game:GetLevel()
    local stage = level:GetStage()
    if not data.spawnedAndPrepared then
       if data.timeGalAnim==nil then data.timeGalAnim=false end
       if data.timeGalType==nil then data.timeGalType=Utils.choose(1,2,3,4,5) end
       if data.timeGalTime==nil then data.timeGalTime=25 end
       if data.timeGalTimer==nil then 
          if stage == LevelStage.STAGE1_1 or stage == LevelStage.STAGE1_2 or (stage == LevelStage.STAGE1_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
             data.timeGalTimer=16-data.timeGalType*2 data.timeGalTime = 25
          elseif stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2 or (stage == LevelStage.STAGE2_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
             data.timeGalTimer=12-data.timeGalType*2 data.timeGalTime = 24
          elseif stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2 or (stage == LevelStage.STAGE3_GREED and (game.Difficulty==2 or game.Difficulty==3)) then
             data.timeGalTimer=7-data.timeGalType data.timeGalTime = 20
          else
             data.timeGalTimer=6-data.timeGalType data.timeGalTime = 16
          end
          local shape = room:GetRoomShape()
          if shape == RoomShape.ROOMSHAPE_LBL or shape == RoomShape.ROOMSHAPE_LBR or shape == RoomShape.ROOMSHAPE_LTL or shape == RoomShape.ROOMSHAPE_LTR or shape == RoomShape.ROOMSHAPE_2x2 then
             data.timeGalTimer=data.timeGalTimer*2
          end
       end
       sprite:ReplaceSpritesheet(1,"gfx/effects/timeGal" .. data.timeGalType .. "Prize.png")
       sprite:LoadGraphics()
       data.spawnedAndPrepared = true
    end
    npc:ClearEntityFlags(npc:GetEntityFlags()) 
    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    
    if data.timeGalTimer>=0 then
       if this.timer>0 then this.timer=this.timer-1 else this.timer=data.timeGalTime data.timeGalTimer=data.timeGalTimer-1 end
    end

    if not data.timeGalAnim then sprite:Play("Idle") end
    if data.timeGalTimer<0 and not data.timeGalAnim then
       data.timeGalAnim = true
       if room:IsClear() then 
          sprite:Play("Win")
       else
          Game():ShakeScreen(6)
          sfx:Play(SoundEffect.SOUND_THUMBS_DOWN , 1, 0, false, 1)
          sprite:Play("Death")
       end
    end

    if room:IsClear() then 
       data.timeGalTimer=-1
    end

    if sprite:IsEventTriggered("Teleport") then
       sfx:Play(SoundEffect.SOUND_HELL_PORTAL1 , 0.8, 0, false, 1)
    end

    if sprite:IsEventTriggered("DropItem") then
       sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1)
       Isaac.Spawn(1000, 15, 0, npc.Position, vectorZero, player)
       local dropped = Utils.choose(50,50,60)
       if data.timeGalType == 1 then dropped = 20 end
       if data.timeGalType == 2 then dropped = 40 end
       if data.timeGalType == 3 then dropped = 30 end
       if data.timeGalType == 4 then dropped = 10 end
       if data.timeGalType == 5 then dropped = Utils.choose(50,50,60) end
       Isaac.Spawn(5, dropped, 1, Isaac.GetFreeNearPosition(npc.Position + Vector(0, 45), 1), Vector.FromAngle(math.random(0, 360)):Resized(1), player)
    end

    if sprite:IsFinished("Death") or sprite:IsFinished("Win") then
       npc:Remove()
    end
  end
end

function this:updateRoom()
   local room = game:GetRoom()
   local player = Isaac.GetPlayer(0)
   if player:HasCollectible(this.id) then
     if room:IsFirstVisit() and not room:IsClear() and room:GetType() ~= RoomType.ROOM_BOSS then 
      local pos = Isaac.GetFreeNearPosition(room:GetCenterPos()+Vector(math.random(-50,50),math.random(-50,50)), 1)  
      Isaac.Spawn(1000, this.timeGal, 0, pos, vectorZero, nil)
     end
   end
end

local TimeGalTimer = Sprite() TimeGalTimer:Load("gfx/timeGalTimer.anm2", true)
function this:onRender()
   local player = Isaac.GetPlayer(0)
   local room = game:GetRoom()
   for e, gal in pairs(Isaac.GetRoomEntities()) do 
      if gal.Type == 1000 and gal.Variant == this.timeGal then 
         local data = gal:GetData()
         if data.spawnedAndPrepared then
           if data.timeGalTimer>=0 then
            --local pos = room:WorldToScreenPosition(gal.Position)
            --local pos2 = room:WorldToScreenPosition(gal.Position+Vector(-23,-96))
            local pos3 = room:WorldToScreenPosition(gal.Position+Vector(-10,-96))
            --TimeGalTimer:SetFrame("Idle", 0)
            --TimeGalTimer:RenderLayer(0, Vector(pos.X,pos.Y))
            --Utils.RenderNumber(0, Vector(pos2.X,pos2.Y), false)
            Utils.RenderNumber(data.timeGalTimer, Vector(pos3.X,pos3.Y), false)
           end 
         end
      end
   end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateRoom)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateSilhouette)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.onRender)
end

return this
 