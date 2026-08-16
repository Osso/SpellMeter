local _, namespace = ...

local Model = {}

local DEFAULTS = {
    mode = "damage",
    point = "CENTER",
    x = 0,
    y = 0,
}

function Model.next_mode(mode)
    if mode == "damage" then
        return "healing"
    end

    return "damage"
end

function Model.damage_meter_type(mode, damageMeterTypes)
    if mode == "healing" then
        return damageMeterTypes.Hps
    end

    return damageMeterTypes.Dps
end

function Model.normalize_settings(saved)
    saved = type(saved) == "table" and saved or {}

    return {
        mode = saved.mode == "healing" and "healing" or DEFAULTS.mode,
        point = type(saved.point) == "string" and saved.point or DEFAULTS.point,
        x = type(saved.x) == "number" and saved.x or DEFAULTS.x,
        y = type(saved.y) == "number" and saved.y or DEFAULTS.y,
    }
end

if type(namespace) == "table" then
    namespace.Model = Model
end

return Model
