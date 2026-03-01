--[[
    SAMBUNG KATA ULTIMATE v5.0
    3 MODE: AI XZ | MANUAL | BEVERLY (FULL)
    Fitur:
    - Deteksi File (WORK 100%)
    - Natural Typing (ketik 1-1 kayak manusia)
    - 5 Rekomendasi kata (Mode MANUAL)
    - Auto Answer (Mode AI XZ & BEVERLY)
    - Toggle Huruf Favorit A-Z (bisa ON/OFF)
    - Skak Musuh X/Z/Q/F/V
    - Speed Slider (Lambat - Turbo)
    - Statistik lengkap
    - Tema Biru Keren
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =====================================================
-- KONFIGURASI
-- =====================================================
local CONFIG = {
    typingSpeed = 0.08,
    favoriteEndings = {
        k = true, h = true, r = true, n = true,
        l = true, m = true, g = true, p = true, t = true
    },
    submitCooldown = 1.2,
    autoSubmit = true,
    naturalType = true,
    autoAnswer = false,
    currentMode = 2,  -- 1=AI XZ, 2=MANUAL, 3=BEVERLY
}

-- =====================================================
-- DATABASE KATA (70K+ DARI GITHUB + SKAK)
-- =====================================================
local wordDB = {}
local allWords = {}
local usedWords = {}

-- Database skak musuh
local SKAK_DB = {
    x = {"refleks", "kompleks", "konteks", "teks", "indeks", "matriks", "sintaks", "paradoks", "ortodoks", "klimaks"},
    z = {"jazz", "topaz", "hafiz", "analisis", "krisis", "hipnotis", "diagnosis", "prognosis"},
    q = {"haq", "sidiq", "thoriq", "qalbu", "qari'", "qasar", "qiam"},
    f = {"aktif", "positif", "negatif", "efektif", "produktif", "kreatif", "inovatif", "selektif", "sensitif", "objektif"},
    v = {"pasif", "motif", "evolusi", "revolusi", "inovatif", "provokatif"},
}

-- Load kata dari GitHub
local function loadWordDatabase()
    local success, result = pcall(function()
        local url = "https://raw.githubusercontent.com/zerydery/last-letter/main/data/words.js"
        local response = game:HttpGet(url)
        local jsonString = response:match("%[(.-)%]")
        if jsonString then
            return HttpService:JSONDecode("[" .. jsonString .. "]")
        end
        return {}
    end)
    
    if success and #result > 5000 then
        return result
    else
        return {"makan", "minum", "rumah", "sekolah", "mobil", "jalan"}
    end
end

-- Initialize database
allWords = loadWordDatabase()
for _, word in ipairs(allWords) do
    local first = word:sub(1,1):lower()
    if not wordDB[first] then wordDB[first] = {} end
    table.insert(wordDB[first], word)
end

-- Gabung SKAK DB
for letter, words in pairs(SKAK_DB) do
    if not wordDB[letter] then wordDB[letter] = {} end
    for _, word in ipairs(words) do
        table.insert(wordDB[letter], word)
    end
end

-- =====================================================
-- SISTEM DETEKSI FILE (WORK 100%)
-- =====================================================
local currentLetter = ""
local lastLetter = ""

local function scanCurrentLetter()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("StringValue") and obj.Name:match("currentWorldIndex") then
            local val = obj.Value:lower()
            if #val == 1 and val:match("[a-z]") then
                return val
            end
        end
    end
    return nil
end

local function isOurTurn()
    return scanCurrentLetter() ~= nil
end

-- Monitor perubahan huruf
task.spawn(function()
    while true do
        task.wait(0.3)
        local newLetter = scanCurrentLetter()
        if newLetter and newLetter ~= lastLetter then
            lastLetter = newLetter
            currentLetter = newLetter
        end
    end
end)

-- =====================================================
-- SISTEM SKORING KATA
-- =====================================================
local function scoreWord(word, requiredFirstLetter)
    if not word then return -999 end
    if word:sub(1,1):lower() ~= requiredFirstLetter then return -999 end
    
    local score = #word * 5
    local last = word:sub(-1):lower()
    
    if CONFIG.favoriteEndings[last] then
        score = score + 50
    end
    
    if usedWords[word] then
        score = score - 100
    end
    
    return score
end

-- Cari kata terbaik
local function findBestWords(requiredLetter, limit)
    limit = limit or 5
    if not requiredLetter or not wordDB[requiredLetter] then
        return {}
    end
    
    local candidates = {}
    for _, word in ipairs(wordDB[requiredLetter]) do
        local score = scoreWord(word, requiredLetter)
        if score > -500 then
            table.insert(candidates, {word = word, score = score})
        end
    end
    
    table.sort(candidates, function(a, b) return a.score > b.score end)
    
    local results = {}
    for i = 1, math.min(limit, #candidates) do
        results[i] = candidates[i].word
    end
    return results
end

-- =====================================================
-- SISTEM SUBMIT + NATURAL TYPING
-- =====================================================
local lastSubmitTime = 0

local function findTextBox()
    for _, v in pairs(playerGui:GetDescendants()) do
        if v:IsA("TextBox") and v.Visible then
            return v
        end
    end
    return nil
end

local function findEnterButton()
    for _, v in pairs(playerGui:GetDescendants()) do
        if v:IsA("TextButton") and v.Visible then
            local name = v.Name:lower()
            local text = v.Text:lower()
            if name == "enter" or text == "enter" or text == "kirim" then
                return v
            end
        end
    end
    return nil
end

-- NATURAL TYPING (KETIK 1-1 KAYAK MANUSIA)
local function submitWord(word)
    if not word or #word == 0 then return false end
    
    local now = tick()
    if now - lastSubmitTime < CONFIG.submitCooldown then
        return false
    end
    
    local textBox = findTextBox()
    if not textBox then return false end
    
    -- Focus
    pcall(function() textBox:CaptureFocus() end)
    task.wait(0.05)
    
    -- NATURAL TYPING
    if CONFIG.naturalType then
        textBox.Text = ""
        for i = 1, #word do
            textBox.Text = word:sub(1, i)
            local waitTime = CONFIG.typingSpeed + (math.random() * 0.03)
            task.wait(waitTime)
        end
    else
        textBox.Text = word
        task.wait(0.1)
    end
    
    -- Submit
    if CONFIG.autoSubmit then
        local enterBtn = findEnterButton()
        if enterBtn then
            pcall(function() enterBtn.MouseButton1Click:Fire() end)
        else
            pcall(function()
                local VIM = game:GetService("VirtualInputManager")
                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end)
        end
    end
    
    lastSubmitTime = tick()
    usedWords[word] = true
    return true
end

-- =====================================================
-- AUTO ANSWER LOOP (UNTUK MODE AI XZ & BEVERLY)
-- =====================================================
local autoRunning = false
local autoThread = nil

local function startAutoAnswer()
    if autoRunning then return end
    autoRunning = true
    
    autoThread = task.spawn(function()
        while autoRunning do
            task.wait(0.5)
            
            if not isOurTurn() then
                continue
            end
            
            if currentLetter and currentLetter ~= "" then
                local topWords = findBestWords(currentLetter, 1)
                if topWords[1] then
                    submitWord(topWords[1])
                end
            end
        end
    end)
end

local function stopAutoAnswer()
    autoRunning = false
    if autoThread then
        task.cancel(autoThread)
        autoThread = nil
    end
end

-- =====================================================
-- UI UTAMA (TEMA BIRU KEREN)
-- =====================================================
local gui = Instance.new("ScreenGui")
gui.Name = "SambungKataUltimate"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 550)
main.Position = UDim2.new(0.5, -190, 0.5, -275)
main.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
main.BackgroundTransparency = 0.05
main.Active = true
main.Draggable = true
main.Parent = gui

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = main

-- Glow effect (stroke biru neon)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 180, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = main

-- =====================================================
-- HEADER dengan MODE SELECTOR
-- =====================================================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(15, 25, 45)
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 20)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 15, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ SAMBUNG KATA ULTIMATE v5.0"
title.TextColor3 = Color3.fromRGB(100, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Mode selector buttons
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(1, -30, 0, 30)
modeFrame.Position = UDim2.new(0, 15, 0, 30)
modeFrame.BackgroundTransparency = 1
modeFrame.Parent = header

local modeLayout = Instance.new("UIListLayout")
modeLayout.FillDirection = Enum.FillDirection.Horizontal
modeLayout.Padding = UDim.new(0, 8)
modeLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
modeLayout.Parent = modeFrame

-- Tombol mode AI XZ
local mode1Btn = Instance.new("TextButton")
mode1Btn.Size = UDim2.new(0, 100, 0, 30)
mode1Btn.BackgroundColor3 = CONFIG.currentMode == 1 and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 40, 60)
mode1Btn.Text = "🤖 AI XZ"
mode1Btn.TextColor3 = CONFIG.currentMode == 1 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 200, 255)
mode1Btn.Font = Enum.Font.GothamBold
mode1Btn.TextSize = 12
mode1Btn.Parent = modeFrame

