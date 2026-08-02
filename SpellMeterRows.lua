local _, namespace = ...

local Rows = {}

function Rows.apply(rows, combatSpells, maxAmount, api)
    for index, row in ipairs(rows) do
        local combatSpell = combatSpells[index]
        if combatSpell then
            local spellID = combatSpell.spellID
            row.icon:SetTexture(api.spell_texture(spellID))
            row.name:SetText(api.spell_name(spellID))
            row.value:SetText(combatSpell.amountPerSecond)
            row.bar:SetMinMaxValues(0, maxAmount)
            row.bar:SetValue(combatSpell.totalAmount)
            row:SetShown(true)
        else
            row:SetShown(false)
        end
    end
end

if type(namespace) == "table" then
    namespace.Rows = Rows
end

return Rows
