-- =========================
-- CREDITS
-- =========================
-- formulas: celeranis
-- code: eclypseHz

-- =========================
-- VARIABLES
-- =========================
local basePrice = 1 -- base fish value (found on the wiki)
local baseWeight = 1 -- base fish weight (found on the wiki)
local currentWeight = 1 -- current fish weight
local rarity = "Common" -- fish rarity
local mutation = "None" -- fish mutation (use none for non-mutated fish) 
-- ↓ true if active
local fishFood = {
  Guppies = false,
  FishChow = false,
  SplashSnacks = false
}
local duplicateCount = 0
local isShiny = false
local isSparkling = false

-- =========================
-- UNTOUCHABLE VARS
-- =========================
-- ↓ updated from version 1.54, w/o unob or limited mutations
local mutationsList = {
  normal = {
    ["Tryhard"] = 17,
    ["Darkness"] = 16.8,
    ["Mossy"] = 16.5,
    ["Mastered"] = 16,
    ["Glowy"] = 15,
    ["Umbra"] = 15,
    ["Evil"] = 15,
    ["Nocturnal"] = 14.2,
    ["Serene"] = 14,
    ["Diurnal"] = 13.5,
    ["Chaotic"] = 12,
    ["Glacial"] = 12,
    ["Oscar"] = 12,
    ["Puritas"] = 10.7,
    ["Atomic"] = 10,
    ["Snowy"] = 10,
    ["Blessed"] = 10,
    ["Infernal"] = 10,
    ["Tentacle Surge"] = 10,
    ["Breezed"] = 10,
    ["Flora"] = 10,
    ["Siren's Spite"] = 10,
    ["Luminescent"] = 9,
    ["Carrot"] = 8,
    ["Nuclear"] = 8,
    ["Rainbow Cluster"] = 8,
    ["Chilled"] = 8,
    ["Prismize"] = 8,
    ["Sanguine"] = 8,
    ["Toxic"] = 8,
    ["Sacratus"] = 7.7,
    ["Nova"] = 7.5,
    ["Shrouded"] = 7.5,
    ["Stardust"] = 7.5,
    ["Levitas"] = 7,
    ["Aurora"] = 6.5,
    ["Wrath"] = 6.5,
    ["Astral"] = 6,
    ["Gemstone"] = 6,
    ["Heavenly"] = 6,
    ["Crimson"] = 6,
    ["Lost"] = 5.5,
    ["Ashen Fortune"] = 5,
    ["Bloom"] = 5,
    ["Colossal Ink"] = 5,
    ["Cursed Touch"] = 5,
    ["Emberflame"] = 5,
    ["Fungal"] = 5,
    ["Galactic"] = 5,
    ["Lobster"] = 5,
    ["Nullified"] = 5,
    ["Subspace"] = 5,
    ["Quiet"] = 5,
    ["Mythical"] = 4.5,
    ["Seasonal (Spring)"] = 4.5,
    ["Anomalous"] = 4.44,
    ["Spirit"] = 4.2,
    ["Aureolin"] = 4,
    ["Greedy"] = 4,
    ["Revitalized"] = 4,
    ["Seasonal (Autumn)"] = 4,
    ["Sunken"] = 4,
    ["Abyssal"] = 3.5,
    ["Aurulent"] = 3.5,
    ["Electric Shock"] = 3.5,
    ["King's Blessing"] = 3.5,
    ["Vined"] = 3.5,
    ["Atlantean"] = 3,
    ["Aureate"] = 3,
    ["Blighted"] = 3,
    ["Brown Wood"] = 3,
    ["Celestial"] = 3,
    ["Cracked"] = 3,
    ["Crystalized"] = 3,
    ["Ember"] = 3,
    ["Green Leaf"] = 3,
    ["Mother Nature"] = 3,
    ["Aurelian"] = 2.5,
    ["Fossilized"] = 2.5,
    ["Lunar"] = 2.5,
    ["Scorched"] = 2.5,
    ["Seasonal (Winter)"] = 2.5,
    ["Solarblaze"] = 2.5,
    ["Sleet"] = 2.4,
    ["Moon-Kissed"] = 2.2,
    ["Aurous"] = 2,
    ["Midas"] = 2,
    ["Purified"] = 2,
    ["Glossy"] = 1.6,
    ["Silver"] = 1.6,
    ["Brother"] = 1.5,
    ["Mosaic"] = 1.5,
    ["Hexed"] = 1.5,
    ["Electric"] = 1.45,
    ["Darkened"] = 1.3,
    ["Frozen"] = 1.3,
    ["Negative"] = 1.3,
    ["Translucent"] = 1.3,
    ["Albino"] = 1.1,
    ["Studded"] = 1.1,
    ["Oak"] = 1.05,
    ["Cement"] = 1.03,
    ["Lightning"] = 1,
    ["Neon"] = 1,
    ["Seasonal (Summer)"] = 1,
    ["Upside-Down"] = 1,
    ["None"] = 1,
    ["Poisoned"] = 0.75,
    ["Amber"] = 0.5,
    ["Charred"] = 0.5,
    ["Dirty"] = 0.3,
    ["Exploded"] = 0.1
  },
  
  admin = {
    ["Spicy"] = 15,
    ["Mayhem"] = 15,
    ["Alien"] = 14,
    ["Fragmented"] = 14,
    ["Galaxy"] = 14,
    ["Radiant"] = 12,
    ["Spectral"] = 12,
    ["Chlorowoken"] = 12,
    ["Mango"] = 10,
    ["Lustrous"] = 10,
    ["Haunted"] = 8,
    ["Fortune"] = 8,
    ["Chilled"] = 8,
    ["Tormented"] = 6.66,
    ["Venomous"] = 6.5,
    ["Wisp"] = 5.5,
    ["Botanic"] = 2.5,
    ["Mace"] = 2,
    ["Golden"] = 2,
    ["Lightened"] = 1.01,
    ["Yellow"] = 1,
    ["Red"] = 1,
    ["Pink"] = 1,
    ["Green"] = 1,
    ["Blue"] = 1,
    ["Female"] = 1,
    ["Madness"] = 1,
    ["67"] = 0.67,
    ["Rooted"] = 0.66,
    ["Soulless"] = 0.66,
  }
}

