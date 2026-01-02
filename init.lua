    -- 放暗非焦点窗口
    -- https://github.com/selimacerbas/FocusMode.spoon
-- hs.loadSpoon("SpoonInstall")
--spoon.SpoonInstall:andUse("FocusMode", { start = true })

    -- 在菜单栏上显示虚拟桌面
--    ActiveSpace = hs.loadSpoon("ActiveSpace")
--    ActiveSpace:start()

    -- 显示器上下排列伪装  https://github.com/mogenson/WarpMouse.spoon/tree/main
WarpMouse = hs.loadSpoon("WarpMouse")
WarpMouse.margin = 8  -- optionally set how far past a screen edge the mouse should warp, default is 2 pixels
WarpMouse:start()


    -- PaperWM主程序
    -- https://github.com/mogenson/PaperWM.spoon?tab=readme-ov-file
    
PaperWM = hs.loadSpoon("PaperWM")
-- 修改预设的窗口比例
PaperWM.window_ratios = { 0.3, 0.5, 0.8, 1 }
-- 按住Hyper拖鼠标整个卷轴运动功能，没有鸟用。
-- PaperWM.drag_window = { "cmd", "ctrl", "alt" }
PaperWM:bindHotkeys({
    -- 上下左右聚焦窗口 switch to a new focused window in tiled grid
--    focus_left  = {{"alt", "cmd"}, "left"},
--    focus_right = {{"alt", "cmd"}, "right"},
--    focus_up    = {{"alt", "cmd"}, "up"},
--    focus_down  = {{"alt", "cmd"}, "down"},

    -- 旋转聚焦窗口，头尾相连 switch windows by cycling forward/backward
    -- (forward = down or right, backward = up or left)
    
focus_prev = {{"cmd", "ctrl", "alt"}, "j"},
focus_next = {{"cmd", "ctrl", "alt"}, "l"},

    -- 将当前窗口在队列中进行移动 move windows around in tiled grid
    
    swap_left  = {{"cmd", "ctrl", "alt"}, "left"},
    swap_right = {{"cmd", "ctrl", "alt"}, "right"},

--    swap_up    = {{"alt", "cmd", "shift"}, "up"},
--    swap_down  = {{"alt", "cmd", "shift"}, "down"},

    -- 调整当前窗口的大小 position and resize focused window
  center_window        = {{"cmd", "ctrl", "alt"}, "i"},
--  full_width           = {{"cmd", "ctrl", "alt"}, "i"},
  cycle_width          = {{"cmd", "ctrl", "alt"}, "k"},
--    reverse_cycle_width  = {{"ctrl", "alt", "cmd"}, "r"},
--    cycle_height         = {{"alt", "cmd", "shift"}, "r"},
--    reverse_cycle_height = {{"ctrl", "alt", "cmd", "shift"}, "r"},

    -- 与KDE一样。直接增加，减少当前窗口大小increase/decrease width
increase_width = {{"cmd", "ctrl", "alt"}, "]"},
decrease_width = {{"cmd", "ctrl", "alt"}, "["},

    -- Mac独有。纵向进入或退出队列 move focused window into / out of a column
--    slurp_in = {{"cmd", "ctrl", "alt"}, "down"},
--    barf_out = {{"cmd", "ctrl", "alt"}, "up"},

    -- 与KDE一样。当前窗口是否成为浮动窗口 move the focused window into / out of the tiling layer
    toggle_floating = {{"cmd", "ctrl", "alt"}, "space"},

    -- focus the first / second / etc window in the current space
--    focus_window_1 = {{"cmd", "shift"}, "1"},
--    focus_window_2 = {{"cmd", "shift"}, "2"},
--    focus_window_3 = {{"cmd", "shift"}, "3"},
--    focus_window_4 = {{"cmd", "shift"}, "4"},
--    focus_window_5 = {{"cmd", "shift"}, "5"},
--    focus_window_6 = {{"cmd", "shift"}, "6"},
--    focus_window_7 = {{"cmd", "shift"}, "7"},
--    focus_window_8 = {{"cmd", "shift"}, "8"},
--    focus_window_9 = {{"cmd", "shift"}, "9"},

    -- switch to a new Mission Control space
--    switch_space_l = {{"alt", "cmd"}, ","},
--    switch_space_r = {{"alt", "cmd"}, "."},
--    switch_space_1 = {{"alt", "cmd"}, "1"},
--    switch_space_2 = {{"alt", "cmd"}, "2"},
--    switch_space_3 = {{"alt", "cmd"}, "3"},
--    switch_space_4 = {{"alt", "cmd"}, "4"},
--    switch_space_5 = {{"alt", "cmd"}, "5"},
--    switch_space_6 = {{"alt", "cmd"}, "6"},
--    switch_space_7 = {{"alt", "cmd"}, "7"},
--    switch_space_8 = {{"alt", "cmd"}, "8"},
--    switch_space_9 = {{"alt", "cmd"}, "9"},

    -- move focused window to a new space and tile
--    move_window_1 = {{"alt", "cmd", "shift"}, "1"},
--    move_window_2 = {{"alt", "cmd", "shift"}, "2"},
--    move_window_3 = {{"alt", "cmd", "shift"}, "3"},
--    move_window_4 = {{"alt", "cmd", "shift"}, "4"},
--    move_window_5 = {{"alt", "cmd", "shift"}, "5"},
--    move_window_6 = {{"alt", "cmd", "shift"}, "6"},
--    move_window_7 = {{"alt", "cmd", "shift"}, "7"},
--    move_window_8 = {{"alt", "cmd", "shift"}, "8"},
--    move_window_9 = {{"alt", "cmd", "shift"}, "9"}
})
PaperWM:start()

