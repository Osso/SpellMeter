package.path = "./?.lua;" .. package.path

local function assert_equal(actual, expected, message)
    if actual ~= expected then
        error((message or "values differ") .. ": expected " .. tostring(expected) .. ", got " .. tostring(actual), 2)
    end
end

local function test(name, callback)
    local ok, failure = pcall(callback)
    if not ok then
        io.stderr:write("FAIL " .. name .. "\n" .. failure .. "\n")
        os.exit(1)
    end
    print("PASS " .. name)
end

test("mode toggles between damage and healing", function()
    local Model = require("SpellMeterModel")
    assert_equal(Model.next_mode("damage"), "healing")
    assert_equal(Model.next_mode("healing"), "damage")
end)

test("mode maps to Blizzard per-second meter types", function()
    local Model = require("SpellMeterModel")
    local meter_types = { Dps = 41, Hps = 43 }
    assert_equal(Model.damage_meter_type("damage", meter_types), 41)
    assert_equal(Model.damage_meter_type("healing", meter_types), 43)
end)

test("settings retain valid values and replace invalid values", function()
    local Model = require("SpellMeterModel")
    local valid = Model.normalize_settings({ mode = "healing", point = "TOP", x = 12, y = -9, shown = false })
    assert_equal(valid.mode, "healing")
    assert_equal(valid.point, "TOP")
    assert_equal(valid.x, 12)
    assert_equal(valid.y, -9)
    assert_equal(valid.shown, false)

    local defaults = Model.normalize_settings({ mode = "invalid", x = "12", shown = "yes" })
    assert_equal(defaults.mode, "damage")
    assert_equal(defaults.point, "CENTER")
    assert_equal(defaults.x, 0)
    assert_equal(defaults.y, 0)
    assert_equal(defaults.shown, true)
end)

test("rows preserve Blizzard order and pass secret values directly to UI sinks", function()
    local Rows = require("SpellMeterRows")
    local amount_one = {}
    local amount_two = {}
    local maximum = {}
    local spells = {
        { spellID = 101, amountPerSecond = amount_one, totalAmount = {} },
        { spellID = 202, amountPerSecond = amount_two, totalAmount = {} },
    }

    local function make_row()
        local row = { shown = false }
        row.icon = { SetTexture = function(_, value) row.texture = value end }
        row.name = { SetText = function(_, value) row.label = value end }
        row.value = { SetText = function(_, value) row.display_value = value end }
        row.bar = {
            SetMinMaxValues = function(_, minimum, maximum_value)
                row.minimum = minimum
                row.maximum = maximum_value
            end,
            SetValue = function(_, value) row.bar_value = value end,
        }
        function row:SetShown(value) self.shown = value end
        return row
    end

    local rows = { make_row(), make_row(), make_row() }
    Rows.apply(rows, spells, maximum, {
        spell_name = function(id) return "Spell " .. id end,
        spell_texture = function(id) return id * 10 end,
    })

    assert_equal(rows[1].label, "Spell 101")
    assert_equal(rows[1].texture, 1010)
    assert_equal(rows[1].display_value, amount_one)
    assert_equal(rows[1].maximum, maximum)
    assert_equal(rows[1].bar_value, spells[1].totalAmount)
    assert_equal(rows[2].display_value, amount_two)
    assert_equal(rows[3].shown, false)
end)

print("All SpellMeter tests passed")
