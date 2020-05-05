local this = {}
this.id = Isaac.GetEntityTypeByName("Bloodmind Spit")
this.variant = Isaac.GetEntityVariantByName("Bloodmind Spit")

function this:behaviour(npc)
 if npc.Variant == this.variant then
  local target = npc:GetPlayerTarget()
  local sprite = npc:GetSprite()
  local data = npc:GetData()
  local room = game:GetRoom()
  local params = ProjectileParams()  
  
  -- Begin--
  if npc.State == NpcState.STATE_INIT then
    npc.State = NpcState.STATE_IDLE
    npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    npc:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
 
  -- Move and wait for player to get closer--
  elseif npc.State == NpcState.STATE_IDLE then   
    if data.GridCountdown == nil then data.GridCountdown = 0 end
    sprite:Play("Start")
	
        params.FallingSpeedModifier = math.random(-28, -4) 
        params.FallingAccelModifier = 1.2 
		
        local velocity = (target.Position - npc.Position):Rotated(math.random(-18, -18)) * 0.01 * math.random(6, 13) * 0.1
        npc:FireProjectiles(npc.Position + utils.vecToPos(target.Position, npc.Position, 10), velocity, 0, params)
        end
	npc.Velocity = utils.vecToPos(target.Position, npc.Position) * 0.2 + npc.Velocity 	
	
	if sprite:IsFinished("Start") then
       npc:Remove()
	   sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
	   elseif npc:CollidesWithGrid() then
       npc:Remove()
       sfx:Play(SoundEffect.SOUND_MEATY_DEATHS , 1.2, 0, false, 1)
       Game():ShakeScreen(5)
	  end
   end
 end
function this:onHitNPC(npc)
  if npc.Type == Isaac.GetEntityTypeByName("Bloodmind Spit") and npc.Variant == Isaac.GetEntityVariantByName("Bloodmind Spit") then
    return false
  end
end

function this.Init()
  mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, this.behaviour, this.id)
  mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, this.onHitNPC)
end

return this
