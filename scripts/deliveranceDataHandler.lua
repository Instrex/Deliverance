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
  if deliveranceData.persistent.completiondata then
    deliveranceData.persistent.deliriumcomp = deliveranceData.persistent.completiondata[0]
    deliveranceData.persistent.heartcomp = deliveranceData.persistent.completiondata[1]
    deliveranceData.persistent.isaaccomp = deliveranceData.persistent.completiondata[2]
    deliveranceData.persistent.satancomp = deliveranceData.persistent.completiondata[3]
    deliveranceData.persistent.rushcomp = deliveranceData.persistent.completiondata[4]
    deliveranceData.persistent.bluebabycomp = deliveranceData.persistent.completiondata[5]
    deliveranceData.persistent.lambcomp = deliveranceData.persistent.completiondata[6]
    deliveranceData.persistent.megasatancomp = deliveranceData.persistent.completiondata[7]
    deliveranceData.persistent.greedcomp = deliveranceData.persistent.completiondata[8]
    deliveranceData.persistent.hushcomp = deliveranceData.persistent.completiondata[9]
  end
end

function this:leave(shouldSave)
  --print('[this:leave] shouldSave', shouldSave)
  if not shouldSave then 
    deliveranceData.temporary = {}

  else
    deliveranceData.temporary.persistentObjects = npcPersistence.getSaveData()

  end

  this.directSave()
  npcPersistence.clear()
end

function this.init()
  mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, this.leave)
  mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, this.load)
end

return this
