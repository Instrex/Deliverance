local this = {}
this.id = Isaac.GetItemIdByName("Encharmed Penny")
this.description = "Increases health and damage of every friendly/charmed monsters#Gives you a chance to charm a random monster when entering the room"
this.rusdescription ={"Encharmed Penny /«ачарованный пенни", "”величивает здоровье и урон каждому дружелюбному/очарованному монстру#ƒает шанс очаровать случайного врага при входе в комнату"}

this.blacklist = {
   [EntityType.ENTITY_STONEHEAD] = true,
   [EntityType.ENTITY_STONEY] = true,
   [EntityType.ENTITY_CONSTANT_STONE_SHOOTER] = true,
   [EntityType.ENTITY_GAPING_MAW] = true,
   [EntityType.ENTITY_BROKEN_GAPING_MAW] = true,
   [EntityType.ENTITY_BRIMSTONE_HEAD] = true,
   [EntityType.ENTITY_GRUDGE] = true,
   [765] = true
}
 
function this:update(entity)
    local data = entity:GetData()
    local player = Isaac.GetPlayer(0)
    if player:HasCollectible(this.id) then
      if data.encharmed==nil and entity:IsActiveEnemy() and entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
        entity.Scale = entity.Scale * 1.125
        entity.MaxHitPoints = entity.MaxHitPoints*1.25
        entity.HitPoints = entity.HitPoints*1.25
        entity.CollisionDamage = entity.CollisionDamage*1.25
        data.encharmed=true
      end
    end
end

function this:updateRoom()
   local room = game:GetRoom()
   local player = Isaac.GetPlayer(0)
   if player:HasCollectible(this.id) then
     if room:IsFirstVisit() and not room:IsClear() then
        local enemies = {}
        local et = nil
        for _, entity in pairs(Isaac.GetRoomEntities()) do
           if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not entity:IsBoss() and not this.blacklist[entity.Type] then
              table.insert(enemies,entity)
              et = enemies[math.random(#enemies)]
           end
        end
        if et~=nil then
           if math.random(1, 4-(math.min(player.Luck, 3))) == 1 then
	      et:AddCharmed(EntityRef(player),-1)
	      et:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
           end
        end
     end
   end
end


function this:dropPennies()
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) and not deliveranceData.temporary.penniesDropped then
      for i=1, 5 do
         Isaac.Spawn(5, 20, 1, player.Position, Vector.FromAngle(math.random(0, 360)):Resized(2), player)
      end
      deliveranceData.temporary.penniesDropped=true
      deliveranceDataHandler.directSave()
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.update)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.updateRoom)
  mod:AddCallback(ModCallbacks.MC_POST_UPDATE, this.dropPennies)
end

return this
