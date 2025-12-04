local addonName, addon = ...

addon.Data = {}
local Data = addon.Data

-- ============================================================================
-- HERB ITEM DATA
-- ============================================================================

-- Classic Herbs
local peacebloom = 2447
local silverleaf = 765
local earthroot = 2449
local mageroyal = 785
local briarthorn = 2450
local swiftthistle = 2452
local bruiseweed = 2453
local wild_steelbloom = 3355
local grave_moss = 3356
local kingsblood = 3357
local liferoot = 3358
local fadeleaf = 3818
local goldthorn = 3821
local khadgars_whisker = 3369
local wintersbite = 3819
local stranglekelp = 3820
local firebloom = 4625
local purple_lotus = 8831
local arthas_tears = 8836
local sungrass = 8838
local blindweed = 8839
local ghost_mushroom = 8845
local gromsblood = 8846
local golden_sansam = 13464
local dreamfoil = 13463
local mountain_silversage = 13465
local plaguebloom = 13466
local icecap = 13467

-- Outland
local felweed = 22785
local dreaming_glory = 22786
local ragveil = 22787
local terocone = 22789
local ancient_lichen = 22790
local netherbloom = 22791
local nightmare_vine = 22792
local mana_thistle = 22793

-- Northrend
local goldclover = 36901
local tiger_lily = 36904
local talandras_rose = 36907
local adders_tongue = 36903
local icethorn = 36906
local lichbloom = 36905

-- Cataclysm
local cinderbloom = 52983
local stormvine = 52984
local azsharas_veil = 52985
local heartblossom = 52986
local twilight_jasmine = 52987
local whiptail = 52988

-- Pandaria
local green_tea_leaf = 72234
local rain_poppy = 72237
local silkweed = 72238
local snow_lily = 72235
local fool_s_cap = 72236

-- Draenor
local fireweed_wod = 109125
local frostweed = 109124
local starflower = 109126
local gorgrond_flytrap = 109127
local nagrand_arrowbloom = 109128
local talador_orchid = 109129

-- Legion
local aethril = 124101
local dreamleaf = 124102
local foxflower = 124103
local fjarnskaggl = 124104
local starlight_rose = 124105
local astral_glory = 151565

-- BFA
local riverbud = 152505
local star_moss = 152506
local akundas_bite = 152507
local winters_kiss = 152508
local sirens_pollen = 152509
local sea_stalk = 152510
local anchor_weed = 152511
local zinanthid = 168487

-- Shadowlands
local marrowroot = 168589
local rising_glory = 168586
local widobloom = 168583
local vigil_s_torch = 170554
local death_blossom = 169701
local nightshade = 171315

-- Dragonflight (Bronze/Base Quality IDs)
local hochenblume_bronze = 191460
local hochenblume_silver = 191461
local hochenblume_gold = 191462
local saxifrage_bronze = 191464
local saxifrage_silver = 191465
local saxifrage_gold = 191466
local bubble_poppy_bronze = 191467
local bubble_poppy_silver = 191468
local bubble_poppy_gold = 191469
local writhebark_bronze = 191470
local writhebark_silver = 191471
local writhebark_gold = 191472

-- War Within (Mycobloom, etc)
local mycobloom_bronze = 210796
local mycobloom_silver = 210797
local mycobloom_gold = 210798
local luredrop_bronze = 210799
local luredrop_silver = 210800
local luredrop_gold = 210801
local orbinid_bronze = 210802
local orbinid_silver = 210803
local orbinid_gold = 210804
local blessing_blossom_bronze = 210805
local blessing_blossom_silver = 210806
local blessing_blossom_gold = 210807
local arathors_spear_bronze = 210808
local arathors_spear_silver = 210809
local arathors_spear_gold = 210810

