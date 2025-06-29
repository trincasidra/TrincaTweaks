local A, L = ...

L.C = {
    texture = "Interface\\Buttons\\WHITE8x8",
    font = "Interface\\AddOns\\" .. A .. "\\media\\Expressway.ttf",
    chatHistory = {
        enable = true,
        logLines = 500,
        logChannels = false, -- Whether to log General, Trade, Defense, Services and Custom channels
    },
    styleTooltip = true,
    styleRollHistory = false,
    fade = {
        microMenuAndBags = false,
        expBar = false,
        actionBar1 = true,
        actionBar2 = true,
        actionBar3 = true,
        actionBar4 = true,
        actionBar5 = true,
        actionBar6 = true,
        actionBar7 = true,
        actionBar8 = true
    },
    minimapBorderColor = { 0, 0, 0 }
}
