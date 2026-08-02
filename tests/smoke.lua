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
    local spellRow
    for _, child in ipairs({ SpellMeterFrame:GetChildren() }) do
        if child.bar and child.name then
            spellRow = child
            break
        end
    end

    assertNotNil(spellRow)
    assertEquals(spellRow.bar, spellRow.name:GetParent())
end)
