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
    npcPersistence._reload()
  end

  --this.directSave()
  npcPersistence._reload()
  npcPersistence.frozen = false
  npcPersistence.restore()
end

function this.directSave()
  --print('[DDH] Direct save')
  mod:SaveData(json.encode(deliveranceData))
end

function this:leave(shouldSave)
  --print('[this:leave] shouldSave', shouldSave)
  npcPersistence.frozen = true
  if not shouldSave then 
    deliveranceData.temporary = {}
  end

  --this.directSave()
  npcPersistence._reload()
end

function this.init()
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, this.leave)
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, this.load)
end

return this