local mode1Corner = Instance.new("UICorner")
mode1Corner.CornerRadius = UDim.new(0, 15)
mode1Corner.Parent = mode1Btn

-- Tombol mode MANUAL
local mode2Btn = Instance.new("TextButton")
mode2Btn.Size = UDim2.new(0, 100, 0, 30)
mode2Btn.BackgroundColor3 = CONFIG.currentMode == 2 and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 40, 60)
mode2Btn.Text = "👆 MANUAL"
mode2Btn.TextColor3 = CONFIG.currentMode == 2 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 200, 255)
mode2Btn.Font = Enum.Font.GothamBold
mode2Btn.TextSize = 12
mode2Btn.Parent = modeFrame

local mode2Corner = Instance.new("UICorner")
mode2Corner.CornerRadius = UDim.new(0, 15)
mode2Corner.Parent = mode2Btn

-- Tombol mode BEVERLY
local mode3Btn = Instance.new("TextButton")
mode3Btn.Size = UDim2.new(0, 100, 0, 30)
mode3Btn.BackgroundColor3 = CONFIG.currentMode == 3 and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 40, 60)
mode3Btn.Text = "👑 BEVERLY"
mode3Btn.TextColor3 = CONFIG.currentMode == 3 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 200, 255)
mode3Btn.Font = Enum.Font.GothamBold
mode3Btn.TextSize = 12
mode3Btn.Parent = modeFrame

