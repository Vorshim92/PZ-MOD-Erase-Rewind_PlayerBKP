--- **ModData Character**
local ModData = {}
ModData.Character = {

    BKP_MOD_1 = "BKP_MOD_1",
    BKP_MOD_2 = "BKP_MOD_2",
    isDeath = "isDeath_Bkp",

    -- Chiavi specifiche per il backup periodico del player
    BKP_1 = {
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
    },
    BKP_2 = {
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
}

if getActivatedMods():contains("SkillLimiter_fix") then
    ModData.Character.BKP_1["SKILL_LIMITER"] = {}
    ModData.Character.BKP_2["SKILL_LIMITER"] = {}
end
if getActivatedMods():contains("SurvivalRewards") then
    ModData.Character.BKP_1["kilMilReached"] = {}
    ModData.Character.BKP_2["kilMilReached"] = {}
    ModData.Character.BKP_1["milReached"] = {}
    ModData.Character.BKP_2["milReached"] = {}end

return ModData