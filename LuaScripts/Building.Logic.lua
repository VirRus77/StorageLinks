---@type DependecyItem[] #
Buildings.Dependencies = {
    ---@type DependecyItem
    {
        Buildings = Buildings.GoodTypes,
        DependencyOn = {
            'MortarMixerCrude',
            'MortarMixerGood'
        }
    },
    ---@type DependecyItem
    {
        Buildings = Buildings.SuperTypes,
        DependencyOn = {
            'MetalWorkbench'
        }
    },
}

function Buildings.AddDependencies()
    for _, value in ipairs(Buildings.Dependencies) do
        BuildingsDependencyTree.AddDependency (value)
    end
end