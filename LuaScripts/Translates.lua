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

--- func desc
---@param value TranslateItem
function Translates.UpdateAccessPointsDescription(value)
    --Logging.LogDebug("UpdateMagnetDescription %s", value)
    ---@type TransmitterSettingsItem
    local settings = BuildingSettings.GetSettingsByReferenceType(value.Building) or error("Not found settings.", 666) or { }
    value.Description = string.format(
        value.Description,
        settings.MaxTransferOneTime
    )
end

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

Translates.German = {
    -- Magnet
    {
        Building = Buildings.MagnetCrude,
        Name = "Magnet",
        Description = "Zieht %d/s Objekt(e) an.\nZieht Bereich %dx%d an.\nEnthält Bereich: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetGood, Name = "Guter magnet",
        Description = "Zieht %d/s Objekt(e) an. Der Einzugsbereich %dx%d.\nEnthält den Einzugsbereich: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetSuper, Name = "Super magnet",
        Description = "Zieht %d/s Objekt(e) an. Der Einzugsbereich %dx%d.\nEnthält den Einzugsbereich: {L,T;R,B}",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },

    -- Pump
    {
        Building = Buildings.PumpCrude,
        Name = "Pumpe",
        Description = "Transportiert Objekte.",
    },
    {
        Building = Buildings.PumpGood,
        Name = "Gute Pumpe",
        Description = "Transportiert Objekte.",
    },
    {
        Building = Buildings.PumpSuper,
        Name = "Super Pumpe",
        Description = "Transportiert Objekte.",
    },
    {
        Building = Buildings.PumpSuperLong,
        Name = "Super Pumpe - lang",
        Description = "Transportiert Objekte.",
    },

    -- Overflow Pump
    {
        Building = Buildings.OverflowPumpCrude,
        Name = "Überlaufpumpe",
        Description = "Überlädt Objekte, wenn die Quelle überläuft.",
    },
    {
        Building = Buildings.OverflowPumpGood,
        Name = "Eine gute Überlaufpumpe",
        Description = "Überlädt Objekte, wenn die Quelle überläuft.",
    },
    {
        Building = Buildings.OverflowPumpSuper,
        Name = "Super Überlaufpumpe",
        Description = "Überlädt Objekte, wenn die Quelle überläuft.",
    },

    -- Balancer
    {
        Building = Buildings.BalancerCrude,
        Name = "Ausgleichspumpe",
        Description = "Balanciert Objekte nach Anzahl.",
    },
    {
        Building = Buildings.BalancerGood,
        Name = "Gute Ausgleichspumpe",
        Description = "Balanciert Objekte nach Anzahl.",
    },
    {
        Building = Buildings.BalancerSuper,
        Name = "Super Ausgleichspumpe",
        Description = "Balanciert Objekte nach Anzahl.",
    },
    {
        Building = Buildings.BalancerSuperLong,
        Name = "Super Ausgleichspumpe - Lang",
        Description = "Balanciert Objekte nach Anzahl.",
    },

    -- Transmitter    
    {
        Building = Buildings.TransmitterCrude,
        Name = "Sender",
        Description = "Sendet die Objekte an den Empfänger. Geschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterGood,
        Name = "Guter Sender",
        Description = "Sendet die Objekte an den Empfänger. Geschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterSuper,
        Name = "Super Sender",
        Description = "Sendet die Objekte an den Empfänger. Geschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Receiver
    {
        Building = Buildings.ReceiverCrude,
        Name = "Empfänger",
        Description = "Empfängt die Objekte vom Absender.\nGeschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverGood,
        Name = "Guter Empfänger",
        Description = "Empfängt die Objekte vom Absender.\nGeschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverSuper,
        Name = "Super Empfänger",
        Description = "Empfängt die Objekte vom Absender.\nGeschwindigkeit: %d Objekt(e) pro s.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Switch
    {
        Building = Buildings.SwitchSuper,
        Name = "Umschalttafel",
        Description = "Deaktiviert die Objektlogik.\nGruppennamen: \"[GroupName]\".",
    },

    -- Extractor
    {
        Building = Buildings.Extractor,
        Name = "Extraktor",
        Description = "Ruft ein Objekt aus dem Speicher ab.",
    },

    -- Inspector
    {
        Building = Buildings.Inspector,
        Name = "Inspektor",
        Description = "Prüft die Objekte im Bereich und deaktiviert die Gruppenlogik.\nGruppennamen: \"[GroupName]\".",
    },
}

Translates.English = {
    -- Magnet
    {
        Building = Buildings.MagnetCrude,
        Name = "Crude Magnet",
        Description = "Attracts %d/s object(s).\nArea of attraction is %dx%d.\nSupport are: \"{L,T;R,B}\"",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetGood,
        Name = "Good Magnet",
        Description = "Attracts %d/s object(s).\nArea of attraction is %dx%d.\nSupport are: \"{L,T;R,B}\"",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },
    {
        Building = Buildings.MagnetSuper,
        Name = "Super Magnet",
        Description = "Attracts %d/s object(s).\nArea of attraction is %dx%d.\nSupport are: \"{L,T;R,B}\"",
        UpdateDescription = Translates.UpdateMagnetDescription,
    },

    -- Pump
    {
        Building = Buildings.PumpCrude,
        Name = "Crude Pump",
        Description = nil,
    },
    {
        Building = Buildings.PumpGood,
        Name = "Good Pump",
        Description = nil,
    },
    {
        Building = Buildings.PumpSuper,
        Name = "Super Pump",
        Description = nil,
    },
    {
        Building = Buildings.PumpSuperLong,
        Name = "Super Pump Long",
        Description = nil,
    },

    -- Overflow Pump
    {
        Building = Buildings.OverflowPumpCrude,
        Name = "Crude Overflow Pump",
        Description = nil,
    },
    {
        Building = Buildings.OverflowPumpGood,
        Name = "Good Overflow Pump",
        Description = nil,
    },
    {
        Building = Buildings.OverflowPumpSuper,
        Name = "Super Overflow Pump",
        Description = nil,
    },

    -- Balancer
    {
        Building = Buildings.BalancerCrude,
        Name = "Crude Balancer",
        Description = nil,
    },
    {
        Building = Buildings.BalancerGood,
        Name = "Good Balancer",
        Description = nil,
    },
    {
        Building = Buildings.BalancerSuper,
        Name = "Super Balancer",
        Description = nil,
    },
    {
        Building = Buildings.BalancerSuperLong,
        Name = "Super Balancer Long",
        Description = nil,
    },

    -- Transmitter    
    {
        Building = Buildings.TransmitterCrude,
        Name = "Crude Transmitter",
        Description = "Speed: %d object in sec.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterGood,
        Name = "Good Transmitter",
        Description = "Speed: %d object in sec.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.TransmitterSuper,
        Name = "Super Transmitter",
        Description = "Speed: %d object in sec.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Receiver
    {
        Building = Buildings.ReceiverCrude,
        Name = "Crude Receiver",
        Description = "Speed: %d object in sec.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverGood,
        Name = "Good Receiver",
        Description = "Speed: %d object in sec.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },
    {
        Building = Buildings.ReceiverSuper,
        Name = "Super Receiver",
        Description = "Speed: %d object in sec.",
        UpdateDescription = Translates.UpdateAccessPointsDescription,
    },

    -- Switch
    {
        Building = Buildings.SwitchSuper,
        Name = "Super Switch",
        Description = nil,
    },

    -- Extractor
    {
        Building = Buildings.Extractor,
        Name = "Extract item",
        Description = "Retrieves an object from storage.",
    },

    -- Inspector
    {
        Building = Buildings.Inspector,
        Name = "Inspector",
        Description = "Checks the objects in the area and disables the logic for the group.\nGroup names: ex. \"[GroupName]\".",
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
---@param namesList { Building :{ Type :ReferenceValue<string> }, Name :string, Description :string|nil }[] #
function Translates.SetNamesList(namesList)
    for _, value in ipairs(namesList) do
        ModText.SetText(value.Building.Type.Value, value.Name)
        if (value.Description ~= nil) then
            ModText.SetDescription(value.Building.Type.Value, value.Description)
        end
    end
end