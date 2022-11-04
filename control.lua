local modGui = require("mod-gui")
local name = 'ViidisGameSpeedButton'
local speeds = {
    0.1, 0.25, 1, 2, 4, 60
}
local eps = 0.0001

local function updateButton()
    local caption
    if game.speed > 1 - eps or game.speed < eps then
        caption = "×" .. tostring(math.floor(game.speed * 100) / 100)
    else
        caption = "/" .. tostring(math.floor(100 / game.speed) / 100)
    end

    for _, player in pairs(game.players) do
        local flow = modGui.get_button_flow(player)
        if not flow[name] then
            flow.add {
                type = "button",
                name = name,
                caption = caption,
                tooltip = { "ViidisGameSpeedButton.tt" },
                style = modGui.button_style
            }
        else
            local btn = flow[name]
            btn.caption = caption
        end
    end
end

---@param event OnGuiClick
local function onGuiClick(event)
    if event.element.name == name then
        if event.button == defines.mouse_button_type.left then
            if game.speed < 1 - eps then
                game.speed = 1
            else
                for i = 1, #speeds, 1 do
                    if speeds[i] > game.speed + eps then
                        game.speed = speeds[i]
                        break
                    end
                end
            end
        elseif event.button == defines.mouse_button_type.right then
            if game.speed > 1 + eps then
                game.speed = 1
            else
                for i = #speeds, 1, -1 do
                    if speeds[i] < game.speed - eps then
                        game.speed = speeds[i]
                        break
                    end
                end
            end
        elseif event.button == defines.mouse_button_type.middle then
            game.speed = 1
        end
        updateButton()
    end
end

script.on_event(defines.events.on_gui_click, onGuiClick)

local function updateSpeeds()
    local newSpeeds = {}
    local sets = string.gmatch(settings.global["ViidisGameSpeedButton-factors"].value, '([0-9.]+)')
    if sets then
        for sp in sets do
            local num = tonumber(sp)
            if num then
                newSpeeds[#newSpeeds + 1] = num
            end
        end
        if #newSpeeds > 0 then
            speeds = newSpeeds
        end
    end
end

local function init()
    updateSpeeds()
    if game then
        updateButton()
    end
end

script.on_configuration_changed(updateSpeeds)
script.on_event(defines.events.on_runtime_mod_setting_changed, updateSpeeds)

script.on_init(init)
script.on_load(init)
script.on_configuration_changed(init)
