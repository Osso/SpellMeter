local function spellRows()
    local rows = {}
    for _, child in ipairs({ SpellMeterFrame:GetChildren() }) do
        if child.bar and child.name then
            table.insert(rows, child)
        end
    end
    return rows
end

local function firstSpellRow()
    return spellRows()[1]
end

local function closeButton()
    for _, child in ipairs({ SpellMeterFrame:GetChildren() }) do
        if child:GetObjectType() == "Button" and child:GetWidth() == 24 and child:GetHeight() == 24 then
            return child
        end
    end
    return nil
end

test("persistent meter window loads visible with its saved mode", function()
    assertNotNil(SpellMeterFrame)
    assertTrue(SpellMeterFrame:IsShown())
    if SpellMeterDB.mode == "healing" then
        assertEquals("Spell HPS", SpellMeterFrame.title:GetText())
        assertEquals("DPS", SpellMeterFrame.modeButton:GetText())
    else
        assertEquals("Spell DPS", SpellMeterFrame.title:GetText())
        assertEquals("HPS", SpellMeterFrame.modeButton:GetText())
    end
end)

test("mode button switches the persistent window to the opposite mode", function()
    local wasHealing = SpellMeterDB.mode == "healing"
    SpellMeterFrame.modeButton:Click()
    if wasHealing then
        assertEquals("Spell DPS", SpellMeterFrame.title:GetText())
        assertEquals("HPS", SpellMeterFrame.modeButton:GetText())
    else
        assertEquals("Spell HPS", SpellMeterFrame.title:GetText())
        assertEquals("DPS", SpellMeterFrame.modeButton:GetText())
    end
end)

test("slash command hides and restores the persistent window without saving visibility", function()
    SlashCmdList.SPELLMETER()
    assertFalse(SpellMeterFrame:IsShown())
    assertNil(SpellMeterDB.shown)
    SlashCmdList.SPELLMETER()
    assertTrue(SpellMeterFrame:IsShown())
    assertNil(SpellMeterDB.shown)
end)

test("close button hides only in-session and slash command restores it", function()
    local button = closeButton()
    assertNotNil(button)
    assertTrue(SpellMeterFrame:IsShown())
    assertNil(SpellMeterDB.shown)

    button:Click()
    assertFalse(SpellMeterFrame:IsShown())
    assertNil(SpellMeterDB.shown)

    SlashCmdList.SPELLMETER()
    assertTrue(SpellMeterFrame:IsShown())
    assertNil(SpellMeterDB.shown)
end)

test("spell labels render above their status bars", function()
    local spellRow = firstSpellRow()
    assertNotNil(spellRow)
    assertEquals(spellRow.bar, spellRow.name:GetParent())
end)

test("spell icons render in front of their status bars", function()
    local spellRow = firstSpellRow()
    assertNotNil(spellRow)
    assertTrue(spellRow.icon:GetParent():GetFrameLevel() > spellRow.bar:GetFrameLevel())
    assertFalse(spellRow.icon:IsDesaturated())
end)

test("spell icon hover shows and hides its spell tooltip", function()
    local spellRow = firstSpellRow()
    assertNotNil(spellRow)
    spellRow.spellID = 116

    local onEnter = spellRow.iconFrame:GetScript("OnEnter")
    assertNotNil(onEnter)
    onEnter(spellRow.iconFrame)

    local tooltip = GetAppropriateTooltip()
    assertTrue(tooltip:IsShown())
    local _, tooltipSpellID = tooltip:GetSpell()
    assertEquals(116, tooltipSpellID)

    local onLeave = spellRow.iconFrame:GetScript("OnLeave")
    assertNotNil(onLeave)
    onLeave(spellRow.iconFrame)
    assertFalse(tooltip:IsShown())
end)

async_test("combat session updates refresh the visible spell rows", function(done)
    local rows = spellRows()
    assertEquals(10, #rows)
    assertTrue(SpellMeterFrame:IsShown())

    local initialShown = {}
    for index, row in ipairs(rows) do
        initialShown[index] = row:IsShown()
        row:SetShown(not initialShown[index])
    end

    A_Admin.FireEvent("DAMAGE_METER_COMBAT_SESSION_UPDATED", Enum.DamageMeterType.Hps, 1)
    C_Timer.After(0, function()
        done(function()
            for index, row in ipairs(rows) do
                assertEquals(initialShown[index], row:IsShown())
            end
        end)
    end)
end)
