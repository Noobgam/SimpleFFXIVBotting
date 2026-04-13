if RavanaFarm == nil then
    RavanaFarm = {}
end

RavanaFarm.State = "Unknown"
RavanaFarm.WaitUntil = nil
RavanaFarm.WaitCondition = nil
RavanaFarm.BreakOutDelayMillis = nil
RavanaFarm.LastProcessedChatId = nil
RavanaFarm.EnsuredUnsync = false
RavanaFarm.StartedFarming = nil
RavanaFarm.DungeonData = {}
RavanaFarm.StartedClearing = nil
RavanaFarm.StartedCollecting = nil

-- Configuration
-- non limsa config
-- local CONFIG = {
--     targetId = 3660,
--     chestContentIds = { 472 },
--     chestPos = {
--         x = 0,
--         y = 0,
--         z = -4.3,
--     },
--     dutyId = 87,
--     localMapId = 813,
--     vendorContentId = 1027383,
--     menderContentId = 1027384,
--     spamPos = {
--         x = -781,
--         y = 53,
--         z = -224
--     }
-- }

local CONFIG = {
    targetId = 3660,
    chestContentIds = { 472 },
    chestPos = {
        x = 0,
        y = 0,
        z = -4.3,
    },
    dutyId = 87,
    localMapId = 129,
    vendorContentId = 1001207,
    menderContentId = 1001206,
    spamPos = {
        x = -252.8,
        y = 16,
        z = 52
    }
}

local function log(message)
    d("[RavanaFarm] " .. message)
end

