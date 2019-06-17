local json = require 'json'
local this = {}

function this:load(fromSave)
  if mod:HasData() then 
    deliveranceData = json.decode(mod:LoadData())
  else
    deliveranceData = {persistent = {}, temporary = {}}
  end

  if not fromSave then
    deliveranceData.temporary = {}
    npcPersistence._reload()
  end

  this.directSave()
  npcPersistence._reload()
  npcPersistence.frozen = false
  npcPersistence.restore()
end

function this.directSave()
  mod:SaveData(json.encode(deliveranceData))
end

function this.save()
  this.directSave()
end

function this:leave(shouldSave)
  npcPersistence.frozen = true
  if not shouldSave then 
    deliveranceData.temporary = {}
    npcPersistence._reload()
  end

  this.directSave()
end

function this.init()
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, this.leave)
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, this.load)
  mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.save)
end

return this
