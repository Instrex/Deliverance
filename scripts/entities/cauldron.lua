local this = {}
this.id = Isaac.GetEntityTypeByName("Cauldron")
this.variant = Isaac.GetEntityVariantByName("Cauldron")

local symbolType = 1
local droppedTrinket = 1

cauldronRecipeHandler = require 'scripts.cauldronRecipeHandler'
function this:behaviour(npc)
 if npc.Variant == this.variant then
  local sprite = npc:GetSprite()
  local player = Isaac.GetPlayer(0)

  -- В начале нужно инициализировать data.persistent --
  local data = npc:GetData()
  data.persistent = data.persistent or { components = {} }
  data.Position = data.Position or npc.Position

  -- Затем, если этот объект не имеет присвоенного индекса, задать его и загрузить данные(если имеются) --
  if not data._index then 
    data._index = npcPersistence.initEntity(npc)
  end

  data.processing = data.processing or false

  if data.persistent.components[1]~=nil then sprite:ReplaceSpritesheet(6, Isaac.GetItemConfig():GetTrinket(data.persistent.components[1]).GfxFileName) else sprite:ReplaceSpritesheet(6, "gfx/items/alchemicCauldronSymbol.png") end
  if data.persistent.components[2]~=nil then sprite:ReplaceSpritesheet(7, Isaac.GetItemConfig():GetTrinket(data.persistent.components[2]).GfxFileName) else sprite:ReplaceSpritesheet(7, "gfx/items/alchemicCauldronSymbol.png") end
  if data.persistent.components[3]~=nil then sprite:ReplaceSpritesheet(8, Isaac.GetItemConfig():GetTrinket(data.persistent.components[3]).GfxFileName) else sprite:ReplaceSpritesheet(8, "gfx/items/alchemicCauldronSymbol.png") end
  if data.persistent.components[4]~=nil then sprite:ReplaceSpritesheet(9, Isaac.GetItemConfig():GetTrinket(data.persistent.components[4]).GfxFileName) else sprite:ReplaceSpritesheet(9, "gfx/items/alchemicCauldronSymbol.png") end

  if data.persistent.components[1]~=nil and data.persistent.components[2]~=nil and data.persistent.components[3]~=nil and data.persistent.components[4]~=nil then
    if not data.outcome then 
      data.outcome = cauldronRecipeHandler.queryExactRecipe(data.persistent.components)
    end

    sprite:ReplaceSpritesheet(5, "gfx/items/symbol" .. data.outcome[2] .. ".png") 
    sprite:ReplaceSpritesheet(1, "gfx/items/alchemicCauldronCloud.png")
  else
    sprite:ReplaceSpritesheet(5, "gfx/items/alchemicCauldronSymbol.png") 
    sprite:ReplaceSpritesheet(1, "gfx/items/alchemicCauldronSymbol.png")
  end
  sprite:LoadGraphics()

  npc.Velocity = data.Position - npc.Position
  --local room = game:GetRoom()

  -- Begin --
  if npc.State == NpcState.STATE_INIT then
    npc:ClearEntityFlags(npc:GetEntityFlags()) 
    npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
    npc.State = 2 
    data.processing = false

  elseif npc.State == 2 then
    sprite:Play("Idle")

      if (npc.Position - player.Position):Length() <= npc.Size + player.Size then

              -- При обновлении переменных необходимо вызывать npcPersistence.update(npc) 
              if data.persistent.components[1]~=nil and data.persistent.components[2]~=nil and data.persistent.components[3]~=nil and data.persistent.components[4]~=nil then
                 sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
                 npc.State = 4
              --elseif player:GetTrinket(0) ~= TrinketType.TRINKET_NULL then
              elseif deliveranceContent.characters.awan.currentMaterialNumber > 0 then
                 sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
                 table.insert(data.persistent.components, deliveranceContent.characters.awan.currentMaterial)
                 npcPersistence.update(npc)
                 droppedTrinket = deliveranceContent.characters.awan.currentMaterial
                 if deliveranceContent.characters.awan.currentMaterial==deliveranceContent.characters.awan.gunPowder then deliveranceData.temporary.m1=deliveranceData.temporary.m1-1 end
                 if deliveranceContent.characters.awan.currentMaterial==deliveranceContent.characters.awan.paper then deliveranceData.temporary.m2=deliveranceData.temporary.m2-1 end
                 if deliveranceContent.characters.awan.currentMaterial==deliveranceContent.characters.awan.blood then deliveranceData.temporary.m3=deliveranceData.temporary.m3-1 end
                 if deliveranceContent.characters.awan.currentMaterial==deliveranceContent.characters.awan.rib then deliveranceData.temporary.m4=deliveranceData.temporary.m4-1 end
                 if deliveranceContent.characters.awan.currentMaterial==deliveranceContent.characters.awan.feather then deliveranceData.temporary.m5=deliveranceData.temporary.m5-1 end
                 deliveranceDataHandler.directSave()
                 --player:TryRemoveTrinket(player:GetTrinket(0))
                 npc.State = 3
              end 
      end
      data.processing = false

  elseif npc.State == 3 then
    
    sprite:Play("AddTrinket")

    if sprite:IsFinished("AddTrinket") then
        npc.State = 2
    end

    if sprite:IsEventTriggered("Gulp") then
      sfx:Play(212, 1, 0, false, math.random(7, 9) / 10)
    end

    if droppedTrinket~=nil then
        sprite:ReplaceSpritesheet(10, Isaac.GetItemConfig():GetTrinket(droppedTrinket).GfxFileName) 
        sprite:LoadGraphics()
    end

    data.processing = false

  elseif npc.State == 4 then
    
    sprite:Play("Process")

    if sprite:IsEventTriggered("SpawnItem") then
      data.persistent.components={}
      npcPersistence.update(npc)
      
      local pos = Isaac.GetFreeNearPosition(npc.Position + Vector(0, 75), 1)
      Isaac.Spawn(1000, 15, 0, pos, vectorZero, npc)
      Isaac.Spawn(5, 100, cauldronRecipeHandler.evaluateOutcome(data.outcome), pos, vectorZero, nil)
      sfx:Play(SoundEffect.SOUND_SUMMONSOUND, 1, 0, false, 1)

      data.outcome = nil
    end

    if sprite:IsEventTriggered("CauldronProcess") then
      --sfx:Play(SoundEffect.SOUND_METAL_BLOCKBREAK , 1, 0, false, math.random(7, 9) / 10)
      sfx:Play(Isaac.GetSoundIdByName("CauldronJump"), 0.8, 0, false, 1.2)
      sfx:Play(212, 1.2, 0, false, math.random(7, 9) / 10)
    end

    if sprite:IsFinished("Process") then
        npc.State = 2
    end

    data.processing = true
  end
 end
