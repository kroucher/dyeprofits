local addonName, addon = ...

addon.UI = {}
local UI = addon.UI

local PricingService = addon.PricingService
local HotDye = addon.HotDye

UI.lastRecipeID = nil

function UI:CreateDetailsFrame(parent)
    local frame = CreateFrame("Frame", "DyeProfitsDetailsFrame", parent)
    frame:SetSize(185, 150)
    frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -30, 30)
    
    local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    text:SetJustifyH("RIGHT")
    text:SetText("Scanning...")
    
    self.detailsFrame = frame
    self.detailsText = text
    
    return frame
end

function UI:UpdateDetails(recipeInfo)
    if not self.detailsText then return end
    if not recipeInfo or not recipeInfo.recipeID then return end
    
    if self.lastRecipeID == recipeInfo.recipeID then
        return
    end
    self.lastRecipeID = recipeInfo.recipeID
    
    local status, err = pcall(function()
        local schematic = C_TradeSkillUI.GetRecipeSchematic(recipeInfo.recipeID, false)
        if not schematic then 
            self.detailsText:SetText("No schematic found")
            return 
        end

        local hasReagents = false
        local lines = {}
        
        local pigmentID = nil
        local pigmentQty = 0
        
        if schematic.reagentSlotSchematics then
            for _, reagentSlot in ipairs(schematic.reagentSlotSchematics) do
                if reagentSlot.reagents and reagentSlot.reagents[1] then
                     hasReagents = true
                     local reagent = reagentSlot.reagents[1]
                     pigmentID = reagent.itemID
                     pigmentQty = reagentSlot.quantityRequired
                end
            end
        end

        local resultValue = 0
        local dyeItemID = schematic.outputItemID
        if dyeItemID then
            local _, resultLink = GetItemInfo(dyeItemID)
            resultValue = PricingService:GetPrice(dyeItemID, resultLink)
        end
        
        local quantity = schematic.quantityMin or 1
        local totalValue = resultValue * quantity
        
        local isHot = HotDye:IsHotDye(dyeItemID)
        local hotIndicator = isHot and " |cFFFF6600[HOT]|r" or ""
        
        table.insert(lines, string.format("|cFFFFFFFFDye Value:|r %s%s", PricingService:FormatMoney(totalValue), hotIndicator))
        table.insert(lines, " ")

        if pigmentID and pigmentQty > 0 then
            local _, pigmentLink = GetItemInfo(pigmentID)
            pigmentLink = pigmentLink or ("Item " .. pigmentID)
            
            local pigmentPrice = PricingService:GetPrice(pigmentID, pigmentLink)
            local buyCost = pigmentPrice * pigmentQty
            local buyProfit = totalValue - buyCost
            
            local buyColor = (buyProfit >= 0) and "00FF00" or "FF0000"
            
            table.insert(lines, string.format("|cFFFFD700Strategy 1: Buy Pigment|r"))
            table.insert(lines, string.format("Cost: %s", PricingService:FormatMoney(buyCost)))
            table.insert(lines, string.format("Profit: |cFF%s%s|r", buyColor, PricingService:FormatMoney(buyProfit)))
            table.insert(lines, " ")

            local herbCost, herbID = PricingService:GetPigmentHerbCost(pigmentID)
            if herbCost then
                local totalHerbCost = herbCost * pigmentQty
                local herbProfit = totalValue - totalHerbCost
                
                local herbColor = (herbProfit >= 0) and "00FF00" or "FF0000"
                local _, herbLink = GetItemInfo(herbID)
                herbLink = herbLink or ("Item " .. herbID)
                
                table.insert(lines, string.format("|cFFFFD700Strategy 2: Mill Herbs|r"))
                table.insert(lines, string.format("Using: %s", herbLink))
                table.insert(lines, string.format("Cost: %s", PricingService:FormatMoney(totalHerbCost)))
                table.insert(lines, string.format("Profit: |cFF%s%s|r", herbColor, PricingService:FormatMoney(herbProfit)))
            else
                 table.insert(lines, string.format("|cFFFFD700Strategy 2: Mill Herbs|r"))
                 table.insert(lines, "No herb data found")
            end
        else
            table.insert(lines, "No pigment reagent found")
        end
        
        self.detailsText:SetText(table.concat(lines, "\n"))
    end)
    
    if not status then
        print("Dye Profits Error: " .. tostring(err))
        self.detailsText:SetText("Error calculating profits")
        self.detailsText:SetTextColor(1, 0, 0)
    end
end
