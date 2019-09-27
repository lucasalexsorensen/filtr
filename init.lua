local _, core = ...

-- commands
core.commands = {
	['config'] = core.Config.Toggle,
	
	['help'] = function()
		print(' ')
		core:Print('List of slash commands:')
		core:Print('|cff00cc66/filtr config|r - shows config menu')
		core:Print('|cff00cc66/filtr help|r - shows help info')
		print(' ')
	end
}

local function HandleSlashCommands(str)	
	if (#str == 0) then	
		-- User just entered '/filtr' with no additional args.
		core.commands.help()
		return		
	end	
	
	local args = {}
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg)
		end
	end
	
	local path = core.commands -- required for updating found table.
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then -- if string length is greater than 0.
			arg = arg:lower()			
			if (path[arg]) then
				if (type(path[arg]) == 'function') then				
					-- all remaining args passed to our function!
					path[arg](select(id + 1, unpack(args))) 
					return					
				elseif (type(path[arg]) == 'table') then				
					path = path[arg] -- another sub-table found!
				end
			else
				q = select(1, unpack(args))
				core:CreateMainFrame(q)
				return
			end
		end
	end
end

function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor())
    local prefix = string.format('|cff%s%s|r', hex:upper(), 'Filtr:')	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(' ', prefix, ...))
end

function core:CreateMainFrame(q)
	self.Hooks:CreateFrame(q)
end

function core:ChatEvent(...)
	return self.Hooks:ChatEvent(select(1, ...))
end

function core:HandleEvents(event, ...)
	if event == 'ADDON_LOADED' then
		name = select(1, ...)
		if (name ~= 'Filtr') then return end
		return core:Init()
	elseif event == 'CHAT_MSG_CHANNEL' then
		return core:ChatEvent(select(1, ...))
	end
end

function core:Init()
	----------------------------------
	-- Register Slash Commands!
	----------------------------------
	SLASH_RELOADUI1 = '/rl' -- new slash command for reloading UI
	SlashCmdList.RELOADUI = ReloadUI

	SLASH_FRAMESTK1 = '/fs' -- new slash command for showing framestack tool
	SlashCmdList.FRAMESTK = function()
		LoadAddOn('Blizzard_DebugTools')
		FrameStackTooltip_Toggle()
	end

	SLASH_Filtr1 = '/filtr'
	SlashCmdList.Filtr = HandleSlashCommands
	
	core:Print('Welcome back', UnitName('player')..'!')
	core:CreateMainFrame('lfm')
end

local events = CreateFrame('Frame')
events:RegisterEvent('ADDON_LOADED')
events:RegisterEvent('CHAT_MSG_CHANNEL')
events:SetScript('OnEvent', core.HandleEvents)