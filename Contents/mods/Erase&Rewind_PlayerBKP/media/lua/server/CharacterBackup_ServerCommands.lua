if not isServer() then return end

local Commands = {}

-- Funzione per serializzare una tabella in formato testo con indentazione
local function serializeData(data, indent)
    indent = indent or ""
    local serialized = ""
    if type(data) == "table" then
        serialized = serialized .. "{\n"
        for k, v in pairs(data) do
            local key = tostring(k)
            -- Aggiungi le virgolette se la chiave non è un identificatore valido
            if not key:match("^[_%a][_%w]*$") then
                key = string.format("[%q]", key)
            end
            serialized = serialized .. indent .. "  " .. key .. " = " .. serializeData(v, indent .. "  ") .. ",\n"
        end
        serialized = serialized .. indent .. "}"
    elseif type(data) == "string" then
        serialized = serialized .. string.format("%q", data)
    else
        serialized = serialized .. tostring(data)
    end
    return serialized
end

-- Funzione ricorsiva per contare gli elementi in una tabella
local function countDataSize(data)
    local size = 0
    if type(data) == "table" then
        for _, v in pairs(data) do
            size = size + countDataSize(v)
        end
    else
        size = size + 1
    end
    return size
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
function Commands.saveCharacterBackup(player, data)
    if isClient() or not data then return end
    local id = player:getUsername()
    
    print("[Commands.saveCharacterBackup] Inizio del salvataggio dei dati per ID " .. id)
    -- Definisci il percorso del file
    local filepath = "/Backup/PlayerBKP_" .. id .. ".txt"
    print("[Commands.saveCharacterBackup] Percorso del file: " .. filepath)
    
    -- Controlla se il file esiste già
    local fileExists = false
    local filereader = getFileReader(filepath, false)
    if filereader then
        filereader:close()
        fileExists = true
    end
    
    local tempFilePath = filepath .. ".temp"
    
    -- Se il file esiste, fare una copia temporanea rinominandolo
    if fileExists then
        local copySuccess, copyErr = os.rename(filepath, tempFilePath)
        if copySuccess then
            print("[Commands.saveCharacterBackup] Copia temporanea del file di backup esistente creata: " .. tempFilePath)
        else
            print("[Commands.saveCharacterBackup] Errore durante la creazione della copia temporanea: " .. copyErr)
            return
        end
    else
        print("[Commands.saveCharacterBackup] Nessun file di backup esistente trovato per ID " .. id)
    end
    
    -- Serializza i dati e scrivili nel file
    local filewriter = getFileWriter(filepath, true, false)
    if filewriter then
        local serializedData = serializeData(data)
        filewriter:write(serializedData)
        filewriter:close()
        print("[Commands.saveCharacterBackup] Dati del personaggio salvati correttamente per ID: " .. id)
        -- Dopo aver scritto il nuovo backup, eliminare la copia temporanea
        if fileExists then
            local success, err = os.remove(tempFilePath)
            if success then
                print("[Commands.saveCharacterBackup] Copia temporanea eliminata: " .. tempFilePath)
            else
                print("[Commands.saveCharacterBackup] Errore durante l'eliminazione della copia temporanea " .. tempFilePath .. ": " .. err)
            end
        end
    else
        print("[Commands.saveCharacterBackup] Impossibile aprire il file per la scrittura.")
        -- Ripristinare il file originale dalla copia temporanea
        if fileExists then
            local restoreSuccess, restoreErr = os.rename(tempFilePath, filepath)
            if restoreSuccess then
                print("[Commands.saveCharacterBackup] Ripristinato il file di backup originale da " .. tempFilePath)
            else
                print("[Commands.saveCharacterBackup] Errore durante il ripristino del file originale da " .. tempFilePath .. ": " .. restoreErr)
            end
        end
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

