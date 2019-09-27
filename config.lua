local _, core = ...
core.Config = {}

local Config = core.Config
local UIConfig

local defaults = {
	theme = {
		r = 0, 
		g = 0.8, -- 204/255
		b = 1,
		hex = "00ccff"
	}
}

function Config:Toggle()
	local menu = UIConfig or Config:CreateMenu()
	menu:SetShown(not menu:IsShown())
end

function Config:GetThemeColor()
	local c = defaults.theme
	return c.r, c.g, c.b, c.hex
end

function Config:CreateMenu()
	UIConfig = CreateFrame('Frame', 'Filtr - Config', UIParent, 'BasicFrameTemplateWithInset')
	UIConfig:SetSize(260, 360)
    UIConfig:SetPoint('CENTER') -- Doesn't need to be ('CENTER', UIParent, 'CENTER')

	UIConfig.title = UIConfig:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	UIConfig.title:SetPoint('LEFT', UIConfig.TitleBg, 'LEFT', 5, 0)
	UIConfig.title:SetText('Filtr Config')
	
	UIConfig:Hide()
	return UIConfig
end
