--[[
		GamepadPlus
		Gamepad UI enhancement for display of market data
		License: (To Be Determined)
		Based on RockingDice's GamePadBuddy
		https://www.esoui.com/downloads/info1773-GamePadBuddy.html
		https://github.com/rockingdice/GamePadBuddy
]]

-- Arkadius' Trade Tools
if GPP.settings.att and ArkadiusTradeTools then
    local avgPrice = ArkadiusTradeTools.Modules.Sales:GetAveragePricePerItem(itemLink, nil, nil)

    if avgPrice ~= nil and avgPrice ~= 0 then
        tooltip:AddLine(zo_strformat("|cf58585ATT average price: <<1>><<2>> |r", FormatNumber(avgPrice, "currency"), symbolGold))
    end
end

-- ESO Trading Hub
if (GPP.settings.ethl or GPP.settings.eths) and LibEsoHubPrices then
    local priceData = LibEsoHubPrices.GetItemPriceData(itemLink)

    if priceData ~= nil then

        -- Listing Prices
        if GPP.settings.ethl and priceData.averageListing ~= nil then
            local suggestedListingPriceMin	= priceData.suggestedListingPriceMin
            local suggestedListingPriceMax	= priceData.suggestedListingPriceMax
            local averageListing			= priceData.averageListing
            local numberOfListings			= priceData.numberOfListings
            local listingPriceMax			= priceData.listingPriceMax
            local listingPriceMin			= priceData.listingPriceMin

            tooltip:AddLine(zo_strformat("|cffff99ESO-Hub.com Listings Data|r"))

            if suggestedListingPriceMin ~= nil and suggestedListingPriceMax ~= nil then
                tooltip:AddLine(zo_strformat("Suggested price: <<1>><<2>> - <<3>><<4>>", FormatNumber(suggestedListingPriceMin, "currency"), symbolGold, FormatNumber(suggestedListingPriceMax, "currency"), symbolGold))
            end

            tooltip:AddLine(zo_strformat("Average price: <<1>><<2>>", FormatNumber(averageListing, "currency"), symbolGold))

            if listingPriceMax ~= nil and listingPriceMin ~= nil and numberOfListings ~= nil then
                tooltip:AddLine(zo_strformat("<<1>><<2>> - <<3>><<4>> in <<5[no listings/1 listing/$d listings]>>", FormatNumber(listingPriceMin, "currency"), symbolGold, FormatNumber(listingPriceMax, "currency"), symbolGold, FormatNumber(numberOfListings)))
            end
        end

        -- Sales Prices
        if GPP.settings.eths and priceData.averageSales ~= nil then
            local suggestedSalesPriceMin	= priceData.suggestedSalesPriceMin
            local suggestedSalesPriceMax	= priceData.suggestedSalesPriceMax
            local averageSales				= priceData.averageSales
            local numberOfSales				= priceData.numberOfSales
            local salesPriceMax				= priceData.salesPriceMax
            local salesPriceMin				= priceData.salesPriceMin

            tooltip:AddLine(zo_strformat("|cffff99ESO-Hub.com Sales Data (Last 14 days)|r"))

            if suggestedSalesPriceMin ~= nil and suggestedSalesPriceMax ~= nil then
                tooltip:AddLine(zo_strformat("Suggested price: <<1>><<2>> - <<3>><<4>>", FormatNumber(suggestedSalesPriceMin, "currency"), symbolGold, FormatNumber(suggestedSalesPriceMax, "currency"), symbolGold))
            end

            tooltip:AddLine(zo_strformat("Average price: <<1>><<2>>", FormatNumber(averageSales, "currency"), symbolGold))

            if salesPriceMin ~= nil and salesPriceMax ~= nil and numberOfSales ~= nil then
                tooltip:AddLine(zo_strformat("<<1>><<2>> - <<3>><<4>> in <<5[no sales/1 sale/$d sales]>>", FormatNumber(salesPriceMin, "currency"), symbolGold, FormatNumber(salesPriceMax, "currency"), symbolGold, FormatNumber(numberOfSales)))
            end
        end
    end
end

