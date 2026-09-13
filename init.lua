-- 暴力替换：将 · 替换为 `
local replaceFullwidthBacktick = function(event)
    -- 获取按键的 keyCode
    local keyCode = event:getKeyCode()
    -- 获取当前修饰键状态
    local flags = event:getFlags()

    -- 1. 判断是否是“·”键 (keyCode 50)，并且没有按任何修饰键
    -- 这样可以避免影响 Option+· 等组合键
    if keyCode == 50 and not (flags.alt or flags.shift or flags.cmd or flags.ctrl) then
        -- 2. 发送半角反引号字符
        -- 注意：hs.eventtap.keyStrokes 会模拟输入，绕过输入法的全角转换
        hs.eventtap.keyStrokes("`")
        -- 3. 返回 true，拦截原始的“·”事件
        return true
    end

    -- 其他情况不处理
    return false
end

-- 创建并启动事件监听器
local backtickWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, replaceFullwidthBacktick)
backtickWatcher:start()

-- 可选：在启动时显示提示
hs.alert.show("Backtick 替换脚本已加载")
