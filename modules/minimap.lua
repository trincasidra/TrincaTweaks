local A, L = ...

local rLib = L.rLib

local dummy = function() end
local unpack = unpack
local backdrop = { edgeFile = L.C.texture, edgeSize = 1 }

--[[
  Minimap wdigets:
      +-----------------------------------------+
      | Tracking    Instance Mode      Garrison |
      |                                         |
      |                                         |
      |                                         |
      |                                         |
      |                                         |
      | Addons                                  |
      |                                         |
      |                                         |
      |                                         |
      |                                         |
      |                                         |
      | LFG             Clock              Mail |
      +-----------------------------------------+
]]

-- Hide minimap border art
MinimapBackdrop:Hide()
MinimapCompassTexture:Hide()
Minimap.ZoomIn:Hide()
Minimap.ZoomIn.Show = dummy
Minimap.ZoomOut:Hide()
Minimap.ZoomOut.Show = dummy

-- Square minimap
Minimap:SetMaskTexture(L.C.texture)
Minimap:ClearAllPoints()
Minimap:SetPoint("CENTER", -10, -22)
Minimap:SetSize(240, 240)
Minimap:SetArchBlobRingScalar(0)
Minimap:SetQuestBlobRingScalar(0)
Minimap:SetTaskBlobRingScalar(0)
function GetMinimapShape() return "SQUARE" end

-- New minimap border
local border = CreateFrame("Frame", nil, Minimap, BackdropTemplateMixin and "BackdropTemplate")
border:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -1, 1)
border:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", 1, -1)
border:SetBackdrop(backdrop)
border:SetBackdropBorderColor(unpack(L.C.minimapBorderColor))
border:SetFrameLevel(3)
Minimap.Border = border

-- Zone text
MinimapCluster.ZoneTextButton:Hide()
MinimapCluster.BorderTop:Hide()

-- Mail icon
MinimapCluster.IndicatorFrame.MailFrame:ClearAllPoints()
MinimapCluster.IndicatorFrame.MailFrame:SetPoint("BOTTOMRIGHT", Minimap.Border, "BOTTOMRIGHT", -4, 4)
MinimapCluster.IndicatorFrame.MailFrame:SetAlpha(.9)
MinimapCluster.IndicatorFrame.MailFrame.SetPoint = dummy

-- Clock
C_AddOns.LoadAddOn("Blizzard_TimeManager")
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOM", Minimap.Border, "BOTTOM", 0, 4)
TimeManagerClockTicker:SetFont(L.C.font, 12, "OUTLINE")
TimeManagerClockTicker:SetTextColor(.8, .8, .6, 1)
TimeManagerClockButton:SetAlpha(.9)

-- Addons
AddonCompartmentFrame:ClearAllPoints()
AddonCompartmentFrame:SetPoint("LEFT", Minimap.Border, "LEFT", 4, 0)
AddonCompartmentFrame.Text:SetFont(L.C.font, 12, "OUTLINE")
AddonCompartmentFrame.Text:SetTextColor(.8, .8, .6, 1)
AddonCompartmentFrame:SetAlpha(.9)

-- Calendar
GameTimeFrame:Hide()

-- Tracking
MinimapCluster.Tracking:SetParent(Minimap.Border)
MinimapCluster.Tracking:SetScale(1)
MinimapCluster.Tracking:ClearAllPoints()
MinimapCluster.Tracking:SetPoint("TOPLEFT", Minimap.Border, 4, -4)
MinimapCluster.Tracking.Background:Hide()
MinimapCluster.Tracking:SetAlpha(0)

-- Instance difficulty
MinimapCluster.InstanceDifficulty:ClearAllPoints()
MinimapCluster.InstanceDifficulty:SetParent(Minimap.Border)
MinimapCluster.InstanceDifficulty:SetPoint("TOP", Minimap.Border, 0, -5)
MinimapCluster.InstanceDifficulty:SetFrameStrata("HIGH")
MinimapCluster.InstanceDifficulty.ChallengeMode.Background:Hide()
MinimapCluster.InstanceDifficulty.ChallengeMode.Border:Hide()
MinimapCluster.InstanceDifficulty.Default.Background:Hide()
MinimapCluster.InstanceDifficulty.Default.Border:Hide()
MinimapCluster.InstanceDifficulty.Guild.Background:Hide()
MinimapCluster.InstanceDifficulty.Guild.Border:Hide()

local function MoveInstanceDifficulty()
    MinimapCluster.InstanceDifficulty:ClearAllPoints()
    MinimapCluster.InstanceDifficulty:SetParent(Minimap.Border)
    MinimapCluster.InstanceDifficulty:SetPoint("TOP", Minimap.Border, 0, -5)
    MinimapCluster.InstanceDifficulty:SetFrameStrata("HIGH")
end
MinimapCluster.InstanceDifficulty:HookScript("OnEvent", MoveInstanceDifficulty)

-- LFG
local function MoveLfgEye()
    if not QueueStatusButton.alreadyMoved then
        QueueStatusButton:SetParent(Minimap.Border)
        QueueStatusButton:ClearAllPoints()
        QueueStatusButton:SetScale(.8)
        QueueStatusButton:SetPoint("BOTTOMLEFT", Minimap.Border, 4, 4)
        QueueStatusButton:SetFrameStrata("HIGH")
        QueueStatusButton.SetPoint = dummy
        MicroMenuContainer.Layout = dummy
        QueueStatusButton.alreadyMoved = true
    end
end
--QueueStatusButton:HookScript("OnShow", MoveLfgEye)

-- Garrison
ExpansionLandingPageMinimapButton:SetParent(Minimap.Border)
ExpansionLandingPageMinimapButton:SetScale(.7)
ExpansionLandingPageMinimapButton:ClearAllPoints()
ExpansionLandingPageMinimapButton:SetPoint("TOPRIGHT", Minimap.Border, -4, -4)
ExpansionLandingPageMinimapButton.ClearAllPoints = dummy
ExpansionLandingPageMinimapButton.SetPoint = dummy
ExpansionLandingPageMinimapButton:SetAlpha(.9)

-- Hide/Show minimap buttons on mouseover
local function Show()
    MinimapCluster.Tracking:SetAlpha(.9)
    MinimapCluster.InstanceDifficulty:SetAlpha(.9)
    ExpansionLandingPageMinimapButton:SetAlpha(.9)
end
Minimap:HookScript("OnEnter", Show)

local lasttime = 0
local function Hide()
    if Minimap:IsMouseOver() then return end
    if time() == lasttime then return end
    MinimapCluster.Tracking:SetAlpha(0)
    MinimapCluster.InstanceDifficulty:SetAlpha(0)
    ExpansionLandingPageMinimapButton:SetAlpha(0)
end
local function SetTimer()
    lasttime = time()
    C_Timer.After(1.5, Hide)
end
Minimap:HookScript("OnLeave", SetTimer)
rLib:RegisterCallback("PLAYER_ENTERING_WORLD", Hide)
Hide(Minimap)