local function calculateDist(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function wait(millis, breakOutCondition, breakOutDelayMillis)
    local suggested = Now() + millis

    if breakOutCondition then
        if RavanaFarm.WaitCondition == nil or RavanaFarm.WaitUntil < suggested then
            RavanaFarm.WaitCondition = breakOutCondition
            RavanaFarm.WaitUntil = suggested
            RavanaFarm.BreakOutDelayMillis = breakOutDelayMillis
        end
    else
        if RavanaFarm.WaitUntil == nil or RavanaFarm.WaitUntil < suggested then
            RavanaFarm.WaitCondition = nil
            RavanaFarm.WaitUntil = suggested
        end
    end
end

local function itemIsHive(item)
    local name = string.lower(item.name)
    return name ~= "hive totem" and name ~= "hive forewing" and string.find(name, "hive", 1, true) ~= nil
end

local function itemIsCoffer(item)
    local name = string.lower(item.name)
    return string.find(name, "coffer", 1, true) ~= nil or
        (string.find(name, "paladin", 1, true) ~= nil and string.find(name, "arms", 1, true) ~= nil)
end

local function ensureUnsync()
    if not IsControlOpen("ContentsFinderSetting") then
        RavanaFarm.NeedToConfirmSettingsChange = false
    end

    if IsControlOpen("ContentsFinderSetting") then
        local data = GetControlData("ContentsFinderSetting", "UnderSizedParty")
        if tostring(data) ~= "true" then
            if UseControlAction("ContentsFinderSetting", "UnderSizedParty", 1) then
                RavanaFarm.NeedToConfirmSettingsChange = true
            end
            return false
        end

        if RavanaFarm.NeedToConfirmSettingsChange then
            UseControlAction("ContentsFinderSetting", "Confirm")
            wait(500)
            return false
        end

        RavanaFarm.EnsuredUnsync = true
        return true
    elseif not IsControlOpen("ContentsFinder") then
        ActionList:Get(10, 33):Cast()
        wait(500)
        return false
    elseif IsControlOpen("ContentsFinder") then
        UseControlAction("ContentsFinder", "Settings")
        return false
    end
end

local function processSalesFromChat()
    local salesCount = 0
    local totalGil = 0
    local pattern = "^You sell.-(%d+,?%d*) gil"
    local clog = GetChatLines()
    local lpci = RavanaFarm.LastProcessedChatId

    if table.valid(clog) then
        for i, k in pairs(clog) do
            if i > RavanaFarm.LastProcessedChatId then
                local line = k.line
                local amount = line:match(pattern)

                if amount then
                    amount = amount:gsub(",", "")
                    amount = tonumber(amount)
                    salesCount = salesCount + 1
                    totalGil = totalGil + amount
                end

                lpci = math.max(lpci, i)
            end
        end
    end

    RavanaFarm.LastProcessedChatId = lpci

    if salesCount > 0 then
        log("Sold " .. salesCount .. " items for " .. totalGil .. " gil")
    end

    return salesCount, totalGil
end

local function needRepair()
    local bag = Inventory:Get(1000)
    if table.valid(bag) then
        local ilist = bag:GetList()
        for slot, item in pairs(ilist) do
            if item.condition < 3 then
                return true
            end
        end
    end
    return false
end

function RavanaFarm.Reset()
    RavanaFarm.State = "EnteringDungeon"
    RavanaFarm.LastProcessedChatId = nil
    RavanaFarm.EnsuredUnsync = false
    RavanaFarm.StartedFarming = nil
    RavanaFarm.DungeonData = {}
    RavanaFarm.StartedClearing = nil
    RavanaFarm.StartedCollecting = nil
    log("Reset complete")
end

function RavanaFarm.Update()
    -- Handle wait conditions
    if RavanaFarm.WaitUntil ~= nil and RavanaFarm.WaitUntil > Now() then
        if RavanaFarm.WaitCondition and RavanaFarm.WaitCondition() then
            log("Breaking out of wait loop")
            RavanaFarm.WaitUntil = Now() + (RavanaFarm.BreakOutDelayMillis or 0)
            RavanaFarm.BreakOutDelayMillis = nil
            RavanaFarm.WaitCondition = nil
            return
        else
            return
        end
    end

    local info = Duty:GetActiveDutyInfo()
    local in_dungeon = table.valid(info) or Player.localmapid == 446

    -- Initialize last processed chat
    if RavanaFarm.LastProcessedChatId == nil then
        local clog = GetChatLines()
        if table.valid(clog) then
            for i, k in pairs(clog) do
                RavanaFarm.LastProcessedChatId = math.max(i, RavanaFarm.LastProcessedChatId or 0)
            end
        end
        return
    end

    local dd = RavanaFarm.DungeonData

    -- State: Unknown - determine initial state
    if RavanaFarm.State == "Unknown" then
        if in_dungeon then
            RavanaFarm.State = "ExitingDungeon"
            return
        else
            local items = {}
            for bid = 0, 3 do
                for k, v in pairs(Inventory:Get(bid):GetList()) do
                    if itemIsHive(v) then
                        table.insert(items, v)
                    end
                end
            end

            if #items > 0 then
                log("Detected unsold items, proceeding to sell")
                RavanaFarm.State = "Selling"
                dd.sold = 2
            else
                log("No items to sell, proceeding to enter dungeon")
                RavanaFarm.State = "EnteringDungeon"
            end
        end
    end

    -- State: EnteringDungeon
    if RavanaFarm.State == "EnteringDungeon" then
        if in_dungeon then
            RavanaFarm.State = "ClearingDungeon"
            RavanaFarm.StartedClearing = GetTickCount()
            RavanaFarm.StartedCollecting = nil
            return
        end

        if not in_dungeon then
            if Player.localmapid ~= 0 and (Player.localmapid ~= CONFIG.localMapId or calculateDist(Player.pos, CONFIG.spamPos) > 1) then
                log("Not at spawn location, moving there")
                if ml_task_hub:CurrentTask() ~= nil and ml_task_hub.shouldRun then
                    wait(10000)
                    return
                end
                NavigationTask.MoveTo({
                    mapId = CONFIG.localMapId,
                    pos = CONFIG.spamPos,
                })
                wait(10000)
                return
            end
        end

        if not RavanaFarm.EnsuredUnsync then
            ensureUnsync()
            return
        end

        if needRepair() then
            log("Need repair")
            local menders = EntityList("targetable,contentid=" .. CONFIG.menderContentId)
            --- @type Entity
            local mender = nil
            for _, v in pairs(menders) do
                mender = v
                break
            end
            if mender then
                if IsControlOpen("SelectYesno") then
                    log("Agreeing to repair")
                    UseControlAction("SelectYesno", "Yes")
                    wait(1000)
                    return
                end
                if not IsControlOpen("Repair") then
                    log("Interacting with mender to open")
                    Player:Interact(mender.id)
                    wait(1000)
                else
                    log("Using repair")
                    local repair = GetControlByName("Repair")
                    repair:DoAction(0)
                    wait(1000)
                end
            else
                log("Mender doesn't exist")
            end
            return
        end

        processSalesFromChat()

        if Duty:GetQueueStatus() ~= 3 then
            Duty:JoinDuty(2, CONFIG.dutyId)
            wait(500, function()
                return IsControlOpen("ContentsFinderConfirm")
            end)
            return
        else
            UseControlAction("ContentsFinderConfirm", "Confirm")
            wait(500)
            RavanaFarm.DungeonData = {}
            return
        end
    end

    if FFXIV_Common_BotRunning then
        return
    end

    -- State: ClearingDungeon
    if RavanaFarm.State == "ClearingDungeon" then
        if RavanaFarm.StartedClearing < GetTickCount() - 40000 then
            log("Timeout on killing boss, exiting")
            RavanaFarm.State = "ExitingDungeon"
            return
        end

        local target = Player:GetTarget()
        if target == nil or target.contentId ~= CONFIG.targetId or not target.alive then
            local entities = EntityList("contentid=" .. CONFIG.targetId .. ",alive,aggressive")
            target = nil
            for _, entity in pairs(entities) do
                target = entity
                break
            end

            if target == nil then
                if dd.TargetFound then
                    log("Target disappeared, assuming kill")
                    RavanaFarm.State = "CollectingLoot"
                    RavanaFarm.StartedCollecting = GetTickCount()
                    return
                end
                log("Target not found")
                return
            end

            if not dd.TargetFound then
                log("Found target, starting fight")
                dd.TargetFound = true
            end

            Player:SetTarget(target.id)
            return
        end

        -- Move to chest position and enable bot
        local p = CONFIG.chestPos
        Player:MoveTo(p.x, p.y, p.z, 1)
        SkillMgr.Cast()
        wait(100)
    end

    -- State: CollectingLoot
    if RavanaFarm.State == "CollectingLoot" then
        if RavanaFarm.StartedCollecting < GetTickCount() - 5000 then
            log("Timeout on item collection, exiting")
            RavanaFarm.State = "ExitingDungeon"
            return
        end

        local p = CONFIG.chestPos
        Player:MoveTo(p.x, p.y, p.z, 1)

        if calculateDist(Player.pos, p) > 1 then
            wait(200)
            return
        end

        Player:Stop()

        local collected = dd.collectedChests or 0
        local itemsLastFrame = dd.itemsLastFrame
        local items = {}

        for bid = 0, 3 do
            for k, v in pairs(Inventory:Get(bid):GetList()) do
                table.insert(items, v)
            end
        end

        if itemsLastFrame ~= nil and #items > itemsLastFrame then
            dd.collectedChests = collected + 1
            log("Items increased, moving to next chest")
        end

        dd.itemsLastFrame = #items

        if collected < #CONFIG.chestContentIds then
            local chestContentId = CONFIG.chestContentIds[collected + 1]
            local chests = EntityList("contentid=" .. chestContentId)
            local chest = nil
            for _, v in pairs(chests) do
                chest = v
                break
            end

            if chest then
                log("Interacting with chest")
                Player:Interact(chest.id)
            end
            return
        end

        log("No chests left, exiting dungeon")
        RavanaFarm.State = "ExitingDungeon"
        return
    end

    -- State: ExitingDungeon
    if RavanaFarm.State == "ExitingDungeon" then
        Player:Stop()

        if not in_dungeon then
            log("Transitioned to selling")
            RavanaFarm.State = "Selling"
            dd.sold = 0
            return
        end

        if not IsControlOpen("ContentsFinderMenu") then
            log("Opening duty finder")
            ActionList:Get(10, 33):Cast()
            wait(300, function()
                return IsControlOpen("ContentsFinderMenu")
            end)
        else
            if not IsControlOpen("SelectYesno") then
                UseControlAction("ContentsFinderMenu", "Leave")
                wait(300, function()
                    return IsControlOpen("SelectYesno")
                end)
            else
                UseControlAction("SelectYesno", "Yes")
                wait(400)
            end
        end
    end

    -- State: Selling
    if RavanaFarm.State == "Selling" then
        if in_dungeon then
            log("In dungeon during sell state, resetting")
            RavanaFarm.Reset()
            RavanaFarm.State = "ClearingDungeon"
            RavanaFarm.StartedClearing = GetTickCount()
            return
        end

        if Player.localmapid ~= 0 and (Player.localmapid ~= CONFIG.localMapId or calculateDist(Player.pos, CONFIG.spamPos) > 1) then
            log("Not at spawn location, moving there")
            if ml_task_hub:CurrentTask() ~= nil and ml_task_hub.shouldRun then
                wait(10000)
                return
            end
            NavigationTask.MoveTo({
                mapId = CONFIG.localMapId,
                pos = CONFIG.spamPos,
            })
            wait(10000)
            return
        end

        if Player.localmapid ~= CONFIG.localMapId then
            return
        end

        local items = {}
        local allItems = {}

        for bid = 0, 3 do
            for k, v in pairs(Inventory:Get(bid):GetList()) do
                table.insert(allItems, v)
                if itemIsHive(v) then
                    table.insert(items, v)
                end
            end
        end

        local itemsLastFrame = dd.itemsLastFrame

        if IsControlOpen("Shop") and itemsLastFrame ~= nil and #allItems < itemsLastFrame then
            dd.sold = (dd.sold or 0) + 1
            log("Item sold")
        end

        dd.itemsLastFrame = #allItems

        local hiveWeapons = {
            ["Hive Shamshir"] = FFXIV.JOBS.PALADIN,
            ["Hive Scutum"] = FFXIV.JOBS.PALADIN,
            ["Hive Battleaxe"] = FFXIV.JOBS.WARRIOR,
            ["Hive Claymore"] = FFXIV.JOBS.DARKKNIGHT,
            ["Hive Spear"] = FFXIV.JOBS.DRAGOON,
            ["Hive Claws"] = FFXIV.JOBS.MONK,
            ["Hive Katana"] = FFXIV.JOBS.SAMURAI,
            ["Hive Kris"] = FFXIV.JOBS.NINJA,
            ["Hive Bow"] = FFXIV.JOBS.BARD,
            ["Hive Musketoon"] = FFXIV.JOBS.MACHINIST,
            ["Hive Longpole"] = FFXIV.JOBS.BLACKMAGE,
            ["Hive Grimoire"] = FFXIV.JOBS.SUMMONER,
            ["Hive Rapier"] = FFXIV.JOBS.REDMAGE,
            ["Hive Cane"] = FFXIV.JOBS.WHITEMAGE,
            ["Hive Codex"] = FFXIV.JOBS.SCHOLAR,
            ["Hive Planisphere"] = FFXIV.JOBS.ASTROLOGIAN
        }

        local haveJobs = {}
        for _, el in pairs(items) do
            local job = hiveWeapons[el.name]
            if job ~= nil then
                haveJobs[job] = true
            end
        end

        if ActionList:IsCasting() then
            if dd.waitForNewHiveItem == nil then
                dd.waitForNewHiveItem = true
                log("Opening chest")
            end
            return
        end

        if dd.waitForNewHiveItem then
            if dd.startedWaitingForItems == nil then
                dd.startedWaitingForItems = GetTickCount()
            else
                if dd.startedWaitingForItems < GetTickCount() - 2000 then
                    log("Cast interrupted, no longer waiting")
                    dd.waitForNewHiveItem = nil
                    dd.startedWaitingForItems = nil
                end
            end

            local nonCoffers = {}
            for _, item in pairs(items) do
                if not itemIsCoffer(item) then
                    table.insert(nonCoffers, item)
                end
            end

            if #nonCoffers > #(dd.hiveItemsSnap or {}) then
                log("Received item from chest")
                dd.waitForNewHiveItem = nil
            end
            return
        end

        local shop = GetControlByName("Shop")

        -- Open coffers if we can't sell them
        if haveJobs[Player.job] == nil then
            for _, el in pairs(items) do
                if itemIsCoffer(el) and string.find(string.lower(el.name), "paladin", 1, true) and string.find(string.lower(el.name), "arms", 1, true) then
                    if shop and shop:IsOpen() then
                        shop:Close()
                        wait(50)
                        return
                    end
                    log("Opening paladin coffer")
                    el:Cast()
                    return
                end
            end

            for _, el in pairs(items) do
                if itemIsCoffer(el) then
                    if shop and shop:IsOpen() then
                        shop:Close()
                        wait(50)
                        return
                    end
                    if Player.mountid ~= 0 then
                        log("Dismounting before the coffer open")
                        Dismount()
                        wait(50)
                        return
                    end
                    log("Opening coffer: " .. el.name)
                    el:Cast()
                    wait(100)
                    return
                end
            end
        end

        -- Sell items
        if #items > 0 then
            local vendors = EntityList("contentid=" .. CONFIG.vendorContentId)
            --- @type Entity
            local vendor = nil
            for _, v in pairs(vendors) do
                vendor = v
                break
            end

            if not vendor then
                log("No vendor found")
                wait(100)
                return
            end

            if ActionList:IsCasting() then
                return
            end

            if IsControlOpen("SelectIconString") then
                UseControlAction("SelectIconString", "SelectIndex", 1)
                return
            end

            if not shop or not shop:IsOpen() then
                Player:Interact(vendor.id)
                log("Opening shop")
                wait(200)
                return
            else
                for _, el in pairs(items) do
                    if not itemIsCoffer(el) then
                        log("Selling: " .. el.name)
                        el:Sell()
                        wait(50)
                        return
                    end
                end

                log("No items to sell, closing shop")
                shop:Close()
                wait(50)
                return
            end
        end

        if shop and shop:IsOpen() then
            log("Closing shop")
            shop:Close()
            wait(50)
            return
        end

        log("No items left, entering dungeon")
        RavanaFarm.State = "EnteringDungeon"
    end
end

return RavanaFarm