if not isServer() then return end

local Commands = {}

-- Funzione per serializzare una tabella in formato testo con indentazione
local function serializeTable(tbl, indent)
    indent = indent or ""
    local lines = {}
    local nextIndent = indent .. "    "
    for key, value in pairs(tbl) do
        local formattedKey = tostring(key)
        if type(value) == "table" then
            table.insert(lines, string.format('%s%s = {', indent, formattedKey))
            table.insert(lines, serializeTable(value, nextIndent))
            table.insert(lines, string.format('%s},', indent))
        else
            local formattedValue
            if type(value) == "string" then
                formattedValue = string.format('"%s"', value)
            elseif type(value) == "number" or type(value) == "boolean" then
                formattedValue = tostring(value)
            else
                -- Gestione di tipi di dati non supportati
                formattedValue = '"UnsupportedType"'
            end
            table.insert(lines, string.format('%s%s = %s,', indent, formattedKey, formattedValue))
        end
    end
    return table.concat(lines, "\n")
end

-- Funzione ricorsiva per contare gli elementi in una tabella
local function countElements(tbl)
    local count = 0
    if type(tbl) ~= "table" then return count end
    for _, v in pairs(tbl) do
        count = count + 1
        if type(v) == "table" then
            count = count + countElements(v)
        end
    end
    return count
end







-- function Commands.saveCharacterData(player, args)
--     local id = player:getUsername();
--     print("[Commands.saveData] Parsing data table for ID " .. id);
--     local filepath = "/Backup/Erase&Rewind_BKP_" .. id .. ".txt";
--     print("[Commands.saveData] Vorshim Character Backup - filepath: " .. filepath);

-- 	local filewriter = getFileWriter(filepath, true, false);
-- 	SFQuest_Server.parseTable(args, filewriter, "temp");
-- 	print("[Commands.saveData] Vorshim Character Backup - Server saved data for ID: " .. id);
--     filereader:close();
-- end



-- Funzione per salvare una specifica sottotabella di DataMod.Character
function Commands.saveCharacterBackup(player, characterData)
    -- Uscita precoce se eseguito dal client o se characterData è nil

    if not characterData then
        print("[Commands.saveCharacterBackup] Funzione chiamata senza dati da salvare. Operazione annullata.")
        return
    end

    local id = player:getUsername()

    -- Identifica quale backup sta salvando basandosi su chiavi uniche
    local backupKey = nil

    -- Supponiamo che BKP_1 abbia 'characterBoost_Bkp' e BKP_2 abbia 'characterBoost_Bkp2'
    if characterData.BOOST == "characterBoost_Bkp" then
        backupKey = "BKP_1"
    elseif characterData.BOOST == "characterBoost_Bkp2" then
        backupKey = "BKP_2"
    else
        print("[Commands.saveCharacterBackup] Backup data non riconosciuto. Operazione annullata.")
        return
    end

    print(string.format("[Commands.saveCharacterBackup] Vorshim Character Backup - Preparazione del salvataggio della sottotabella '%s' per ID %s", backupKey, id))

    -- Costruisci il percorso del file includendo il backupKey per differenziare i file
    local filepath = "/Backup/Erase&Rewind_BKP_" .. backupKey .. "_" .. id .. ".txt"
    print("[Commands.saveCharacterBackup] Vorshim Character Backup - Percorso del file: " .. filepath)

    -- Verifica se il file esiste già e, in tal caso, cancellalo
    local filereader = getFileReader(filepath, false)
    if filereader then
        filereader:close()
        local success, err = os.remove(filepath)
        if success then
            print(string.format("[Commands.saveCharacterBackup] Vorshim Character Backup - File esistente cancellato: %s", filepath))
        else
            print(string.format("[Commands.saveCharacterBackup] Vorshim Character Backup - Errore durante la cancellazione del file %s: %s", filepath, err))
            return
        end
    else
        print(string.format("[Commands.saveCharacterBackup] Vorshim Character Backup - Nessun file di backup esistente trovato per ID %s nella sottotabella '%s'.", id, backupKey))
    end

    -- Serializza la sottotabella in testo
    local serializedData = serializeTable(characterData)

    -- Scrivi i dati nel file di backup
    local filewriter = getFileWriter(filepath, true, false)
    if filewriter then
        filewriter:write(serializedData)
        filewriter:close()
        print(string.format("[Commands.saveCharacterBackup] Vorshim Character Backup - Dati di '%s' salvati correttamente per ID: %s.", backupKey, id))
    else
        print(string.format("[Commands.saveCharacterBackup] Vorshim Character Backup - Impossibile aprire il file writer per ID: %s.", id))
    end
end






function Commands.sendData(player, args)
	local id = args.id;
	print("[Commands.sendData] Vorshim Character Backup - Server received a request for backup data. Player ID: " .. id);
	local filepath = "/Backup/Erase&Rewind_BKP_" .. id .. ".txt";
	local filereader = getFileReader(filepath, false);
	if filereader then
		print("[Commands.sendData] Vorshim Character Backup - Requested quest data for player " .. id);
		local temp = {};
		local line = filereader:readLine();
		while line ~= nil do
			table.insert(temp, line);
			line = filereader:readLine();
		end
		filereader:close();
		local newargs = { id = id , data = temp };
		print("[Commands.sendData] Vorshim Character Backup - Data for player " .. id .. " sent.");
		sendServerCommand('Vorshim', "setBackup", newargs);
	end;
end









Events.OnClientCommand.Add(function(module, command, player, args)
	if module == 'Vorshim' and Commands[command] then
		args = args or {}
		Commands[command](player, args)
	end
end)

