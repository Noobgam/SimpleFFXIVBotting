if GUI_Manager == nil then
    GUI_Manager = {}
    GUI_Manager.open = true
    GUI_Manager.visible = true
    GUI_Manager.Enabled = false
    GUI_Manager.SelectedMode = "Bootstrap"
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

local function drawBootstrapUI()
    GUI:Text("MSQ Bootstrap")
    GUI:Separator()

    if MGetGameState() ~= FFXIV.GAMESTATE.INGAME then
        ColoredText(0.8, 0.1, 0.2, "Not in game")
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
end

function GUI_Manager.Draw()
    if not IsGUIVisible() or not GUI_Manager.open then
        return
    end

    GUI:SetNextWindowSize(450, 600, GUI.SetCond_Once)
    GUI_Manager.visible, GUI_Manager.open = GUI:Begin("NoobgamSidekick", GUI_Manager.open)


    if GUI_Manager.visible then
        local checked, enabledPressed = GUI:Checkbox("Enabled", GUI_Manager.Enabled)
        GUI:Separator()
        if enabledPressed then
            GUI_Manager.Enabled = checked
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
