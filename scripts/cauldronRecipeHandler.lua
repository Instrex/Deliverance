local this = {}

-- Every recipe should have a value of array with first element as OutcomeType
-- Other elements vary by outcome types
-- In the comments it's written what your array MUST include
local OutcomeType = {
    Item        = 1,    -- { OutcomeType.Item, OutcomeIcon, COLLECTIBLE_TYPE }
    Pool        = 2,    -- { OutcomeType.Pool, OutcomeIcon, ITEM_POOL_TYPE }
    Function    = 3     -- { OutcomeType.Function, OutcomeIcon, FUNCTION }           
    -- !!!: Function must return either Item or Pool as defined previously, but not Function (or not cause infinite loop at least)
}

-- Outcome icons, which you can see when you add all four components --
local OutcomeIcon = {
    Unknown     = 9,
    Bomb        = 1,
    Book        = 2,
    Curse       = 3,
    Secret      = 4,
    Devil       = 5,
    Shop        = 6,
    Angel       = 7,
    DemonAngel  = 8
}

this.recipes = {
    [{ gunpowder = 1, rib = 1, blood = 1, feather = 1, paper = 1}] = { OutcomeType.Pool, OutcomeIcon.Unknown, ItemPoolType.POOL_BOSS },
    [{ rib = 2, blood = 2 }]          = { OutcomeType.Pool, OutcomeIcon.Devil, ItemPoolType.POOL_DEVIL },
    [{ paper = 2, gunpowder = 2 }]    = { OutcomeType.Pool, OutcomeIcon.Shop, ItemPoolType.POOL_SHOP },
    [{ feather = 2, blood = 2 }]      = { OutcomeType.Function, OutcomeIcon.DemonAngel,
        function() 
            return { OutcomeType.Pool, OutcomeIcon.DemonAngel, utils.choose(ItemPoolType.POOL_ANGEL, ItemPoolType.POOL_DEVIL) }
        end 
    },

    [{ gunpowder = 3 }]               = { OutcomeType.Pool, OutcomeIcon.Bomb, ItemPoolType.POOL_BOMB_BUM },
    [{ paper = 3 }]                   = { OutcomeType.Pool, OutcomeIcon.Book, ItemPoolType.POOL_LIBRARY },
    [{ blood = 3 }]                   = { OutcomeType.Pool, OutcomeIcon.Curse, ItemPoolType.POOL_CURSE },
    [{ rib = 3 }]                     = { OutcomeType.Pool, OutcomeIcon.Secret, ItemPoolType.POOL_SECRET  },
    [{ feather = 3 }]                 = { OutcomeType.Pool, OutcomeIcon.Angel, ItemPoolType.POOL_ANGEL }
}

-- Convert trinket IDs to brewable ingredients --
function this.evaluateIngredients(table)
    local ingredients = {}
    for name, id in pairs(CauldronMaterialID) do
        for i = 1, 4 do 
            if table[i] == id then 
                ingredients[name] = (ingredients[name] or 0) + 1
            end
        end
    end

    return ingredients
end

-- Try to find exact recipe that matches the ingredients, if it fails try to find the most similiar recipe using cosine similiarity --
function this.queryExactRecipe(table)
    local ingredients = this.evaluateIngredients(table)
    local similiarities = {}
    for recipe, outcome in pairs(this.recipes) do 
        
        if recipe.gunpowder == ingredients.gunpowder and 
        recipe.blood == ingredients.blood and 
        recipe.feather == ingredients.feather and
        recipe.rib == ingredients.rib and
        recipe.paper == ingredients.paper then 
            return outcome
        end

        similiarities[cosineSimiliarity(
            {recipe.gunpowder or 0, recipe.paper or 0, recipe.blood or 0, recipe.rib or 0, recipe.feather or 0},
            {ingredients.gunpowder or 0, ingredients.paper or 0, ingredients.blood or 0, ingredients.rib or 0, ingredients.feather or 0}
        )] = outcome
    end

    return this.queryInexactRecipe(similiarities)
end

function this.queryInexactRecipe(similiarities)
    local perfect = -1
    for factor, result in pairs(similiarities) do 
        if factor > perfect then 
            perfect = factor
        end
    end

    return similiarities[perfect]
end

function this.evaluateOutcome(outcome)
    if outcome[1] == OutcomeType.Item then
        return outcome[3]

    elseif outcome[1] == OutcomeType.Pool then
        return Game():GetItemPool():GetCollectible(outcome[3], true, Game():GetSeeds():GetPlayerInitSeed())

    elseif outcome[1] == OutcomeType.Function then
        return this.evaluateOutcome(outcome[3]())

    end
end

-- Cosine similiarity algorithm, used to determine similiarity between to arrays of same size --
function cosineSimiliarity(a, b)
    local length = #a
    if length ~= #b then
        error 'Arrays must be of the same length'
    end
    
    local sum = 0
    local sqSumA = 0
    local sqSumB = 0
    for i=1, length do 
        sum = sum + a[i] * b[i]
        
        sqSumA = sqSumA + a[i] * a[i]
        sqSumB = sqSumB + b[i] * b[i]
    end
    
    return sum / (math.sqrt(sqSumA) * math.sqrt(sqSumB))
end

return this