local foodMultiTable = {
  Guppies = 1.05,
  FishChow = 1.15,
  SplashSnacks = 1.06
}

local fishFoodMultiplier = 1
for food, active in pairs(fishFood) do
  if active then
    fishFoodMultiplier = fishFoodMultiplier * foodMultiTable[food]
  end
end

local mutationMultiplier = mutationsList.normal[mutation] or mutationsList.admin[mutation]

-- =========================
-- FUNCTIONS
-- ========================= 
local function sanitize(n)
  return math.max(n or 0.1, 0.1)
end

basePrice = sanitize(basePrice)
baseWeight = sanitize(baseWeight)
currentWeight = sanitize(currentWeight)

local function formatNumber(n)
  local formatted = tostring(math.floor(n))
  formatted = formatted:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
  return formatted
end

local function ln(n)
  return math.log(n)
end

local function roundUp(n)
  return math.ceil(n)
end

local function weightMultiplierCalc(currentWeight, baseWeight)
  local weightRatio = currentWeight / baseWeight
  local weightMultiplier = math.max(weightRatio - ((weightRatio - 1) ^ (ln(2) / ln(2.1))), 1)
  return weightMultiplier
end

local function dampenedMutationMultiplierCalc(mutationMultiplier, isShiny, isSparkling)
  if not (isShiny or isSparkling) and mutationMultiplier > 1 then
    return mutationMultiplier - (0.1 * ((mutationMultiplier - 1) ^ (ln(20) / ln(9))))
  elseif mutationMultiplier > 1 then
    return mutationMultiplier
  else
    return 1
  end
end

local function specialMultiplierCalc(dampenedMultiplier, isShiny, isSparkling)
  local shinyMultiplier = isShiny and 1.5 or 1
  local sparklingMultiplier = isSparkling and 1.5 or 1
  return dampenedMultiplier * shinyMultiplier * sparklingMultiplier
end

local function combinedMultiplierCalc(specialMultiplier, isShiny, isSparkling, mutation)
  local attributes = 0
  if isShiny then attributes = attributes + 1 end
  if isSparkling then attributes = attributes + 1 end
  if mutation ~= "None" then attributes = attributes + 1 end

  if attributes >= 2 then
    return specialMultiplier - (0.2 * ((specialMultiplier - 1) ^ (ln(20) / ln(9))))
  else
    return specialMultiplier
  end
end

local function finalHourlyCalc(basePrice, duplicateCount, rarity, fishFoodMultiplier, currentWeight, baseWeight, isShiny, isSparkling, mutation)
  local weightMultiplier = weightMultiplierCalc(currentWeight, baseWeight)
  local dampenedMultiplier = dampenedMutationMultiplierCalc(mutationMultiplier, isShiny, isSparkling)
  local specialMultiplier = specialMultiplierCalc(dampenedMultiplier, isShiny, isSparkling)
  local combinedMultiplier = combinedMultiplierCalc(specialMultiplier, isShiny, isSparkling, mutation)

  local rarityPenalties = {
    Apex = 0.5,
    Extinct = 0.6,
    Secret = 0.65,
    Exotic = 0.75
  }
  local rarityPenalty = rarityPenalties[rarity] or 1

  local roundedBase = roundUp(weightMultiplier * basePrice)

  local finalHourly = (roundedBase * combinedMultiplier * (0.75 ^ duplicateCount) * rarityPenalty * fishFoodMultiplier) / 5
  return finalHourly
end

-- =========================
-- RESULT CALC
-- =========================
local result = finalHourlyCalc(
    basePrice,
    duplicateCount,
    rarity,
    fishFoodMultiplier,
    currentWeight,
    baseWeight,
    isShiny,
    isSparkling,
    mutation
)

print("C$ per hour: " .. formatNumber(result))
