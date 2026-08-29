if GUI_Manager == nil then
    GUI_Manager = {}
    GUI_Manager.open = true
    GUI_Manager.visible = true
    GUI_Manager.SelectedMode = "Bootstrap" -- Kept for compatibility with older reloads.
    GUI_Manager.ShowDebug = true
end

local MODE_NAMES = { "Bootstrap", "Helper", "Ravana" }
local MODE_DESCRIPTIONS = {
    Bootstrap = "Automated MSQ, job quests, and story duty progression",
    Helper = "Host story-duty clears for another game instance",
    Ravana = "Dedicated Ravana Extreme farming loop",
}

local function ColoredText(r, g, b, text)
    GUI:PushStyleColor(GUI.Col_Text, r, g, b, 1)
    GUI:Text(text)
    GUI:PopStyleColor()
end

local function drawModePicker()
    local currentMode = NoobgamConfigManager.Config.mode or "Bootstrap"
    local currentIndex = 1
    for index, mode in ipairs(MODE_NAMES) do
        if mode == currentMode then
            currentIndex = index
            break
        end
    end

    GUI:PushItemWidth(180)
    local selectedIndex, changed = GUI:Combo("Mode", currentIndex, MODE_NAMES)
    GUI:PopItemWidth()

    if changed and MODE_NAMES[selectedIndex] then
        currentMode = MODE_NAMES[selectedIndex]
        NoobgamConfigManager.Config.mode = currentMode
        NoobgamConfigManager.SaveConfig()
    end

    -- SelectedMode used to be independent from Config.mode, which made the
    -- visible page disagree with the mode actually running.
    GUI_Manager.SelectedMode = currentMode
    ColoredText(0.65, 0.65, 0.65, MODE_DESCRIPTIONS[currentMode] or "")
    GUI:Separator()
end

local function drawRavanaOverview()
    ColoredText(0.9, 0.65, 0.2, "Ravana Extreme Farmer")
    GUI:Text("State: " .. tostring(RavanaFarm.State or "Unknown"))

    if MGetGameState() == FFXIV.GAMESTATE.INGAME then
        GUI:Text("Gil: " .. tostring(GilCount()))
    else
        ColoredText(0.8, 0.2, 0.2, "Not in game")
    end

    GUI:Separator()
    if GUI:Button("Reset Farm##RavanaFarm") then
        RavanaFarm.Reset()
    end
end

local function drawRavanaSettings()
    ColoredText(0.9, 0.3, 0.2, "High-risk mode")
    GUI:Text("Ravana farming has no configurable options.")
    GUI:Text("Avoid prolonged or unattended farming sessions.")
end

local function drawHelperOverview()
    ColoredText(0.8, 0.8, 0.2, "MSQ Clear Helper")
    GUI:Text("Role: " .. tostring(MsqClearHelper.Role or "Waiting"))
    GUI:Text("Host State: " .. tostring(MsqClearHelper.HostState or "Idle"))
    GUI:Text("Dungeon ID: " .. tostring(MsqClearHelper.CurrentDungeonId or "None"))
    GUI:Text("Farmer: " .. tostring(MsqClearHelper.CurrentFarmer or "None"))

    if MGetGameState() ~= FFXIV.GAMESTATE.INGAME then
        ColoredText(0.8, 0.2, 0.2, "Not in game")
    elseif MsqClearHelper.CurrentFarmer then
        ColoredText(0.2, 0.8, 0.2, "A clear request is active")
    else
        ColoredText(0.65, 0.65, 0.65, "Waiting for a clear request")
    end

    GUI:Separator()
    if GUI:Button("Reset Helper##Helper") then
        MsqClearHelper.Reset()
    end
end

local function drawHelperSettings()
    GUI:Text("Helper mode watches the shared request folder and hosts")
    GUI:Text("undersized story-duty clears for a Bootstrap instance.")
    GUI:Separator()
    GUI:Text("There are no per-helper settings.")
end

