if not isClient() then return end
    if getActivatedMods():contains("Erase&Rewind_RPGbyVorshimtest") then
        local characterManagement = require('character/CharacterManagement')
        local activityCalendar = require('lib/ActivityCalendar')
        local modDataManager = require('lib/ModDataManager')
        local DataMod = {}

        --- **ModData Character**
        DataMod.Character = {

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

        local function onStartSaveBkp(playerIndex, player)
            -- local player = getPlayer() -- do not use because events it self give us player
            if player  then
                local time = activityCalendar.getStarTime()
                time = activityCalendar.fromSecondToDate(time)
                local lines = {}
                table.insert(lines, time)
                if not modDataManager.isExists(DataMod.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore in BKP_1")
                    if modDataManager.isExists(DataMod.Character.BKP_MOD_1) then
                        modDataManager.remove(DataMod.Character.BKP_MOD_1)
                        print("ErasePlayerBKP: BKP_1 pronto per la scrittura")
                    end

                    characterManagement.writeBook(player, DataMod.Character.BKP_1)
                    modDataManager.save(DataMod.Character.BKP_MOD_1, lines)
                    print("ErasePlayerBKP: BKP_1 scritto con successo. Orario: " .. time)
                elseif modDataManager.isExists(DataMod.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore in BKP_2")
                    if modDataManager.isExists(DataMod.Character.BKP_MOD_2) then
                        modDataManager.remove(DataMod.Character.BKP_MOD_2)
                        print("ErasePlayerBKP: BKP_2 pronto per la scrittura")
                    end
                    characterManagement.writeBook(player, DataMod.Character.BKP_2)
                    modDataManager.save(DataMod.Character.BKP_MOD_2, lines)
                    print("ErasePlayerBKP: BKP_2 scritto con successo. Orario: " .. time)
                end
                
        
            else
                print("ErasePlayerBKP: Impossibile creare il backup: giocatore non disponibile o non vivo.")
            end
        end

        Events.OnCreatePlayer.Add(onStartSaveBkp)
        Events.OnCharacterDeath.Add(function()
            if modDataManager.isExists(DataMod.Character.isDeath) then
                modDataManager.remove(DataMod.Character.isDeath)
            else
            modDataManager.save(DataMod.Character.isDeath)
            end
            end)
    else
        print("ErasePlayerBKP: Mod Erase&Rewind_RPGbyVorshim non attiva. Nessuna azione verrà eseguita.")
    end
