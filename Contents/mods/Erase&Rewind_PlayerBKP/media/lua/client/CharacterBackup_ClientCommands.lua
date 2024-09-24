if not isClient() then return end
local Commands = {}

function Commands.setProgress(args)
	-- WIP
end

Events.OnServerCommand.Add(function(module, command, args)
	if not isClient() then return end
	if module == "Vorshim" and Commands[command] then
		args = args or {}
		Commands[command](args)
	end
end)