-- Herb Colors Map
Data.HerbColors = {
    Red = {
        mageroyal, netherbloom, tiger_lily, cinderbloom, rain_poppy, fireweed_wod, astral_glory, star_moss, widobloom, saxifrage_bronze, saxifrage_silver, saxifrage_gold, mana_thistle, arathors_spear_bronze, arathors_spear_silver, arathors_spear_gold
    },
    Orange = {
        golden_sansam, nightmare_vine, goldclover, heartblossom, rain_poppy, fireweed_wod, foxflower, sirens_pollen, widobloom, writhebark_bronze, writhebark_silver, writhebark_gold, luredrop_bronze, luredrop_silver, luredrop_gold
    },
    Yellow = {
        sungrass, dreaming_glory, goldclover, whiptail, green_tea_leaf, gorgrond_flytrap, fjarnskaggl, sea_stalk, rising_glory, saxifrage_bronze, saxifrage_silver, saxifrage_gold, arathors_spear_bronze, arathors_spear_silver, arathors_spear_gold
    },
    Green = {
        swiftthistle, felweed, adders_tongue, azsharas_veil, green_tea_leaf, nagrand_arrowbloom, dreamleaf, riverbud, vigil_s_torch, bubble_poppy_bronze, bubble_poppy_silver, bubble_poppy_gold, blessing_blossom_bronze, blessing_blossom_silver, blessing_blossom_gold
    },
    Teal = {
        bruiseweed, terocone, lichbloom, stormvine, silkweed, starflower, dreamleaf, sirens_pollen, marrowroot, hochenblume_bronze, hochenblume_silver, hochenblume_gold, orbinid_bronze, orbinid_silver, orbinid_gold
    },
    Blue = {
        silverleaf, terocone, icethorn, stormvine, silkweed, frostweed, dreamleaf, akundas_bite, death_blossom, bubble_poppy_bronze, bubble_poppy_silver, bubble_poppy_gold, luredrop_bronze, luredrop_silver, luredrop_gold
    },
    Purple = {
        kingsblood, mana_thistle, talandras_rose, twilight_jasmine, fool_s_cap, talador_orchid, aethril, zinanthid, vigil_s_torch, hochenblume_bronze, hochenblume_silver, hochenblume_gold, orbinid_bronze, orbinid_silver, orbinid_gold
    },
    Brown = {
        briarthorn, dreaming_glory, adders_tongue, cinderbloom, gorgrond_flytrap, foxflower, sea_stalk, marrowroot, writhebark_bronze, writhebark_silver, writhebark_gold, mycobloom_bronze, mycobloom_silver, mycobloom_gold
    },
    Black = {
        fadeleaf, felweed, lichbloom, azsharas_veil, nagrand_arrowbloom, riverbud, death_blossom, writhebark_bronze, writhebark_silver, writhebark_gold, blessing_blossom_bronze, blessing_blossom_silver, blessing_blossom_gold
    },
    White = {
        peacebloom, ragveil, icethorn, whiptail, snow_lily, talador_orchid, fjarnskaggl, winters_kiss, rising_glory, saxifrage_bronze, saxifrage_silver, saxifrage_gold, mycobloom_bronze, mycobloom_silver, mycobloom_gold
    }
}

-- ============================================================================
-- PIGMENT ITEM IDS
-- ============================================================================

Data.PigmentIDToColor = {
    [262625] = "Purple",
    [262639] = "Black",
    [262642] = "Brown",
    [262643] = "Blue",
    [262655] = "Red",
    [260947] = "White",
    [262644] = "Yellow",
    [262647] = "Green",
    [262626] = "Teal",
    [262656] = "Orange",
}

function Data:GetPigmentSource(pigmentItemID)
    local color = self.PigmentIDToColor[pigmentItemID]
    
    if color and self.HerbColors[color] then
        local sources = {}
        for _, herbID in ipairs(self.HerbColors[color]) do
            -- Only add valid IDs (skip 0 placeholders)
            if herbID and herbID > 0 then
                table.insert(sources, { itemID = herbID, quantity = 10 }) 
            end
        end
        return sources
    end
    
    return nil
end