local function drawDebugPanel()
    if not GUI:CollapsingHeader("Debug Panel") then
        return
    end

    GUI:Indent()

    -- Job Quest Debug
    ColoredText(0.8, 0.8, 0.2, "Job Quest Status")
    GUI:Separator()

    local myJob = MsqBootstrap.CONFIG.jobMapping[Player.job] or Player.job
    GUI:Text("Current Job: " .. tostring(Player.job) .. " (Mapped: " .. tostring(myJob) .. ")")
    GUI:Text("Job Level: " .. tostring(Player.levels[Player.job] or 0))

    -- Check job quest completion at each level
    local levels = { 15, 30, 50, 60, 70, 80 }
    for _, level in ipairs(levels) do
        local mapping = MsqBootstrap.CONFIG.jobQuestCompletion[level]
        if mapping then
            local questId = mapping[myJob]
            if questId then
                local completed = QuestCompleted(questId)
                local color = completed and { 0.2, 0.8, 0.2 } or { 0.8, 0.2, 0.2 }
                GUI:Text("  Level " .. level .. " (Quest " .. questId .. "): ")
                GUI:SameLine()
                ColoredText(color[1], color[2], color[3], completed and "Complete" or "Incomplete")
            else
                GUI:Text("  Level " .. level .. ": No quest defined")
            end
        end
    end

    GUI:Separator()

    -- Soul Crystal Check
    ColoredText(0.8, 0.8, 0.2, "Soul Crystal Check")
    GUI:Separator()

    local soul = Inventory:Get(1000):GetList()[14]
    if soul then
        ColoredText(0.2, 0.8, 0.2, "Soul Crystal Equipped: " .. (soul.name or "Unknown"))
    else
        ColoredText(0.8, 0.2, 0.2, "No Soul Crystal Equipped")
    end

    GUI:Separator()

    -- Prerequisite Quests
    ColoredText(0.8, 0.8, 0.2, "Prerequisite Quests")
    GUI:Separator()

    local prereqs = {
        { id = 1162, name = "Chocobo" },
        { id = 952,  name = "Airship Quest (Has)" },
        { id = 953,  name = "Airship Quest (Complete)" },
        { id = 715,  name = "First Contact" },
        { id = 4522, name = "Can Do Porta" },
        { id = 1619, name = "Heavensward Complete" },
        { id = 3649, name = "Role Quest Unlock" },
        { id = 3650, name = "Role Quest Check" },
    }

    for _, quest in ipairs(prereqs) do
        local completed = QuestCompleted(quest.id)
        local hasQuest = HasQuest(quest.id)
        local color = completed and { 0.2, 0.8, 0.2 } or (hasQuest and { 0.8, 0.8, 0.2 } or { 0.8, 0.2, 0.2 })
        local status = completed and "Complete" or (hasQuest and "Active" or "Not Started")

        GUI:Text("  " .. quest.name .. " (" .. quest.id .. "): ")
        GUI:SameLine()
        ColoredText(color[1], color[2], color[3], status)
    end

    GUI:Separator()

    -- Decision Logic
    ColoredText(0.8, 0.8, 0.2, "Decision Logic")
    GUI:Separator()

    local haveChocobo = QuestCompleted(1162)
    local deadlockedByAirship = HasQuest(952) or (QuestCompleted(952) and not QuestCompleted(953))
    local canDoPorta = QuestCompleted(4522)
    local timeToJob = not deadlockedByAirship and haveChocobo and QuestCompleted(715)

    GUI:Text("Have Chocobo: " .. (haveChocobo and "Yes" or "No"))
    GUI:Text("Deadlocked by Airship: " .. (deadlockedByAirship and "Yes" or "No"))
    GUI:Text("Can Do Porta: " .. (canDoPorta and "Yes" or "No"))
    GUI:Text("Time To Job: ")
    GUI:SameLine()
    ColoredText(timeToJob and 0.2 or 0.8, timeToJob and 0.8 or 0.2, 0.2, timeToJob and "Yes" or "No")

    GUI:Separator()

    -- Current Quest Step Check
    ColoredText(0.8, 0.8, 0.2, "Unskippable Dungeon Check")
    GUI:Separator()

    local foundUnskippable = false
    for questId, steps in pairs(MsqClearHelper.QuestStepIdToDungeonId) do
        for stepId, dungeonId in pairs(steps) do
            local currentStep = Quest:GetQuestCurrentStep(questId)
            if currentStep == stepId then
                ColoredText(0.8, 0.2, 0.2,
                    "BLOCKED: Quest " .. questId .. " Step " .. stepId .. " -> Dungeon " .. dungeonId)
                foundUnskippable = true
            end
        end
    end

    if not foundUnskippable then
        ColoredText(0.2, 0.8, 0.2, "No unskippable dungeons blocking")
    end

    GUI:Separator()

    -- Job Chest Check
    ColoredText(0.8, 0.8, 0.2, "Job Chest Inventory")
    GUI:Separator()

    local chestRanges = {
        { 20601, 20612, "IL 240 Coffers" },
        { 20642, 20670, "IL 90 Coffers" },
        { 20275, 20288, "IL 290 Coffers" },
    }

    local foundChests = false
    for invid = 0, 3 do
        local bag = Inventory:Get(invid)
        if table.valid(bag) then
            for _, item in pairs(bag:GetList()) do
                if item then
                    for _, range in ipairs(chestRanges) do
                        if item.hqid >= range[1] and item.hqid <= range[2] then
                            ColoredText(0.8, 0.5, 0.2, "Found: " .. (item.name or "Unknown") .. " (" .. range[3] .. ")")
                            foundChests = true
                        end
                    end
                end
            end
        end
    end

    if not foundChests then
        GUI:Text("No job chests found")
    end

    GUI:Unindent()
