--- **ModData Character**
local ModData = {}


    ModData.BKP_MOD_1 = "BKP_MOD_1"
    ModData.BKP_MOD_2 = "BKP_MOD_2"
    ModData.isDeath = "isDeath_Bkp"

    -- Chiavi specifiche per il backup periodico del player
    ModData.BKP_1 = {
        ["BOOST"] = {},
        ["CALORIES"] = {},
        ["LIFE_TIME"] = {},
        ["MULTIPLIER"] = {},
        ["PERK_DETAILS"] = {},
        ["PROFESSION"] = {},
        ["RECIPES"] = {},
        ["TRAITS"] = {},
        ["WEIGHT"] = {},
        ["KILLED_ZOMBIES"] = {}
    }
    ModData.BKP_2 = {
        ["BOOST"] = {},
        ["CALORIES"] = {},
        ["LIFE_TIME"] = {},
        ["MULTIPLIER"] = {},
        ["PERK_DETAILS"] = {},
        ["PROFESSION"] = {},
        ["RECIPES"] = {},
        ["TRAITS"] = {},
        ["WEIGHT"] = {},
        ["KILLED_ZOMBIES"] = {}
    }


if getActivatedMods():contains("SkillLimiter_fix") then
    ModData.BKP_1["SKILL_LIMITER"] = {}
    ModData.BKP_2["SKILL_LIMITER"] = {}
end
if getActivatedMods():contains("SurvivalRewards") then
    ModData.BKP_1["kilMilReached"] = {}
    ModData.BKP_2["kilMilReached"] = {}
    ModData.BKP_1["milReached"] = {}
    ModData.BKP_2["milReached"] = {}
end

return ModData