-- Master Merchant
if GPP.settings.mm and (MasterMerchant and MasterMerchant.isInitialized ~= false) and (LibGuildStore and LibGuildStore.guildStoreReady ~=  false) then
    local priceData = MasterMerchant:itemStats(itemLink, false)

    if priceData ~= nil then
        local avgPrice = priceData.avgPrice
        local numSales = priceData.numSales
        local numDays = priceData.numDays
        local numItems = priceData.numItems

        if 	avgPrice ~= nil and numSales ~= nil and numDays ~= nil and numItems ~= nil then
            tooltip:AddLine(zo_strformat("|c7171d1MM price (<<1[no sales/1 sale/$d sales]>>/<<2[no items/1 item/$d items]>>, <<3[no days/1 day/$d days]>>): <<4>><<5>> |r", FormatNumber(numSales), FormatNumber(numItems), FormatNumber(numDays), FormatNumber(avgPrice, "currency"), symbolGold))
        end

        -- Crafting Cost
        local craftCost, craftCostEach = MasterMerchant:itemCraftPrice(itemLink)

        if craftCost ~= nil and craftCostEach ~= nil then
            if (itemType == ITEMTYPE_POTION) or (itemType == ITEMTYPE_POISON) then
                tooltip:AddLine(zo_strformat("|c7171d1MM Craft cost: <<1>> (<<2>> each)<<3>> |r", FormatNumber(craftCost, "currency"), FormatNumber(craftCostEach, "currency"), symbolGold))

            elseif ((itemType == ITEMTYPE_DRINK) or (itemType == ITEMTYPE_FOOD) or
                    (itemType == ITEMTYPE_RECIPE and
                            (specializedItemType == SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_FOOD or
                                    specializedItemType == SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_DRINK))) then
                tooltip:AddLine(zo_strformat("|c7171d1MM Craft cost: <<1>> (<<2>> each)<<3>> |r", FormatNumber(craftCost, "currency"), FormatNumber(craftCostEach, "currency"), symbolGold))

            else
                tooltip:AddLine(zo_strformat("|c7171d1MM Craft cost: <<1>><<2>> |r", FormatNumber(craftCost, "currency"), symbolGold))
            end
        end

        -- Product Price
        if GPP.settings.recipes and itemType == ITEMTYPE_RECIPE then
            local resultItemLink = GetItemLinkRecipeResultItemLink(itemLink)
            local productPriceData = MasterMerchant:itemStats(resultItemLink, false)

            if productPriceData ~= nil then
                local productAvgPrice = productPriceData.avgPrice
                local productNumSales = productPriceData.numSales
                local productNumDays = productPriceData.numDays
                local productNumItems = productPriceData.numItems

                if productAvgPrice ~= nil and productNumSales ~= nil and productNumDays ~= nil and productNumItems ~= nil then
                    tooltip:AddLine(zo_strformat("|c7171d1MM Product price (<<1[no sales/1 sale/$d sales]>>/<<2[no items/1 item/$d items]>>, <<3[no days/1 day/$d days]>>): <<4>><<5>> |r", FormatNumber(productNumSales), FormatNumber(productNumItems), FormatNumber(productNumDays), FormatNumber(productAvgPrice, "currency"), symbolGold))
                end
            end
        end
    end
end

-- Tamriel Trade Centre
-- TODO: Cleanup TTC code and add TTC sales data
if GPP.settings.ttc and TamrielTradeCentre ~= nil then
    local itemInfo = TamrielTradeCentre_ItemInfo:New(itemLink)
    local priceInfo = TamrielTradeCentrePrice:GetPriceInfo(itemInfo)

    if (priceInfo == nil) then
        tooltip:AddLine(zo_strformat("|cf23d8eTTC <<1>>|r", GetString(TTC_PRICE_NOLISTINGDATA)))
    else
        if (priceInfo.SuggestedPrice ~= nil) then
            tooltip:AddLine(zo_strformat("|cf23d8eTTC <<1>>|r", string.format(GetString(TTC_PRICE_SUGGESTEDXTOY),
                    TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice, 0), TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice * 1.25, 0))))
        end

        if (true) then
            tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", string.format(GetString(TTC_PRICE_AGGREGATEPRICESXYZ), TamrielTradeCentre:FormatNumber(priceInfo.Avg),
                    TamrielTradeCentre:FormatNumber(priceInfo.Min), TamrielTradeCentre:FormatNumber(priceInfo.Max))))
        end

        if (true) then
            if (priceInfo.EntryCount ~= priceInfo.AmountCount) then
                tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", string.format(GetString(TTC_PRICE_XLISTINGSYITEMS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount), TamrielTradeCentre:FormatNumber(priceInfo.AmountCount))))
                tooltip:AddLine()
            else
                tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", string.format(GetString(TTC_PRICE_XLISTINGS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount))))
            end
        end
    end

    if GPP.settings.recipes and itemType == ITEMTYPE_RECIPE then

        local resultItemLink = GetItemLinkRecipeResultItemLink(itemLink)
        local priceInfo = TamrielTradeCentrePrice:GetPriceInfo(resultItemLink)

        if (priceInfo == nil) then
            tooltip:AddLine(zo_strformat("|cf23d8eProduct <<1>>|r", GetString(TTC_PRICE_NOLISTINGDATA)))
        else
            if (priceInfo.SuggestedPrice ~= nil) then
                tooltip:AddLine(zo_strformat("|cf23d8eProduct <<1>>|r", string.format(GetString(TTC_PRICE_SUGGESTEDXTOY),
                        TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice, 0), TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice * 1.25, 0))))
            end

            if (true) then
                tooltip:AddLine(zo_strformat("|cf23d8eProduct <<1>>|r", string.format(GetString(TTC_PRICE_AGGREGATEPRICESXYZ), TamrielTradeCentre:FormatNumber(priceInfo.Avg),
                        TamrielTradeCentre:FormatNumber(priceInfo.Min), TamrielTradeCentre:FormatNumber(priceInfo.Max))))
            end

            if (true) then
                if (priceInfo.EntryCount ~= priceInfo.AmountCount) then
                    tooltip:AddLine(zo_strformat("|cf23d8eProduct <<1>>|r", string.format(GetString(TTC_PRICE_XLISTINGSYITEMS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount), TamrielTradeCentre:FormatNumber(priceInfo.AmountCount))))
                    tooltip:AddLine()
                else
                    tooltip:AddLine(zo_strformat("|cf23d8eProduct <<1>>|r", string.format(GetString(TTC_PRICE_XLISTINGS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount))))
                end
            end
        end
    end
end