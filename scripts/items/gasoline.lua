local this = {}
this.id = Isaac.GetItemIdByName("Gasoline")
this.variant = Isaac.GetEntityVariantByName("Gasoline Fire")

function this:cache(player, flag)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
    player:AddNullCostume(content.costumes.gasoline)
    if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then  
      player:ReplaceCostumeSprite(Isaac.GetItemConfig():GetNullItem(content.costumes.gasoline), "gfx/costumes/sheet_costume_gasoline_forgotten.png", 0)
    end
  end
end

function this:onHitNPC(npc)
  local player = Isaac.GetPlayer(0)
  if player:HasCollectible(this.id) then
      Isaac.Spawn(1000, 45, 0, npc.Position, Vector(0, 0), player)
      SFXManager():Play(43, 0.8, 0, false, 1.2)
      local fire = Isaac.Spawn(1000, this.variant, 0, npc.Position, Vector(0, 0), player)
      local data = fire:GetData()
      data.time = 0
      fire:GetSprite():Play("Start")
  end
end

function this:updateFire(npc)
  if npc.Variant == this.variant then
    local player = Isaac.GetPlayer(0)
    local data = npc:GetData()
    local sprite = npc:GetSprite()

    data.time = data.time + 1

    if sprite:IsFinished("Start") then sprite:Play("Loop") end

    if data.time >= 116 then sprite:Play("End") end

    if sprite:IsFinished("End") then npc:Remove() end

    for e, enemies in pairs(Isaac.FindInRadius(npc.Position, 15, EntityPartition.ENEMY)) do
      enemies:TakeDamage(0.75, 0, EntityRef(nil), 0)
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, this.cache)
    
    
  mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH , this.onHitNPC)
  mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, this.updateFire)
end

return this
