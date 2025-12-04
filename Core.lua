local addonName, addon = ...

local UI = addon.UI
local HotDye = addon.HotDye

local function Init()
    print("|cFF00FF00Dye Profits|r: Loaded")

    if not ProfessionsFrame then
        print("|cFFFF0000Dye Profits|r: ProfessionsFrame not found!")
        return
    end

    UI:CreateDetailsFrame(ProfessionsFrame.CraftingPage)
    
    if ProfessionsFrame.CraftingPage.SchematicForm then
        hooksecurefunc(ProfessionsFrame.CraftingPage.SchematicForm, "Init", function(self, recipeInfo)
            local professionInfo = ProfessionsFrame:GetProfessionInfo()
            if professionInfo and professionInfo.professionName == "Dye Crafting" then
                UI:UpdateDetails(recipeInfo)
            else
                UI.detailsFrame:Hide()
            end
        end)
        
        ProfessionsFrame.CraftingPage:HookScript("OnShow", function()
            UI.detailsFrame:Hide()
            UI.lastRecipeID = nil
            
            local professionInfo = ProfessionsFrame:GetProfessionInfo()
            if not professionInfo or professionInfo.professionName ~= "Dye Crafting" then
                return
            end
            
            local form = ProfessionsFrame.CraftingPage.SchematicForm
            if form and form.recipeSchematic then
                if form.currentRecipeInfo then
                     UI:UpdateDetails(form.currentRecipeInfo)
                elseif form.recipeSchematic.recipeID then
                     UI:UpdateDetails({ recipeID = form.recipeSchematic.recipeID })
                end
            end
            
            HotDye:ScanHottestDyes()
            HotDye:HookRecipeList()
        end)
        
        ProfessionsFrame.CraftingPage:HookScript("OnHide", function()
            UI.detailsFrame:Hide()
            UI.lastRecipeID = nil
        end)
    else
        print("Dye Profits: SchematicForm not found")
    end
end

Init()