end

local logsStateFolder = GetLuaModsPath() .. "SimpleFFXIVBotting\\logs\\"
local sharedStateFolder = GetLuaModsPath() .. "SimpleFFXIVBotting\\shared\\"

local function clearSharedFolder()
    local sharedStatePath = sharedStateFolder .. "msq_clear_requests.json"
    local pfReadyPath = sharedStateFolder .. "msq_pf_ready.json"
    FileDelete(sharedStatePath)
    FileDelete(pfReadyPath)
end

local function buildBugReport()
    local lines = {}

    local function add(text)
        lines[#lines + 1] = text
    end

    add("=== NoobgamSidekick Bug Report ===")
    add("Date: " .. os.date("%Y-%m-%d %H:%M:%S"))
    add("")

    add("--- Player Info ---")
    add("Job: " .. tostring(Player.job))
    add("Level: " .. tostring(Player.levels[Player.job] or 0))
    add("Map ID: " .. tostring(Player.localmapid))
    add("Gil: " .. tostring(GilCount()))
    add("")

    add("--- Bot State ---")
    add("Mode: " .. tostring(NoobgamConfigManager.Config.mode))
    add("Enabled: " .. tostring(NoobgamConfigManager.Config.enabled))
    add("Bot Running: " .. tostring(FFXIV_Common_BotRunning))
    add("Quest Profile: " .. tostring(gQuestProfile or "None"))
    add("Bot Mode: " .. tostring(gBotMode or "None"))
    add("Active Profile: " .. tostring(MsqBootstrap.LastProfile or "None"))
    add("Use Duty Finder: " .. tostring(NoobgamConfigManager.Config.useDutyFinder or false))
    add("Do Not Use Helpers: " .. tostring(NoobgamConfigManager.Config.doNotUseHelpers or false))
    add("")

    add("--- Wait State ---")
    if MsqBootstrap.WaitUntil and MsqBootstrap.WaitUntil > Now() then
        local remaining = math.floor((MsqBootstrap.WaitUntil - Now()) / 1000)
        add("Waiting: " .. remaining .. "s remaining")
        add("Has Break-out Condition: " .. tostring(MsqBootstrap.WaitCondition ~= nil))
    else
        add("Not waiting")
    end
    add("")

    add("--- Quest Settings ---")
    add("Latty Running: " .. tostring(LattyLib.QuestCore.running == true))
    add("Quest Rule: " .. tostring(LattyLib.GetQuestRuleValue()))
    add("Quest Sub-Rule: " .. tostring(LattyLib.GetEffectiveSideQuestRule()))
    add("Aether Quests: " .. tostring(LattyLib.LattyPackAetherQuests() and "Yes" or "No"))
    add("Latty Status: " .. tostring(LattyLib.QuestCore.lastStatus or ""))
    add("")

    add("--- Prerequisite Quests ---")
    local prereqs = {
        { id = 1162, name = "Chocobo" },
        { id = 952,  name = "Airship Quest (Has)" },
        { id = 953,  name = "Airship Quest (Complete)" },
        { id = 715,  name = "First Contact" },
        { id = 4522, name = "Can Do Porta" },
        { id = 1619, name = "Heavensward Complete" },
        { id = 3649, name = "Role Quest Unlock" },
        { id = 3650, name = "Role Quest Check" },
    }
    for _, quest in ipairs(prereqs) do
        local completed = QuestCompleted(quest.id)
        local hasQuest = HasQuest(quest.id)
        local status = completed and "Complete" or (hasQuest and "Active" or "Not Started")
        add("  " .. quest.name .. " (" .. quest.id .. "): " .. status)
    end
    add("")

    add("--- Decision Logic ---")
    local haveChocobo = QuestCompleted(1162)
    local deadlockedByAirship = HasQuest(952) or (QuestCompleted(952) and not QuestCompleted(953))
    local canDoPorta = QuestCompleted(4522)
    local timeToJob = not deadlockedByAirship and haveChocobo and QuestCompleted(715)
    add("Have Chocobo: " .. (haveChocobo and "Yes" or "No"))
    add("Deadlocked by Airship: " .. (deadlockedByAirship and "Yes" or "No"))
    add("Can Do Porta: " .. (canDoPorta and "Yes" or "No"))
    add("Time To Job: " .. (timeToJob and "Yes" or "No"))
    add("")

    add("--- Job Quest Status ---")
    local myJob = MsqBootstrap.CONFIG.jobMapping[Player.job] or Player.job
    add("Mapped Job: " .. tostring(myJob))
    local levels = { 15, 30, 50, 60, 70, 80 }
    for _, level in ipairs(levels) do
        local mapping = MsqBootstrap.CONFIG.jobQuestCompletion[level]
        if mapping then
            local questId = mapping[myJob]
            if questId then
                local completed = QuestCompleted(questId)
                add("  Level " .. level .. " (Quest " .. questId .. "): " .. (completed and "Complete" or "Incomplete"))
            else
                add("  Level " .. level .. ": No quest defined")
            end
        end
    end
    add("")

    add("--- Unskippable Dungeons ---")
    local foundUnskippable = false
    for questId, steps in pairs(MsqClearHelper.QuestStepIdToDungeonId) do
        for stepId, dungeonId in pairs(steps) do
            local currentStep = Quest:GetQuestCurrentStep(questId)
            if currentStep == stepId then
                add("BLOCKED: Quest " .. questId .. " Step " .. stepId .. " -> Dungeon " .. dungeonId)
                foundUnskippable = true
            end
        end
    end
    if not foundUnskippable then
        add("No unskippable dungeons blocking")
    end
    add("")

    add("=== End of Report ===")

    return table.concat(lines, "\n")
end

local function execute(cmd)
    local handle = io.popen(cmd)
    d("Executing " .. cmd)
    if not handle then return nil end
    local output = handle:read("*a")
    handle:close()
    return output
end

local function generateBugReportZip()
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local baseFolder = GetLuaModsPath() .. "SimpleFFXIVBotting\\"
    local stagingDir = baseFolder .. "bugreport_" .. timestamp
    local zipPath = baseFolder .. "bugreport_" .. timestamp .. ".zip"

    execute('mkdir "' .. stagingDir .. '"')
    execute('mkdir "' .. stagingDir .. '\\shared"')
    execute('mkdir "' .. stagingDir .. '\\logs"')

    local report = buildBugReport()
    local reportFile = io.open(stagingDir .. "\\report.txt", "w")
    if reportFile then
        reportFile:write(report)
        reportFile:close()
    end

    local consoleLines = GetConsoleLines()
    local consoleFile = io.open(stagingDir .. "\\console.log", "w")
    if consoleFile then
        consoleFile:write(consoleLines)
        consoleFile:close()
    end

    execute(string.format('xcopy "%s*" "%s\\shared\\" /E /I /Y /Q', sharedStateFolder, stagingDir))
    execute(string.format('xcopy "%s*" "%s\\logs\\" /E /I /Y /Q', logsStateFolder, stagingDir))

    local zipCmd = string.format(
        'powershell -NoProfile -Command "Compress-Archive -Path \'%s\\*\' -DestinationPath \'%s\'"',
        stagingDir,
        zipPath
    )
    execute(zipCmd)

    return zipPath
end

local function drawBootstrapSettings()
    ColoredText(0.8, 0.8, 0.2, "Quest Selection")

    local useBlueQuestFilter, blueQuestFilterPressed = GUI:Checkbox(
        "Use Blue Quests instead of Aether Current quests",
        NoobgamConfigManager.Config.useBlueQuestFilter or false
    )
    if blueQuestFilterPressed then
        NoobgamConfigManager.Config.useBlueQuestFilter = useBlueQuestFilter
        NoobgamConfigManager.SaveConfig()
    end

    local questLevelCap, levelCapChanged = GUI:SliderInt(
        "Quest level cap",
        NoobgamConfigManager.Config.questLevelCap or 10,
        1,
        100
    )
    if levelCapChanged then
        NoobgamConfigManager.Config.questLevelCap = questLevelCap
        NoobgamConfigManager.SaveConfig()
    end

    GUI:Separator()
    ColoredText(0.8, 0.8, 0.2, "Duty Handling")

    local doNotUseHelpers, helpersChanged = GUI:Checkbox(
        "Do not use helpers",
        NoobgamConfigManager.Config.doNotUseHelpers or false
    )
    if helpersChanged then
        NoobgamConfigManager.Config.doNotUseHelpers = doNotUseHelpers
        NoobgamConfigManager.SaveConfig()
        if doNotUseHelpers then
            -- updateFarmer also performs this cleanup. Doing it here makes
            -- the setting immediate when changed while logged in.
            if MGetGameState() == FFXIV.GAMESTATE.INGAME then
                MsqClearHelper.UnregisterClear()
                MsqClearHelper.UnpublishPfReady(Player.name)
            end
            MsqClearHelper.CurrentDungeonId = nil
            MsqClearHelper.JoinPfScheduled = false
            MsqClearHelper.HelperOptOutCleaned = false
        end
    end

    local useDutyFinder, dutyFinderPressed = GUI:Checkbox(
        "Use Duty Finder",
        NoobgamConfigManager.Config.useDutyFinder or false
    )
    if dutyFinderPressed then
        NoobgamConfigManager.Config.useDutyFinder = useDutyFinder
        NoobgamConfigManager.SaveConfig()
    end

    if doNotUseHelpers and useDutyFinder then
        ColoredText(0.2, 0.8, 0.2, "All detected story duties will use Duty Finder.")
    elseif doNotUseHelpers then
        ColoredText(0.9, 0.5, 0.2, "Story duties will pause; no helper requests will be sent.")
    elseif useDutyFinder then
        ColoredText(0.65, 0.65, 0.65, "Duty Finder handles unsupported duties; helpers handle the rest.")
    else
        ColoredText(0.65, 0.65, 0.65, "Helpers handle supported story duties.")
    end

    if GUI:CollapsingHeader("Unsupported trial opt-outs") then
        GUI:Indent()
        local trialOptOuts = NoobgamConfigManager.Config.msqTrialOptOuts or {}
        for _, trial in ipairs(MsqClearHelper.UnsupportedMsqTrials) do
            local optedOut, optOutChanged = GUI:Checkbox(trial.label, trialOptOuts[trial.key] == true)
            if optOutChanged then
                trialOptOuts[trial.key] = optedOut
                NoobgamConfigManager.Config.msqTrialOptOuts = trialOptOuts
                NoobgamConfigManager.SaveConfig()
            end
        end
        GUI:Unindent()
    end
end

local function drawBootstrapOverview()
    ColoredText(0.8, 0.8, 0.2, "MSQ Bootstrap")

    if MGetGameState() ~= FFXIV.GAMESTATE.INGAME then
        ColoredText(0.8, 0.1, 0.2, "Not in game")
        return
    end

    -- Status Section
    ColoredText(0.8, 0.8, 0.2, "Status")
    GUI:Separator()

    local profileText = MsqBootstrap.LastProfile or "None"
    GUI:Text("Active Profile: " .. profileText)

    local botStatus = FFXIV_Common_BotRunning and "Running" or "Stopped"
    local botColor = FFXIV_Common_BotRunning and { 0.2, 0.8, 0.2 } or { 0.8, 0.2, 0.2 }
    GUI:Text("Bot Status: ")
    GUI:SameLine()
    ColoredText(botColor[1], botColor[2], botColor[3], botStatus)

    GUI:Text("Quest Profile: " .. (gQuestProfile or "None"))
    GUI:Text("Bot Mode: " .. (gBotMode or "None"))

    GUI:Separator()

    ColoredText(0.8, 0.8, 0.2, "Wait State")
    GUI:Separator()

    if MsqBootstrap.WaitUntil and MsqBootstrap.WaitUntil > Now() then
        local remaining = math.floor((MsqBootstrap.WaitUntil - Now()) / 1000)
        ColoredText(0.8, 0.5, 0.2, "Waiting: " .. remaining .. "s")

        if MsqBootstrap.WaitCondition then
            GUI:Text("Has break-out condition")
        end
    else
        ColoredText(0.2, 0.8, 0.2, "Not Waiting")
    end

    GUI:Separator()

    ColoredText(0.8, 0.8, 0.2, "Player Info")
    GUI:Separator()

    GUI:Text("Level: " .. tostring(Player.levels[Player.job] or 0))
    GUI:Text("Map ID: " .. tostring(Player.localmapid))

    local inDungeon = table.valid(Duty:GetActiveDutyInfo())
    GUI:Text("In Dungeon: ")
    GUI:SameLine()
    if inDungeon then
        ColoredText(0.8, 0.5, 0.2, "Yes")
    else
        ColoredText(0.2, 0.8, 0.2, "No")
    end

    GUI:Separator()

    -- Quest Settings Section
    ColoredText(0.8, 0.8, 0.2, "Quest Settings")
    GUI:Separator()

    GUI:Text("Latty Running: " .. (LattyLib.QuestCore.running and "Yes" or "No"))
    GUI:Text("Quest Rule: " .. LattyLib.GetQuestRuleValue())
    GUI:Text("Quest Sub-Rule: " .. LattyLib.GetEffectiveSideQuestRule())
    GUI:Text("Aether Quests: " .. (LattyLib.LattyPackAetherQuests() and "Yes" or "No"))
    GUI:Text("Latty Status: " .. tostring(LattyLib.QuestCore.lastStatus or ""))

    GUI:Separator()

    -- Controls Section
    ColoredText(0.8, 0.8, 0.2, "Controls")
    GUI:Separator()

    if GUI:Button("Reset Bootstrap##Bootstrap") then
        clearSharedFolder()
        MsqBootstrap.Reset()
    end

    GUI:SameLine()

    if GUI:Button("Clear Wait##Bootstrap") then
        MsqBootstrap.WaitUntil = nil
        MsqBootstrap.WaitCondition = nil
        MsqBootstrap.BreakOutDelayMillis = nil
    end

    GUI:SameLine()

    if GUI:Button("Bug Report##Bootstrap") then
        local zipName = generateBugReportZip()
        GUI:SetClipboardText("Bug report saved to: " .. zipName)
    end

    GUI:Separator()
    GUI:Text("Gil: " .. tostring(GilCount()))

end

local function drawOverview(mode)
    if mode == "Ravana" then
        drawRavanaOverview()
    elseif mode == "Helper" then
        drawHelperOverview()
    else
        drawBootstrapOverview()
    end
end

local function drawSettings(mode)
    if mode == "Ravana" then
        drawRavanaSettings()
    elseif mode == "Helper" then
        drawHelperSettings()
    else
        drawBootstrapSettings()
    end
end

local function drawDiagnostics(mode)
    if MGetGameState() ~= FFXIV.GAMESTATE.INGAME then
        ColoredText(0.8, 0.2, 0.2, "Diagnostics are available while in game.")
        return
    end

    if mode == "Bootstrap" then
        if GUI:Button("Create Bug Report##Diagnostics") then
            local zipName = generateBugReportZip()
            GUI:SetClipboardText("Bug report saved to: " .. zipName)
        end
        GUI:SameLine()
        if GUI:Button("Clear Shared State##Diagnostics") then
            clearSharedFolder()
        end
        GUI:Separator()
        drawDebugPanel()
    elseif mode == "Helper" then
        GUI:Text("Role: " .. tostring(MsqClearHelper.Role or "None"))
        GUI:Text("Host State: " .. tostring(MsqClearHelper.HostState or "Idle"))
        GUI:Text("Need to Disband: " .. tostring(MsqClearHelper.NeedToDisband == true))
        GUI:Text("In Dungeon: " .. tostring(MsqClearHelper.InDungeon == true))
        if GUI:Button("Clear Shared State##HelperDiagnostics") then
            clearSharedFolder()
        end
    else
        GUI:Text("State: " .. tostring(RavanaFarm.State or "Unknown"))
        GUI:Text("Waiting: " .. tostring(RavanaFarm.WaitUntil ~= nil and RavanaFarm.WaitUntil > Now()))
        GUI:Text("Unsynced Setting Verified: " .. tostring(RavanaFarm.EnsuredUnsync == true))
    end
end

local function drawModePages(mode)
    if GUI:BeginTabBar("NoobgamSidekickPages") then
        -- Older FFXIVMinion ImGui bindings require the legacy
        -- (label, enabled, flags) signature. Omitting `enabled` causes every
        -- tab item to return false, leaving an empty tab bar.
        if GUI:BeginTabItem("Overview", true, 0) then
            drawOverview(mode)
            GUI:EndTabItem()
        end
        if GUI:BeginTabItem("Settings", true, 0) then
            drawSettings(mode)
            GUI:EndTabItem()
        end
        if GUI:BeginTabItem("Diagnostics", true, 0) then
            drawDiagnostics(mode)
            GUI:EndTabItem()
        end
        GUI:EndTabBar()
    end
end

function GUI_Manager.Draw()
    if not IsGUIVisible() or not GUI_Manager.open then
        return
    end

    GUI:SetNextWindowSize(450, 800, GUI.SetCond_Once)
    GUI_Manager.visible, GUI_Manager.open = GUI:Begin("NoobgamSidekick", GUI_Manager.open)

    if GUI_Manager.visible then
        local checked, enabledPressed = GUI:Checkbox("Enabled", NoobgamConfigManager.Config.enabled)
        GUI:Separator()
        if enabledPressed then
            NoobgamConfigManager.Config.enabled = checked
            NoobgamConfigManager.SaveConfig()
            if not checked then
                -- Disabling the addon stops Latty immediately as well as the
                -- legacy Minion/KDF automation handled by the "none" profile.
                if LattyLib.QuestCore.running or LattyLib.QuestCore.stopping then
                    local ok, stopped, detail = pcall(LattyLib.StopQuesting, "NoobgamSidekick disabled")
                    if not ok then
                        d("[GUI] LattyLib.StopQuesting failed: " .. tostring(stopped))
                    elseif stopped == false then
                        d("[GUI] LattyLib deferred STOP QUESTING: " .. tostring(detail))
                    end
                end
                MsqBootstrap.EnsureProfileEnabled("none")
            end
        end

        drawModePicker()
        drawModePages(NoobgamConfigManager.Config.mode or "Bootstrap")
    end

    GUI:End()
end

return GUI_Manager