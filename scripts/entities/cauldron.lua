local this = {}
this.id = Isaac.GetEntityTypeByName("Cauldron")
this.variant = Isaac.GetEntityVariantByName("Cauldron")
this.gunPowder = Isaac.GetTrinketIdByName("Gunpowder")
this.paper = Isaac.GetTrinketIdByName("Piece of Paper")
this.blood = Isaac.GetTrinketIdByName("Bottled Blood")
this.rib = Isaac.GetTrinketIdByName("Wooden Rib")
this.feather = Isaac.GetTrinketIdByName("Glowing Feather")

local symbolType = 1

local componentNames = {
  [this.gunPowder] = 'gunPowder',
  [this.paper]     = 'paper',
  [this.blood]     = 'blood',
  [this.rib]       = 'rib',
  [this.feather]   = 'feather'
}

local function getComp(data)
return data.persistent.components
end

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

  if data.persistent.components[1]~=nil then sprite:ReplaceSpritesheet(6, Isaac.GetItemConfig():GetCollectible(data.persistent.components[1]).GfxFileName) else sprite:ReplaceSpritesheet(6, "gfx/items/alchemicCauldronSymbol.png") end
  if data.persistent.components[2]~=nil then sprite:ReplaceSpritesheet(7, Isaac.GetItemConfig():GetCollectible(data.persistent.components[2]).GfxFileName) else sprite:ReplaceSpritesheet(7, "gfx/items/alchemicCauldronSymbol.png") end
  if data.persistent.components[3]~=nil then sprite:ReplaceSpritesheet(8, Isaac.GetItemConfig():GetCollectible(data.persistent.components[3]).GfxFileName) else sprite:ReplaceSpritesheet(8, "gfx/items/alchemicCauldronSymbol.png") end
  if data.persistent.components[4]~=nil then sprite:ReplaceSpritesheet(9, Isaac.GetItemConfig():GetCollectible(data.persistent.components[4]).GfxFileName) else sprite:ReplaceSpritesheet(9, "gfx/items/alchemicCauldronSymbol.png") end

  if data.persistent.components[1]~=nil and data.persistent.components[2]~=nil and data.persistent.components[3]~=nil and data.persistent.components[4]~=nil then
      sprite:ReplaceSpritesheet(5, "gfx/items/symbol" .. symbolType .. ".png") 
  else
     sprite:ReplaceSpritesheet(5, "gfx/items/alchemicCauldronSymbol.png") 
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

  elseif npc.State == 2 then
    sprite:Play("Idle")

      if (npc.Position - player.Position):Length() <= npc.Size + player.Size then

              -- При обновлении переменных необходимо вызывать npcPersistence.update(npc) 
              if data.persistent.components[1]~=nil and data.persistent.components[2]~=nil and data.persistent.components[3]~=nil and data.persistent.components[4]~=nil then
                 sfx:Play(SoundEffect.SOUND_COIN_SLOT, 1, 0, false, 1)
                 npc.State = 4
              elseif player:GetTrinket(0) ~= TrinketType.TRINKET_NULL then
                 sfx:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1)
                 table.insert(data.persistent.components, player:GetTrinket(0))
                 npcPersistence.update(npc)
                 player:TryRemoveTrinket(player:GetTrinket(0))
                 npc.State = 3
              end 
              print(data.persistent.components[1])
              print(data.persistent.components[2])
              print(data.persistent.components[3])
              print(data.persistent.components[4])
      end

  elseif npc.State == 3 then
    
    sprite:Play("AddTrinket")

    if sprite:IsFinished("AddTrinket") then
        npc.State = 2
    end

  elseif npc.State == 4 then
    
    sprite:Play("Process")

    if sprite:IsEventTriggered("SpawnItem") then
      data.persistent.components={}
      npcPersistence.update(npc)
      local pos = Isaac.GetFreeNearPosition(npc.Position + Vector(0, 75), 1)
      Isaac.Spawn(1000, 15, 0, pos, vectorZero, npc)
      Isaac.Spawn(5, 100, 0, pos, vectorZero, nil)
      sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0, false, 1)
    end

    if sprite:IsFinished("Process") then
        npc.State = 2
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

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
