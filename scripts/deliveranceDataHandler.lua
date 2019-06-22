local json = require 'json'
local this = {}

function this:load(fromSave)
  if mod:HasData() then 
    deliveranceData = json.decode(mod:LoadData())
  else
    deliveranceData = {persistent = {}, temporary = {}}
  end
  
  --print('[this:load] hasData', mod:HasData(), 'fromSave', fromSave)

  if not fromSave then
    deliveranceData.temporary = {}
  end

  --this.directSave()
  npcPersistence.loadData(deliveranceData.temporary.persistentObjects)
end

function this.directSave()
  mod:SaveData(json.encode(deliveranceData))
end

function this:leave(shouldSave)
  --print('[this:leave] shouldSave', shouldSave)

  if not shouldSave then 
    deliveranceData.temporary = {}

  else
    deliveranceData.temporary.persistentObjects = npcPersistence.getSaveData()

  end

  this.directSave()
end

function this.init()
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, this.leave)
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, this.load)
end

return this
