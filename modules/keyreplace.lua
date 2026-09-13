local M = {}

-- 规则表：每条规则定义 { keyCode, 修饰键检查, 输出字符 }
local rules = {
    {
        name = "· -> `",
        keyCode = 50,
        match = function(flags) return not (flags.alt or flags.shift or flags.cmd or flags.ctrl) end,
        output = "`",
    },
    {
        name = "… -> :",
        keyCode = 41,  -- 改成你实际的 keyCode
        match = function(flags) return flags.alt end,
        output = ":",
    },
}

-- 事件处理函数
local function handler(event)
    local keyCode = event:getKeyCode()
    local flags = event:getFlags()

    for _, rule in ipairs(rules) do
        if keyCode == rule.keyCode and rule.match(flags) then
            hs.eventtap.keyStrokes(rule.output)
            return true
        end
    end
    return false
end

-- 启动监听
function M.start()
    if M.watcher then M.watcher:stop() end
    M.watcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, handler)
    M.watcher:start()
    hs.alert.show("按键替换规则已加载")
end

function M.stop()
    if M.watcher then
        M.watcher:stop()
        M.watcher = nil
    end
end

return M
