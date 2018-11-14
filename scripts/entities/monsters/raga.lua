local this = {}
this.id = Isaac.GetEntityTypeByName("Raga")

function this:behaviour(raga)
  local sprite = raga:GetSprite()

  sprite:Play("Fly")
  raga.Velocity = (Isaac.GetPlayer(0).Position - raga.Position):Normalized()*4
end

function this:transformation(entity)
  if utils.chance(4) then
    entity:Morph(this.id, 0, 0, 0)
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, this.transformation, 252)
end

return this
