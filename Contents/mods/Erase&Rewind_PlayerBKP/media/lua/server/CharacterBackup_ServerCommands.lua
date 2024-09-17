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
function Commands.saveCharacterBackup(player, characterData)
    if isClient() or not data then return end
    local id = player:getUsername()
    
    print("[Commands.saveData] Inizio del salvataggio dei dati per ID " .. id)
    -- Definisci il percorso del file
    local filepath = "/Backup/CharacterData_" .. id .. ".txt"
    print("[Commands.saveData] Percorso del file: " .. filepath)
    
    -- Controlla se il file esiste già
    local fileExists = false
    local filereader = getFileReader(filepath, false)
    if filereader then
        filereader:close()
        fileExists = true
    end
    
    

    -- Se il file esiste, eliminarlo o fare una copia temporanea
    if fileExists then
        -- Opzione 1: Eliminare il file esistente
        -- local success, err = os.remove(filepath)
        -- if success then
        --     print("[Commands.saveData] File di backup esistente eliminato: " .. filepath)
        -- else
        --     print("[Commands.saveData] Errore durante l'eliminazione del file " .. filepath .. ": " .. err)
        --     return
        -- end
        -- Se desideri fare una copia temporanea prima di eliminarlo, puoi implementare questa logica qui
        -- Fare una copia temporanea del file esistente
        local tempFilePath = filepath .. ".temp"
        local copySuccess, copyErr = os.rename(filepath, tempFilePath)
        if copySuccess then
            print("[Commands.saveData] Copia temporanea del file di backup esistente creata: " .. tempFilePath)
        else
            print("[Commands.saveData] Errore durante la creazione della copia temporanea: " .. copyErr)
        end
    else
        print("[Commands.saveData] Nessun file di backup esistente trovato per ID " .. id)
    end
    
    -- Serializza i dati e scrivili nel file
    local filewriter = getFileWriter(filepath, true, false)
    if filewriter then
        local serializedData = serializeData(data)
        filewriter:write(serializedData)
        filewriter:close()
        print("[Commands.saveData] Dati del personaggio salvati correttamente per ID: " .. id)
    else
        print("[Commands.saveData] Impossibile aprire il file per la scrittura.")
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

