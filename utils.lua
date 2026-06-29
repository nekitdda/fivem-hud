-- Утилиты для работы с зонами и координатами
Utils = {}

-- Таблица зон GTA V
local Zones = {
    -- Основные районы Los Santos
    {name = 'Челси', coords = {x = 141.0, y = -925.0}},
    {name = 'Чайнатаун', coords = {x = 350.0, y = -900.0}},
    {name = 'Порт Мэрии', coords = {x = 350.0, y = -1400.0}},
    {name = 'Портман', coords = {x = 600.0, y = -200.0}},
    {name = 'Батл-Бей', coords = {x = 400.0, y = -1000.0}},
    {name = 'Иствуд', coords = {x = 1200.0, y = -1300.0}},
    {name = 'Дельперро', coords = {x = -450.0, y = -350.0}},
    {name = 'Голдкост', coords = {x = -400.0, y = -900.0}},
    {name = 'Лос-Сантос-Интернешнл', coords = {x = 200.0, y = -2300.0}},
    {name = 'Бель-Айр', coords = {x = -500.0, y = 50.0}},
    {name = 'Ричмонд', coords = {x = -600.0, y = 200.0}},
    {name = 'Мортон-Высоты', coords = {x = -300.0, y = -700.0}},
    {name = 'Винвуд', coords = {x = -700.0, y = -500.0}},
    {name = 'Вест Лос-Сантос', coords = {x = -800.0, y = -200.0}},
    {name = 'Рокфорд-Хиллз', coords = {x = -100.0, y = 200.0}},
    {name = 'Палето-Бэй', coords = {x = -300.0, y = 6000.0}},
    {name = 'Чумаш', coords = {x = -3600.0, y = 5000.0}},
    {name = 'Велиция', coords = {x = -2200.0, y = 4000.0}},
    {name = 'Громас-Гров', coords = {x = 1200.0, y = -1500.0}},
    {name = 'Алтос-Дос', coords = {x = 500.0, y = -500.0}},
}

-- Получить текущую зону по координатам
function Utils.GetZoneAtCoords(x, y)
    local closest_zone = Zones[1]
    local closest_dist = math.huge
    
    for _, zone in ipairs(Zones) do
        local dist = math.sqrt((x - zone.coords.x)^2 + (y - zone.coords.y)^2)
        if dist < closest_dist then
            closest_dist = dist
            closest_zone = zone
        end
    end
    
    return closest_zone.name
end

-- Получить направление по углу (в градусах)
function Utils.GetDirectionFromHeading(heading)
    if heading >= 337.5 or heading < 22.5 then
        return 'N'  -- Север
    elseif heading >= 22.5 and heading < 67.5 then
        return 'NE' -- Северо-восток
    elseif heading >= 67.5 and heading < 112.5 then
        return 'E'  -- Восток
    elseif heading >= 112.5 and heading < 157.5 then
        return 'SE' -- Юго-восток
    elseif heading >= 157.5 and heading < 202.5 then
        return 'S'  -- Юг
    elseif heading >= 202.5 and heading < 247.5 then
        return 'SW' -- Юго-запад
    elseif heading >= 247.5 and heading < 292.5 then
        return 'W'  -- Запад
    elseif heading >= 292.5 and heading < 337.5 then
        return 'NW' -- Северо-запад
    end
end

-- Форматирование времени
function Utils.FormatTime(hour, minute)
    local ampm = 'AM'
    if hour >= 12 then
        ampm = 'PM'
        if hour > 12 then
            hour = hour - 12
        end
    end
    if hour == 0 then
        hour = 12
    end
    return string.format('%d:%02d %s', hour, minute, ampm)
end

-- Получить температуру (статичная)
function Utils.GetTemperature()
    return 67 -- °F
end

return Utils