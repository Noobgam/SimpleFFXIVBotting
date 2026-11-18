---@meta
---@diagnostic disable: lowercase-global

---@class ClassQuestingAPI
---@field profilesDisplay string[]
---@field AddProfile fun(profile: table, alias?: string)

---@class ClassQuestFFXIVLib
---@field Questing ClassQuestingAPI
---@type ClassQuestFFXIVLib
FFXIVLib = FFXIVLib

---@param itemId integer
---@return boolean
function IsEquipped(itemId) end
