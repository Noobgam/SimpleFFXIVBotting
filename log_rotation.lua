-- One file per local calendar day; keep the newest three files per UUID.
if NoobgamLog == nil then NoobgamLog = {} end
local Log = NoobgamLog
local state
local KEEP_FILES, CLEANUP_INTERVAL = 3, 300

local function cleanup()
    local byUUID = {}
    for _, filename in pairs(FolderList(state.folder, [[(.*)log$]]) or {}) do
        local uuid, date = filename:match("^(%x+)%.(%d%d%d%d%-%d%d%-%d%d)%.log$")
        if uuid and #uuid == 32 then
            uuid = uuid:lower()
            byUUID[uuid] = byUUID[uuid] or {}
            table.insert(byUUID[uuid], { name = filename, date = date })
        end
    end
    for _, files in pairs(byUUID) do
        table.sort(files, function(a, b) return a.date > b.date end)
        for i = KEEP_FILES + 1, #files do
            FileDelete(state.folder .. files[i].name)
        end
    end
end

function Log.Start(logPath)
    local folder, uuid = logPath:match("^(.*[/\\])(%x+)%.log$")
    assert(folder and #uuid == 32, "Expected a UUID log path")
    state = { folder = folder, prefix = folder .. uuid, nextCleanup = 0 }
end

function Log.Path(timestamp)
    assert(state, "Log rotation has not been initialized")
    local date = os.date("%Y-%m-%d", timestamp)
    if state.date ~= date then
        state.date = date
        state.nextCleanup = 0 -- Prune after the first write to a new daily file.
    end
    return state.prefix .. "." .. date .. ".log"
end

function Log.Update()
    if not state then return end
    local now = os.time()
    if now < state.nextCleanup then return end
    state.nextCleanup = now + CLEANUP_INTERVAL
    local ok, err = pcall(cleanup)
    if not ok then
        -- Never recurse through the file-writing shim for a filesystem error.
        (original_d or d)("[NoobgamLog] " .. tostring(err))
    end
end
