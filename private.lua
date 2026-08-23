---@diagnostic disable: duplicate-set-field
NoobgamPrivateAPI = {}

function NoobgamPrivateAPI.SetKDFToNone()
    if KitanoiSettings == nil or kIO == nil then
        return
    end

    if KitanoiSettings.KDFIntegration ~= 1 then
        KitanoiSettings.SingleOrQueue = 1
        KitanoiSettings.KDFIntegration = 1
        kIO.save()
    end
end

function NoobgamPrivateAPI.SetKDFToMsqIntegration()
    if KitanoiSettings == nil or kIO == nil then
        return
    end

    if KitanoiSettings.KDFIntegration ~= 2 then
        if not QuestCompleted(4522) then
            QuestOpts_Q_v1_AllaganPiece = false
        end

        KitanoiSettings.AutoTrusts = true
        KitanoiSettings.AutoStoryDungeons = true
        KitanoiSettings.AdditionalQuests = true
        KitanoiFuncs.MSQindex = nil
        KitanoiFuncs.KDFNMJBLG = true
        KitanoiSettings.SingleOrQueue = 1
        KitanoiSettings.KDFIntegration = 2
        kIO.save()
    end
end

return NoobgamPrivateAPI
