local addonName, namespace = ...
local Model = namespace.Model
local Rows = namespace.Rows

local ROW_COUNT = 10
local ROW_HEIGHT = 22
local FRAME_WIDTH = 290
local FRAME_HEIGHT = 38 + (ROW_COUNT * ROW_HEIGHT)

local meterFrame
local settings
local rows = {}

local function spellName(spellID)
    return C_Spell.GetSpellName(spellID) or UNKNOWN
end

local function spellTexture(spellID)
    return C_Spell.GetSpellTexture(spellID)
end

local rowApi = {
    spell_name = spellName,
    spell_texture = spellTexture,
}

local function showSpellTooltip(row)
    if not row.spellID then
        return
    end

    local tooltip = GetAppropriateTooltip()
    GameTooltip_SetDefaultAnchor(tooltip, row.iconFrame)
    tooltip:SetSpellByID(row.spellID, false)
    tooltip:Show()
end

local function hideSpellTooltip()
    GetAppropriateTooltip():Hide()
end

local function createRow(parent, index)
    local row = CreateFrame("Frame", nil, parent)
    row:SetHeight(ROW_HEIGHT - 2)
    row:SetPoint("TOPLEFT", 8, -34 - ((index - 1) * ROW_HEIGHT))
    row:SetPoint("TOPRIGHT", -8, -34 - ((index - 1) * ROW_HEIGHT))

    row.bar = CreateFrame("StatusBar", nil, row)
    row.bar:SetAllPoints()
    row.bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    row.bar:SetStatusBarColor(0.82, 0.58, 0.18, 0.9)

    local background = row.bar:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(0.08, 0.08, 0.08, 0.88)

    row.iconFrame = CreateFrame("Frame", nil, row)
    row.iconFrame:SetSize(18, 18)
    row.iconFrame:SetPoint("LEFT", 1, 0)
    row.iconFrame:SetFrameLevel(row.bar:GetFrameLevel() + 1)
    row.iconFrame:EnableMouse(true)
    row.iconFrame:EnableMouseMotion(true)
    row.iconFrame:SetScript("OnEnter", function()
        showSpellTooltip(row)
    end)
    row.iconFrame:SetScript("OnLeave", hideSpellTooltip)

    row.icon = row.iconFrame:CreateTexture(nil, "ARTWORK")
    row.icon:SetAllPoints()
    row.icon:SetTexCoord(0.0625, 0.9, 0.0626, 0.9)
    row.icon:SetDesaturated(false)

    row.name = row.bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.name:SetPoint("LEFT", row.icon, "RIGHT", 5, 0)
    row.name:SetPoint("RIGHT", row, "RIGHT", -84, 0)
    row.name:SetJustifyH("LEFT")
    row.name:SetWordWrap(false)

    row.value = row.bar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.value:SetPoint("RIGHT", -6, 0)
    row.value:SetWidth(76)
    row.value:SetJustifyH("RIGHT")

    return row
end

local function savePosition(frame)
    local point, _, _, x, y = frame:GetPoint(1)
    settings.point = point
    settings.x = x
    settings.y = y
end

local function updateHeader()
    if settings.mode == "healing" then
        meterFrame.title:SetText("Spell HPS")
        meterFrame.modeButton:SetText("DPS")
    else
        meterFrame.title:SetText("Spell DPS")
        meterFrame.modeButton:SetText("HPS")
    end
end

local function clearRows(message)
    for index, row in ipairs(rows) do
        row.spellID = nil
        row.icon:SetTexture(nil)
        row:SetShown(index == 1)
    end
    rows[1].icon:SetTexture(nil)
    rows[1].name:SetText(message)
    rows[1].value:SetText("")
    rows[1].bar:SetMinMaxValues(0, 1)
    rows[1].bar:SetValue(0)
end

local function refresh()
    if not meterFrame or not meterFrame:IsShown() then
        return
    end

    local available = C_DamageMeter.IsDamageMeterAvailable()
    if not available then
        clearRows("Blizzard Damage Meter unavailable")
        return
    end

    local sourceGUID = UnitGUID("player")
    if not sourceGUID then
        clearRows("Waiting for player data")
        return
    end

    local meterType = Model.damage_meter_type(settings.mode, Enum.DamageMeterType)
    local source = C_DamageMeter.GetCombatSessionSourceFromType(
        Enum.DamageMeterSessionType.Current,
        meterType,
        sourceGUID
    )

    if not source then
        clearRows("No current combat data")
        return
    end

    Rows.apply(rows, source.combatSpells or {}, source.maxAmount, rowApi)
end

local function toggleMode()
    settings.mode = Model.next_mode(settings.mode)
    updateHeader()
    refresh()
end

local function setShown(shown)
    settings.shown = shown
    meterFrame:SetShown(shown)
    if shown then
        refresh()
    end
end

local function createWindow()
    local frame = CreateFrame("Frame", "SpellMeterFrame", UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint(settings.point, UIParent, settings.point, settings.x, settings.y)
    frame:SetFrameStrata("MEDIUM")
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        savePosition(self)
    end)
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
    })
    frame:SetBackdropColor(0.025, 0.025, 0.025, 0.94)
    frame:SetBackdropBorderColor(0.32, 0.32, 0.32, 1)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOPLEFT", 9, -10)

    frame.modeButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    frame.modeButton:SetSize(48, 22)
    frame.modeButton:SetPoint("TOPRIGHT", -31, -6)
    frame.modeButton:SetScript("OnClick", toggleMode)

    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", 2, 2)
    closeButton:SetScript("OnClick", function()
        setShown(false)
    end)

    for index = 1, ROW_COUNT do
        rows[index] = createRow(frame, index)
    end

    meterFrame = frame
    updateHeader()
    frame:SetShown(settings.shown)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("DAMAGE_METER_CURRENT_SESSION_UPDATED")
eventFrame:RegisterEvent("DAMAGE_METER_COMBAT_SESSION_UPDATED")
eventFrame:RegisterEvent("DAMAGE_METER_RESET")
eventFrame:SetScript("OnEvent", function(_, event, argument)
    if event == "ADDON_LOADED" then
        if argument ~= addonName then
            return
        end

        SpellMeterDB = Model.normalize_settings(SpellMeterDB)
        settings = SpellMeterDB
        createWindow()
        return
    end

    refresh()
end)

SLASH_SPELLMETER1 = "/spellmeter"
SlashCmdList.SPELLMETER = function()
    setShown(not meterFrame:IsShown())
end
