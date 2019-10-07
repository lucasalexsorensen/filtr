local _, core = ...
core.Hooks = {}

local Hooks = core.Hooks
local MainFrame

function Scroller_OnMouseWheel(self, delta)
    if (delta < 0) then
        self:PageDown()
    else
        self:PageUp()
    end
end

function Hooks:CreateFrame(q)
    MainFrame = CreateFrame('Frame', 'Filtr - MainFrame', UIParent, 'BasicFrameTemplateWithInset')
    MainFrame.q = q:lower()
    MainFrame.title = MainFrame:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	MainFrame.title:SetPoint('LEFT', MainFrame.TitleBg, 'LEFT', 5, -3)
	MainFrame.title:SetText('Filtr - "' .. q .. '"')
    MainFrame.width = 500
	MainFrame.height = 250
    MainFrame:SetFrameStrata('FULLSCREEN_DIALOG')
	MainFrame:SetSize(MainFrame.width, MainFrame.height)
	MainFrame:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
    MainFrame:SetBackdropColor(0, 0, 0, 1)
    MainFrame:EnableMouse(true)
    MainFrame:EnableMouseWheel(true)

	MainFrame:SetMovable(true)
	MainFrame:SetResizable(true)
	MainFrame:SetMinResize(100, 100)
	MainFrame:RegisterForDrag('LeftButton')
	MainFrame:SetScript('OnDragStart', MainFrame.StartMoving)
	MainFrame:SetScript('OnDragStop', MainFrame.StopMovingOrSizing)
	MainFrame:SetScript('OnLoad', function(self) print(self:GetName()) end)
	--tinsert(UISpecialFrames, historyFrame)

    local Scroller = CreateFrame('ScrollingMessageFrame', 'Filtr - Scroller', MainFrame)
    MainFrame.scroller = Scroller
    Scroller:SetPoint('CENTER', 5, -10)	
    Scroller:SetSize(MainFrame.width - 20, MainFrame.height - 40)
    Scroller:SetFontObject(GameFontNormal)
	Scroller:SetTextColor(1, 1, 1, 1)
    Scroller:SetJustifyH('LEFT')
	Scroller:SetHyperlinksEnabled(true)
	Scroller:SetFading(false)
    Scroller:SetMaxLines(300)
    Scroller:EnableMouse(true)
    Scroller:Clear()
	
    Scroller:SetScript('OnMouseWheel', Scroller_OnMouseWheel)

    return MainFrame
end

function Hooks:ChatEvent(...)
    local scroller = MainFrame.scroller

    local args = {...}
    local msg = args[1]
    local author = args[2]
    local lang = args[3]
    local channel = args[4]
    local target = args[5]
    local flags = args[6]
--    local zone = args[7]
    
    if string.find(msg:lower(), MainFrame.q) then
        scroller:AddMessage(author:gsub('-.*', '')..': '..msg)
        -- print('['..author..']:  '..msg)
    else
        -- print('blacklisted '..msg)
    end
end
