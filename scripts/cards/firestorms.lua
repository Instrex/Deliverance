local this = {}
this.id = Isaac.GetCardIdByName("Firestorms")
this.description = "Sets all enemies on fire#Sets fire on all enemies#Grants Fire Mind effect for one room"
this.isActive = false

function this:cardCallback(cardId)
    local player = Isaac.GetPlayer(0)
    if cardId == this.id then 
        deliveranceContent.items.lighter.use()
        for e, entity in pairs(Isaac.GetRoomEntities()) do 
           if entity:IsActiveEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) and not entity:IsBoss() then 
               local fire = Isaac.Spawn(1000, Isaac.GetEntityVariantByName("Gasoline Fire"), 0, entity.Position, vectorZero, player)
               local data = fire:GetData()
               data.time = 0
               fire:GetSprite():Play("Start")
               fire.SpriteScale = Vector(math.min(1.75, 0.5+entity.MaxHitPoints / 50), math.min(1.75, 0.6+entity.MaxHitPoints / 50))
               data.radius = entity.MaxHitPoints
               data.dmg = entity.MaxHitPoints / 66
               data.outTime = entity.MaxHitPoints * 5
           end 
        end
        this.isActive = true
    end
end

function this:onTear(tear)
    if this.isActive then 
        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BURN
        tear:ChangeVariant(TearVariant.FIRE_MIND)
    end
end

function this.reset()
    this.isActive = false
end

function this.Init()
    mod:AddCallback(ModCallbacks.MC_USE_CARD, this.cardCallback, this.id)
    mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, this.onTear)
    mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, this.reset)
end

return this