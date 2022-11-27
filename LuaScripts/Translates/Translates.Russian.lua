--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


---@type TranslateItem[]
Translates.Russian = {
    -- Magnet
    ---@alias TranslateItem { Building :{ Type :ReferenceValue<string> }, Name :string, Description :string|nil, UpdateDescription :fun(value :TranslateItem)|nil }
    {
        Building = Buildings.MagnetCrude,
        Name = "Магнит",
        Description = "Притягивает %d/c объект(ов).\nОбласть притягивания %dx%d.\nПоддерживает область: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetGood, Name = "Хороший магнит",
        Description = "Притягивает %d/c объект(ов). Область притягивания %dx%d.\nПоддерживает область: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetSuper, Name = "Супер магнит",
        Description = "Притягивает %d/c объект(ов). Область притягивания %dx%d.\nПоддерживает область: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },

    -- Pump
    {
        Building = Buildings.PumpCrude,
        Name = "Помпа",
        Description = "Транспортирует объекты.",
    },
    {
        Building = Buildings.PumpGood,
        Name = "Хорошая Помпа",
        Description = "Транспортирует объекты.",
    },
    {
        Building = Buildings.PumpSuper,
        Name = "Супер Помпа",
        Description = "Транспортирует объекты.",
    },
    {
        Building = Buildings.PumpSuperLong,
        Name = "Супер Помпа - длинная",
        Description = "Транспортирует объекты.",
    },

    -- Overflow Pump
    {
        Building = Buildings.OverflowPumpCrude,
        Name = "Помпа Переполнения",
        Description = "Перекачивает объекты при переполнении источника.",
    },
    {
        Building = Buildings.OverflowPumpGood,
        Name = "Хорошая Помпа Переполнения",
        Description = "Перекачивает объекты при переполнении источника.",
    },
    {
        Building = Buildings.OverflowPumpSuper,
        Name = "Супер Помпа Переполнения",
        Description = "Перекачивает объекты при переполнении источника.",
    },

    -- Balancer
    {
        Building = Buildings.BalancerCrude,
        Name = "Помпа Баланса",
        Description = "Баланчсирует объекты по количеству.",
    },
    {
        Building = Buildings.BalancerGood,
        Name = "Хорошая Помпа Баланса",
        Description = "Баланчсирует объекты по количеству.",
    },
    {
        Building = Buildings.BalancerSuper,
        Name = "Супер Помпа Баланса",
        Description = "Баланчсирует объекты по количеству.",
    },
    {
        Building = Buildings.BalancerSuperLong,
        Name = "Супер Помпа Баланса - длинная",
        Description = "Баланчсирует объекты по количеству.",
    },

    -- Transmitter    
    {
        Building = Buildings.TransmitterCrude,
        Name = "Отправитель",
        Description = "Отправляет объекты на получатель.\nСкорость: %d объект(ов) в с.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterGood,
        Name = "Хороший Отправитель",
        Description = "Отправляет объекты на получатель.\nСкорость: %d объект(ов) в с.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterSuper,
        Name = "Супер Отправитель",
        Description = "Отправляет объекты на получатель.\nСкорость: %d объект(ов) в с.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Receiver
    {
        Building = Buildings.ReceiverCrude,
        Name = "Получатель",
        Description = "Получает объекты от отправителя.\nСкорость: %d объект(ов) в с.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverGood,
        Name = "Хороший Получатель",
        Description = "Получает объекты от отправителя.\nСкорость: %d объект(ов) в с.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverSuper,
        Name = "Супер Получатель",
        Description = "Получает объекты от отправителя.\nСкорость: %d объект(ов) в с.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Switch
    {
        Building = Buildings.SwitchSuper,
        Name = "Нажимная Панель",
        Description = "Отплючает логику объектов.\nИмена групп: \"[GroupName]\".",
    },

    -- Extractor
    {
        Building = Buildings.Extractor,
        Name = "Извлкеатель",
        Description = "Извлекает объект из хранилища.",
    },

    -- Inspector
    {
        Building = Buildings.Inspector,
        Name = "Инспектор",
        Description = "Проверяет объекты в области и отключает логику группе.\nИмена групп: \"[GroupName]\".",
    },
}