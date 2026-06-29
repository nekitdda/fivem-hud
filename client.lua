-- Основной код HUD для FiveM
local HUD_Visible = true
local VoiceActive = false
local WaveAnimation = 0

-- Функция для рисования текста
local function DrawText(x, y, scale, text, r, g, b, a)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextCentre(true)
    EndTextCommandDisplayText(x / 1920, y / 1080)
end

-- Функция для рисования волн звука
local function DrawVoiceWaves(x, y, scale, r, g, b, a)
    if not VoiceActive then return end
    
    WaveAnimation = (WaveAnimation + 1) % 120
    local progress = WaveAnimation / 120
    local alpha = a * (1 - progress)
    
    -- Первая волна (самая яркая)
    DrawRect(x / 1920, y / 1080, 0.02 * scale, 0.015 * scale, r, g, b, alpha)
    
    -- Вторая волна (с задержкой)
    if WaveAnimation > 40 then
        local alpha2 = alpha * (1 - ((WaveAnimation - 40) / 80))
        DrawRect((x - 15) / 1920, y / 1080, 0.04 * scale, 0.015 * scale, r, g, b, alpha2 * 0.6)
    end
    
    -- Третья волна (с большей задержкой)
    if WaveAnimation > 80 then
        local alpha3 = alpha * (1 - ((WaveAnimation - 80) / 40))
        DrawRect((x + 15) / 1920, y / 1080, 0.06 * scale, 0.015 * scale, r, g, b, alpha3 * 0.3)
    end
end

-- Получить информацию о игроке
local function GetPlayerInfo()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Время в игре
    local hour = GetClockHours()
    local minute = GetClockMinutes()
    
    -- Зона
    local zone = Utils.GetZoneAtCoords(coords.x, coords.y)
    
    -- Направление
    local directionCode = Utils.GetDirectionFromHeading(heading)
    local directionRu = Config.Directions[directionCode]
    
    -- Температура
    local temp = Utils.GetTemperature()
    
    return {
        time = Utils.FormatTime(hour, minute),
        zone = zone,
        direction = directionRu,
        temperature = temp
    }
end

-- Основной цикл отрисовки HUD
Citizen.CreateThread(function()
    while true do
        Wait(Config.UpdateInterval)
        
        if HUD_Visible then
            local info = GetPlayerInfo()
            local cfg = Config.HUD
            
            -- Время (вверху по центру)
            DrawText(cfg.time.x, cfg.time.y, cfg.time.scale, info.time, 
                     cfg.time.color[1], cfg.time.color[2], cfg.time.color[3], cfg.time.color[4])
            
            -- PD статус (маленький текст вверху)
            DrawText(cfg.pd_status.x, cfg.pd_status.y, cfg.pd_status.scale, "● PD", 
                     cfg.pd_status.color[1], cfg.pd_status.color[2], cfg.pd_status.color[3], cfg.pd_status.color[4])
            
            -- Иконка звука (справа вверху)
            DrawText(cfg.sound_icon.x, cfg.sound_icon.y, cfg.sound_icon.scale, "🔊", 
                     cfg.sound_icon.color[1], cfg.sound_icon.color[2], cfg.sound_icon.color[3], cfg.sound_icon.color[4])
            
            -- Температура (справа вверху)
            DrawText(cfg.temperature.x, cfg.temperature.y, cfg.temperature.scale, 
                     string.format("%d°F", info.temperature), 
                     cfg.temperature.color[1], cfg.temperature.color[2], cfg.temperature.color[3], cfg.temperature.color[4])
            
            -- Компас направление (справа, под температурой)
            DrawText(cfg.compass.x, cfg.compass.y, cfg.compass.scale, info.direction, 
                     cfg.compass.color[1], cfg.compass.color[2], cfg.compass.color[3], cfg.compass.color[4])
            
            -- Информация об улице (нижний левый угол)
            DrawText(cfg.street_info.x, cfg.street_info.y, cfg.street_info.scale, info.zone, 
                     cfg.street_info.color[1], cfg.street_info.color[2], cfg.street_info.color[3], cfg.street_info.color[4])
            
            -- Волны голоса (когда игрок говорит)
            if VoiceActive then
                DrawVoiceWaves(cfg.voice_waves.x, cfg.voice_waves.y, cfg.voice_waves.scale,
                               cfg.voice_waves.color[1], cfg.voice_waves.color[2], cfg.voice_waves.color[3], cfg.voice_waves.color[4])
            end
        end
    end
end)

-- Команда для переключения видимости HUD
RegisterCommand('hudon', function()
    HUD_Visible = true
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"HUD", "включен"}
    })
end, false)

RegisterCommand('hudoff', function()
    HUD_Visible = false
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"HUD", "выключен"}
    })
end, false)

-- Команда для переключения голоса (волны)
RegisterCommand('voicetest', function()
    VoiceActive = not VoiceActive
    local status = VoiceActive and "активен" or "отключен"
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"Голос", "Волны: " .. status}
    })
end, false)

print("^2[HUD] Скрипт успешно загружен!^7")