local addonName, addon = ...

addon.PricingService = {}
local PricingService = addon.PricingService

local function GetTSMItemString(itemID)
    if not itemID then return nil end
    return "i:" .. itemID
end

local function ToTSMString(link)
    if not link then return nil end
    if string.find(link, "^i:%d+") or string.find(link, "^p:%d+") then
        return link
    end
    local itemID = GetItemInfoInstant(link)
    if itemID then
        return "i:" .. itemID
    end
    return link 
end

function PricingService:GetPrice(itemID, itemLink)
    if not itemID and not itemLink then return 0 end
    
    local tsmString = GetTSMItemString(itemID)
    if not tsmString and itemLink then
         tsmString = ToTSMString(itemLink)
    end
    
    if _G.TSM_API then
        local function TrySource(source)
            local status1, isValid = pcall(_G.TSM_API.IsCustomPriceValid, source)
            if not status1 or not isValid then return nil end
            
            local status2, value = pcall(_G.TSM_API.GetCustomPriceValue, source, tsmString)
            if status2 and value then return value end
            return nil
        end

        local price = TrySource("dbminbuyout")
        if price then return price end

        price = TrySource("dbmarket")
        if price then return price end
        
        price = TrySource("dbhistorical")
        if price then return price end

         if itemLink and itemLink ~= tsmString then
             tsmString = itemLink 
             price = TrySource("dbminbuyout")
             if price then return price end
             price = TrySource("dbmarket")
             if price then return price end
         end
    end
    
    return 0
end

function PricingService:GetPigmentHerbCost(pigmentItemID)
    local Data = addon.Data
    local source = Data and Data:GetPigmentSource(pigmentItemID)
    
    if not source then return nil, nil end
    
    local bestCost = nil
    local bestHerbID = nil
    
    for _, src in ipairs(source) do
         local baseID = src.itemID
         local quantity = src.quantity
         local herbPrice = self:GetPrice(baseID)
         
         if herbPrice > 0 then
             local craftCost = herbPrice * quantity
             if not bestCost or craftCost < bestCost then
                 bestCost = craftCost
                 bestHerbID = baseID
             end
         end
    end
    
    return bestCost, bestHerbID
end

function PricingService:FormatMoney(copper)
    local goldIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
    local silverIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t"
    local copperIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t"
    
    if not copper then return "0" .. goldIcon end
    if type(copper) ~= "number" then return "0" .. goldIcon end
    if copper == 0 then return "0" .. goldIcon end
    
    local isNegative = copper < 0
    copper = math.abs(copper)
    
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop = copper % 100
    
    local parts = {}
    
    if gold > 0 then
        table.insert(parts, string.format("%d%s", gold, goldIcon))
        if silver > 0 then
            table.insert(parts, string.format("%d%s", silver, silverIcon))
        end
        if cop > 0 then
            table.insert(parts, string.format("%d%s", cop, copperIcon))
        end
    elseif silver > 0 then
        table.insert(parts, string.format("%d%s", silver, silverIcon))
        if cop > 0 then
            table.insert(parts, string.format("%d%s", cop, copperIcon))
        end
    else
        table.insert(parts, string.format("%d%s", cop, copperIcon))
    end
    
    local str = table.concat(parts, " ")
    
    if isNegative then
        return "-" .. str
    else
        return str
    end
end
