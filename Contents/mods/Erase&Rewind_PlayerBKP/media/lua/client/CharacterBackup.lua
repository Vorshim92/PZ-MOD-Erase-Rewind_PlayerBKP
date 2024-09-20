if not isClient() then return end
    if getActivatedMods():contains("Erase&Rewind_RPGbyVorshim") then
        local characterManagement = require('character/CharacterManagement')
        local activityCalendar = require('lib/ActivityCalendar')
        local modDataManager = require('lib/ModDataManager')
        local playerBkp = require('CharacterPlayer')

        

        local function onStartSaveBkp(playerIndex, player)
            -- local player = getPlayer() -- do not use because events it self give us player
            if player  then
                -- salvo il tempo attuale per il backup
                local time = activityCalendar.getStarTime()
                time = activityCalendar.fromSecondToDate(time)

                local temp = modDataManager.read("Erase_Rewind")
                if not temp.isDeath then
                    print("ErasePlayerBKP: Giocatore in BKP_1")
                    -- if temp.BKP_MOD_1 then
                    --     temp.BKP_MOD_1 = nil
                    --     print("ErasePlayerBKP: BKP_1 pronto per la scrittura")
                    -- end

                    temp.BKP_MOD_1 =  time
                    modDataManager.save("Erase_Rewind", temp)
                    characterManagement.writeBook(player, playerBkp.BKP_1, "BKP_1")
                    print("ErasePlayerBKP: BKP_1 scritto con successo. Orario: " .. time)
                elseif temp.isDeath then
                    print("ErasePlayerBKP: Giocatore in BKP_2")
                    -- if temp.BKP_MOD_2 then
                    --     temp.BKP_MOD_2 = nil
                    --     print("ErasePlayerBKP: BKP_1 pronto per la scrittura")
                    -- end
                    temp.BKP_MOD_2 =  time
                    modDataManager.save("Erase_Rewind", temp)
                    characterManagement.writeBook(player, playerBkp.BKP_2, "BKP_1")
                    print("ErasePlayerBKP: BKP_2 scritto con successo. Orario: " .. time)
                end
            else
                print("ErasePlayerBKP: Impossibile creare il backup: giocatore non disponibile o non vivo.")
            end
        end

        Events.OnCreatePlayer.Add(onStartSaveBkp)
        Events.OnCharacterDeath.Add(function()
            local temp = modDataManager.read("Erase_Rewind")
                if temp.isDeath then
                    temp.isDeath = false
                else
                temp.isDeath = true
                end
                modDataManager.save("Erase_Rewind", temp)
            end)

    else
        print("ErasePlayerBKP: Mod Erase&Rewind_RPGbyVorshim non attiva. Nessuna azione verrà eseguita.")
    end
