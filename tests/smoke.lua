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

test("persistent meter window loads", function()
    assertNotNil(SpellMeterFrame)
    assertTrue(SpellMeterFrame:IsShown())
    assertEquals("Spell DPS", SpellMeterFrame.title:GetText())
end)

test("mode button switches the persistent window to HPS", function()
    SpellMeterFrame.modeButton:Click()
    assertEquals("Spell HPS", SpellMeterFrame.title:GetText())
    assertEquals("DPS", SpellMeterFrame.modeButton:GetText())
end)

test("slash command hides and restores the persistent window", function()
    SlashCmdList.SPELLMETER()
    assertFalse(SpellMeterFrame:IsShown())
    SlashCmdList.SPELLMETER()
    assertTrue(SpellMeterFrame:IsShown())
end)

test("spell labels render above their status bars", function()
    local spellRow = firstSpellRow()
    assertNotNil(spellRow)
    assertEquals(spellRow.bar, spellRow.name:GetParent())
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
