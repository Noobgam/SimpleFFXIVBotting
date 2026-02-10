if GUI_Manager == nil then
    GUI_Manager = {}
    GUI_Manager.open = true
    GUI_Manager.visible = true
    GUI_Manager.Enabled = false
    GUI_Manager.SelectedMode = "Bootstrap"
    GUI_Manager.ShowDebug = true
end

local function ColoredText(r, g, b, text)
    GUI:PushStyleColor(GUI.Col_Text, r, g, b, 1)
    GUI:Text(text)
    GUI:PopStyleColor()
end

local function drawModePicker()
    GUI:Text("Select Mode:")
    GUI:SameLine()

    if GUI:RadioButton("Bootstrap", GUI_Manager.SelectedMode == "Bootstrap") then
        GUI_Manager.SelectedMode = "Bootstrap"
    end

    GUI:SameLine()

    if GUI:RadioButton("Ravana", GUI_Manager.SelectedMode == "Ravana") then
        GUI_Manager.SelectedMode = "Ravana"
    end

    GUI:Separator()
end

local function drawRavanaFarmGUI()
    GUI:Text("Ravana Extreme Farmer")
    GUI:Separator()

    GUI:Separator()
    GUI:Text("State: " .. RavanaFarm.State)

    if GUI:Button("Reset##RavanaFarm") then
        RavanaFarm.Reset()
    end

    GUI:Separator()
    GUI:Text("Gil: " .. tostring(GilCount()))
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
    local levels = {15, 30, 50, 60, 70, 80}
    for _, level in ipairs(levels) do
        local mapping = MsqBootstrap.CONFIG.jobQuestCompletion[level]
        if mapping then
            local questId = mapping[myJob]
            if questId then
                local completed = QuestCompleted(questId)
                local color = completed and {0.2, 0.8, 0.2} or {0.8, 0.2, 0.2}
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
        {id = 1162, name = "Chocobo"},
        {id = 952, name = "Airship Quest (Has)"},
        {id = 953, name = "Airship Quest (Complete)"},
        {id = 715, name = "First Contact"},
        {id = 4522, name = "Can Do Porta"},
        {id = 1619, name = "Heavensward Complete"},
        {id = 3649, name = "Role Quest Unlock"},
        {id = 3650, name = "Role Quest Check"},
    }
    
    for _, quest in ipairs(prereqs) do
        local completed = QuestCompleted(quest.id)
        local hasQuest = HasQuest(quest.id)
        local color = completed and {0.2, 0.8, 0.2} or (hasQuest and {0.8, 0.8, 0.2} or {0.8, 0.2, 0.2})
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
    for questId, steps in pairs(MsqBootstrap.CONFIG.questStepIdToDungeonId) do
        for stepId, dungeonId in pairs(steps) do
            local currentStep = Quest:GetQuestCurrentStep(questId)
            if currentStep == stepId then
                ColoredText(0.8, 0.2, 0.2, "BLOCKED: Quest " .. questId .. " Step " .. stepId .. " -> Dungeon " .. dungeonId)
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
        {20601, 20612, "IL 240 Coffers"},
        {20642, 20670, "IL 90 Coffers"},
        {20275, 20288, "IL 290 Coffers"},
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

local function drawBootstrapUI()
    GUI:Text("MSQ Bootstrap")
    GUI:Separator()

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

    GUI:Text("Quest Rule: " .. (QuestOpts_100_v1_QuestRule or "None"))
    GUI:Text("Quest Sub-Rule: " .. (QuestOpts_100_v1_QuestSubRule or "None"))
    GUI:Text("Aether Currents: " .. (gQuestGatherAetherCurrents and "Yes" or "No"))
    GUI:Text("Buy Greens: " .. (QuestOpts_Q_BuyGreens and "Yes" or "No"))

    GUI:Separator()

    -- Controls Section
    ColoredText(0.8, 0.8, 0.2, "Controls")
    GUI:Separator()

    if GUI:Button("Reset Bootstrap##Bootstrap") then
        MsqBootstrap.Reset()
    end

    GUI:SameLine()

    if GUI:Button("Clear Wait##Bootstrap") then
        MsqBootstrap.WaitUntil = nil
        MsqBootstrap.WaitCondition = nil
        MsqBootstrap.BreakOutDelayMillis = nil
    end

    GUI:Separator()
    GUI:Text("Gil: " .. tostring(GilCount()))
    
    GUI:Separator()
    
    -- Debug Panel
    drawDebugPanel()
end

function GUI_Manager.Draw()
    if not IsGUIVisible() or not GUI_Manager.open then
        return
    end

    GUI:SetNextWindowSize(450, 800, GUI.SetCond_Once)
    GUI_Manager.visible, GUI_Manager.open = GUI:Begin("NoobgamSidekick", GUI_Manager.open)

    if GUI_Manager.visible then
        local checked, enabledPressed = GUI:Checkbox("Enabled", GUI_Manager.Enabled)
        GUI:Separator()
        if enabledPressed then
            GUI_Manager.Enabled = checked
            if not checked then
                MsqBootstrap.EnsureProfileEnabled("none")
            end
        end

        drawModePicker()

        if GUI_Manager.SelectedMode == "Ravana" then
            drawRavanaFarmGUI()
        elseif GUI_Manager.SelectedMode == "Bootstrap" then
            drawBootstrapUI()
        end
    end

    GUI:End()
end

return GUI_Manager