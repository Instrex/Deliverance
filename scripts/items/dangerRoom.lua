local this = {}
this.id = Isaac.GetItemIdByName("Danger Room")
this.description = "Tracks nearby enemy projectiles, filling the scale of danger#After filling the scale gives a random pick-up item"
this.rusdescription ={"Danger Room /Опасная комната", "Отслеживает ближайшие снаряды противника, заполняя шкалу опасности#После заполнения шкалы даёт случайный предмет"}
this.barOpacity=true
this.backTimer=0 this.backTimer2=0 this.backTimer3=0

function this:Update()
   local room = game:GetRoom()
   if Utils.GetPlayers() then
     for _, player in pairs(Utils.GetPlayers()) do
       local data = player:GetData()
       if player:HasCollectible(this.id) then
         if data.dangerBarUsed == nil then data.dangerBarUsed = 1 end
         if data.dangerBar == nil then data.dangerBar = 0 end
         for i,proj in ipairs(Isaac.FindByType(EntityType.ENTITY_PROJECTILE, -1, -1, true)) do
           if ((player.Position):Distance(proj.Position) < proj.Size*7 + player.Size) and not room:IsClear() and this.backTimer3==0 and not player:IsDead() and data.dangerBarUsed<11 then
             this.barOpacity=false
             this.backTimer2=10
             data.dangerBar=data.dangerBar+1
           end
         end
         if data.dangerBar>0 then
           if this.backTimer2>0 then this.backTimer2=this.backTimer2-1 else this.barOpacity=true end
           if this.backTimer>0 then this.backTimer=this.backTimer-1 else
           this.backTimer=8
           data.dangerBar=data.dangerBar-1
         end
         if data.dangerBar>=24 then
           local poof = Isaac.Spawn(1000, 14, 0, player.Position, vectorZero, nil)
           poof:GetSprite():ReplaceSpritesheet(0,"gfx/effects/effect_poof2.png")
           poof:GetSprite():LoadGraphics()
           local pos = Isaac.GetFreeNearPosition(player.Position, 1)
           --[[
           if utils.chancep(60) then
             if utils.chancep(30) then
               Isaac.Spawn(3, 43, 0, pos, vectorZero, nil)
               Isaac.Spawn(3, 73, 0, pos, vectorZero, nil)
             else
               Isaac.Spawn(5, 20, 1, pos, vectorZero, nil)
             end
           else
             if utils.chancep(50) then
               Isaac.Spawn(5, 40, 1, pos, vectorZero, nil)
             else
               if utils.chancep(50) then
                 Isaac.Spawn(5, 30, 1, pos, vectorZero, nil)
               else
                 Isaac.Spawn(5, 10, 1, pos, vectorZero, nil)
               end
             end
           end
           ]]--
           player:UseActiveItem(97,false,false,false,false)
           sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0, false, 1.125)
           --player:AnimateHappy()
           this.backTimer3=30*data.dangerBarUsed
           data.dangerBar=0
           data.dangerBarUsed=data.dangerBarUsed+1
         end
       end
       if this.backTimer3>0 then this.backTimer3=this.backTimer3-1 end
     end
   end
 end
 end

local DangerBar = Sprite() DangerBar:Load("gfx/ui/dangerRoom_bar.anm2", true)

function this:onRender()
   local room = game:GetRoom()
 
   if room:GetFrameCount() == 0 and room:GetType() == RoomType.ROOM_BOSS and not room:IsClear() then
     return
   end
   for _, player in pairs(Utils.GetPlayers()) do
     local data = player:GetData()
     if player:HasCollectible(this.id) then
       if data.dangerBar~=nil and data.dangerBar>0 and not player:IsDead() then
         local pos = room:WorldToScreenPosition(player.Position)
         if not this.barOpacity then DangerBar:SetFrame("Idle", data.dangerBar) else DangerBar:SetFrame("IdleTransparent", data.dangerBar) end
         DangerBar:RenderLayer(2, Vector(pos.X,pos.Y))
         DangerBar:RenderLayer(0, Vector(pos.X,pos.Y))
         DangerBar:RenderLayer(1, Vector(pos.X,pos.Y))
       end
     end
   end
 end

function this:updateStage()
   for _, player in pairs(Utils.GetPlayers()) do
     local data = player:GetData()
     if player:HasCollectible(this.id) then
       data.dangerBarUsed=1
     end
   end
 end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.Update)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.onRender)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.updateStage)
end

return this
 