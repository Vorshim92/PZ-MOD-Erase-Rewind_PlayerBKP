if not isClient() then return end
    if getActivatedMods():contains("Erase&Rewind_RPGbyVorshimtest") then
        local characterManagement = require('character/CharacterManagement')


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
            -- local player = getPlayer()
            if player  then
                if not ModData.exists(DataMod.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore mai morto, sono in BKP_1")
                    if not ModData.exists(DataMod.Character.BKP_MOD_1) then
                        ModData.create(DataMod.Character.BKP_MOD_1)
                        print("ErasePlayerBKP: BKP_1 pronto per la scrittura")
                    end
                    characterManagement.writeBook(player, DataMod.Character.BKP_1)
                    print("ErasePlayerBKP: BKP_1 scritto con successo")
                elseif ModData.exists(DataMod.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore morto, sono in BKP_2")
                    if not ModData.exists(DataMod.Character.BKP_MOD_2) then
                        ModData.create(DataMod.Character.BKP_MOD_2)
                        print("ErasePlayerBKP: BKP_2 pronto per la scrittura")
                    end
                    characterManagement.writeBook(player, DataMod.Character.BKP_2)
                    print("ErasePlayerBKP: BKP_2 scritto con successo")
                end
            else
                print("ErasePlayerBKP: Impossibile creare il backup: giocatore non disponibile o non vivo.")
            end
        end

        Events.OnCreatePlayer.Add(onStartSaveBkp)
        Events.OnCharacterDeath.Add(function()
            if ModData.exists(DataMod.Character.isDeath) then
                ModData.remove(DataMod.Character.isDeath)
            else
            ModData.create(DataMod.Character.isDeath)
            end
            end)
    else
        print("ErasePlayerBKP: Mod Erase&Rewind_RPGbyVorshim non attiva. Nessuna azione verrà eseguita.")
    end
