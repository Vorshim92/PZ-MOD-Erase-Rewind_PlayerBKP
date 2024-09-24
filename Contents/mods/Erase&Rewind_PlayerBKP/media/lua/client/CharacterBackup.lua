if not isClient() then return end
    if getActivatedMods():contains("Erase&Rewind_RPGbyVorshim") then
        local characterManagement = require('character/CharacterManagement')
        local activityCalendar = require('lib/ActivityCalendar')
        -- local modDataManager = require('lib/ModDataManager')
        local playerBkp = require('CharacterPlayer')
        IsNewGame = false
        

        local function onStartSaveBkp()
            local player = getPlayer()
            if player  then
                -- salvo il tempo attuale per il backup
                local time = activityCalendar.getStarTime()
                time = activityCalendar.fromSecondToDate(time)
                local temp = ModData.getOrCreate("Erase_Rewind")
                if not temp.isDeath then
                    temp.BKP_MOD_1 =  time
                    ModData.add("Erase_Rewind", temp)
                    characterManagement.writeBook(player, playerBkp.BKP_1, "BKP_1")
                    print("ErasePlayerBKP: BKP_1 scritto con successo. Orario: " .. time)
                elseif temp.isDeath then
                    print("ErasePlayerBKP: Giocatore in BKP_2")

                    temp.BKP_MOD_2 =  time
                    ModData.add("Erase_Rewind", temp)
                    characterManagement.writeBook(player, playerBkp.BKP_2, "BKP_2")
                    print("ErasePlayerBKP: BKP_2 scritto con successo. Orario: " .. time)
                end
            else
                print("ErasePlayerBKP: Impossibile creare il backup: giocatore non disponibile o non vivo.")
            end
        end

        local tickDelay = 200
        function CreateDelayBkp()
            if tickDelay == 0 then
            onStartSaveBkp()
            Events.OnTick.Remove(CreateDelayBkp)
            return
            end
            tickDelay = tickDelay - 1
        end

        local function onCreatedPlayerBkp(playerIndex, player)
            Events.OnTick.Add(CreateDelayBkp)
          end
          
        Events.OnCreatePlayer.Add(onCreatedPlayerBkp)
        Events.OnPlayerDeath.Add(function()
            if getPlayer():isDead() then
                local temp = ModData.getOrCreate("Erase_Rewind")
                    if temp.isDeath then
                        temp.isDeath = false
                        print("ErasePlayerBKP: Giocatore è morto, switch a BKP1")
                    else
                    temp.isDeath = true
                    print("ErasePlayerBKP: Giocatore è morto, switch a BKP2")
                    end
                ModData.add("Erase_Rewind", temp)
            end
        end)
        

    else
        print("ErasePlayerBKP: Mod Erase&Rewind_RPGbyVorshim non attiva. Nessuna azione verrà eseguita.")
    end
