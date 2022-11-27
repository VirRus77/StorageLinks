--[[
Copyright (C) Sotin NU aka VirRus77
Author: Sotin NU aka VirRus77
--]]


Languages = {
    Russian = "Russian",
    English = "English",
    German = "German",
    French = "French",
    ChineseSimplified = "ChineseSimplified",
    JapaneseKana = "JapaneseKana",
    BrazilianPortugeuse = "BrazilianPortugeuse",
    Spanish = "Spanish",
    Polish = "Polish",
    Korean = "Korean",
    Turkish = "Turkish",
}

---@class Translates : table<string, TranslateItem[]>
Translates = {
    DefaultLanguage = Languages.English,
}

function Translates.SetNames()
    local language = ModText.GetLanguage();
    ---@type TranslateItem[]|nil
    local translate = Translates[language]  --[[@as TranslateItem[] | nil]]
    if (translate == nil) then
        translate = Translates[Translates.DefaultLanguage] --[[@as TranslateItem[] ]]
    end

    Translates.UpdateDescriptions(translate)
    Translates.SetNamesList(translate)
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