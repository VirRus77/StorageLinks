--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


Languages = {
    English = "English",
    German = "German",
    French = "French",
    Russian = "Russian",
    ChineseSimplified = "ChineseSimplified",
    JapaneseKana = "JapaneseKana",
    BrazilianPortugeuse = "BrazilianPortugeuse",
    Spanish = "Spanish",
    Polish = "Polish",
    Korean = "Korean",
    Turkish = "Turkish",
}

Translates = {
    DefaultLanguage = Languages.English,
}

--- func desc
---@param value TranslateItem
function Translates.UpdateMagnetDescription(value)
    --Logging.LogDebug("UpdateMagnetDescription %s", value)
    ---@type MagnetSettingsItem2
    local settings = BuildingSettings.GetSettingsByReferenceType(value.Building) or error("Not found settings.", 666) or { }
    value.Description = string.format(
        value.Description,
        settings.CountOneTime,
        settings.Area:Width(),
        settings.Area:Height()
    )
end

---@type TranslateItem[]
Translates.Russian = {
    -- Magnet
    ---@alias TranslateItem { Building :{ Type :string }, Name :string, Description :string|nil, UpdateDescription :fun(value :{ Buiding :{ Type :string }, Description :string })|nil }
    {
        Building = Buildings.MagnetCrude, Name = "Магнит",
        Description = "Притягивает %d объект(ов). Область притягивания %dx%d.",
        UpdateDescription = Translates.UpdateMagnetDescription
    },
    {
        Building = Buildings.MagnetGood, Name = "Хороший магнит",
        Description = "Притягивает %d объект(ов). Область притягивания %dx%d.",
        UpdateDescription = Translates.UpdateMagnetDescription
    },
    {
        Building = Buildings.MagnetSuper, Name = "Супер магнит",
        Description = "Притягивает %d объект(ов). Область притягивания %dx%d.",
        UpdateDescription = Translates.UpdateMagnetDescription
    },

    -- Pump
    { Building = Buildings.PumpCrude, Name = "Помпа",
        Description = "Транспортирует объекты."
    },
    { Building = Buildings.PumpGood, Name = "Хорошая Помпа",
        Description = "Транспортирует объекты."
    },
    { Building = Buildings.PumpSuper, Name = "Супер Помпа",
        Description = "Транспортирует объекты."
    },
    { Building = Buildings.PumpSuperLong, Name = "Супер Помпа - длинная",
        Description = "Транспортирует объекты."
    },

    -- Overflow Pump
    { Building = Buildings.OverflowPumpCrude, Name = "Помпа Переполнения",
        Description = "Перекачивает объекты при переполнении источника."
    },
    { Building = Buildings.OverflowPumpGood, Name = "Хорошая Помпа Переполнения",
        Description = "Перекачивает объекты при переполнении источника."
    },
    { Building = Buildings.OverflowPumpSuper, Name = "Супер Помпа Переполнения",
        Description = "Перекачивает объекты при переполнении источника."
    },

    -- Balancer
    { Building = Buildings.BalancerCrude, Name = "Помпа Баланса",
        Description = "Баланчсирует объекты по количеству."
    },
    { Building = Buildings.BalancerGood, Name = "Хорошая Помпа Баланса",
        Description = "Баланчсирует объекты по количеству."
    },
    { Building = Buildings.BalancerSuper, Name = "Супер Помпа Баланса",
        Description = "Баланчсирует объекты по количеству."
    },
    { Building = Buildings.BalancerSuperLong, Name = "Супер Помпа Баланса - длинная",
        Description = "Баланчсирует объекты по количеству."
    },

    -- Transmitter    
    { Building = Buildings.TransmitterCrude, Name = "Отправитель",
        Description = "Отправляет объекты на получатель."
    },
    { Building = Buildings.TransmitterGood, Name = "Хороший Отправитель",
        Description = "Отправляет объекты на получатель."
    },
    { Building = Buildings.TransmitterSuper, Name = "Супер Отправитель",
        Description = "Отправляет объекты на получатель."
    },

    -- Receiver
    { Building = Buildings.ReceiverCrude, Name = "Получатель",
        Description = "Получает объекты от отправителя."
    },
    { Building = Buildings.ReceiverGood, Name = "Хороший Получатель",
        Description = "Получает объекты от отправителя."
    },
    { Building = Buildings.ReceiverSuper, Name = "Супер Получатель",
        Description = "Получает объекты от отправителя."
    },

    -- Switch
    { Building = Buildings.SwitchSuper, Name = "Нажимная Панель",
        Description = "Отплючает логику объектов. Имя панели должно быть вида: \">{GroupName}\". Имя объектов в группе: \"sw[{GroupName}]\""
    },

    -- Extractor
    { Building = Buildings.Extractor, Name = "Извлкеатель",
        Description = "Извлекает объект из хранилища."
    },

    -- Inspector
    { Building = Buildings.Inspector, Name = "Инспектор",
        Description = "Контролирует объекты в области."
    },
}

