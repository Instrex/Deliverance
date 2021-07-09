local this = {}
this.id = Isaac.GetItemIdByName("Glass Crown")
this.description = "Gives a bonus to stats that will decrease if the character takes damage#Receiving the third hit will destroy this item"
--this.rusdescription ={"Glass Crown /���������� ������", "��� ����� � ��������������� ������� ����� ����������� ���� �������� ������� ����#���� ����� � ����������, ������� ����� �����������, ���� �������� ������� ����#��� ��������� �������� �����, ������ ��������"}
local crown = Sprite()
crown:Load("gfx/glassCrown.anm2", true)

local bonus = {
  speed = 0.15,
  damage = 0.85,
  luck = 1,
  range = 0.25,
  shotspeed = 0.10,
  tears = 0.35
}

--[[function this:update(continue)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) and continue then
	  data.glasscounter = data.glasscounter or 3
	  player:AddCacheFlags(CacheFlag.CACHE_ALL)
	  player:EvaluateItems()
	  
	elseif not player:HasCollectible(this.id) then
		data.glasscounter = nil
  end
  deliveranceDataHandler.directSave()
end--]]

function this:cache(player, flag)
  local data = player:GetData()
  if player:GetCollectibleNum(this.id) > 0 and not data.glasscounter then
    data.glasscounter = 3
  end

  if player:HasCollectible(this.id) and data.glasscounter then
    if 	   flag == CacheFlag.CACHE_SPEED     then player.MoveSpeed = player.MoveSpeed + (bonus.speed * data.glasscounter)
	elseif flag	== CacheFlag.CACHE_DAMAGE    then player.Damage = player.Damage + (bonus.damage * data.glasscounter)
	elseif flag == CacheFlag.CACHE_LUCK      then player.Luck = player.Luck + (bonus.luck * data.glasscounter)
	elseif flag == CacheFlag.CACHE_RANGE     then player.TearHeight = player.TearHeight - (bonus.range * data.glasscounter)
	elseif flag == CacheFlag.CACHE_SHOTSPEED then player.ShotSpeed = player.ShotSpeed + (bonus.shotspeed * data.glasscounter)
	elseif flag == CacheFlag.CACHE_FIREDELAY then player.MaxFireDelay =  Utils.tearsUp(player.MaxFireDelay,bonus.tears * data.glasscounter)
	  end
  end
end

function this:trigger(ent)
	local player = ent:ToPlayer()
	local data = player:GetData()
	if player:HasCollectible(this.id) and data.glasscounter then
	  data.glasscounter = data.glasscounter - 1
	  player:AddCacheFlags(CacheFlag.CACHE_ALL)
	  player:EvaluateItems()
  
	  crown:Play("Crack"..data.glasscounter,false)
  
	  if crown:IsFinished("Crack"..data.glasscounter) then
		crown:Play("Idle"..data.glasscounter)
	  end
	end
  end

function this:crownrender()
	local room = game:GetRoom()
	
	if (not Game():IsPaused()) and Isaac.GetFrameCount() % 2 == 0 then
		crown:Update()
	end
	for _, player in pairs(Utils.GetPlayers()) do
		local data = player:GetData()
		if player:HasCollectible(this.id) and not (room:GetFrameCount() == 0 and room:GetType() == RoomType.ROOM_BOSS and not room:IsClear()) and not player:IsDead() then
			crown:Render(Isaac.WorldToScreen(player.Position + Vector(0, player.Size)), Vector.Zero,Vector.Zero)
			
			if data.glasscounter == 0 then
				crown:Play("CrackFinal",false)
			else
				if not crown:IsPlaying("Crack"..data.glasscounter) then
					crown:Play("Idle"..data.glasscounter,false)
				end
			end
			
			if crown:IsFinished("CrackFinal") then
				player:RemoveCollectible(this.id)
				data.glasscounter = nil
			end
		end
	end
end
--[[function this:updateFloor()
  local player = Isaac.GetPlayer(0)
  local room = game:GetRoom()
  if player:HasCollectible(this.id) then
    if this.bonusMulti < 3 then
      this.bonusMulti = 3
      player:AddCacheFlags(CacheFlag.CACHE_ALL)
      player:EvaluateItems()
    end
  end
end--]]

function this.Init()
  --mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, this.update)
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
  --mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, this.updateFloor)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.trigger, EntityType.ENTITY_PLAYER)
  mod:AddCallback(ModCallbacks.MC_POST_RENDER, this.crownrender)
end

return this