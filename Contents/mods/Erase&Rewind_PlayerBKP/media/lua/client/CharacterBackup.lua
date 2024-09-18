if not isClient() then return end
    if getActivatedMods():contains("Erase&Rewind_RPGbyVorshim") then
        local characterManagement = require('character/CharacterManagement')
        local activityCalendar = require('lib/ActivityCalendar')
        local modDataManager = require('lib/ModDataManager')
        local dataMod = require('CharacterPlayer')

        

        local function onStartSaveBkp(playerIndex, player)
            -- local player = getPlayer() -- do not use because events it self give us player
            if player  then
                local time = activityCalendar.getStarTime()
                time = activityCalendar.fromSecondToDate(time)
                local lines = {}
                table.insert(lines, time)
                if not modDataManager.isExists(dataMod.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore in BKP_1")
                    if modDataManager.isExists(dataMod.Character.BKP_MOD_1) then
                        modDataManager.remove(dataMod.Character.BKP_MOD_1)
                        print("ErasePlayerBKP: BKP_1 pronto per la scrittura")
                    end

                    characterManagement.writeBook(player, dataMod.Character.BKP_1)
                    modDataManager.save(dataMod.Character.BKP_MOD_1, lines)
                    print("ErasePlayerBKP: BKP_1 scritto con successo. Orario: " .. time)
                elseif modDataManager.isExists(dataMod.Character.isDeath) then
                    print("ErasePlayerBKP: Giocatore in BKP_2")
                    if modDataManager.isExists(dataMod.Character.BKP_MOD_2) then
                        modDataManager.remove(dataMod.Character.BKP_MOD_2)
                        print("ErasePlayerBKP: BKP_2 pronto per la scrittura")
                    end
                    characterManagement.writeBook(player, dataMod.Character.BKP_2)
                    modDataManager.save(dataMod.Character.BKP_MOD_2, lines)
                    print("ErasePlayerBKP: BKP_2 scritto con successo. Orario: " .. time)
                end
            else
                print("ErasePlayerBKP: Impossibile creare il backup: giocatore non disponibile o non vivo.")
            end
        end

        Events.OnCreatePlayer.Add(onStartSaveBkp)
        Events.OnCharacterDeath.Add(function()
            if modDataManager.isExists(dataMod.Character.isDeath) then
                modDataManager.remove(dataMod.Character.isDeath)
            else
            modDataManager.save(dataMod.Character.isDeath)
            end
            end)

    else
        print("ErasePlayerBKP: Mod Erase&Rewind_RPGbyVorshim non attiva. Nessuna azione verrà eseguita.")
    end
