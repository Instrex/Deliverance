local this = {}
this.id = Isaac.GetEntityTypeByName("Munchubus")
this.variant = Isaac.GetEntityVariantByName("Munchubus")

function this:_yieldPassiveItems()
  local set = {}
  for _, class in pairs(deliveranceContent.items) do
    if not class.isActive then 
      table.insert(set, class.id)
    end
  end

  return set
end

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local sprite = npc:GetSprite()
  local player = Isaac.GetPlayer(0)

  -- В начале нужно инициализировать data.persistent --
  local data = npc:GetData()
  --data.persistent = data.persistent or { coins = 0 }
  data.Position = data.Position or npc.Position

  -- Затем, если этот объект не имеет присвоенного индекса, задать его и загрузить данные(если имеются) --
  if not data._index then 
    data._index = npcPersistence.initEntity(npc)
  end

  npc.Velocity = data.Position - npc.Position
  --local room = game:GetRoom()

  function this.replaceItem()
    if player:GetActiveItem()~=0 then
      sprite:ReplaceSpritesheet(5, Isaac.GetItemConfig():GetCollectible(player:GetActiveItem()).GfxFileName)
      sprite:LoadGraphics()
    end
  end

  if sprite:IsEventTriggered("ChestOpen") then
     sfx:Play(SoundEffect.SOUND_CHEST_OPEN, 1.2, 0, false, 0.9)
     sfx:Play(SoundEffect.SOUND_MONSTER_GRUNT_0 , 0.8, 0, false, 1)
  end

  if sprite:IsEventTriggered("ChestClosed") then
     sfx:Play(SoundEffect.SOUND_CHEST_DROP, 1.2, 0, false, 0.9)
     Game():ShakeScreen(5)
  end

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc:ClearEntityFlags(npc:GetEntityFlags()) 
    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
    if player:GetActiveItem()~=0 then npc.State = 3 else npc.State = 2 end
    
  elseif npc.State == 2 then
    sprite:Play("Sleeping")

  elseif npc.State == 3 then
    sprite:Play("Idle")

      if (npc.Position - player.Position):Length() <= 150 then
          npc.State = 4
      end

    this.replaceItem()

  elseif npc.State == 4 then
    
    sprite:Play("IdleToMouth")

    if sprite:IsFinished("IdleToMouth") then
       npc.State = 5
    end
    
    this.replaceItem()

  elseif npc.State == 5 then
    sprite:Play("Mouth")

      if (npc.Position - player.Position):Length() > 150 then
          npc.State = 6
      end

      if (npc.Position - player.Position):Length() <= npc.Size + player.Size then
          if player:GetActiveItem()~=0 then
              sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
              --player:AddCoins(1)
              --print(data._index..': '..data.persistent.coins)

              -- При обновлении переменных необходимо вызывать npcPersistence.update(npc) --
              --data.persistent.coins = data.persistent.coins + 1
              --npcPersistence.update(npc)

              npc.State = 7
              --npc.StateFrame = -1
          end
      end
    this.replaceItem()

  elseif npc.State == 6 then
    
    sprite:Play("MouthToIdle")

    if sprite:IsFinished("MouthToIdle") then
       npc.State = 3
    end
    this.replaceItem()

  elseif npc.State == 7 then
    
    sprite:Play("Transform")

    if sprite:IsEventTriggered("ChestRoar1") then
       sfx:Play(SoundEffect.SOUND_MONSTER_ROAR_0 , 0.8, 0, false, 1)
    end

    if sprite:IsEventTriggered("RemoveItem") then
        player:RemoveCollectible(player:GetActiveItem())
        sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
    end

    if sprite:IsEventTriggered("SpawnItem") then
      local loopIndex = 0
      local passives = this._yieldPassiveItems()
      local item = utils.chooset(passives)
      while loopIndex < 50 and player:HasCollectible(item) do
          item = utils.chooset(passives)
          loopIndex = loopIndex + 1
      end

      Isaac.Spawn(5, 100, item, Isaac.GetFreeNearPosition(npc.Position + Vector(0, 75), 1), vectorZero, nil)
      sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0, false, 1)
    end

    if sprite:IsFinished("Transform") then
        npc.State = 8
    end

  elseif npc.State == 8 then
    sprite:Play("IdleWithoutItem")

  elseif npc.State == 9 then
    
    sprite:Play("AltarGone")

    if sprite:IsEventTriggered("Prize") then
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
    end

    if sprite:IsEventTriggered("Teleport") then
      sfx:Play(SoundEffect.SOUND_HELL_PORTAL1 , 0.8, 0, false, 1)
    end

    if sprite:IsFinished("AltarGone") then
       -- При удалении нпс нужно вызывать npcPersistence.remove(npc) --
       npcPersistence.remove(npc)
       npc:Remove()
    end
  end
 end
end

function this:onHitNPC(npc)
 if npc.Type == this.id  then
  if npc.Variant == this.variant then
    return false
  end
 end
end

if MinimapAPI then

	local minimapIcons = Sprite()
	minimapIcons:Load("gfx/ui/minimapapi/deliverance_icons.anm2", true)
	minimapIcons:Play("DeliveranceIconFarewellStoneCard", true)
	
	MinimapAPI:AddIcon(
		"DeliveranceMunchubusIcon",
		minimapIcons,
		"DeliveranceIconChestBoy",
		0
	)
	
	MinimapAPI:AddPickup(
		"DeliveranceMunchubus",
		"DeliveranceMunchubusIcon",
		this.id,
		this.variant,
		-1,
		nil,
		"deliverancemisc",
		4000
	)
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
