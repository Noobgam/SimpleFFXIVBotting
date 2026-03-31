function closeIfOpen(controlName)
    local ctrl = GetControlByName(controlName)
    if ctrl and ctrl:IsOpen() then
        ctrl:Close()
        return true
    end
    return false
end

local function closeUselessControls()
    -- this shit is completely irrelevant everywhere. It breaks PressKeys flow for some cases.
    if IsControlOpen("SelectString") then
        local ss = GetControlStrings("SelectString", 2)
        if ss ~= nil and string.find(ss, "Select a control", 1, true) then
            UseControlAction("SelectString", "SelectIndex", 0)
            return
        end
    end
    if closeIfOpen("JobHudNotice") then
        return
    end
    if IsControlOpen("ContentsTutorial") then
        GetControlByName("ContentsTutorial"):PushButton(25,2)
        GetControlByName("ContentsTutorial"):PushButton(25,3)
    end
    if closeIfOpen("EventTutorial") then
        return
    end
    if closeIfOpen("HowToNotice") then
        return
    end
    if closeIfOpen("BeginnersMansionTutorial") then
        return
    end
    if closeIfOpen("BeginnersMansionProblem") then
        return
    end
    if closeIfOpen("AchievementInfo") then
        return
    end
    if closeIfOpen("RecommendList") then
        return
    end
    if closeIfOpen("SupportDeskView") then
        return
    end
    if closeIfOpen("SupportDesk") then
        return
    end
    if closeIfOpen("WebGuidance") then
        return
    end

    if IsControlOpen("PlayGuide") then
        GetControlByName("PlayGuide"):DoAction(1)
        return
    end
    if IsControlOpen("ReturnerDialog") then
        GetControlByName("ReturnerDialog"):DoAction(3)
        return
    end
    if IsControlOpen("BeginnerChatInviteDialog") then
        GetControlByName("BeginnerChatInviteDialog"):DoAction(3)
        return
    end
end

local function onUpdate()
    if MGetGameState() ~= FFXIV.GAMESTATE.INGAME then
        if NoobgamConfigManager.Status == FFXIV.GAMESTATE.INGAME then
            d("[NoobgamSideKick]: No longer logged in. Resetting everything")
            MsqBootstrap.Reset()
            RavanaFarm.Reset()
            MsqClearHelper.Reset()
        end
        NoobgamConfigManager.Status = MGetGameState()
        return
    end
    NoobgamConfigManager.Status = FFXIV.GAMESTATE.INGAME
    if not NoobgamConfigManager.Config.enabled then
        return
    end

    closeUselessControls()
    local mapping = {
        ["Ravana"] = RavanaFarm.Update,
        ["Bootstrap"] = MsqBootstrap.Update,
        ["Helper"] = MsqClearHelper.HostUpdate,
    }
    local func = mapping[NoobgamConfigManager.Config.mode]
    if func == nil then
        error("No such mode")
    end
    return func()
end

local function onDraw()
    GUI_Manager.Draw()
end

local function preinit()
    NoobgamConfigManager.ReadConfig()
    local folder = GetLuaModsPath() .. "\\SimpleFFXIVBotting\\logs"
    if not FolderExists(folder) then
        FolderCreate(folder)
    end
    local path_to_log = folder .. "\\" .. NoobgamUtils.GetMinionAppUUIDHex() .. ".log"
    NoobgamUtils.shim_d(path_to_log)
end

RegisterEventHandler([[Module.Initalize]], preinit, [[NoobgamSidekick.Preinit]])
RegisterEventHandler("Gameloop.Update", onUpdate, "NoobgamSidekick.Update")
RegisterEventHandler("Gameloop.Draw", onDraw, "NoobgamSidekick.Draw")