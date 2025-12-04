local addonName, addon = ...

addon.HotDye = {}
local HotDye = addon.HotDye

HotDye.hottestByCategory = {}
HotDye.hasScanned = false
local DYES = {
    { id = 259115, category = "Blue" },    -- Alliance Blue Dye
    { id = 259131, category = "Purple" },  -- Arcwine Dye
    { id = 259078, category = "White" },   -- Basic Birch Dye
    { id = 259120, category = "White" },   -- Bone White Dye
    { id = 259107, category = "Yellow" },  -- Brass Dye
    { id = 259108, category = "Orange" },  -- Bronze Dye
    { id = 259105, category = "Orange" },  -- Copper Dye
    { id = 259112, category = "Brown" },   -- Dark Gold Dye
    { id = 259109, category = "Black" },   -- Dark Iron Dye
    { id = 259098, category = "Black" },   -- Darkwood Dye
    { id = 259151, category = "Red" },     -- Deep Mageroyal Red Dye
    { id = 259153, category = "Blue" },    -- Dusk Lily Grey Dye
    { id = 259133, category = "Green" },   -- Dustwallow Green Dye
    { id = 259122, category = "Brown" },   -- Earthen Brown Dye
    { id = 259150, category = "Green" },   -- Earthroot Dye
    { id = 259118, category = "Orange" },  -- Elwynn Pumpkin Dye
    { id = 259134, category = "Green" },   -- Emerald Dreaming Dye
    { id = 259127, category = "Red" },     -- Firebloom Red Dye
    { id = 259144, category = "Purple" },  -- Forsaken Plum Dye
    { id = 259139, category = "Red" },     -- Gilnean Rose Dye
    { id = 258838, category = "Yellow" },  -- Gold Dye
    { id = 259143, category = "Green" },   -- Gravemoss Green Dye
    { id = 259147, category = "Green" },   -- Grizzly Hills Green Dye
    { id = 259103, category = "Brown" },   -- Heartwood Dye
    { id = 259149, category = "White" },   -- Highborne Marble Dye
    { id = 259099, category = "White" },   -- Highland Birch Dye
    { id = 259152, category = "Red" },     -- Hinterlands Hickory Dye
    { id = 259100, category = "Yellow" },  -- Holy Oak Tan Dye
    { id = 259113, category = "Red" },     -- Horde Red Dye
    { id = 259111, category = "Black" },   -- Ironclaw Dye
    { id = 259128, category = "Brown" },   -- Kalimdor Sand Dye
    { id = 259116, category = "Purple" },  -- Kirin Tor Violet Dye
    { id = 259132, category = "Orange" },  -- Kodohide Brown Dye
    { id = 259110, category = "Teal" },    -- Kul Tiran Steel Dye
    { id = 259114, category = "Green" },   -- Lush Green Dye
    { id = 259102, category = "Red" },     -- Mahogany Dye
    { id = 259096, category = "Brown" },   -- Mesquite Brown Dye
    { id = 259135, category = "Blue" },    -- Midnight Blue Dye
    { id = 259140, category = "Purple" },  -- Moonberry Amethyst Dye
    { id = 259146, category = "Blue" },    -- Nazjatar Navy Dye
    { id = 259119, category = "Purple" },  -- Netherstorm Fuchsia Dye
    { id = 259130, category = "Purple" },  -- Nightsong Lilac Dye
    { id = 259121, category = "Black" },   -- Obsidium Black Dye
    { id = 259101, category = "Brown" },   -- Pale Umber Dye
    { id = 259097, category = "Yellow" },  -- Pinewood Dye
    { id = 259154, category = "Red" },     -- Rain Poppy Red Dye
    { id = 259142, category = "Red" },     -- Ratchet Rust Dye
    { id = 259117, category = "Yellow" },  -- Sandfury Yellow Dye
    { id = 259138, category = "Yellow" },  -- Savannah Gold Dye
    { id = 259124, category = "Green" },   -- Silversage Green Dye
    { id = 259123, category = "Black" },   -- Stormheim Grey Dye
    { id = 259104, category = "Black" },   -- Stormsteel Dye
    { id = 259137, category = "Yellow" },  -- Sungrass Yellow Dye
    { id = 259148, category = "Teal" },    -- Tidesage Teal Dye
    { id = 259145, category = "Brown" },   -- Timbermaw Brown Dye
    { id = 259125, category = "Teal" },    -- Un'Goro Green Dye
    { id = 259126, category = "Purple" },  -- Void Violet Dye
    { id = 259141, category = "Brown" },   -- Vol'dun Taupe Dye
    { id = 259136, category = "Teal" },    -- Vortex Teal Dye
    { id = 259053, category = "Brown" },   -- Warm Teak Dye
    { id = 259106, category = "Yellow" },  -- Zandalari Gold Dye
    { id = 259129, category = "Blue" },    -- Zephras Blue Dye
}

