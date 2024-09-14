if isClient() then
    if getActivatedMods():contains("Erase&Rewind_RPGbyVorshimtest") then
        local characterManagement = require('character/CharacterManagement')
        local modDataManager = require('shared/lib/ModDataManager')
        ---@class ModData

        local ModData = {}

        --- **ModData Character**
        ---@return table string
        ModData.Character = {

            BKP_MOD_1 = "BKP_MOD_1",
            BKP_MOD_2 = "BKP_MOD_2",
            isDeath = "isDeath_Bkp",

            -- Chiavi specifiche per il backup periodico del player
            BKP_1 = {
                BOOST = "characterBoost_Bkp",
                CALORIES = "characterCalories_Bkp",
                LIFE_TIME = "characterLifeTime_Bkp",
                MULTIPLIER = "characterMultiplier_Bkp",
                PERK_DETAILS = "characterPerkDetails_Bkp",
                PROFESSION = "characterProfession_Bkp",
                RECIPES = "characterRecipes_Bkp",
                TRAITS = "characterTraits_Bkp",
                WEIGHT = "characterWeight_Bkp",
                KILLED_ZOMBIES = "characterKilledZombies_Bkp",
                SKILL_LIMITER = "characterSkillLimiter_Bkp"
            },
            BKP_2 = {
                BOOST = "characterBoost_Bkp2",
                CALORIES = "characterCalories_Bkp2",
                LIFE_TIME = "characterLifeTime_Bkp2",
                MULTIPLIER = "characterMultiplier_Bkp2",
                PERK_DETAILS = "characterPerkDetails_Bkp2",
                PROFESSION = "characterProfession_Bkp2",
                RECIPES = "characterRecipes_Bkp2",
                TRAITS = "characterTraits_Bkp2",
                WEIGHT = "characterWeight_Bkp2",
                KILLED_ZOMBIES = "characterKilledZombies_Bkp2",
                SKILL_LIMITER = "characterSkillLimiter_Bkp2"
            }
        }

        local player = getPlayer()
        local function onStartSaveBkp()
            if player and player:isAlive() then
                if not modDataManager.isExists(ModData.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore mai morto, sono in BKP_1")
                    if modDataManager.isExists(ModData.Character.BKP_MOD_1) then
                        characterManagement.removeAllModData(ModData.Character.BKP_1)
                        print("ErasePlayerBKP: BKP_1 già esistente, rimuovo Backup_1 prima di riscriverlo")
                    end
                        modDataManager.save(ModData.Character.BKP_MOD_1)
                        characterManagement.writeBook(player, ModData.Character.BKP_1)
                elseif modDataManager.isExists(ModData.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore morto, sono in BKP_2")
                    if modDataManager.isExists(ModData.Character.BKP_MOD_2) then
                        characterManagement.removeAllModData(ModData.Character.BKP_2)
                        print("ErasePlayerBKP: BKP_2 è esistente, rimuovo Backup_2 prima di riscriverlo")
                    end
                        modDataManager.save(ModData.Character.BKP_MOD_2)
                        characterManagement.writeBook(player, ModData.Character.BKP_2)
                end
                print("ErasePlayerBKP: Backup all'avvio creato per il giocatore: " )
            else
                print("ErasePlayerBKP: Impossibile creare il backup: giocatore non disponibile o non vivo.")
            end
        end

        Events.OnCreatePlayer.Add(onStartSaveBkp)
        Events.OnCharacterDeath.Add(function()
            if modDataManager.isExists(ModData.Character.isDeath) then
                modDataManager.remove(ModData.Character.isDeath)
            else
            modDataManager.save(ModData.Character.isDeath)
            end
            end)
    else
        print("ErasePlayerBKP: Mod Erase&Rewind_RPGbyVorshim non attiva. Nessuna azione verrà eseguita.")
    end
end