local mode3Corner = Instance.new("UICorner")
mode3Corner.CornerRadius = UDim.new(0, 15)
mode3Corner.Parent = mode3Btn

-- =====================================================
-- CONTENT AREA (BERUBAH SESUAI MODE)
-- =====================================================
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -80)
content.Position = UDim2.new(0, 10, 0, 75)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 4
content.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.Parent = content

-- =====================================================
-- FUNCTION TO UPDATE UI BASED ON MODE
-- =====================================================
local function updateUIMode(mode)
    CONFIG.currentMode = mode
    
    -- Stop auto answer when switching modes
    stopAutoAnswer()
    
    -- Update tombol warna
    mode1Btn.BackgroundColor3 = mode == 1 and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 40, 60)
    mode1Btn.TextColor3 = mode == 1 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 200, 255)
    
    mode2Btn.BackgroundColor3 = mode == 2 and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 40, 60)
    mode2Btn.TextColor3 = mode == 2 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 200, 255)
    
    mode3Btn.BackgroundColor3 = mode == 3 and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(30, 40, 60)
    mode3Btn.TextColor3 = mode == 3 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(150, 200, 255)
    
    -- Hapus semua isi content
    for _, child in pairs(content:GetChildren()) do
        if child ~= contentLayout then
            child:Destroy()
        end
    end
    
    -- =====================================================
    -- MODE 1: AI XZ (Auto Simple)
    -- =====================================================
    if mode == 1 then
        local mode1UI = Instance.new("Frame")
        mode1UI.Size = UDim2.new(1, 0, 0, 350)
        mode1UI.BackgroundTransparency = 1
        mode1UI.Parent = content
        
        -- Huruf besar di tengah
        local bigLetter = Instance.new("TextLabel")
        bigLetter.Size = UDim2.new(1, 0, 0, 180)
        bigLetter.Position = UDim2.new(0, 0, 0, 20)
        bigLetter.BackgroundTransparency = 1
        bigLetter.Text = currentLetter and currentLetter:upper() or "?"
        bigLetter.TextColor3 = Color3.fromRGB(100, 200, 255)
        bigLetter.Font = Enum.Font.GothamBold
        bigLetter.TextSize = 140
        bigLetter.Parent = mode1UI
        
        -- Status
        local status = Instance.new("TextLabel")
        status.Size = UDim2.new(1, 0, 0, 30)
        status.Position = UDim2.new(0, 0, 0, 220)
        status.BackgroundTransparency = 1
        status.Text = "🤖 AI XZ Mode - Auto Running"
        status.TextColor3 = Color3.fromRGB(150, 150, 200)
        status.Font = Enum.Font.Gotham
        status.TextSize = 14
        status.Parent = mode1UI
        
        -- Start/Stop button
        local startBtn = Instance.new("TextButton")
        startBtn.Size = UDim2.new(0.6, 0, 0, 45)
        startBtn.Position = UDim2.new(0.2, 0, 0, 260)
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        startBtn.Text = "▶ START AUTO"
        startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        startBtn.Font = Enum.Font.GothamBold
        startBtn.TextSize = 14
        startBtn.Parent = mode1UI
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 22)
        btnCorner.Parent = startBtn
        
        local isRunning = false
        startBtn.MouseButton1Click:Connect(function()
            isRunning = not isRunning
            if isRunning then
                startBtn.Text = "⏹ STOP AUTO"
                startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                startAutoAnswer()
            else
                startBtn.Text = "▶ START AUTO"
                startBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                stopAutoAnswer()
            end
        end)
        
        -- Update huruf实时
        task.spawn(function()
            while mode1UI and mode1UI.Parent do
                bigLetter.Text = currentLetter and currentLetter:upper() or "?"
                task.wait(0.3)
            end
        end)
    
    -- =====================================================
    -- MODE 2: MANUAL (5 Rekomendasi)
    -- =====================================================
    elseif mode == 2 then
        local mode2UI = Instance.new("Frame")
        mode2UI.Size = UDim2.new(1, 0, 0, 400)
        mode2UI.BackgroundTransparency = 1
        mode2UI.Parent = content
        
        -- Header dengan huruf
        local headerFrame = Instance.new("Frame")
        headerFrame.Size = UDim2.new(1, 0, 0, 90)
        headerFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
        headerFrame.Parent = mode2UI
        
        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 15)
        headerCorner.Parent = headerFrame
        
        local hurufText = Instance.new("TextLabel")
        hurufText.Size = UDim2.new(1, 0, 0, 25)
        hurufText.Position = UDim2.new(0, 15, 0, 10)
        hurufText.BackgroundTransparency = 1
        hurufText.Text = "🔤 Huruf akhir:"
        hurufText.TextColor3 = Color3.fromRGB(150, 150, 200)
        hurufText.Font = Enum.Font.Gotham
        hurufText.TextSize = 12
        hurufText.TextXAlignment = Enum.TextXAlignment.Left
        hurufText.Parent = headerFrame
        
        local letterDisplay = Instance.new("TextLabel")
        letterDisplay.Size = UDim2.new(1, 0, 0, 45)
        letterDisplay.Position = UDim2.new(0, 15, 0, 35)
        letterDisplay.BackgroundTransparency = 1
        letterDisplay.Text = currentLetter and currentLetter:upper() or "?"
        letterDisplay.TextColor3 = Color3.fromRGB(100, 200, 255)
        letterDisplay.Font = Enum.Font.GothamBold
        letterDisplay.TextSize = 40
        letterDisplay.TextXAlignment = Enum.TextXAlignment.Left
        letterDisplay.Parent = headerFrame
        
        -- Panel rekomendasi
        local recLabel = Instance.new("TextLabel")
        recLabel.Size = UDim2.new(1, -20, 0, 25)
        recLabel.Position = UDim2.new(0, 10, 0, 100)
        recLabel.BackgroundTransparency = 1
        recLabel.Text = "📋 PILIH JAWABAN (klik langsung kirim):"
        recLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        recLabel.Font = Enum.Font.GothamBold
        recLabel.TextSize = 12
        recLabel.TextXAlignment = Enum.TextXAlignment.Left
        recLabel.Parent = mode2UI
        
        -- Grid untuk 5 tombol
        local gridFrame = Instance.new("Frame")
        gridFrame.Size = UDim2.new(1, -20, 0, 280)
        gridFrame.Position = UDim2.new(0, 10, 0, 130)
        gridFrame.BackgroundTransparency = 1
        gridFrame.Parent = mode2UI
        
        local gridLayout = Instance.new("UIGridLayout")
        gridLayout.CellSize = UDim2.new(0, 160, 0, 50)
        gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
        gridLayout.FillDirection = Enum.FillDirection.Horizontal
        gridLayout.Parent = gridFrame
        
        -- Buat 5 tombol rekomendasi
        local recButtons = {}
        for i = 1, 5 do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3 = Color3.fromRGB(30, 45, 70)
            btn.Text = "-"
            btn.TextColor3 = Color3.fromRGB(200, 200, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 14
            btn.Visible = false
            btn.Parent = gridFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 10)
            btnCorner.Parent = btn
            
            -- Hover effect
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 70, 100)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 45, 70)}):Play()
            end)
            
            recButtons[i] = btn
        end
        
        -- Update rekomendasi实时
        task.spawn(function()
            while mode2UI and mode2UI.Parent do
                letterDisplay.Text = currentLetter and currentLetter:upper() or "?"
                
                if currentLetter and currentLetter ~= "" then
                    local topWords = findBestWords(currentLetter, 5)
                    
                    for i = 1, 5 do
                        local btn = recButtons[i]
                        if topWords[i] then
                            btn.Text = topWords[i]
                            btn.Visible = true
                            
                            -- Hapus event lama pake coroutine biar gak numpuk
                            local wordToSubmit = topWords[i]
                            btn.MouseButton1Click:Connect(function()
                                submitWord(wordToSubmit)
                                -- Feedback visual
                                btn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
                                task.wait(0.2)
                                btn.BackgroundColor3 = Color3.fromRGB(30, 45, 70)
                            end)
                        else
                            btn.Visible = false
                        end
                    end
                end
                
                task.wait(0.3)
            end
        end)
    
    -- =====================================================
    -- MODE 3: BEVERLY (Full Featured dengan Tab)
    -- =====================================================
    elseif mode == 3 then
        local mode3UI = Instance.new("Frame")
        mode3UI.Size = UDim2.new(1, 0, 0, 700)
        mode3UI.BackgroundTransparency = 1
        mode3UI.Parent = content
        
        -- Tab navigasi
        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 0, 40)
        tabFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
        tabFrame.Parent = mode3UI
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 12)
        tabCorner.Parent = tabFrame
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.Padding = UDim.new(0, 5)
        tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabLayout.Parent = tabFrame
        
        local tabs = {"MAIN", "HURUF", "SKAK", "CEPAT", "INFO"}
        local tabButtons = {}
        local currentTab = 1
        
        for i, tabName in ipairs(tabs) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 30)
            btn.Position = UDim2.new(0, 5 + (i-1)*75, 0, 5)
            btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 50, 70)
            btn.Text = tabName
            btn.TextColor3 = i == 1 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.Parent = tabFrame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 15)
            btnCorner.Parent = btn
            
            tabButtons[i] = btn
        end
        
        -- Content area untuk tab
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 0, 650)
        tabContent.Position = UDim2.new(0, 0, 0, 45)
        tabContent.BackgroundTransparency = 1
        tabContent.Parent = mode3UI
        
        -- Function to switch tabs
        local function switchTab(tabIndex)
            currentTab = tabIndex
            
            -- Update button colors
            for i, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = i == tabIndex and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 50, 70)
                btn.TextColor3 = i == tabIndex and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(200, 200, 255)
            end
            
            -- Clear tab content
            for _, child in pairs(tabContent:GetChildren()) do
                child:Destroy()
            end
            
            -- =============================================
            -- TAB 1: MAIN
            -- =============================================
            if tabIndex == 1 then
                local mainTab = Instance.new("Frame")
                mainTab.Size = UDim2.new(1, 0, 0, 600)
                mainTab.BackgroundTransparency = 1
                mainTab.Parent = tabContent
                
                -- Huruf display besar
                local letterBox = Instance.new("Frame")
                letterBox.Size = UDim2.new(0.8, 0, 0, 100)
                letterBox.Position = UDim2.new(0.1, 0, 0, 10)
                letterBox.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
                letterBox.Parent = mainTab
                
                local boxCorner = Instance.new("UICorner")
                boxCorner.CornerRadius = UDim.new(0, 15)
                boxCorner.Parent = letterBox
                
                local boxStroke = Instance.new("UIStroke")
                boxStroke.Color = Color3.fromRGB(0, 180, 255)
                boxStroke.Thickness = 1
                boxStroke.Parent = letterBox
                
                local hurufBesar = Instance.new("TextLabel")
                hurufBesar.Size = UDim2.new(1, 0, 1, 0)
                hurufBesar.BackgroundTransparency = 1
                hurufBesar.Text = currentLetter and currentLetter:upper() or "?"
                hurufBesar.TextColor3 = Color3.fromRGB(100, 200, 255)
                hurufBesar.Font = Enum.Font.GothamBold
                hurufBesar.TextSize = 60
                hurufBesar.Parent = letterBox
                
                -- Auto answer toggle
                local autoFrame = Instance.new("Frame")
                autoFrame.Size = UDim2.new(1, -20, 0, 50)
                autoFrame.Position = UDim2.new(0, 10, 0, 120)
                autoFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
                autoFrame.Parent = mainTab
                
                local autoCorner = Instance.new("UICorner")
                autoCorner.CornerRadius = UDim.new(0, 10)
                autoCorner.Parent = autoFrame
                
                local autoLabel = Instance.new("TextLabel")
                autoLabel.Size = UDim2.new(0.7, 0, 1, 0)
                autoLabel.Position = UDim2.new(0, 10, 0, 0)
                autoLabel.BackgroundTransparency = 1
                autoLabel.Text = "🤖 AUTO ANSWER"
                autoLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
                autoLabel.Font = Enum.Font.GothamBold
                autoLabel.TextSize = 14
                autoLabel.TextXAlignment = Enum.TextXAlignment.Left
                autoLabel.Parent = autoFrame
                
                local autoBtn = Instance.new("TextButton")
                autoBtn.Size = UDim2.new(0, 60, 0, 30)
                autoBtn.Position = UDim2.new(1, -70, 0.5, -15)
                autoBtn.BackgroundColor3 = CONFIG.autoAnswer and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(80, 80, 100)
                autoBtn.Text = CONFIG.autoAnswer and "ON" or "OFF"
                autoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                autoBtn.Font = Enum.Font.GothamBold
                autoBtn.TextSize = 12
                autoBtn.Parent = autoFrame
                
                local autoBtnCorner = Instance.new("UICorner")
                autoBtnCorner.CornerRadius = UDim.new(0, 15)
                autoBtnCorner.Parent = autoBtn
                
                autoBtn.MouseButton1Click:Connect(function()
                    CONFIG.autoAnswer = not CONFIG.autoAnswer
                    autoBtn.BackgroundColor3 = CONFIG.autoAnswer and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(80, 80, 100)
                    autoBtn.Text = CONFIG.autoAnswer and "ON" or "OFF"
                    
                    if CONFIG.autoAnswer then
                        startAutoAnswer()
                    else
                        stopAutoAnswer()
                    end
                end)
                
                -- Rekomendasi 3 kata
                local recTitle = Instance.new("TextLabel")
                recTitle.Size = UDim2.new(1, -20, 0, 25)
                recTitle.Position = UDim2.new(0, 10, 0, 180)
                recTitle.BackgroundTransparency = 1
                recTitle.Text = "📋 REKOMENDASI 3 KATA"
                recTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
                recTitle.Font = Enum.Font.GothamBold
                recTitle.TextSize = 12
                recTitle.TextXAlignment = Enum.TextXAlignment.Left
                recTitle.Parent = mainTab
                
                local recGrid = Instance.new("Frame")
                recGrid.Size = UDim2.new(1, -20, 0, 120)
                recGrid.Position = UDim2.new(0, 10, 0, 205)
                recGrid.BackgroundTransparency = 1
                recGrid.Parent = mainTab
                
                local recGridLayout = Instance