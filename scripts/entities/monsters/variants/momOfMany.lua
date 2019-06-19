local this = {}
this.variant = Isaac.GetEntityVariantByName("Mother Of Many")
this.variant2 = Isaac.GetEntityVariantByName("Pale Mother Of Many")

function this.checkEnemies()
  local count = 0
  for _, e in pairs(Isaac.GetRoomEntities()) do
    if e.Type == Isaac.GetEntityTypeByName("Gappy") and e.Variant == Isaac.GetEntityVariantByName("Gappy") then count = count + 1 end
  end
  return count
end

function this:behaviour(npc)
  if npc.Variant == this.variant or npc.Variant == this.variant2 then
  local sprite = npc:GetSprite()
  if npc.Variant == this.variant2 then
    sprite:ReplaceSpritesheet(0, "gfx/monsters/motherOfMany_pale.png")
    sprite:ReplaceSpritesheet(1, "gfx/monsters/motherOfMany_pale.png")
    sprite:ReplaceSpritesheet(2, "gfx/monsters/motherOfMany_pale.png")
    sprite:LoadGraphics()
  end
  local data = npc:GetData()
  if data.spawnedGappies == nil then
     for i=1, 3+math.random(2, 3) do
        local gapp = Game():Spawn(Isaac.GetEntityTypeByName("Gappy"), Isaac.GetEntityVariantByName("Gappy"), npc.Position, vectorZero, npc, 0, 1):ToNPC()
        gapp:GetData().parent=npc
        if npc.Variant == this.variant2 then
           gapp:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/lilgapers_pale.png")
           gapp:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/lilgapers_pale.png")
           gapp:GetSprite():LoadGraphics() 
        end 
     end
     data.spawnedGappies=true
  end
    if sprite:IsEventTriggered("Shoot") then 
       if this.checkEnemies() <= 10 then
          local gapp = Game():Spawn(Isaac.GetEntityTypeByName("Gappy"), Isaac.GetEntityVariantByName("Gappy"), npc.Position, vectorZero, npc, 0, 1):ToNPC()
          gapp:GetData().parent=npc
          if npc.Variant == this.variant2 then
             gapp:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/lilgapers_pale.png")
             gapp:GetSprite():ReplaceSpritesheet(1, "gfx/monsters/lilgapers_pale.png")
             gapp:GetSprite():LoadGraphics() 
          end 
       end
       for i=1, 9 do
          local params = ProjectileParams() 
          params.FallingSpeedModifier = math.random(-28, -4) 
          params.FallingAccelModifier = 1.2 
          params.Variant = 3
          local velocity = Vector(Utils.choose(math.random(-6, -1), math.random(1, 6)), Utils.choose(math.random(-6, -1), math.random(1, 6))):Rotated(math.random(-30, 30))
          npc:FireProjectiles(Vector(npc.Position.X,npc.Position.Y), velocity, 0, params)
       end
        for e, gappy in pairs(Isaac.FindInRadius(npc.Position, 128, EntityPartition.ENEMY)) do
           if gappy.Type == Isaac.GetEntityTypeByName("Gappy") and gappy.Variant == Isaac.GetEntityVariantByName("Gappy") then
              gappy.Velocity = (gappy.Position - npc.Position):Resized(36)
           end
        end
    end
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, 208)
end

return this