-- focus adjacent window with 3 finger swipe 
local actions = PaperWM.actions.actions() 
local current_id, threshold 
Swipe = hs.loadSpoon("Swipe") 
Swipe:start(3, function(direction, distance, id) 
    if id == current_id then 
        if distance > threshold then 
            threshold = math.huge -- trigger once per swipe 

            -- use "natural" scrolling 
            if direction == "left" then 
                actions.focus_right() 
            elseif direction == "right" then 
                actions.focus_left() 
            elseif direction == "up" then 
                actions.focus_down() 
            elseif direction == "down" then 
                actions.focus_up() 
            end 
        end 
    else 
        current_id = id 
        threshold = 0.2 -- swipe distance > 20% of trackpad size 
    end 
end)

-- Focus first window in space
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "up", function()
    local focused_window = hs.window.focusedWindow()
    if not focused_window then return end
    
    local space = hs.spaces.windowSpaces(focused_window)[1]
    if not space then return end
    
    local columns = PaperWM.state.windowList(space)
    if not columns or #columns == 0 then return end
    
    local first_window = columns[1][1]
    if first_window then first_window:focus() end
end)

-- Focus last window in space
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "down", function()

    local focused_window = hs.window.focusedWindow()
    if not focused_window then return end
    
    local space = hs.spaces.windowSpaces(focused_window)[1]
    if not space then return end
    
    local columns = PaperWM.state.windowList(space)
    if not columns or #columns == 0 then return end
    
    local last_column = columns[#columns]
    if last_column then
        local last_window = last_column[#last_column]
        if last_window then last_window:focus() end
    end
end)


-- Function to set all windows in current space to 50% width
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "return", function()
    local focused_window = hs.window.focusedWindow()
    if not focused_window then 
        PaperWM.logger.d("No focused window found")
        return 
    end
    local space = hs.spaces.windowSpaces(focused_window)[1]
    if not space then 
        PaperWM.logger.d("No space found for focused window")
        return 
    end
    local screen = focused_window:screen()
    local canvas = PaperWM.windows.getCanvas(screen)
    
    -- Calculate 50% width
    -- PaperWM logic for calculating width with gaps:
    -- size = ratio * (area_size + gap) - gap
    -- here ratio is 0.5
    local gap = (PaperWM.windows.getGap("left") + PaperWM.windows.getGap("right")) / 2
    local new_width = 0.5 * (canvas.w + gap) - gap
    local columns = PaperWM.state.windowList(space)
    if not columns then return end
    -- Iterate over all columns and windows
    for _, column in ipairs(columns) do
        for _, window in ipairs(column) do
            local frame = window:frame()
            -- Only update if width is different significantly (to avoid jitter)
            if math.abs(frame.w - new_width) > 1 then
                frame.x = frame.x + ((frame.w - new_width) // 2)
                frame.w = new_width
                PaperWM.windows.moveWindow(window, frame)
            end
        end
    end
    -- Retile the space to apply changes and fix positions
    PaperWM:tileSpace(space)
    
    hs.alert.show("All windows set to 50%", 1)
end)


-- 提示配置已重载
hs.alert.show("Config Loaded 🚀", 1) 
-- 这里的数字 2 代表显示 2 秒
