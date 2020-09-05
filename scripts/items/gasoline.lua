local this = {}
this.id = Isaac.GetItemIdByName("Gasoline")
this.description = "Lights up damaging fires when enemies die"
this.rusdescription ={"Gasoline /÷истерна", "–азводит повреждающий врагов огонь под убитыми противниками"}

function this:onHitNPC(npc)
  local player = Isaac.GetPlayer(0)
  if not npc:IsBoss() then 
    if player:HasCollectible(this.id) then
      local creep = Isaac.Spawn(1000, 45, 0, npc.Position, vectorZero, nil)
      creep.SpriteScale = Vector(math.min(1.75, 0.5+npc.MaxHitPoints / 50), math.min(1.75, 0.5+npc.MaxHitPoints / 50))
      creep:Update()
      sfx:Play(43, 0.8, 0, false, 1.2)
      local fire = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Gasoline Fire"), 0, npc.Position, vectorZero, player)
      local data = fire:GetData()
      data.time = 0
      fire:GetSprite():Play("Start")
      fire.SpriteScale = Vector(math.min(1.75, 0.5+npc.MaxHitPoints / 50), math.min(1.75, 0.6+npc.MaxHitPoints / 50))

      data.radius = npc.MaxHitPoints
      data.dmg = npc.MaxHitPoints / 20
      data.outTime = npc.MaxHitPoints * 10
    end
  end
end

local updateIndex = 0
function this:updateFire(npc)
  if npc.Variant == Isaac.GetEntityVariantByName("Gasoline Fire") then
    local player = Isaac.GetPlayer(0)
    local data = npc:GetData()
    local sprite = npc:GetSprite()

    data.time = data.time + 1

    if sprite:IsFinished("Start") then sprite:Play("Loop") end

    if data and data.time >= data.outTime then sprite:Play("End") end

    if sprite:IsFinished("End") then npc:Remove() end

    updateIndex = updateIndex - 1
    if updateIndex <= 0 then 
      updateIndex = 10
      for e, enemies in pairs(Isaac.FindInRadius(npc.Position, data.radius, EntityPartition.ENEMY)) do
        enemies:TakeDamage(data.dmg, 0, EntityRef(nil), 0)
      end
    end
    
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH , this.onHitNPC)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateFire)
end

return this
