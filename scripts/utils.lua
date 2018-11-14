Utils = {}

-- Usage
-- utils.chance(10) to roll a number from 0 to 10 and return true with 10% chance
-- utils.chance(10, "yes", "no") to roll a number and return "yes" or "no" based of result of roll
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
-- utils.switch(value, { "a" = function() print("smth") end, "b" = doSmth()}) to invoke "a" if value = "a", "b" if value = "b"
function Utils.switch(val, cases)
  if cases[val] ~= nil then
    cases[val]()
  end
end

return Utils
