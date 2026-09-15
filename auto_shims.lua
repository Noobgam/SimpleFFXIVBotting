AutoShims = AutoShims or {}

function AutoShims.InstallMemoizedHelpers()
    if AutoShims.MemoizedHelpers ~= nil then
        return
    end
    if not ml_global_information or not ml_global_information.preparers
        or type(MGetGameState) ~= "function" then
        return
    end

    local resets = {}
    local NIL = {} -- distinct from false, and usable as a nil argument key
    local helpers = {}
    local originals = {}

    local function cachedValue(fn)
        local value, cached
        resets[#resets + 1] = function() value, cached = nil, false end
        return function()
            if not cached then
                value = fn()
                cached = true
            end
            return value
        end
    end

    local function cachedOne(fn)
        local values = {}
        resets[#resets + 1] = function()
            if next(values) ~= nil then values = {} end
        end
        return function(a)
            if a ~= a then return fn(a) end -- NaN cannot be a table key
            local key = a
            if key == nil then key = NIL end
            local value = values[key]
            if value == nil then
                value = fn(a)
                if value == nil then values[key] = NIL else values[key] = value end
            elseif value == NIL then
                return nil
            end
            return value
        end
    end

    local function cachedTwo(fn)
        local values = {}
        resets[#resets + 1] = function()
            if next(values) ~= nil then values = {} end
        end
        return function(a, b)
            if a ~= a or b ~= b then return fn(a, b) end
            local ka, kb = a, b
            if ka == nil then ka = NIL end
            if kb == nil then kb = NIL end
            local row = values[ka]
            if row == nil then row = {}; values[ka] = row end
            local value = row[kb]
            if value == nil then
                value = fn(a, b)
                if value == nil then row[kb] = NIL else row[kb] = value end
            elseif value == NIL then
                return nil
            end
            return value
        end
    end

    local function cachedThree(fn)
        local values = {}
        resets[#resets + 1] = function()
            if next(values) ~= nil then values = {} end
        end
        return function(a, b, c)
            if a ~= a or b ~= b or c ~= c then return fn(a, b, c) end
            local ka, kb, kc = a, b, c
            if ka == nil then ka = NIL end
            if kb == nil then kb = NIL end
            if kc == nil then kc = NIL end
            local row = values[ka]
            if row == nil then row = {}; values[ka] = row end
            local leaf = row[kb]
            if leaf == nil then leaf = {}; row[kb] = leaf end
            local value = leaf[kc]
            if value == nil then
                value = fn(a, b, c)
                if value == nil then leaf[kc] = NIL else leaf[kc] = value end
            elseif value == NIL then
                return nil
            end
            return value
        end
    end

    helpers.MUsingAutoFace = cachedValue(UsingAutoFace)
    helpers.MPlayerDriving = cachedValue(PlayerDriving)
    helpers.MGetGameState = cachedValue(GetGameState)
    helpers.MGetEorzeaTime = cachedValue(GetEorzeaTime)
    helpers.MIsMoving = cachedValue(function() return Player:IsMoving() end)
    helpers.MIsLoading = cachedValue(IsLoading)
    helpers.MIsLocked = cachedValue(IsPositionLocked)
    helpers.MGetTarget = cachedValue(function() return Player:GetTarget() end)
    helpers.MGetParty = cachedValue(GetParty)
    helpers.MGatherableSlotList = cachedValue(function() return Player:GetGatherableSlotList() end)
    helpers.MGetDirectorIndex = cachedValue(function()
        if not table.isa(Duty:GetActiveDutyInfo()) then return 0 end
        local director = Director:GetActiveDirector()
        if not table.isa(director) then return 0 end
        return IsNull(director.textindex, 0)
    end)

    local casting, fullCasting, castingCached, fullCastingCached
    resets[#resets + 1] = function()
        casting, fullCasting, castingCached, fullCastingCached = nil, nil, false, false
    end
    helpers.MIsCasting = function(fullcheck)
        if fullcheck == nil or fullcheck == false then
            if not castingCached then
                casting = ActionList:IsCasting()
                castingCached = true
            end
            return casting
        end
        if fullcheck == true then
            if not fullCastingCached then
                fullCasting = ActionList:IsCasting()
                fullCastingCached = true
            end
            return fullCasting
        end
        -- The original does not pass fullcheck to the native API either.
        return ActionList:IsCasting()
    end

    local entity = cachedOne(function(id) return EntityList:Get(id) end)
    helpers.MGetEntity = function(id) return entity(tonumber(id) or 0) end
    local entities = cachedOne(function(filter)
        local list = EntityList(filter)
        if table.valid(list) then return list end
        return nil -- preserve the public empty-search result
    end)
    helpers.MEntityList = function(filter) return entities(filter or "") end
    -- Preserve the original argument signature and single item return; it does
    -- not forward includehq/requirehq to GetItem.
    helpers.MGetItem = cachedThree(function(hqid, includehq, requirehq) return (GetItem(hqid)) end)
    helpers.MPartyMemberWithBuff = cachedThree(PartyMemberWithBuff)
    helpers.MPartySMemberWithBuff = cachedThree(PartySMemberWithBuff)
    helpers.MGetBestTankHealTarget = cachedOne(GetBestTankHealTarget)
    helpers.MGetBestPartyHealTarget = cachedTwo(GetBestPartyHealTarget)
    helpers.MGetBestHealTarget = cachedThree(GetBestHealTarget)

    local controls, controlsTick
    resets[#resets + 1] = function() controls, controlsTick = nil, nil end
    helpers.MGetControls = function()
        if GetControls2 then return GetControls2() end
        local now = Now()
        if type(controls) ~= "table" or controlsTick ~= now then
            controls = GetControls()
            controlsTick = now
            if table.valid(controls) then
                for _, control in pairs(controls) do controls[control.name] = control end
            end
        end
        return controls
    end

    -- Minion invokes preparers immediately after replacing memoize. No per-call
    -- frame/timer checks, and no cached Lua entity/target results cross that reset.
    ml_global_information.preparers.AutoShimsMemoized = function()
        for i = 1, #resets do resets[i]() end
    end
    for name, fn in pairs(helpers) do
        originals[name] = _G[name]
        _G[name] = fn
    end
    AutoShims.MemoizedOriginals = originals
    AutoShims.MemoizedHelpers = helpers
end

-- All addon files must be loaded before overriding Minion's helper definitions.
RegisterEventHandler("Module.Initalize", AutoShims.InstallMemoizedHelpers, "AutoShims.MemoizedHelpers")