local function GetDailySold(itemID)
    if not _G.TSM_API or not itemID then return 0 end
    
    local tsmString = "i:" .. itemID
    
    local status1, isValid = pcall(_G.TSM_API.IsCustomPriceValid, "dbregionsoldperday")
    if not status1 or not isValid then return 0 end
    
    local status2, value = pcall(_G.TSM_API.GetCustomPriceValue, "dbregionsoldperday", tsmString)
    if status2 and value then return value end
    
    return 0
end

function HotDye:ScanHottestDyes()
    if self.hasScanned then 
        return 
    end
    
    local categoryBest = {}
    
    for _, dye in ipairs(DYES) do
        local volume = GetDailySold(dye.id)
        
        if not categoryBest[dye.category] or volume > categoryBest[dye.category].volume then
            categoryBest[dye.category] = {
                dyeID = dye.id,
                volume = volume
            }
        end
    end
    
    for category, data in pairs(categoryBest) do
        self.hottestByCategory[category] = data.dyeID
    end
    
    self.hasScanned = true
end

function HotDye:GetCategoryForDye(dyeItemID)
    for _, dye in ipairs(DYES) do
        if dye.id == dyeItemID then
            return dye.category
        end
    end
    return nil
end

function HotDye:IsHotDye(dyeItemID)
    local category = self:GetCategoryForDye(dyeItemID)
    if not category then return false end
    
    return self.hottestByCategory[category] == dyeItemID
end

function HotDye:HookRecipeList()
    if not ProfessionsFrame or not ProfessionsFrame.CraftingPage or not ProfessionsFrame.CraftingPage.RecipeList then
        return
    end
    
    local recipeList = ProfessionsFrame.CraftingPage.RecipeList
    
    if not recipeList.ScrollBox then
        return
    end
    
    local updateTimer = nil
    
    local function UpdateListIcons(scrollBox)
        if updateTimer then
            updateTimer:Cancel()
        end
        
        updateTimer = C_Timer.NewTimer(1.0, function()
            if scrollBox.ForEachFrame then
                scrollBox:ForEachFrame(function(frame, data)
                    local actualData = nil
                    if data then
                        if data.GetData then
                            actualData = data:GetData()
                        elseif data.data then
                            actualData = data.data
                        end
                    end
                    
                    local recipeID = nil
                    if actualData then
                        if actualData.recipeInfo and actualData.recipeInfo.recipeID then
                            recipeID = actualData.recipeInfo.recipeID
                        elseif actualData.recipeID then
                            recipeID = actualData.recipeID
                        end
                    end
                    
                    if recipeID then
                        local schematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, false)
                        
                        if schematic and schematic.outputItemID then
                            local isHot = HotDye:IsHotDye(schematic.outputItemID)
                            
                            if isHot then
                                local regions = { frame:GetRegions() }
                                for _, region in ipairs(regions) do
                                    if region:GetObjectType() == "FontString" then
                                        local text = region:GetText()
                                        local hotIcon = "|TInterface\\Icons\\Spell_Fire_SelfDestruct:0|t "
                                        if text and not string.find(text, "Spell_Fire_SelfDestruct") then
                                            region:SetText(hotIcon .. text)
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
    
    hooksecurefunc(recipeList.ScrollBox, "Update", function(self)
        UpdateListIcons(self)
    end)
    
    UpdateListIcons(recipeList.ScrollBox)
end
