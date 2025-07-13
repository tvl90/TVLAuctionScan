TVLAuctionScanDB = TVLAuctionScanDB or {}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "TVLAuctionScan" then
        print("|cff00ff00[TVLAuctionScan]|r Addon geladen.")
        TVLAuctionScan_Initialize()
    end
end)

function TVLAuctionScan_Initialize()
    local scanButton = CreateFrame("Button", "TVLScanButton", AuctionFrameBrowse, "UIPanelButtonTemplate")
    scanButton:SetSize(100, 22)
    scanButton:SetText("Scan starten")
    scanButton:SetPoint("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", -40, -30)
    scanButton:SetScript("OnClick", TVLAuctionScan_RunScan)
end

function TVLAuctionScan_RunScan()
    local numBatchAuctions = GetNumAuctionItems("list")
    if numBatchAuctions == 0 then
        print("|cffff0000[TVLAuctionScan]|r Keine Auktionen geladen. Bitte auf 'Suchen' klicken.")
        return
    end

    for i = 1, numBatchAuctions do
        local name, _, count, _, _, _, minBid, _, buyoutPrice, _, _, owner = GetAuctionItemInfo("list", i)
        local itemLink = GetAuctionItemLink("list", i)

        if name and buyoutPrice and buyoutPrice > 0 then
            TVLAuctionScanDB[name] = TVLAuctionScanDB[name] or {}
            table.insert(TVLAuctionScanDB[name], {
                price = buyoutPrice,
                count = count,
                owner = owner,
                time = time()
            })
        end
    end

    print("|cff00ff00[TVLAuctionScan]|r Scan abgeschlossen. "..numBatchAuctions.." Einträge gespeichert.")
end
