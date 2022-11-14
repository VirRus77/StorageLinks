TilesMap = {
    -- (Почва)
    Soil = "Soil",
    -- (Почва (вспаханная))
    SoilTilled = "SoilTilled",
    -- (Яма)
    SoilHole = "SoilHole",
    -- (Почва)
    SoilUsed = "SoilUsed",
    -- (Почва (навоз))
    SoilDung = "SoilDung",
    -- (Пресная вода)
    WaterShallow = "WaterShallow",
    -- (Пресная вода (глубоко))
    WaterDeep = "WaterDeep",
    -- (Морская вода)
    SeaWaterShallow = "SeaWaterShallow",
    -- (Морская вода (глубоко))
    SeaWaterDeep = "SeaWaterDeep",
    -- (Песок)
    Sand = "Sand",
    -- (Вычерпанная земля)
    Dredged = "Dredged",
    -- (Болото)
    Swamp = "Swamp",
    -- (Месторождение металлической руды)
    IronHidden = "IronHidden",
    -- (Бедное месторождение металлической руды)
    IronSoil = "IronSoil",
    -- (Месторождение металлической руды)
    IronSoil2 = "IronSoil2",
    -- (Богатое месторождение металлической руды)
    Iron = "Iron",
    -- (Отработанное месторождение металлической руды)
    IronUsed = "IronUsed",
    -- (Месторождение глины)
    ClayHidden = "ClayHidden",
    -- (Месторождение глины)
    ClaySoil = "ClaySoil",
    -- (Богатое месторождение глины)
    Clay = "Clay",
    -- (Отработанное месторождение глины)
    ClayUsed = "ClayUsed",
    -- (Месторождение угля)
    CoalHidden = "CoalHidden",
    -- (Бедное месторождение угля)
    CoalSoil = "CoalSoil",
    -- (Месторождение угля)
    CoalSoil2 = "CoalSoil2",
    -- (Месторождение жирного угля)
    CoalSoil3 = "CoalSoil3",
    -- (Месторождение чистого угля)
    Coal = "Coal",
    -- (Отработанное месторождение угля)
    CoalUsed = "CoalUsed",
    -- (Месторождение камня)
    StoneHidden = "StoneHidden",
    -- (Месторождение камня)
    StoneSoil = "StoneSoil",
    -- (Богатое месторождение камня)
    Stone = "Stone",
    -- (Отработанное месторождение камня)
    StoneUsed = "StoneUsed",
    -- (Твердая рудная масса)
    Raised = "Raised",
    -- (Сооружение)
    Building = "Building",
    -- (Почва)
    Trees = "Trees",
    -- (Почва)
    CoconutTrees = "CoconutTrees",
    -- (Почва)
    CropWheat = "CropWheat",
    -- (Почва)
    CropCotton = "CropCotton",
    -- (Почва)
    Weeds = "Weeds",
    -- (Почва)
    Grass = "Grass",
    -- (Error: TileDecoration1)
    Decoration1 = "Decoration1",
    -- (Error: TileDecoration2)
    Decoration2 = "Decoration2",
    -- (Error: TileDecoration3)
    Decoration3 = "Decoration3",
    -- (Error: TileDecoration4)
    Decoration4 = "Decoration4",
    -- (Error: TileDecoration5)
    Decoration5 = "Decoration5",
    -- (Error: TileDecoration6)
    Decoration6 = "Decoration6",
    -- (Error: TileDecoration7)
    Decoration7 = "Decoration7",
    -- (Error: TileDecoration8)
    Decoration8 = "Decoration8",
    -- (Error: TileDecoration9)
    Decoration9 = "Decoration9",
    -- (Error: TileDecoration10)
    Decoration10 = "Decoration10",
    -- (Error: TileDecoration11)
    Decoration11 = "Decoration11",
    -- (Error: TileDecoration12)
    Decoration12 = "Decoration12",
    -- (Error: TileDecoration13)
    Decoration13 = "Decoration13",
    -- (Error: TileDecoration14)
    Decoration14 = "Decoration14",
    -- (Error: TileDecoration15)
    Decoration15 = "Decoration15",
    -- (Error: TileDecoration16)
    Decoration16 = "Decoration16",
    -- (Error: TileDecoration17)
    Decoration17 = "Decoration17",
    -- (Error: TileDecoration18)
    Decoration18 = "Decoration18",
    -- (Error: TileDecoration19)
    Decoration19 = "Decoration19",
    -- (Error: TileDecoration20)
    Decoration20 = "Decoration20",
    -- (Error: TileDecoration21)
    Decoration21 = "Decoration21",
    -- (Error: TileDecoration22)
    Decoration22 = "Decoration22",
    -- (Error: TileDecoration23)
    Decoration23 = "Decoration23",
    -- (Error: TileDecoration24)
    Decoration24 = "Decoration24",
    -- (Error: TileDecoration25)
    Decoration25 = "Decoration25",
    -- (Error: TileDecoration26)
    Decoration26 = "Decoration26",
    -- (Error: TileDecoration27)
    Decoration27 = "Decoration27",
    -- (Error: TileDecoration28)
    Decoration28 = "Decoration28",
    -- (Error: TileDecoration29)
    Decoration29 = "Decoration29",
    -- (Error: TileDecoration30)
    Decoration30 = "Decoration30",
    -- (Error: TileDecoration31)
    Decoration31 = "Decoration31",
    -- (Error: TileDecoration32)
    Decoration32 = "Decoration32",

}

MakeDevelopMap = {
    StartPoint = Point.new(227, 74),
    Width = 10
}

-- AfterLoad_CreatedWorld
function MakeDevelopMap:Make()
    local startPoint = self.StartPoint
    local currentPoint = Point.new(startPoint.X, startPoint.Y)
    local maxX = startPoint.X + self.Width
    local canDrop = {}
    for key, value in pairs(TilesMap) do
        if(type(value) ~= "function")then
            ModTiles.SetTile(currentPoint.X, currentPoint.Y, value)
            canDrop[value] = ModBase.SpawnItem("Rock", currentPoint.X, currentPoint.Y) ~= -1
            currentPoint.X = currentPoint.X + 1
            if (currentPoint.X >= maxX) then
                currentPoint.X = startPoint.X
                currentPoint.Y = currentPoint.Y + 1
            end
        end
    end

    Logging.LogDebug("CanDrop: %s", canDrop)
end

DiscoveredAllMap = {

}

function DiscoveredAllMap:Go()
    local location = Point.new(table.unpack(ModPlayer.GetLocation()))
    if(location.X == -1 or location.Y == -1) then
        Logging.LogDebug("DiscoveredAllMap player not found.") 
        return
    end
    local discoveredArea = Area.new(0, 0, 10, 12)
    local newLocation = Point.new(5, 6)
    local x = 0
    for x = 5, WORLD_LIMITS.Width, discoveredArea:Width() do
        for y = 6, WORLD_LIMITS.Height, discoveredArea:Height() do
            ModPlayer.SetStartLocation(x, y)
            local newLocation = Point.new(table.unpack(ModPlayer.GetLocation()))
            Logging.LogDebug("Teleprt %d:%d %s", x, y, newLocation)
            if(newLocation.X == x and newLocation.Y == y) then
                return
            end
        end
    end

    ModPlayer.SetStartLocation(location.X, location.Y)
end