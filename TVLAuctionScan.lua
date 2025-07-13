TVLAuctionScanDB = TVLAuctionScanDB or {}

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")

f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "TVLAuctionScan" then
        print("|cff00ff00[TVLAuctionScan]|r Addon geladen.")
        TVLAuctionScan_CreateButton()
    end
end)

function TVLAuctionScan_CreateButton()
    local scanFrame = CreateFrame("Frame", "TVLScanFrame", UIParent)
    scanFrame:SetSize(120, 40)
    scanFrame:SetPoint("CENTER", UIParent, "CENTER", 200, -200)
    scanFrame:SetMovable(true)
    scanFrame:EnableMouse(true)
    scanFrame:RegisterForDrag("LeftButton")
    scanFrame:SetScript("OnDragStart", scanFrame.StartMoving)
    scanFrame:SetScript("OnDragStop", scanFrame.StopMovingOrSizing)

    local bg = scanFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.4)

    local button = CreateFrame("Button", nil, scanFrame, "UIPanelButtonTemplate")
    button:SetSize(100, 24)
    button:SetPoint("CENTER")
    button:SetText("Scan starten")
    button:SetScript("OnClick", TVLAuctionScan_RunScan)
end

function TVLAuctionScan_RunScan()
    local numBatchAuctions = GetNumAuctionItems("list")
    if numBatchAuctions == 0 then
        print("|cffff0000[TVLAuctionScan]|r Keine Auktionen geladen. Bitte auf 'Search' klicken.")
        return
    end

    local scanned = 0
    for i = 1, numBatchAuctions do
        local name, _, count, _, _, _, minBid, _, buyoutPrice, _, _, owner = GetAuctionItemInfo("list", i)

        if name and buyoutPrice and buyoutPrice > 0 then
            TVLAuctionScanDB[name] = TVLAuctionScanDB[name] or {}
            table.insert(TVLAuctionScanDB[name], {
                price = buyoutPrice,
                count = count,
                owner = owner,
                time = time()
            })
            scanned = scanned + 1
        end
    end

    print("|cff00ff00[TVLAuctionScan]|r Scan abgeschlossen: "..scanned.." Einträge gespeichert.")
end