Translates.English = {
    -- Magnet
    { Building = Buildings.MagnetCrude, Name = "Crude Magnet" },
    { Building = Buildings.MagnetGood, Name = "Good Magnet" },
    { Building = Buildings.MagnetSuper, Name = "Super Magnet" },

    -- Pump
    { Building = Buildings.PumpCrude, Name = "Crude Pump" },
    { Building = Buildings.PumpGood, Name = "Good Pump" },
    { Building = Buildings.PumpSuper, Name = "Super Pump" },
    { Building = Buildings.PumpSuperLong, Name = "Super Pump Long" },

    -- Overflow Pump
    { Building = Buildings.OverflowPumpCrude, Name = "Crude Overflow Pump" },
    { Building = Buildings.OverflowPumpGood, Name = "Good Overflow Pump" },
    { Building = Buildings.OverflowPumpSuper, Name = "Super Overflow Pump" },

    -- Balancer
    { Building = Buildings.BalancerCrude, Name = "Crude Balancer" },
    { Building = Buildings.BalancerGood, Name = "Good Balancer" },
    { Building = Buildings.BalancerSuper, Name = "Super Balancer" },
    { Building = Buildings.BalancerSuperLong, Name = "Super Balancer Long" },

    -- Transmitter    
    { Building = Buildings.TransmitterCrude, Name = "Crude Transmitter" },
    { Building = Buildings.TransmitterGood, Name = "Good Transmitter" },
    { Building = Buildings.TransmitterSuper, Name = "Super Transmitter" },

    -- Receiver
    { Building = Buildings.ReceiverCrude, Name = "Crude Receiver" },
    { Building = Buildings.ReceiverGood, Name = "Good Receiver" },
    { Building = Buildings.ReceiverSuper, Name = "Super Receiver" },

    -- Switch
    { Building = Buildings.SwitchSuper, Name = "Super Switch" },

    -- Extractor
    { Building = Buildings.Extractor, Name = "Extract item" },

    -- Inspector
    { Building = Buildings.Inspector, Name = "Inspector",
        Description = "Controls the objects in the area."
    },
}

function Translates.SetNames()
    local languag = ModText.GetLanguage();
    local translateList = Translates.English
    if (languag == Languages.English) then
        translateList = Translates.English
    elseif (languag == Languages.Russian) then
        translateList = Translates.Russian
    end

    Translates.UpdateDescriptions(translateList)
    Translates.SetNamesList(translateList)
end

---@param namesList TranslateItem[] #
function Translates.UpdateDescriptions(namesList)
    Logging.LogInformation("Translates.UpdateDescriptions")
    for _, value in ipairs(namesList) do
        -- Logging.LogDebug("K:%s V:%s", _, value)
        if (value.UpdateDescription ~= nil) then
            value.UpdateDescription(value)
        end
    end
end

--- func desc
---@param namesList { Building :{ Type :string }, Name :string, Description :string|nil }[] #
function Translates.SetNamesList(namesList)
    for _, value in ipairs(namesList) do
        ModText.SetText(value.Building.Type, value.Name)
        if (value.Description ~= nil) then
            ModText.SetDescription(value.Building.Type, value.Description)
        end
    end
end