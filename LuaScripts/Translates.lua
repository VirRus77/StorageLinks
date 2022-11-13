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

Translates.Russian = {
    -- Magnet
    { Building = Buildings.MagnetCrude, Name = "Магнит",
        Description = "Притягивает объекты."
    },
    { Building = Buildings.MagnetGood, Name = "Хороший магнит",
        Description = "Притягивает объекты."
    },
    { Building = Buildings.MagnetSuper, Name = "Супер магнит",
        Description = "Притягивает объекты."
    },

    -- Pump
    { Building = Buildings.PumpCrude, Name = "Помпа",
        Description = "Перекачивает объекты."
    },
    { Building = Buildings.PumpGood, Name = "Хорошая Помпа",
        Description = "Перекачивает объекты."
    },
    { Building = Buildings.PumpSuper, Name = "Супер Помпа",
        Description = "Перекачивает объекты."
    },
    { Building = Buildings.PumpSuperLong, Name = "Супер Помпа - длинная",
        Description = "Перекачивает объекты."
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
    { Building = Converters.Extractor, Name = "Выбрасыватель",
        Description = "Выбрасывает объект из хранилища."
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
    { Building = Converters.Extractor, Name = "Extract item" },
}

function Translates.SetNames()
    local languag = ModText.GetLanguage();
    if (languag == Languages.English) then
        Translates.SetNamesList(Translates.English)
        return
    end

    if (languag == Languages.Russian) then
        Translates.SetNamesList(Translates.Russian)
        return
    end

    Translates.SetNamesList(Translates.English)
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