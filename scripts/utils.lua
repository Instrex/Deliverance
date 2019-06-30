Utils = {}

-- Usage
-- Utils.chance(10) to roll a number from 0 to 10 and return true with 10% chance
-- Utils.chance(10, "yes", "no") to roll a number and return "yes" or "no" based of result of roll
function Utils.chance(k, t, f)
  if t ~= nil then
    if math.random(0, k) == k - 1 then
      return t
    else
      return f
    end
  end

  return math.random(0, k) == k - 1
end

-- Usage
-- Utils.chancep(20) will return true with 20% probability
function Utils.chancep(percentage)
  return math.random(0, 100) <= percentage
end

-- Usage
-- Utils.switch(value, { "a" = function() print("smth") end, "b" = doSmth()}) to invoke "a" if value = "a", "b" if value = "b"
function Utils.switch(val, cases)
  if cases[val] ~= nil then
    cases[val]()
  end
end

-- Usage
-- Utils.vecToPos(player.Position, npc.Position, 4) will return velocity from player's pos to enemy with speed 4
function Utils.vecToPos(from, to, speed)
  return (from - to):Normalized() * (speed or 1)
end

-- Usage
-- Utils.choose(1, 2, 3) will return 1, 2 or 3 randomly
function Utils.choose(...)
  if not ... then 
    return nil
  end

  local args = { ... }
  return args[math.random(#args)]
end

-- Usage
-- Utils.choose({2, 3, 4}) will return 2, 3 or 4 randomly
function Utils.chooset(t)
  local keyset = {}
  for k in pairs(t) do
      table.insert(keyset, k)
  end

  return t[keyset[math.random(#keyset)]]
end

-- Usage
-- if Utils.switchData('something') then
--  ...
-- end
function Utils.switchData(key, type, value)
  type = type or 'temporary'
  value = value or true
  if not deliveranceData[type][key] then 
    deliveranceData[type][key] = value
    return true
  end

  return false
end

-- Usage
-- Utils.getData('key') is equal to deliveranceData.temporary.key
function Utils.getData(key, type)
  type = type or 'temporary'
  return deliveranceData[type][key]
end

-- Usage
-- Utils.getCostume('costumeName')
function Utils.getCostume(name)
  return Isaac.GetCostumeIdByPath("gfx/characters/costumes/animation_costume_"..name..".anm2")
end

function Utils.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  
  return false
end
 
function Utils.playAchievement(name)
         
  sprite = Sprite()
        
  sprite:Load("gfx/ui/achievement/achievement.anm2", true)
        
  sprite:ReplaceSpritesheet(2, name)
        
  sprite:LoadGraphics()
        
    
end
    

function Utils.getScreenCenterPosition()
     
    local room = Game():GetRoom()
    local shape = room:GetRoomShape()
    local centerOffset = (room:GetCenterPos()) - room:GetTopLeftPos()
    local pos = room:GetCenterPos()
    if centerOffset.X > 260 then
        pos.X = pos.X - 260
    end
    if shape == RoomShape.ROOMSHAPE_LBL or shape == RoomShape.ROOMSHAPE_LTL then
        pos.X = pos.X - 260
    end
    if centerOffset.Y > 140 then
        pos.Y = pos.Y - 140
    end
    if shape == RoomShape.ROOMSHAPE_LTR or shape == RoomShape.ROOMSHAPE_LTL then
        pos.Y = pos.Y - 140
    end
    return Isaac.WorldToRenderPosition(pos, false)
end

function Utils.getScreenBottomRight()
    return Utils.getScreenCenterPosition() * 2
end

local HudNumbers = Sprite() HudNumbers:Load("gfx/ui/hudNumbers.anm2", true)

function Utils.RenderNumber(n, Position, blackNil)
   n = n or 0
   if n == 0 and blackNil then 
      HudNumbers:SetFrame("Idle", 10)
      HudNumbers:RenderLayer(0,Position)
      HudNumbers:RenderLayer(0,Position+Vector(6,0))

   else
      HudNumbers:SetFrame("Idle", math.floor(n/10))
      HudNumbers:RenderLayer(0,Position)
      HudNumbers:SetFrame("Idle", n % 10)
      HudNumbers:RenderLayer(0,Position+Vector(6,0))
   end
end

function string:split(sep)
  local sep, fields = sep or ", ", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

return Utils
