local this = {}
this.id = Isaac.GetItemIdByName("Lighter")
this.description = "Sets all enemies on fire"
this.rusdescription ={"Lighter /Зажигалка", "Поджигает всех врагов в комнате"}
this.isActive = true

function this.use()
  sfx:Play(Isaac.GetSoundIdByName("Firestarter") , 0.75, 0, false, 1)
  for e, entity in pairs(Isaac.GetRoomEntities()) do
     if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not entity:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) and entity:IsVulnerableEnemy() then 
        entity:AddBurn(EntityRef(nil), 1800,2.15 + 0.20 * (game:GetLevel():GetStage() - 1))
     end 
     if entity.Type == 1000 and (entity.Variant == 26 or entity.Variant == 45) then
        local fsize = 0.5+math.random()*0.5
        local fire = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Gasoline Fire"), 0, entity.Position, vectorZero, player)
        local data = fire:GetData()
        data.time = 0
        fire:GetSprite():Play("Start")
        fire.SpriteScale = entity.SpriteScale*fsize
        data.radius = 32*fsize
        data.dmg = 3
        data.outTime = 125*fsize
     end 
  end
  return true
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_USE_ITEM, this.use, this.id)
end

return this