end

function this:onHitNPC(npc, dmg, flag)
 local data = npc:GetData()
 if npc.Type == this.id  then
  if npc.Variant == this.variant then 
    if flag and DamageFlag.DAMAGE_EXPLOSION > 0 and not data.processing then
       for i=1, #data.persistent.components do
          if data.persistent.components[i]~=nil then Isaac.Spawn(5, 350, data.persistent.components[i], npc.Position, Vector.FromAngle(math.random(0, 180)):Resized(5), npc) end
       end

       data.persistent.components = {}
       data.outcome = nil
       npcPersistence.update(npc)
       return false
    end
    return false
  end
 end
end

-- MC_EXECUTE_CMD 
function this:cauldronCmd(cmd, params)
  if cmd ~= 'cauldron' then 
    return
  end

  local components = string.split(params, ' ')
  local lastComponent = -1
  for i=1, #components do 
    if tonumber(components[i]) ~= nil then 
      for j=0, tonumber(components[i]) - 2 do 
        Isaac.Spawn(5, 350, lastComponent, Isaac.GetPlayer(0).Position, vectorZero, nil)
      end
    else
      Isaac.Spawn(5, 350, ComponentID[components[i]], Isaac.GetPlayer(0).Position, vectorZero, nil)
      lastComponent = ComponentID[components[i]]
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
  mod:AddCallback(ModCallbacks.MC_EXECUTE_CMD, this.cauldronCmd)
end

return this
