require "round/round"

local Name_AI_List = GameRules.Round.Npc_AI_Data.Name_AI_List

local particles = {
    "particles/treasure_courier_death.vpcf",
    "particles/leader/leader_overhead.vpcf",
    "particles/generic_gameplay/screen_damage_indicator.vpcf",
    "particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_debuff_ti7.vpcf",
    "particles/status_fx/status_effect_poison_viper.vpcf",
    "particles/generic_gameplay/screen_poison_indicator.vpcf",
    "particles/core/border.vpcf",
    "particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf",
    "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter_text_burst.vpcf",
    "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_counter_victories.vpcf",
    "particles/items2_fx/refresher_b.vpcf",
}

local sounds = {
    "soundevents/jugg.vsndevts",
    "soundevents/jugg_attack.vsndevts",
    "game_sounds_vo_juggernaut.vsndevts",
}

local function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            --print('PrecacheEverythingFromTable ',value)
            if string.find(value, "vpcf") then
                PrecacheResource( "particle", value, context)
            end
            if string.find(value, "vmdl") then
                PrecacheResource( "model", value, context)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile", value, context)
            end
        end
    end
end

function PrecacheEverythingFromKV( context )
    local kv_files = {
        "scripts/npc/npc_units_custom.txt",
        "scripts/npc/npc_abilities_custom.txt",
        "scripts/npc/npc_heroes_custom.txt",
        "scripts/npc/npc_abilities_override.txt",
        "scripts/npc/npc_items_custom.txt",
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            if "scripts/npc/npc_units_custom.txt" == kv then
                for name , _v in pairs(kvs) do
                    if Name_AI_List[name] then
                        PrecacheUnitByNameAsync(name,function () end)
                    end
                end
            elseif "scripts/npc/npc_heroes_custom.txt" == kv then
                for name , _v in pairs(Name_AI_List) do
                    print('precache ',name)
                    PrecacheUnitByNameAsync(name,function () end)
                end
                PrecacheUnitByNameAsync("npc_dota_hero_juggernaut",function () end)
            else
                PrecacheEverythingFromTable( context, kvs)
            end
        end
    end
end

return function(context)
    -- if true then
    --     return
    -- end

    --[[
        Precache things we know we'll use.  Possible file types include (but not limited to):
            PrecacheResource( "model", "*.vmdl", context )
            PrecacheResource( "soundfile", "*.vsndevts", context )
            PrecacheResource( "particle", "*.vpcf", context )
            PrecacheResource( "particle_folder", "particles/folder", context )
    ]]
    PrecacheEverythingFromKV(context)
    
    for _, p in pairs(particles) do
        PrecacheResource("particle", p, context)
    end
    for _, p in pairs(sounds) do
        PrecacheResource("soundfile", p, context)
    end

    for unit in pairs(LoadKeyValues("scripts/npc/npc_units_custom.txt")) do
        if Name_AI_List[unit] then
            PrecacheUnitByNameSync(unit,context,0)
        end
    end

end