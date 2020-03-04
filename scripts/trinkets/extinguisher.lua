local this = {
    id = Isaac.GetTrinketIdByName("Extinguisher"),
    description = "Extinguishes nearby fireplaces"
}

function this:update(player)
    if player:HasTrinket(this.id) then 
        for entity in Isaac.FindInRadius(player.Position, 10.0, EntityPartition.ENEMY) do
            if entity.Type == EntityType.ENTITY_FIREPLACE then
                if entity.Variant == 2 or entity.Variant == 3 then
                    Isaac.Explode(player.Position, player, 55)
                end

                entity:Die()
            end
        end
    end
end

function this.Init() 
    mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, this.update)
end

return this