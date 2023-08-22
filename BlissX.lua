repeat wait() until game:IsLoaded() == true
wait()

warn("BlissX - Loading")

local folders = {
    "BlissX",
    "BlissX/Universal",
    "BlissX/QZ",
    "BlissX/Ragdoll",
    "BlissX/Criminality",
    "BlissX/Anarchy",
    "BlissX/NewWorld"
}

for i,v in pairs(folders) do
    if isfolder(v) == false then
        makefolder(v)
    end
end

--LUA FUNCTIONS
local clamp = math.clamp
local round = math.round
local abs = math.abs
local huge = math.huge
local random = math.random
local floor = math.floor
local rad = math.rad

local match = string.match
local sub = string.sub

local v3 = Vector3.new
local v2 = Vector2.new
local u2 = UDim2.new
local CF = CFrame.new
local RGB = Color3.fromRGB

local drawing = Drawing.new

local function NewSquare(args)
    local q = drawing("Square")
    q.Visible = false
    q.Transparency = args.Transparency
    q.Color = args.Color
    q.Size = args.Size or v2(0, 0)
    q.Position = args.Position or v2(0, 0)
    q.Thickness = args.Thickness or 1
    q.Filled = args.Filled or false
    return q
end

local function NewText(args)
    local q = drawing("Text")
    q.Visible = args.Visible or false
    q.Transparency = args.Transparency or 1
    q.Color = args.Color or RGB(0, 0, 0)
    q.Size = args.TextSize or 15
    q.Font = args.Font or 3
    q.Text = args.Text or "null"
    q.Center = args.Centered or false
    q.Position = args.Position or v2(0, 0)
    return q
end

local function NewCircle(Transparency, Color, Radius, Filled, Thickness)
    local c = drawing("Circle")
    c.Transparency = Transparency
    c.Color = Color
    c.Visible = false
    c.Thickness = Thickness
    c.Position = v2(0, 0)
    c.Radius = Radius
    c.NumSides = clamp(Radius*55/100, 10, 75)
    c.Filled = Filled
    return c
end

local LOADING_CHECKING_TEXT = NewText({
    Visible = true,
    Color = RGB(0, 255, 140),
    Transparency = 0.9,
    TextSize = 20,
    Text = "Checking",
    Centered = true,
    Position = v2(game:GetService("Workspace").CurrentCamera.ViewportSize.X/2, 40)
})

local Games = {
    [1] = {ID = "1686265127", Name = "Quarantine-Z"},
    [2] = {ID = "580765040", Name = "Ragdoll Universe"},
    [3] = {ID = "1494262959", Name = "Criminality"},
    [4] = {ID = "2351921349", Name = "The New World"},
    [5] = {ID = "595270616", Name = "State of Anarchy"}
}

local LOADED_START = false
local Supported_Game = false
local Current_Game = nil
for i = 1, #Games do
    local v = Games[i]
    if v.ID == tostring(game.GameId) or v.ID == tostring(game.PlaceId) then
        Supported_Game = true
        Current_Game = v
        LOADING_CHECKING_TEXT.Text = "Loading: "..string.upper(v.Name)
        spawn(function()
            local backup = LOADING_CHECKING_TEXT.Text
            repeat
                wait(0.25)
                local current = LOADING_CHECKING_TEXT.Text
                if sub(current, #current-2, #current) == "..." then
                    LOADING_CHECKING_TEXT.Text = backup.."."
                else
                    LOADING_CHECKING_TEXT.Text = current.."."
                end
            until LOADED_START == true
            LOADING_CHECKING_TEXT:Remove()
        end)
        break
    else 
        Supported_Game = false
    end
end
if Supported_Game == false then
    LOADING_CHECKING_TEXT.Text = "Loading: UNIVERSAL"
    spawn(function()
        local backup = LOADING_CHECKING_TEXT.Text
        repeat
            wait(0.25)
            local current = LOADING_CHECKING_TEXT.Text
            if sub(current, #current-2, #current) == "..." then
                LOADING_CHECKING_TEXT.Text = backup.."."
            else
                LOADING_CHECKING_TEXT.Text = current.."."
            end
        until LOADED_START == true
        LOADING_CHECKING_TEXT:Remove()
    end)
end

_G["pages"] = {}
_G["UI_Info"] = {
    ["Project_Title"] = 'Bliss<b>X</b>'
}

local themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/EssentialUI/main/themes.lua", true))()

_G["Theme"] = themes["Fire"]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/EssentialUI/main/main.lua"))()

local HealthBarRed = RGB(255, 0, 0);
local HealthBarGreen = RGB(0, 255, 0);

local Player = game:GetService("Players").LocalPlayer
repeat wait() until Player.Character ~= nil and Player.Character:FindFirstChildOfClass("Humanoid")

local HttpService = game:GetService("HttpService")

if Supported_Game == false then
    --LOCALS
    local Players = game:GetService("Players")
    local Mouse = Player:GetMouse()
    local Camera = game:GetService("Workspace").CurrentCamera
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local MainWindow = Library:NewWindow()
    LOADED_START = true

    local DESTROY_GUI = false

    -- UNIVERSAL 
    local UniversalCategory = MainWindow:NewPage(_G["pages"], "Universal")

    local Selected_Player = nil

    -- ESP
    local ESPSection = UniversalCategory:NewSection("ESP")

    local ESP_Settings = {
        Names_Toggle = false,
        Text_Size = 15,
        Health = true,
        Boxes_Toggle = false,
        Health_Bar = true,
        Color =  {R = 255, G = 0, B = 175},
        Team_Check = false,
        Team =  {R = 0, G = 255, B = 0},
        Enemy =  {R = 255, G = 0, B = 0},
        Show_Selected = true,
        Selected =  {R = 255, G = 255, B = 255},
        Team_Color = false
    }

    local AIMBOT_Settings = {
        Toggle = false,
        Sensitivity = 0.5,
        Lock_Part = "Head",
        Distance_Type = "Character",
        Team_Check = false,
        FOV_Circle = false,
        FOV_Color = {R = 255, G = 0, B = 175},
        FOV_Radius = 10,
        Tool_Tip = false,
        Tool_Tip_Color = {R = 255, G = 0, B = 175}
    }

    local ESPFile = "BlissX/Universal/ESP.dat"
    local AIMBOTFile = "BlissX/Universal/Aimbot.dat"

    local function LoadESP()
        local u, Result = pcall(readfile, ESPFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if ESP_Settings[i] ~= nil then
                        ESP_Settings[i] = v
                        pcall(ESP_Settings[i], v)
                    end
                end
            end
        end
    end

    local function LoadAIMBOT()
        local u, Result = pcall(readfile, AIMBOTFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if AIMBOT_Settings[i] ~= nil then
                        AIMBOT_Settings[i] = v
                        pcall(AIMBOT_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadESP()
    LoadAIMBOT()

    ESPSection:NewToggle("Names", function (NewValue)
        ESP_Settings.Names_Toggle = NewValue
    end, {default = ESP_Settings.Names_Toggle})

    ESPSection:NewSlider("Text Size", function (NewValue)
        ESP_Settings.Text_Size = NewValue
    end, {value = ESP_Settings.Text_Size, min = 1, max = 75, suffix = " px"})

    ESPSection:NewToggle("Health", function (NewValue)
        ESP_Settings.Health = NewValue
    end, {default = ESP_Settings.Health})

    ESPSection:NewToggle("Boxes", function (NewValue)
        ESP_Settings.Boxes_Toggle = NewValue
    end, {default = ESP_Settings.Boxes_Toggle})

    ESPSection:NewToggle("Health Bar", function (NewValue)
        ESP_Settings.Health_Bar = NewValue
    end, {default = ESP_Settings.Health_Bar})

    ESPSection:NewColorPicker("Color", function (NewValue)
        ESP_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)})

    ESPSection:NewToggle("Team Check", function (NewValue)
        ESP_Settings.Team_Check = NewValue
    end, {default = ESP_Settings.Team_Check})

    ESPSection:NewColorPicker("Team", function (NewValue)
        ESP_Settings.Team = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)})

    ESPSection:NewColorPicker("Enemy", function (NewValue)
        ESP_Settings.Enemy = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)})

    ESPSection:NewToggle("Team Color", function (NewValue)
        ESP_Settings.Team_Color = NewValue
    end, {default = ESP_Settings.Team_Color})

    ESPSection:NewColorPicker("Selected Player", function (NewValue)
        ESP_Settings.Selected = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)})

    ESPSection:NewToggle("Show Selected", function (NewValue)
        ESP_Settings.Show_Selected = NewValue
    end, {default = ESP_Settings.Show_Selected})

    local function NameTag(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")
        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
        NAME.Outline = true
        NAME.OutlineColor = RGB(10, 10, 10)
        NAME.Position = v2(0, 0)
        NAME.Size = ESP_Settings.Text_Size
        NAME.Center = true
        NAME.Font = 3 
        NAME.Text = plr.Name

        local TB = NAME.TextBounds

        local HEALTH = drawing("Text")
        HEALTH.Visible = false
        HEALTH.Transparency = 0.8
        HEALTH.Color = RGB(255, 255, 255)
        HEALTH.Outline = true
        HEALTH.OutlineColor = RGB(10, 10, 10)
        HEALTH.Position = v2(0, 0)
        HEALTH.Size = ESP_Settings.Text_Size
        HEALTH.Font = 3 
        HEALTH.Text = "[]"

        local function Update()
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    HEALTH:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Names_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and char:FindFirstChild("Head") ~= nil and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local Hum = char:FindFirstChildOfClass("Humanoid")
                    Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        NAME.Size = ESP_Settings.Text_Size
                        HEALTH.Size = ESP_Settings.Text_Size

                        -- NAME.Color = ESP_Settings.Color
                        -- NAME.Position = v2(pos.X, pos.Y - TB.Y/2)

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local Top = pos.Y - newsize.Y/2

                        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        NAME.Position = v2(pos.X, Top - TB.Y - 2)

                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                NAME.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                NAME.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end

                        if ESP_Settings.Team_Color then
                            NAME.Color = teamColor.Color
                        end

                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            NAME.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        if ESP_Settings.Health then
                            HEALTH.Text = "["..tostring(round(Hum.Health)).."]"

                            NAME.Position = v2(pos.X - HEALTH.TextBounds.Y, Top - TB.Y - 2)
                            HEALTH.Position = v2(NAME.Position.X + TB.X/2, Top - TB.Y - 2)
                            HEALTH.Visible = true
                        else 
                            HEALTH.Visible = false
                        end

                        NAME.Visible = true
                    else 
                        NAME.Visible = false
                        HEALTH.Visible = false
                    end
                else 
                    if ESP_Settings.Names_Toggle == false and char and char:FindFirstChildOfClass("Humanoid") then 
                        char:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                    NAME.Visible = false
                    HEALTH.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        NAME:Remove()
                        HEALTH:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local function NewLine(color, thickness, transparency)
        local line = drawing("Line")
        line.Visible = false
        line.From = v2(0, 0)
        line.To = v2(0, 0)
        line.Color = color
        line.Thickness = thickness
        line.Transparency = transparency or 1
        return line
    end

    local function DrawBox(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")

        local Box = NewSquare({
            Transparency = 1, 
            Color = RGB(255, 255, 255), 
            Filled = false,
        })

        local Bar = NewLine(RGB(10, 10, 10), 3, 0.75)
        local Health = NewLine(RGB(0, 255, 0), 1)

        local function Update()
            local prevhealth = huge
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    Box:Remove()
                    Bar:Remove()
                    Health:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Boxes_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") ~= nil and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        Box.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                Box.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                Box.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end
                        if ESP_Settings.Team_Color then
                            Box.Color = teamColor.Color
                        end  
                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            Box.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local newpos = v2(pos.X - newsize.X/2, pos.Y - newsize.Y/2)

                        Box.Size = newsize
                        Box.Position = newpos

                        local Right = newpos.X + newsize.X
                        local Top = newpos.Y
                        local Bottom = newpos.Y + newsize.Y

                        if ESP_Settings.Health_Bar then
                            local Hum = char:FindFirstChildOfClass("Humanoid")
                            local Hum_Health = Hum.Health
                            local Hum_MaxHealth = Hum.MaxHealth

                            local offsetX = clamp(round(100/(char.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude), 0, 5)

                            Bar.From = v2(Right + offsetX, Top)
                            Bar.To = v2(Right + offsetX, Bottom)

                            local HealthRatio = Hum_Health / Hum_MaxHealth
                            local Length = abs((Bottom - 1) - (Top + 1))
                                
                            local HealthLength = Length * HealthRatio
                            Health.From = v2(Right + offsetX, Bottom - 1 - HealthLength)
                            Health.To = v2(Right + offsetX, Bottom - 1)

                            if Hum_Health ~= prevhealth then
                                Health.Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))
                                prevhealth = Hum_Health
                            end

                            Health.Visible = true
                            Bar.Visible = true
                        else 
                            Health.Visible = false
                            Bar.Visible = false
                        end

                        Box.Visible = true
                    else 
                        Health.Visible = false
                        Bar.Visible = false
                        Box.Visible = false
                    end
                else
                    Health.Visible = false
                    Bar.Visible = false
                    Box.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        Health:Remove()
                        Bar:Remove()
                        Box:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local t = Players:GetChildren()
    for i = 1, #t do
        local v = t[i]
        if DESTROY_GUI == false and v.Name ~= Player.Name then
            coroutine.wrap(NameTag)(v) 
            coroutine.wrap(DrawBox)(v)
        end
    end

    Players.PlayerAdded:Connect(function(v)
        if DESTROY_GUI == false then
            coroutine.wrap(NameTag)(v)
            coroutine.wrap(DrawBox)(v)
        end
    end)

    -- AIMBOT 
    local AIMBOTSection = UniversalCategory:NewSection("Aimbot")

    AIMBOTSection:NewToggle("Aimbot", function (NewValue)
        AIMBOT_Settings.Toggle = NewValue
    end, {default = AIMBOT_Settings.Toggle})

    AIMBOTSection:NewSlider("Sensitivity", function (NewValue)
        AIMBOT_Settings.Sensitivity = NewValue
    end, {value = AIMBOT_Settings.Sensitivity, min = 0.01, max = 1, suffix = " factor", decimals = 2})

    AIMBOTSection:NewToggle("Team Check", function (NewValue)
        AIMBOT_Settings.Team_Check = NewValue
    end, {default = AIMBOT_Settings.Team_Check})

    do
        local default_option
        local list =  {
            "Head", 
            "Torso", 
            "Feet"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Lock_Part then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Part", function(Option)
            AIMBOT_Settings.Lock_Part = Option
        end, {
            options = list,
            default = default_option
        })
    end

    do
        local default_option
        local list =  {
            "Mouse", 
            "Character"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Distance_Type then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Distance Type", function(Option)
            AIMBOT_Settings.Distance_Type = Option
        end, {
            options = list,
            default = default_option
        })
    end

    AIMBOTSection:NewToggle("FOV Circle", function (NewValue)
        AIMBOT_Settings.FOV_Circle = NewValue
    end, {default = AIMBOT_Settings.FOV_Circle})

    AIMBOTSection:NewColorPicker("FOV Color", function (NewValue)
        AIMBOT_Settings.FOV_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)})

    AIMBOTSection:NewSlider("FOV Radius", function (NewValue)
        AIMBOT_Settings.FOV_Radius = NewValue
    end, {value = AIMBOT_Settings.FOV_Radius, min = 1, max = 400, suffix = "°"})

    local Aiming = false
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = false
        end
    end)

    local FOV = drawing("Circle")
    FOV.Visible = false
    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
    FOV.Position = v2(0, 0)
    FOV.Transparency = 0.6
    FOV.NumSides = 75
    FOV.Radius = AIMBOT_Settings.FOV_Radius
    FOV.Filled = false
    FOV.Thickness = 1

    local function SameTeam(plr)
        local deb = false
        if AIMBOT_Settings.Team_Check then
            if plr.TeamColor == Player.TeamColor then
                deb = true
            else 
                deb = false
            end
        else
            deb = false
        end
        return deb
    end

    local function GetClosest()
        local min = huge
        local closest = nil
        if AIMBOT_Settings.Distance_Type == "Mouse" then
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local dist = (v2(Mouse.X, Mouse.Y) - v2(pos.X, pos.Y)).magnitude
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        else
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local dist = (Player.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        end
        return closest
    end

    coroutine.wrap(function()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            Selected_Player = GetClosest()
        end)
    end)()

    local inset = game:GetService("GuiService"):GetGuiInset()

    local function Aimbot_Start()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                FOV:Remove()
                c:Disconnect()
            end
            if AIMBOT_Settings.Toggle then
                
                if AIMBOT_Settings.FOV_Circle then
                    FOV.Radius = AIMBOT_Settings.FOV_Radius
                    FOV.Thickness = 1
                    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
        
                    FOV.Position = v2(Mouse.X, Mouse.Y + 36)
                    FOV.Visible = true
                else 
                    FOV.Radius = 2000
        
                    FOV.Position = Camera.ViewportSize / 2
                    FOV.Visible = false
                end

                if Aiming and Selected_Player ~= nil then
                    local char = Selected_Player.Character
                    local pos
                    local part = AIMBOT_Settings.Lock_Part
                    if part == "Head" then
                        pos = Camera:WorldToViewportPoint(char.Head.Position)
                    elseif part == "Torso" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    elseif part == "Feet" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position - v3(0, 2.5, 0))
                    end
                    local sens = AIMBOT_Settings.Sensitivity
                    mousemoverel((pos.X - Mouse.X) * sens, (pos.Y - Mouse.Y - inset.Y) * sens)
                end
            else 
                FOV.Visible = false
            end
        end)
    end
    coroutine.wrap(Aimbot_Start)()

    AIMBOTSection:NewToggle("Show Player Tooltip", function (NewValue)
        AIMBOT_Settings.Tool_Tip = NewValue
    end, {default = AIMBOT_Settings.Tool_Tip})

    AIMBOTSection:NewColorPicker("Name Color", function (NewValue)
        AIMBOT_Settings.Tool_Tip_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)})

    coroutine.wrap(function() -- PLAYER TOOLTIP
        local HealthBarThickness = 5
        local Tip_Library = {
            [1] = NewSquare({ -- Tip
                Transparency = 0.75, 
                Color = RGB(10, 10, 10), 
                Size = v2(300, 50),
                Position = v2(810, 10),
                Filled = true
            }),
            [2] = NewText({ -- Name
                Transparency = 1, 
                Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B), 
                TextSize = 15,
                Font = 3,
                Position = v2(816, 12)
            }),
            [3] = NewText({ -- Health_Text
                Transparency = 1, 
                Color = RGB(225, 225, 225), 
                TextSize = 15,
                Font = 3,
                Position = v2(814, 30),
            }),
            [4] = NewSquare({ -- Bar
                Transparency = 0.75, 
                Color = RGB(50, 50, 50), 
                Size = v2(292, HealthBarThickness),
                Position = v2(814, 50),
                Filled = true
            }),
            [5] = NewSquare({ -- Health
                Transparency = 1, 
                Color = RGB(0, 255, 0), 
                Size = v2(290, HealthBarThickness - 2),
                Position = v2(815, 51),
                Filled = true
            })
        }
        local function Visibility(state)
            for i = 1, #Tip_Library do
                local v = Tip_Library[i]
                v.Visible = state
            end
        end

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i = 1, #Tip_Library do
                    local v = Tip_Library[i]
                    v:Remove()
                end
            end
            if AIMBOT_Settings.Tool_Tip then
                if Selected_Player ~= nil then
                    local char = Selected_Player
                    local Hum = char.Character:FindFirstChildOfClass("Humanoid")
                    local Hum_Health = Hum.Health
                    local Hum_MaxHealth = Hum.MaxHealth

                    -- TEXTS
                    Tip_Library[2].Text = Selected_Player.Name
                    Tip_Library[3].Text = "["..round(Hum_Health).."/"..round(Hum_MaxHealth).."]"

                    -- HEALTH BAR
                    local HealthRatio = Hum_Health / Hum_MaxHealth
                    local Length = abs((Tip_Library[4].Position.X + Tip_Library[4].Size.X) - Tip_Library[4].Position.X)

                    local HealthLength = Length * HealthRatio
                    Tip_Library[5].Size = v2(HealthLength, Tip_Library[5].Size.Y)
                    Tip_Library[5].Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))

                    Tip_Library[2].Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)
                    Visibility(true)
                else 
                    Visibility(false)
                end
            else 
                Visibility(false)
            end
        end)
    end)()

    -- VISUALS
    local VISUALSCategory = MainWindow:NewPage(_G["pages"], "Visuals")

    -- ENVIRONMENT
    local ENVIRONMENTSection = VISUALSCategory:NewSection("Environment")

    local Environment_Settings = {
        Graphics_Enhancer = false,
        Toggle = false,
        Color_Change = false,
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = {R = Lighting.Ambient.R, G = Lighting.Ambient.G, B = Lighting.Ambient.B},
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    local ENVFile = "BlissX/Universal/Env.dat"

    local function LoadENV()
        local u, Result = pcall(readfile, ENVFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Environment_Settings[i] ~= nil then
                        Environment_Settings[i] = v
                        pcall(Environment_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadENV()

    local Previous_Environment = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = Lighting.Ambient,
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    ENVIRONMENTSection:NewToggle("Toggle", function (NewValue)
        Environment_Settings.Toggle = NewValue
    end, {default = Environment_Settings.Toggle})

    ENVIRONMENTSection:NewToggle("Change Color", function (NewValue)
        Environment_Settings.Color_Change = NewValue
    end, {default = Environment_Settings.Color_Change})

    ENVIRONMENTSection:NewColorPicker("Ambient", function (NewValue)
        Environment_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B)})

    ENVIRONMENTSection:NewSlider("Brightness", function (NewValue)
        Environment_Settings.Brightness = NewValue
    end, {value = Environment_Settings.Brightness, min = 0, max = 10, suffix = ""})

    ENVIRONMENTSection:NewSlider("Clock Time", function (NewValue)
        Environment_Settings.ClockTime = NewValue
    end, {value = Environment_Settings.ClockTime, min = 0, max = 24, suffix = " h"})

    do
        local default_option
        local list =  {
            "Compatibility", 
            "Voxel",
            "ShadowMap",
            "Legacy",
            "Future"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Environment_Settings.Technology then
                default_option = i
            end
        end
        ENVIRONMENTSection:NewDropdown("Technology", function(Option)
            Environment_Settings.Technology = Enum.Technology[Option]
        end, {
            options = list,
            default = default_option
        })
    end

    ENVIRONMENTSection:NewToggle("Graphics Enhancer", function (NewValue)
        Environment_Settings.Graphics_Enhancer = NewValue
    end, {default = Environment_Settings.Graphics_Enhancer})

    coroutine.wrap(function() -- LOOP
        local function MOD(brightness, color, time, technology)
            Lighting.Brightness = brightness
            Lighting.ClockTime = time
            if Environment_Settings.Color_Change then
                Lighting.ColorShift_Bottom = color
                Lighting.ColorShift_Top = color
            else 
                Lighting.ColorShift_Bottom = Previous_Environment.Color
                Lighting.ColorShift_Top = Previous_Environment.Color
            end
            if gethiddenproperty(Lighting, "Technology") ~= technology then
                sethiddenproperty(Lighting, "Technology", technology)
            end
        end
        local deb = false
        local graphic_deb = false
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            if Environment_Settings.Graphics_Enhancer == false then
                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end
                graphic_deb = true
                if Environment_Settings.Toggle then
                    deb = true
                    MOD(Environment_Settings.Brightness, RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B), Environment_Settings.ClockTime, Environment_Settings.Technology)
                elseif deb then
                    MOD(Previous_Environment.Brightness, Previous_Environment.Color, Previous_Environment.ClockTime, Previous_Environment.Technology)
                    deb = false
                end
            elseif graphic_deb then
                graphic_deb = false

                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end

                local ter = game:GetService("Workspace").Terrain
                local color = Instance.new("ColorCorrectionEffect")
                local bloom = Instance.new("BloomEffect")
                local sun = Instance.new("SunRaysEffect")
                local blur = Instance.new("BlurEffect")

                color.Parent = Lighting
                bloom.Parent = Lighting
                sun.Parent = Lighting
                blur.Parent = Lighting

                local config = {
                    Terrain = true;
                    ColorCorrection = true;
                    Sun = true;
                    Lighting = true;
                    BloomEffect = true;
                }

                color.Enabled = false
                color.Contrast = 0.15
                color.Brightness = 0.1
                color.Saturation = 0.25
                color.TintColor = RGB(255, 222, 211)

                bloom.Enabled = false
                bloom.Intensity = 0.1

                sun.Enabled = false
                sun.Intensity = 0.2
                sun.Spread = 1

                bloom.Enabled = false
                bloom.Intensity = 0.05
                bloom.Size = 32
                bloom.Threshold = 1

                blur.Enabled = false
                blur.Size = 6

                if config.ColorCorrection then
                    color.Enabled = true
                end

                if config.Sun then
                    sun.Enabled = true
                end

                if config.Terrain then
                    ter.WaterColor = RGB(10, 10, 24)
                    ter.WaterWaveSize = 0.1
                    ter.WaterWaveSpeed = 22
                    ter.WaterTransparency = 0.9
                    ter.WaterReflectance = 0.05
                end


                if config.Lighting then
                    Lighting.Ambient = RGB(0, 0, 0)
                    Lighting.Brightness = 4
                    Lighting.ColorShift_Bottom = RGB(0, 0, 0)
                    Lighting.ColorShift_Top = RGB(0, 0, 0)
                    Lighting.ExposureCompensation = 0
                    Lighting.FogColor = RGB(132, 132, 132)
                    Lighting.GlobalShadows = true
                    Lighting.OutdoorAmbient = RGB(112, 117, 128)
                    Lighting.Outlines = false
                end
            end
        end)
    end)()

    -- SCREEN STUFF
    local SCREENSection = VISUALSCategory:NewSection("Screen")

    local Stats_Settings = {
        ShowFPS = false,
        ShowPing = false,
        ShowPosition = false,
        Color = {R = 255, G = 0, B = 175},
        Text_Size = 18,
        Max_Zoom_Distance = 100,
        Tool_Tip = false,
    }

    local STATSFile = "BlissX/Universal/ScreenStats.dat"

    local function LoadSTATS()
        local u, Result = pcall(readfile, STATSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Stats_Settings[i] ~= nil then
                        Stats_Settings[i] = v
                        pcall(Stats_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadSTATS()

    SCREENSection:NewToggle("Show FPS", function (NewValue)
        Stats_Settings.ShowFPS = NewValue
    end, {default = Stats_Settings.ShowFPS})

    SCREENSection:NewToggle("Show Ping", function (NewValue)
        Stats_Settings.ShowPing = NewValue
    end, {default = Stats_Settings.ShowPing})

    SCREENSection:NewToggle("Show Position", function (NewValue)
        Stats_Settings.ShowPosition = NewValue
    end, {default = Stats_Settings.ShowPosition})

    SCREENSection:NewColorPicker("Color", function (NewValue)
        Stats_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)})

    SCREENSection:NewSlider("Text Size", function (NewValue)
        Stats_Settings.Text_Size = NewValue
    end, {value = Stats_Settings.Text_Size, min = 1, max = 50, suffix = " px"})

    SCREENSection:NewSlider("Max Zoom Distance", function (NewValue)
        Stats_Settings.Max_Zoom_Distance = NewValue
    end, {value = Stats_Settings.Max_Zoom_Distance, min = 1, max = 5000, suffix = " studs"})

    coroutine.wrap(function() -- LOOP
        local function NewText()
            local t = drawing("Text")
            t.Visible = false
            t.Transparency = 0.8
            t.Color = RGB(255, 255, 255)
            t.Outline = true
            t.OutlineColor = RGB(10, 10, 10)
            t.Position = v2(0, 0)
            t.Size = 20
            t.Center = false
            t.Font = 3 
            t.Text = ""
            return t
        end
        local FPS = NewText()
        local PING = NewText()
        local POSITION = NewText()
        local c
        c = RS.RenderStepped:Connect(function(step)
            local fps_stat = 1/step
            if DESTROY_GUI then
                c:Disconnect()
                PING:Remove()
                FPS:Remove()
                POSITION:Remove()
            end
            local stats_col = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)
            if Stats_Settings.ShowFPS then
                FPS.Size = Stats_Settings.Text_Size
                FPS.Text = "FPS: "..tostring(round(fps_stat))
                FPS.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y)
                FPS.Color = stats_col
                FPS.Visible = true
            else 
                FPS.Visible = false
            end
            Player.CameraMaxZoomDistance = Stats_Settings.Max_Zoom_Distance
            if Stats_Settings.ShowPing then
                local ping_stat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                PING.Size = Stats_Settings.Text_Size
                PING.Text = "PING: "..tostring(round(ping_stat))
                PING.Color = stats_col
                PING.Visible = true

                local PingB = PING.TextBounds
                if FPS.Visible == false then
                    PING.Position = v2(5, Camera.ViewportSize.Y - PingB.Y)
                else
                    PING.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y - PingB.Y)
                end
            else 
                PING.Visible = false
            end
            if Stats_Settings.ShowPosition then
                if Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos_stat = Player.Character.PrimaryPart.Position
                    POSITION.Size = Stats_Settings.Text_Size
                    POSITION.Text = "POSITION: "..round(pos_stat.X).." "..round(pos_stat.Y).." "..round(pos_stat.Z)
                    POSITION.Color = stats_col
                    POSITION.Visible = true

                    local PB = POSITION.TextBounds
                    local FP = FPS.TextBounds
                    if FPS.Visible == false and PING.Visible == false then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y)
                    elseif (FPS.Visible and PING.Visible == false) or (FPS.Visible == false and PING.Visible == true) then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y)
                    elseif FPS.Visible and PING.Visible then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y*2)
                    end
                else 
                    POSITION.Visible = false
                end
            else 
                POSITION.Visible = false
            end
        end)
    end)()

    local CROSSHAIRSection = VISUALSCategory:NewSection("Crosshair")

    local Crosshair_Settings = {
        Enabled = false,
        Color = {R = 0, G = 255, B = 0},
        Lock = "Mouse",
        Size = 5,
        Offset = 2,
        Thickness = 1
    }

    local CROSSHAIRFile = "BlissX/Universal/Crosshair.dat"

    local function LoadCROSSHAIR()
        local u, Result = pcall(readfile, CROSSHAIRFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Crosshair_Settings[i] ~= nil then
                        Crosshair_Settings[i] = v
                        pcall(Crosshair_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadCROSSHAIR()

    CROSSHAIRSection:NewToggle("Custom Crosshair", function (NewValue)
        Crosshair_Settings.Enabled = NewValue
    end, {default = Crosshair_Settings.Enabled})

    CROSSHAIRSection:NewColorPicker("Color", function (NewValue)
        Crosshair_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)})

    CROSSHAIRSection:NewSlider("Size", function (NewValue)
        Crosshair_Settings.Size = NewValue
    end, {value = Crosshair_Settings.Size, min = 1, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Offset", function (NewValue)
        Crosshair_Settings.Offset = NewValue
    end, {value = Crosshair_Settings.Offset, min = 0, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Thickness", function (NewValue)
        Crosshair_Settings.Thickness = NewValue
    end, {value = Crosshair_Settings.Thickness, min = 1, max = 40, suffix = ""})

    do
        local default_option
        local list =  {
            "Mouse", 
            "Center"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Crosshair_Settings.Lock then
                default_option = i
            end
        end
        CROSSHAIRSection:NewDropdown("Lock", function(Option)
            Crosshair_Settings.Lock = Option
        end, {
            options = list,
            default = default_option
        })
    end


    coroutine.wrap(function()
        local inset = game:service("GuiService"):GetGuiInset()
        local lines = { -- CROSSHAIR LINES
            up = NewLine(RGB(255, 0, 0), 1, 1),
            down = NewLine(RGB(255, 0, 0), 1, 1),
            left = NewLine(RGB(255, 0, 0), 1, 1),
            right = NewLine(RGB(255, 0, 0), 1, 1)
        }
        local c 
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i,v in pairs(lines) do
                    v:Remove()
                end
                c:Disconnect()
            end
            if Crosshair_Settings.Enabled then
                local center = v2(0,0)
                if Crosshair_Settings.Lock == "Mouse" then
                    center = v2(Mouse.X, Mouse.Y + inset.Y)
                elseif Crosshair_Settings.Lock == "Center" then
                    center = Camera.ViewportSize/2
                else 
                    center = Camera.ViewportSize/2
                end
    
                lines.up.From = center - v2(0, Crosshair_Settings.Offset)
                lines.up.To = center - v2(0, Crosshair_Settings.Offset) - v2(0, Crosshair_Settings.Size)

                lines.down.From = center + v2(0, Crosshair_Settings.Offset)
                lines.down.To = center + v2(0, Crosshair_Settings.Offset) + v2(0, Crosshair_Settings.Size)

                lines.left.From = center - v2(Crosshair_Settings.Offset, 0)
                lines.left.To = center - v2(Crosshair_Settings.Offset, 0) - v2(Crosshair_Settings.Size, 0)

                lines.right.From = center + v2(Crosshair_Settings.Offset, 0)
                lines.right.To = center + v2(Crosshair_Settings.Offset, 0) + v2(Crosshair_Settings.Size, 0)

                local crosshair_col = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)
                for i,v in pairs(lines) do
                    v.Color = crosshair_col
                    v.Thickness = Crosshair_Settings.Thickness
                    v.Visible = true
                end
            else 
                for i,v in pairs(lines) do
                    v.Visible = false
                end
            end
        end)
    end)()

    -- BLATANT
    local BLATANTCategory = MainWindow:NewPage(_G["pages"], "Blatant (!)")

    -- PLAYER
    local PLAYER_BLATANTSection = BLATANTCategory:NewSection("Player")

    local PLAYER_Settings = {
        WalkSpeed = false,
        WalkSpeedValue = Player.Character.Humanoid.WalkSpeed,
        JumpPower = false,
        JumpPowerValue = Player.Character.Humanoid.JumpPower
    }

    local PLAYERFile = "BlissX/Universal/Player.dat"

    local function LoadPLAYERMODS()
        local u, Result = pcall(readfile, PLAYERFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if PLAYER_Settings[i] ~= nil then
                        PLAYER_Settings[i] = v
                        pcall(PLAYER_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadPLAYERMODS()

    PLAYER_BLATANTSection:NewToggle("Walk Speed", function (NewValue)
        PLAYER_Settings.WalkSpeed = NewValue
    end, {default = PLAYER_Settings.WalkSpeed})

    PLAYER_BLATANTSection:NewSlider("Speed Value", function (NewValue)
        PLAYER_Settings.WalkSpeedValue = NewValue
    end, {value = PLAYER_Settings.WalkSpeedValue,min = 0, max = 200, suffix = " studs/s"})

    PLAYER_BLATANTSection:NewToggle("Jump Power", function (NewValue)
        PLAYER_Settings.JumpPower = NewValue
    end, {default = PLAYER_Settings.JumpPower})

    PLAYER_BLATANTSection:NewSlider("Jump Value", function (NewValue)
        PLAYER_Settings.JumpPowerValue = NewValue
    end, {value = PLAYER_Settings.JumpPowerValue, min = round(PLAYER_Settings.JumpPowerValue), max = 5000, suffix = ""})

    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__index

    local ospeed = Player.Character.Humanoid.WalkSpeed
    local ojump = Player.Character.Humanoid.JumpPower

    local function ModCharacterValues()
        mt.__index = newcclosure(function(self, a)
            if a == "WalkSpeed" then
                return ospeed
            elseif a == "JumpPower" then
                return ojump
            end
            return old(self, a)
        end)

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                if Player.Character ~= nil and Player.Character:FindFirstChildOfClass("Humanoid") then
                    Player.Character.Humanoid.WalkSpeed = ospeed
                    Player.Character.Humanoid.WalkSpeed = ojump
                end
                c:Disconnect()
            end
            
            if Player.Character ~= nil and Player.Character:FindFirstChildOfClass("Humanoid") then
                if PLAYER_Settings.WalkSpeed then
                    Player.Character.Humanoid.WalkSpeed = PLAYER_Settings.WalkSpeedValue
                else
                    Player.Character.Humanoid.WalkSpeed = ospeed
                end

                if PLAYER_Settings.JumpPower then
                    Player.Character.Humanoid.JumpPower = PLAYER_Settings.JumpPowerValue
                else
                    Player.Character.Humanoid.JumpPower = ojump
                end
            end
        end)
    end
    coroutine.wrap(ModCharacterValues)()

    -- GUI (LAST)
    local GUI_Settings = {
        theme = "Fire",
        toggle_bind = "End"
    }
    
    local GUIFile = "BlissX/Universal/GUI.dat"

    local function LoadGUI()
        local u, Result = pcall(readfile, GUIFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if GUI_Settings[i] ~= nil then
                        GUI_Settings[i] = v
                        pcall(GUI_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadGUI()

    _G["Theme"] = themes[GUI_Settings.theme]
    MainWindow:UpdateTheme()

    local GUICategory = MainWindow:NewPage(_G["pages"], "Settings")

    local GUISection = GUICategory:NewSection("GUI")

    GUISection:NewKeybind("Toggle", function(newbind)
        GUI_Settings.toggle_bind = string.sub(tostring(newbind), 14, #tostring(newbind))
        MainWindow:Toggle()
    end, {keybind = Enum.KeyCode[GUI_Settings.toggle_bind]})

    do
        local default_option
        local list =  {
            "Fire",
            "Forest",
            "Ocean",
            "Grayscale",
            "Midnight",
        }
        for i = 1, #list do
            local v = list[i]
            if v == GUI_Settings.theme then
                default_option = i
            end
        end
        GUISection:NewDropdown("Theme", function(Option)
            GUI_Settings.theme = Option
            _G["Theme"] = themes[Option]
            MainWindow:UpdateTheme()
        end, {
            options = list,
            default = default_option
        })
    end

    GUISection:NewButton("Update Theme", function()
        MainWindow:UpdateTheme()
    end)

    GUISection:NewButton("Kill", function()
        DESTROY_GUI = true
        MainWindow:Kill()
    end)

    GUISection:NewButton("Save Config", function()
        writefile(ESPFile, game:service("HttpService"):JSONEncode(ESP_Settings))
        writefile(AIMBOTFile, game:service("HttpService"):JSONEncode(AIMBOT_Settings))
        writefile(ENVFile, game:service("HttpService"):JSONEncode(Environment_Settings))
        writefile(PLAYERFile, game:service("HttpService"):JSONEncode(PLAYER_Settings))
        writefile(STATSFile, game:service("HttpService"):JSONEncode(Stats_Settings))
        writefile(CROSSHAIRFile, game:service("HttpService"):JSONEncode(Crosshair_Settings))
        writefile(GUIFile, game:service("HttpService"):JSONEncode(GUI_Settings))
    end)

elseif Current_Game.Name == "Quarantine-Z" then
    --LOCALS
    local Players = game:GetService("Players")
    local Mouse = Player:GetMouse()
    local Camera = game:GetService("Workspace").CurrentCamera
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local connections = getconnections(game:GetService("ScriptContext").Error)
    for i = 1, #connections do 
        local v = connections[i]
        v:Disable()
    end

    local MainWindow = Library:NewWindow()
    LOADED_START = true

    local DESTROY_GUI = false

    -- UNIVERSAL 
    local UniversalCategory = MainWindow:NewPage(_G["pages"], "Universal")

    local Selected_Player = nil

    -- ESP
    local ESPSection = UniversalCategory:NewSection("ESP")

    local ESP_Settings = {
        Names_Toggle = false,
        Text_Size = 15,
        Health = true,
        Boxes_Toggle = false,
        Health_Bar = true,
        Color =  {R = 255, G = 0, B = 175},
        Team_Check = false,
        Team =  {R = 0, G = 255, B = 0},
        Enemy =  {R = 255, G = 0, B = 0},
        Show_Selected = true,
        Selected =  {R = 255, G = 255, B = 255},
        Team_Color = false
    }

    local AIMBOT_Settings = {
        Toggle = false,
        Sensitivity = 0.5,
        Lock_Part = "Head",
        Distance_Type = "Character",
        Team_Check = false,
        FOV_Circle = false,
        FOV_Color = {R = 255, G = 0, B = 175},
        FOV_Radius = 10,
        Tool_Tip = false,
        Tool_Tip_Color = {R = 255, G = 0, B = 175}
    }

    local HttpService = game:GetService("HttpService")
    local ESPFile = "BlissX/Universal/ESP.dat"
    local AIMBOTFile = "BlissX/Universal/Aimbot.dat"

    local function LoadESP()
        local u, Result = pcall(readfile, ESPFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if ESP_Settings[i] ~= nil then
                        ESP_Settings[i] = v
                        pcall(ESP_Settings[i], v)
                    end
                end
            end
        end
    end

    local function LoadAIMBOT()
        local u, Result = pcall(readfile, AIMBOTFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if AIMBOT_Settings[i] ~= nil then
                        AIMBOT_Settings[i] = v
                        pcall(AIMBOT_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadESP()
    LoadAIMBOT()

    ESPSection:NewToggle("Names", function (NewValue)
        ESP_Settings.Names_Toggle = NewValue
    end, {default = ESP_Settings.Names_Toggle})

    ESPSection:NewSlider("Text Size", function (NewValue)
        ESP_Settings.Text_Size = NewValue
    end, {value = ESP_Settings.Text_Size, min = 1, max = 75, suffix = " px"})

    ESPSection:NewToggle("Health", function (NewValue)
        ESP_Settings.Health = NewValue
    end, {default = ESP_Settings.Health})

    ESPSection:NewToggle("Boxes", function (NewValue)
        ESP_Settings.Boxes_Toggle = NewValue
    end, {default = ESP_Settings.Boxes_Toggle})

    ESPSection:NewToggle("Health Bar", function (NewValue)
        ESP_Settings.Health_Bar = NewValue
    end, {default = ESP_Settings.Health_Bar})

    ESPSection:NewColorPicker("Color", function (NewValue)
        ESP_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)})

    ESPSection:NewColorPicker("Selected Player", function (NewValue)
        ESP_Settings.Selected = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)})

    ESPSection:NewToggle("Show Selected", function (NewValue)
        ESP_Settings.Show_Selected = NewValue
    end, {default = ESP_Settings.Show_Selected})

    local function NameTag(plr)
        repeat
            wait()
        until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")

        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
        NAME.Outline = true
        NAME.OutlineColor = RGB(10, 10, 10)
        NAME.Position = v2(0, 0)
        NAME.Size = ESP_Settings.Text_Size
        NAME.Center = true
        NAME.Font = 3 
        NAME.Text = plr.Character.Name

        local HEALTH = drawing("Text")
        HEALTH.Visible = false
        HEALTH.Transparency = 0.8
        HEALTH.Color = RGB(255, 255, 255)
        HEALTH.Outline = true
        HEALTH.OutlineColor = RGB(10, 10, 10)
        HEALTH.Position = v2(0, 0)
        HEALTH.Size = ESP_Settings.Text_Size
        HEALTH.Font = 3 
        HEALTH.Text = "[]"

        local start_name = plr.Character.Name

        local function Update()
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    HEALTH:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Names_Toggle and char ~= nil and char:FindFirstChild("Humanoid") ~= nil and char.PrimaryPart ~= nil and char.Humanoid.Health > 0 then
                    local Hum = char.Humanoid
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        NAME.Size = ESP_Settings.Text_Size
                        HEALTH.Size = ESP_Settings.Text_Size

                        -- NAME.Color = ESP_Settings.Color
                        -- NAME.Position = v2(pos.X, pos.Y - TB.Y/2)

                        local ratio = 2500 / pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local Top = pos.Y - newsize.Y / 2

                        local TB = NAME.TextBounds

                        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        NAME.Position = v2(pos.X, Top - TB.Y - 2)

                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and start_name == Selected_Player.Character.Name then
                            NAME.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        if ESP_Settings.Health then
                            HEALTH.Text = "[" .. tostring(round(Hum.Health)) .. "]"

                            NAME.Position = v2(pos.X - HEALTH.TextBounds.Y, Top - TB.Y - 2)
                            HEALTH.Position = v2(NAME.Position.X + TB.X / 2, Top - TB.Y - 2)
                            HEALTH.Visible = true
                        else
                            HEALTH.Visible = false
                        end

                        NAME.Visible = true
                    else
                        NAME.Visible = false
                        HEALTH.Visible = false
                    end
                else
                    NAME.Visible = false
                    HEALTH.Visible = false
                    if Players:FindFirstChild(start_name) == nil then
                        NAME:Remove()
                        HEALTH:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local function NewLine(color, thickness, transparency)
        local line = drawing("Line")
        line.Visible = false
        line.From = v2(0, 0)
        line.To = v2(0, 0)
        line.Color = color
        line.Thickness = thickness
        line.Transparency = transparency or 1
        return line
    end

    local function DrawBox(plr)
        repeat
            wait()
        until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")

        local Box = NewSquare({
            Transparency = 1,
            Color = RGB(255, 255, 255),
            Filled = false
        })

        local Bar = NewLine(RGB(10, 10, 10), 3, 0.75)
        local Health = NewLine(RGB(0, 255, 0), 1)

        local start_name = plr.Character.Name

        local function Update()
            local prevhealth = huge

            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    Box:Remove()
                    Bar:Remove()
                    Health:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Boxes_Toggle and char ~= nil and char:FindFirstChild("Humanoid") ~= nil and char.PrimaryPart ~= nil and char.Humanoid.Health > 0 then
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        Box.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and start_name == Selected_Player.Character.Name then
                            Box.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        local ratio = 2500 / pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local newpos = v2(pos.X - newsize.X / 2, pos.Y - newsize.Y / 2)

                        Box.Size = newsize
                        Box.Position = newpos

                        local Right = newpos.X + newsize.X
                        local Top = newpos.Y
                        local Bottom = newpos.Y + newsize.Y

                        if ESP_Settings.Health_Bar then
                            local Hum = char:FindFirstChild("Humanoid")
                            local Hum_Health = Hum.Health
                            local Hum_MaxHealth = Hum.MaxHealth

                            local offsetX = clamp(round(100 / (char.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude), 0, 5)

                            Bar.From = v2(Right + offsetX, Top)
                            Bar.To = v2(Right + offsetX, Bottom)

                            local HealthRatio = Hum_Health / Hum_MaxHealth
                            local Length = abs((Bottom - 1) - (Top + 1))

                            local HealthLength = Length * HealthRatio
                            Health.From = v2(Right + offsetX, Bottom - 1 - HealthLength)
                            Health.To = v2(Right + offsetX, Bottom - 1)

                            if Hum_Health ~= prevhealth then
                                Health.Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))
                                prevhealth = Hum_Health
                            end

                            Health.Visible = true
                            Bar.Visible = true
                        else
                            Health.Visible = false
                            Bar.Visible = false
                        end

                        Box.Visible = true
                    else
                        Health.Visible = false
                        Bar.Visible = false
                        Box.Visible = false
                    end
                else
                    Health.Visible = false
                    Bar.Visible = false
                    Box.Visible = false
                    if Players:FindFirstChild(start_name) == nil then
                        Health:Remove()
                        Bar:Remove()
                        Box:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    for _,v in pairs(getrenv()._G.PlayerList) do
        coroutine.wrap(function()
            repeat wait() until v.Character ~= nil
            if v.Character.Name ~= Player.Name then 
                coroutine.wrap(NameTag)(v)
                coroutine.wrap(DrawBox)(v)
            end
        end)()
    end

    Players.PlayerAdded:Connect(function(newplr)
        for _,v in pairs(getrenv()._G.PlayerList) do
            coroutine.wrap(function()
                repeat wait() until v.Character ~= nil
                if v.Character.Name == newplr.Name then 
                    coroutine.wrap(NameTag)(v)
                    coroutine.wrap(DrawBox)(v)
                end
            end)()
        end
    end)

    -- AIMBOT 
    local AIMBOTSection = UniversalCategory:NewSection("Aimbot")

    AIMBOTSection:NewToggle("Aimbot", function (NewValue)
        AIMBOT_Settings.Toggle = NewValue
    end, {default = AIMBOT_Settings.Toggle})

    AIMBOTSection:NewSlider("Sensitivity", function (NewValue)
        AIMBOT_Settings.Sensitivity = NewValue
    end, {value = AIMBOT_Settings.Sensitivity, min = 0.01, max = 1, suffix = " factor", decimals = 2})

    do
        local default_option
        local list =  {
            "Head", 
            "Torso", 
            "Feet"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Lock_Part then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Part", function(Option)
            AIMBOT_Settings.Lock_Part = Option
        end, {
            options = list,
            default = default_option
        })
    end

    do
        local default_option
        local list =  {
            "Mouse", 
            "Character"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Distance_Type then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Distance Type", function(Option)
            AIMBOT_Settings.Distance_Type = Option
        end, {
            options = list,
            default = default_option
        })
    end

    AIMBOTSection:NewToggle("FOV Circle", function (NewValue)
        AIMBOT_Settings.FOV_Circle = NewValue
    end, {default = AIMBOT_Settings.FOV_Circle})

    AIMBOTSection:NewColorPicker("FOV Color", function (NewValue)
        AIMBOT_Settings.FOV_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)})

    AIMBOTSection:NewSlider("FOV Radius", function (NewValue)
        AIMBOT_Settings.FOV_Radius = NewValue
    end, {value = AIMBOT_Settings.FOV_Radius, min = 1, max = 400, suffix = "°"})

    local Aiming = false
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = false
        end
    end)

    local FOV = drawing("Circle")
    FOV.Visible = false
    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
    FOV.Position = v2(0, 0)
    FOV.Transparency = 0.6
    FOV.NumSides = 75
    FOV.Radius = AIMBOT_Settings.FOV_Radius
    FOV.Filled = false
    FOV.Thickness = 1

    local function GetClosest()
        local min = huge
        local closest = nil
        if AIMBOT_Settings.Distance_Type == "Mouse" then
            for i,v in pairs(getrenv()._G.PlayerList) do
                if v.Character.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character.PrimaryPart ~= nil then
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local dist = (v2(Mouse.X, Mouse.Y) - v2(pos.X, pos.Y)).magnitude
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        else
            for i,v in pairs(getrenv()._G.PlayerList) do
                if v.Character.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character.PrimaryPart ~= nil then
                    local dist = (Player.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        end
        return closest
    end

    coroutine.wrap(function()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            Selected_Player = GetClosest()
        end)
    end)()

    local inset = game:GetService("GuiService"):GetGuiInset()

    local function Aimbot_Start()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                FOV:Remove()
                c:Disconnect()
            end
            if AIMBOT_Settings.Toggle then

                if AIMBOT_Settings.FOV_Circle then
                    FOV.Radius = AIMBOT_Settings.FOV_Radius
                    FOV.Thickness = 1
                    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)

                    FOV.Position = v2(Mouse.X, Mouse.Y + 36)
                    FOV.Visible = true
                else
                    FOV.Radius = 2000

                    FOV.Position = Camera.ViewportSize / 2
                    FOV.Visible = false
                end
                if Aiming and Selected_Player ~= nil then
                    local char = Selected_Player.Character
                    local pos
                    local part = AIMBOT_Settings.Lock_Part
                    if part == "Head" then
                        pos = Camera:WorldToViewportPoint(char.Head.Position)
                    elseif part == "Torso" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    elseif part == "Feet" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position - v3(0, 2.5, 0))
                    end
                    local sens = AIMBOT_Settings.Sensitivity
                    mousemoverel((pos.X - Mouse.X) * sens, (pos.Y - Mouse.Y - inset.Y) * sens)
                end
            else 
                FOV.Visible = false
            end
        end)
    end
    coroutine.wrap(Aimbot_Start)()

    AIMBOTSection:NewToggle("Show Player Tooltip", function (NewValue)
        AIMBOT_Settings.Tool_Tip = NewValue
    end, {default = AIMBOT_Settings.Tool_Tip})

    AIMBOTSection:NewColorPicker("Name Color", function (NewValue)
        AIMBOT_Settings.Tool_Tip_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)})

    coroutine.wrap(function() -- PLAYER TOOLTIP
        local HealthBarThickness = 5
        local Tip_Library = {
            [1] = NewSquare({ -- Tip
                Transparency = 0.75, 
                Color = RGB(10, 10, 10), 
                Size = v2(300, 50),
                Position = v2(810, 10),
                Filled = true
            }),
            [2] = NewText({ -- Name
                Transparency = 1, 
                Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B), 
                TextSize = 15,
                Font = 3,
                Position = v2(816, 12)
            }),
            [3] = NewText({ -- Health_Text
                Transparency = 1,
                Color = RGB(225, 225, 225),
                TextSize = 15,
                Font = 3,
                Position = v2(814, 30)
            }),
            [4] = NewSquare({ -- Bar
                Transparency = 0.75,
                Color = RGB(50, 50, 50),
                Size = v2(292, HealthBarThickness),
                Position = v2(814, 50),
                Filled = true
            }),
            [5] = NewSquare({ -- Health
                Transparency = 1,
                Color = RGB(0, 255, 0),
                Size = v2(290, HealthBarThickness - 2),
                Position = v2(815, 51),
                Filled = true
            })
        }
        local function Visibility(state)
            for i = 1, #Tip_Library do
                local v = Tip_Library[i]
                v.Visible = state
            end
        end

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i = 1, #Tip_Library do
                    local v = Tip_Library[i]
                    v:Remove()
                end
            end
            if AIMBOT_Settings.Tool_Tip then
                if Selected_Player ~= nil then
                    local char = Selected_Player
                    local Hum = char.Character:FindFirstChild("Humanoid")
                    local Hum_Health = Hum.Health
                    local Hum_MaxHealth = Hum.MaxHealth

                    -- TEXTS
                    Tip_Library[2].Text = Selected_Player.Character.Name
                    Tip_Library[3].Text = "[" .. round(Hum_Health) .. "/" .. round(Hum_MaxHealth) .. "]"

                    -- HEALTH BAR
                    local HealthRatio = Hum_Health / Hum_MaxHealth
                    local Length = abs((Tip_Library[4].Position.X + Tip_Library[4].Size.X) - Tip_Library[4].Position.X)

                    local HealthLength = Length * HealthRatio
                    Tip_Library[5].Size = v2(HealthLength, Tip_Library[5].Size.Y)
                    Tip_Library[5].Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))

                    Tip_Library[2].Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)
                    Visibility(true)
                else
                    Visibility(false)
                end
            else
                Visibility(false)
            end
        end)
    end)()

    -- QZ FEATURES

    local QuarantineZCategory = MainWindow:NewPage(_G["pages"], "Quarantine Z")

    local Main_Features = {
        Thick_Bullet = false,
    }

    local QZFile = "BlissX/QZ/Main.dat"

    local function LoadQZ()
        local u, Result = pcall(readfile, QZFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Main_Features[i] ~= nil then
                        Main_Features[i] = v
                        pcall(Main_Features[i], v)
                    end
                end
            end
        end
    end

    LoadQZ()

    local GUNSection = QuarantineZCategory:NewSection("Weapons")

    GUNSection:NewToggle("Thick Bullet", function (NewValue)
        Main_Features.Thick_Bullet = NewValue
    end, {default = Main_Features.Thick_Bullet})

    -- VISUALS
    local VISUALSCategory = MainWindow:NewPage(_G["pages"], "Visuals")

    local VISUAL_OBJSection = VISUALSCategory:NewSection("Quarantine Z")

    local Object_Visuals = {
        Bodies = false,
        Bodies_Color = {R = 255, G = 255, B = 255},
        Vehicles = false,
        Vehicles_Color = {R = 50, G = 50, B = 255},
        Mines = false,
        Mines_Color = {R = 50, G = 255, B = 50},
        Full_Bright = false,
        Custom_Character_Color = {R = 255, G = 50, B = 0},
    }

    local QZESPFile = "BlissX/QZ/ESP.dat"

    local function LoadQZESP()
        local u, Result = pcall(readfile, QZESPFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Object_Visuals[i] ~= nil then
                        Object_Visuals[i] = v
                        pcall(Object_Visuals[i], v)
                    end
                end
            end
        end
    end

    LoadQZESP()

    VISUAL_OBJSection:NewToggle("Bodies", function (NewValue)
        Object_Visuals.Bodies = NewValue
    end, {default = Object_Visuals.Bodies})

    VISUAL_OBJSection:NewColorPicker("Color", function(NewValue)
        Object_Visuals.Bodies_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Object_Visuals.Bodies_Color.R, Object_Visuals.Bodies_Color.G, Object_Visuals.Bodies_Color.B)})

    -- VISUAL_OBJSection:NewToggle("Vehicles", function (NewValue)
    --     Object_Visuals.Vehicles = NewValue
    -- end, {default = Object_Visuals.Vehicles})

    -- VISUAL_OBJSection:NewColorPicker("Color", function(NewValue)
    --     Object_Visuals.Vehicles_Color = NewValue
    -- end, {default = Object_Visuals.Vehicles_Color})

    -- VISUAL_OBJSection:NewToggle("Mines", function (NewValue)
    --     Object_Visuals.Mines = NewValue
    -- end, {default = Object_Visuals.Mines})

    -- VISUAL_OBJSection:NewColorPicker("Color", function(NewValue)
    --     Object_Visuals.Mines_Color = NewValue
    -- end, {default = Object_Visuals.Mines_Color})

    VISUAL_OBJSection:NewColorPicker("Custom Character Color", function(NewValue)
        Object_Visuals.Custom_Character_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Object_Visuals.Custom_Character_Color.R, Object_Visuals.Custom_Character_Color.G, Object_Visuals.Custom_Character_Color.B)})

    VISUAL_OBJSection:NewToggle("Full Bright", function (NewValue)
        Object_Visuals.Full_Bright = NewValue
    end, {default = Object_Visuals.Full_Bright})

    VISUAL_OBJSection:NewToggle("Compass", function (NewValue)
        Player.PlayerGui.Compass.Enabled = NewValue
    end, {default = Player.PlayerGui.Compass.Enabled})

    local Vehicle_Folder
    for _,v in pairs(game:GetService("Workspace")["game_assets"]:GetChildren()) do
        if tonumber(v.Name) and (v:FindFirstChild("truck") or v:FindFirstChild("jeep") or v:FindFirstChild("minivan") or v:FindFirstChild("police_car")) then
            Vehicle_Folder = v
            break
        end
    end

    coroutine.wrap(function()
        local function PartESP(model)
            local BBGUI = Instance.new("BillboardGui")
            BBGUI.Parent = model.main or model.Head or model.UpperTorso
            BBGUI.Adornee = model.main or model.Head or model.UpperTorso
            BBGUI.Enabled = true
            BBGUI.AlwaysOnTop = true
            BBGUI.ResetOnSpawn = false
            BBGUI.Size = u2(0, 1, 0, 2)
            local NAME = Instance.new("TextLabel")
            NAME.Parent = BBGUI
            NAME.TextColor3 = RGB(Object_Visuals.Bodies_Color.R, Object_Visuals.Bodies_Color.G, Object_Visuals.Bodies_Color.B)
            NAME.Size = u2(1, 0, 1, 0)
            NAME.TextSize = 9
            NAME.Font = Enum.Font.Code
            NAME.Visible = false
            NAME.Text = "Player Body"
            NAME.TextXAlignment = Enum.TextXAlignment.Center

            coroutine.wrap(function()
                while wait(0.5) do
                    if DESTROY_GUI then
                        BBGUI:Destroy()
                        NAME:Destroy()
                    else
                        if Object_Visuals.Bodies then
                            NAME.Visible = true
                            NAME.TextColor3 = RGB(Object_Visuals.Bodies_Color.R, Object_Visuals.Bodies_Color.G, Object_Visuals.Bodies_Color.B)
                        else
                            NAME.Visible = false
                        end
                    end
                end
            end)()
        end

        local body_folder = game:service("Workspace")
        for i,v in pairs(body_folder:GetChildren()) do
            if v.Name == "RagDoll" and v:FindFirstChild("Head") then
                PartESP(v)
            end
        end
        body_folder.ChildAdded:Connect(function(new)
            if new.Name == "RagDoll" and (new:FindFirstChild("main") or new:WaitForChild("main")) then
                PartESP(new)
            end
        end)
    end)()

    coroutine.wrap(function()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            if Object_Visuals.Full_Bright then
                Lighting.ClockTime = 14
                Lighting.Brightness = 6
                Lighting.ColorShift_Top = RGB(116, 100, 0)
                Lighting.ColorShift_Bottom = RGB(116, 100, 0)
            end
        end)
        while wait(1) do
            for _,v in pairs(getrenv()._G.PlayerList) do
                if v.Character ~= nil and v.Character.Name ~= Player.Name and v.Character:FindFirstChild("Head") then
                    if Main_Features.Thick_Bullet then
                        v.Character.Head.Size = v3(5.99, 5.99, 5.99)
                        v.Character.Head.Transparency = 1
                    else
                        v.Character.Head.Size = v3(1, 1, 1)
                        v.Character.Head.Transparency = 0
                    end
                end
            end
        end
    end)()

    coroutine.wrap(function()
        while wait(0.2) do
            if DESTROY_GUI == false then
                local t = Player.Character:GetDescendants()
                for i = 1, #t do
                    local v = t[i]
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.ForceField
                        v.Color = RGB(Object_Visuals.Custom_Character_Color.R, Object_Visuals.Custom_Character_Color.G, Object_Visuals.Custom_Character_Color.B)
                    end
                end
            end
        end
    end)()

    -- SCREEN STUFF
    local SCREENSection = VISUALSCategory:NewSection("Screen")

    local Stats_Settings = {
        ShowFPS = false,
        ShowPing = false,
        ShowPosition = false,
        Color = {R = 255, G = 0, B = 175},
        Text_Size = 18,
        Max_Zoom_Distance = 100,
        Tool_Tip = false,
    }

    local STATSFile = "BlissX/Universal/ScreenStats.dat"

    local function LoadSTATS()
        local u, Result = pcall(readfile, STATSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Stats_Settings[i] ~= nil then
                        Stats_Settings[i] = v
                        pcall(Stats_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadSTATS()

    SCREENSection:NewToggle("Show FPS", function (NewValue)
        Stats_Settings.ShowFPS = NewValue
    end, {default = Stats_Settings.ShowFPS})

    SCREENSection:NewToggle("Show Ping", function (NewValue)
        Stats_Settings.ShowPing = NewValue
    end, {default = Stats_Settings.ShowPing})

    SCREENSection:NewToggle("Show Position", function (NewValue)
        Stats_Settings.ShowPosition = NewValue
    end, {default = Stats_Settings.ShowPosition})

    SCREENSection:NewColorPicker("Color", function (NewValue)
        Stats_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)})

    SCREENSection:NewSlider("Text Size", function (NewValue)
        Stats_Settings.Text_Size = NewValue
    end, {value = Stats_Settings.Text_Size, min = 1, max = 50, suffix = " px"})

    SCREENSection:NewSlider("Max Zoom Distance", function (NewValue)
        Stats_Settings.Max_Zoom_Distance = NewValue
    end, {value = Stats_Settings.Max_Zoom_Distance, min = 1, max = 5000, suffix = " studs"})

    coroutine.wrap(function() -- LOOP
        local function NewText()
            local t = drawing("Text")
            t.Visible = false
            t.Transparency = 0.8
            t.Color = RGB(255, 255, 255)
            t.Outline = true
            t.OutlineColor = RGB(10, 10, 10)
            t.Position = v2(0, 0)
            t.Size = 20
            t.Center = false
            t.Font = 3 
            t.Text = ""
            return t
        end
        local FPS = NewText()
        local PING = NewText()
        local POSITION = NewText()
        local c
        c = RS.RenderStepped:Connect(function(step)
            local fps_stat = 1/step
            if DESTROY_GUI then
                c:Disconnect()
                PING:Remove()
                FPS:Remove()
                POSITION:Remove()
            end
            local stats_col = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)
            if Stats_Settings.ShowFPS then
                FPS.Size = Stats_Settings.Text_Size
                FPS.Text = "FPS: "..tostring(round(fps_stat))
                FPS.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y)
                FPS.Color = stats_col
                FPS.Visible = true
            else 
                FPS.Visible = false
            end
            Player.CameraMaxZoomDistance = Stats_Settings.Max_Zoom_Distance
            if Stats_Settings.ShowPing then
                local ping_stat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                PING.Size = Stats_Settings.Text_Size
                PING.Text = "PING: "..tostring(round(ping_stat))
                PING.Color = stats_col
                PING.Visible = true

                local PingB = PING.TextBounds
                if FPS.Visible == false then
                    PING.Position = v2(5, Camera.ViewportSize.Y - PingB.Y)
                else
                    PING.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y - PingB.Y)
                end
            else 
                PING.Visible = false
            end
            if Stats_Settings.ShowPosition then
                if Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos_stat = Player.Character.PrimaryPart.Position
                    POSITION.Size = Stats_Settings.Text_Size
                    POSITION.Text = "POSITION: "..round(pos_stat.X).." "..round(pos_stat.Y).." "..round(pos_stat.Z)
                    POSITION.Color = stats_col
                    POSITION.Visible = true

                    local PB = POSITION.TextBounds
                    local FP = FPS.TextBounds
                    if FPS.Visible == false and PING.Visible == false then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y)
                    elseif (FPS.Visible and PING.Visible == false) or (FPS.Visible == false and PING.Visible == true) then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y)
                    elseif FPS.Visible and PING.Visible then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y*2)
                    end
                else 
                    POSITION.Visible = false
                end
            else 
                POSITION.Visible = false
            end
        end)
    end)()

    local CROSSHAIRSection = VISUALSCategory:NewSection("Crosshair")

    local Crosshair_Settings = {
        Enabled = false,
        Color = {R = 0, G = 255, B = 0},
        Lock = "Mouse",
        Size = 5,
        Offset = 2,
        Thickness = 1
    }

    local CROSSHAIRFile = "BlissX/Universal/Crosshair.dat"

    local function LoadCROSSHAIR()
        local u, Result = pcall(readfile, CROSSHAIRFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Crosshair_Settings[i] ~= nil then
                        Crosshair_Settings[i] = v
                        pcall(Crosshair_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadCROSSHAIR()

    CROSSHAIRSection:NewToggle("Custom Crosshair", function (NewValue)
        Crosshair_Settings.Enabled = NewValue
    end, {default = Crosshair_Settings.Enabled})

    CROSSHAIRSection:NewColorPicker("Color", function (NewValue)
        Crosshair_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)})

    CROSSHAIRSection:NewSlider("Size", function (NewValue)
        Crosshair_Settings.Size = NewValue
    end, {value = Crosshair_Settings.Size, min = 1, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Offset", function (NewValue)
        Crosshair_Settings.Offset = NewValue
    end, {value = Crosshair_Settings.Offset, min = 0, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Thickness", function (NewValue)
        Crosshair_Settings.Thickness = NewValue
    end, {value = Crosshair_Settings.Thickness, min = 1, max = 40, suffix = ""})

    do
        local default_option
        local list =  {
            "Mouse", 
            "Center"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Crosshair_Settings.Lock then
                default_option = i
            end
        end
        CROSSHAIRSection:NewDropdown("Lock", function(Option)
            Crosshair_Settings.Lock = Option
        end, {
            options = list,
            default = default_option
        })
    end


    coroutine.wrap(function()
        local inset = game:service("GuiService"):GetGuiInset()
        local lines = { -- CROSSHAIR LINES
            up = NewLine(RGB(255, 0, 0), 1, 1),
            down = NewLine(RGB(255, 0, 0), 1, 1),
            left = NewLine(RGB(255, 0, 0), 1, 1),
            right = NewLine(RGB(255, 0, 0), 1, 1)
        }
        local c 
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i,v in pairs(lines) do
                    v:Remove()
                end
                c:Disconnect()
            end
            if Crosshair_Settings.Enabled then
                local center = v2(0,0)
                if Crosshair_Settings.Lock == "Mouse" then
                    center = v2(Mouse.X, Mouse.Y + inset.Y)
                elseif Crosshair_Settings.Lock == "Center" then
                    center = Camera.ViewportSize/2
                else 
                    center = Camera.ViewportSize/2
                end
    
                lines.up.From = center - v2(0, Crosshair_Settings.Offset)
                lines.up.To = center - v2(0, Crosshair_Settings.Offset) - v2(0, Crosshair_Settings.Size)

                lines.down.From = center + v2(0, Crosshair_Settings.Offset)
                lines.down.To = center + v2(0, Crosshair_Settings.Offset) + v2(0, Crosshair_Settings.Size)

                lines.left.From = center - v2(Crosshair_Settings.Offset, 0)
                lines.left.To = center - v2(Crosshair_Settings.Offset, 0) - v2(Crosshair_Settings.Size, 0)

                lines.right.From = center + v2(Crosshair_Settings.Offset, 0)
                lines.right.To = center + v2(Crosshair_Settings.Offset, 0) + v2(Crosshair_Settings.Size, 0)

                local crosshair_col = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)
                for i,v in pairs(lines) do
                    v.Color = crosshair_col
                    v.Thickness = Crosshair_Settings.Thickness
                    v.Visible = true
                end
            else 
                for i,v in pairs(lines) do
                    v.Visible = false
                end
            end
        end)
    end)()

    -- GUI (LAST)
    local GUI_Settings = {
        theme = "Fire",
        toggle_bind = "End"
    }
    
    local GUIFile = "BlissX/Universal/GUI.dat"

    local function LoadGUI()
        local u, Result = pcall(readfile, GUIFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if GUI_Settings[i] ~= nil then
                        GUI_Settings[i] = v
                        pcall(GUI_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadGUI()

    _G["Theme"] = themes[GUI_Settings.theme]
    MainWindow:UpdateTheme()

    local GUICategory = MainWindow:NewPage(_G["pages"], "Settings")

    local GUISection = GUICategory:NewSection("GUI")

    GUISection:NewKeybind("Toggle", function(newbind)
        GUI_Settings.toggle_bind = string.sub(tostring(newbind), 14, #tostring(newbind))
        MainWindow:Toggle()
    end, {keybind = Enum.KeyCode[GUI_Settings.toggle_bind]})

    do
        local default_option
        local list =  {
            "Fire",
            "Forest",
            "Ocean",
            "Grayscale",
            "Midnight",
        }
        for i = 1, #list do
            local v = list[i]
            if v == GUI_Settings.theme then
                default_option = i
            end
        end
        GUISection:NewDropdown("Theme", function(Option)
            GUI_Settings.theme = Option
            _G["Theme"] = themes[Option]
            MainWindow:UpdateTheme()
        end, {
            options = list,
            default = default_option
        })
    end

    GUISection:NewButton("Update Theme", function()
        MainWindow:UpdateTheme()
    end)

    GUISection:NewButton("Kill", function()
        DESTROY_GUI = true
        MainWindow:Kill()
    end)

    GUISection:NewButton("Save Config", function()
        writefile(ESPFile, game:service("HttpService"):JSONEncode(ESP_Settings))
        writefile(AIMBOTFile, game:service("HttpService"):JSONEncode(AIMBOT_Settings))
        writefile(STATSFile, game:service("HttpService"):JSONEncode(Stats_Settings))
        writefile(CROSSHAIRFile, game:service("HttpService"):JSONEncode(Crosshair_Settings))
        writefile(GUIFile, game:service("HttpService"):JSONEncode(GUI_Settings))
        writefile(QZFile, game:service("HttpService"):JSONEncode(Main_Features))
        writefile(QZESPFile, game:service("HttpService"):JSONEncode(Object_Visuals))
    end)

elseif Current_Game.Name == "Ragdoll Universe" then
    --LOCALS
    local Players = game:GetService("Players")
    local Mouse = Player:GetMouse()
    local Space = game:GetService("Workspace")
    local Camera = Space.CurrentCamera
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local MainWindow = Library:NewWindow()
    LOADED_START = true

    local DESTROY_GUI = false

    coroutine.wrap(function() -- CAMERA LOOP
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            Camera = Space.CurrentCamera
        end)
    end)()

    -- UNIVERSAL 
    local UniversalCategory = MainWindow:NewPage(_G["pages"], "Universal")

    local Selected_Player = nil

    -- ESP
    local ESPSection = UniversalCategory:NewSection("ESP")

    local ESP_Settings = {
        Names_Toggle = false,
        Text_Size = 15,
        Health = true,
        Boxes_Toggle = false,
        Health_Bar = true,
        Color =  {R = 255, G = 0, B = 175},
        Team_Check = false,
        Team =  {R = 0, G = 255, B = 0},
        Enemy =  {R = 255, G = 0, B = 0},
        Show_Selected = true,
        Selected =  {R = 255, G = 255, B = 255},
        Team_Color = false
    }

    local AIMBOT_Settings = {
        Toggle = false,
        Sensitivity = 0.5,
        Lock_Part = "Head",
        Distance_Type = "Character",
        Team_Check = false,
        FOV_Circle = false,
        FOV_Color = {R = 255, G = 0, B = 175},
        FOV_Radius = 10,
        Tool_Tip = false,
        Tool_Tip_Color = {R = 255, G = 0, B = 175}
    }

    local ESPFile = "BlissX/Universal/ESP.dat"
    local AIMBOTFile = "BlissX/Universal/Aimbot.dat"

    local function LoadESP()
        local u, Result = pcall(readfile, ESPFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if ESP_Settings[i] ~= nil then
                        ESP_Settings[i] = v
                        pcall(ESP_Settings[i], v)
                    end
                end
            end
        end
    end

    local function LoadAIMBOT()
        local u, Result = pcall(readfile, AIMBOTFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if AIMBOT_Settings[i] ~= nil then
                        AIMBOT_Settings[i] = v
                        pcall(AIMBOT_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadESP()
    LoadAIMBOT()

    ESPSection:NewToggle("Names", function (NewValue)
        ESP_Settings.Names_Toggle = NewValue
    end, {default = ESP_Settings.Names_Toggle})

    ESPSection:NewSlider("Text Size", function (NewValue)
        ESP_Settings.Text_Size = NewValue
    end, {value = ESP_Settings.Text_Size, min = 1, max = 75, suffix = " px"})

    ESPSection:NewToggle("Health", function (NewValue)
        ESP_Settings.Health = NewValue
    end, {default = ESP_Settings.Health})

    ESPSection:NewToggle("Boxes", function (NewValue)
        ESP_Settings.Boxes_Toggle = NewValue
    end, {default = ESP_Settings.Boxes_Toggle})

    ESPSection:NewToggle("Health Bar", function (NewValue)
        ESP_Settings.Health_Bar = NewValue
    end, {default = ESP_Settings.Health_Bar})

    ESPSection:NewColorPicker("Color", function (NewValue)
        ESP_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)})

    ESPSection:NewToggle("Team Check", function (NewValue)
        ESP_Settings.Team_Check = NewValue
    end, {default = ESP_Settings.Team_Check})

    ESPSection:NewColorPicker("Team", function (NewValue)
        ESP_Settings.Team = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)})

    ESPSection:NewColorPicker("Enemy", function (NewValue)
        ESP_Settings.Enemy = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)})

    ESPSection:NewToggle("Team Color", function (NewValue)
        ESP_Settings.Team_Color = NewValue
    end, {default = ESP_Settings.Team_Color})

    ESPSection:NewColorPicker("Selected Player", function (NewValue)
        ESP_Settings.Selected = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)})

    ESPSection:NewToggle("Show Selected", function (NewValue)
        ESP_Settings.Show_Selected = NewValue
    end, {default = ESP_Settings.Show_Selected})

    local function NameTag(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")
        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
        NAME.Outline = true
        NAME.OutlineColor = RGB(10, 10, 10)
        NAME.Position = v2(0, 0)
        NAME.Size = ESP_Settings.Text_Size
        NAME.Center = true
        NAME.Font = 3 
        NAME.Text = plr.Name

        local TB = NAME.TextBounds

        local HEALTH = drawing("Text")
        HEALTH.Visible = false
        HEALTH.Transparency = 0.8
        HEALTH.Color = RGB(255, 255, 255)
        HEALTH.Outline = true
        HEALTH.OutlineColor = RGB(10, 10, 10)
        HEALTH.Position = v2(0, 0)
        HEALTH.Size = ESP_Settings.Text_Size
        HEALTH.Font = 3 
        HEALTH.Text = "[]"

        local function Update()
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    HEALTH:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Names_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and char:FindFirstChild("Head") ~= nil and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local Hum = char:FindFirstChildOfClass("Humanoid")
                    Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        NAME.Size = ESP_Settings.Text_Size
                        HEALTH.Size = ESP_Settings.Text_Size

                        -- NAME.Color = ESP_Settings.Color
                        -- NAME.Position = v2(pos.X, pos.Y - TB.Y/2)

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local Top = pos.Y - newsize.Y/2

                        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        NAME.Position = v2(pos.X, Top - TB.Y - 2)

                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                NAME.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                NAME.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end

                        if ESP_Settings.Team_Color then
                            NAME.Color = teamColor.Color
                        end

                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            NAME.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        if ESP_Settings.Health then
                            HEALTH.Text = "["..tostring(round(Hum.Health)).."]"

                            NAME.Position = v2(pos.X - HEALTH.TextBounds.Y, Top - TB.Y - 2)
                            HEALTH.Position = v2(NAME.Position.X + TB.X/2, Top - TB.Y - 2)
                            HEALTH.Visible = true
                        else 
                            HEALTH.Visible = false
                        end

                        NAME.Visible = true
                    else 
                        NAME.Visible = false
                        HEALTH.Visible = false
                    end
                else 
                    if ESP_Settings.Names_Toggle == false and char and char:FindFirstChildOfClass("Humanoid") then 
                        char:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                    NAME.Visible = false
                    HEALTH.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        NAME:Remove()
                        HEALTH:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local function NewLine(color, thickness, transparency)
        local line = drawing("Line")
        line.Visible = false
        line.From = v2(0, 0)
        line.To = v2(0, 0)
        line.Color = color
        line.Thickness = thickness
        line.Transparency = transparency or 1
        return line
    end

    local function DrawBox(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")

        local Box = NewSquare({
            Transparency = 1, 
            Color = RGB(255, 255, 255), 
            Filled = false,
        })

        local Bar = NewLine(RGB(10, 10, 10), 3, 0.75)
        local Health = NewLine(RGB(0, 255, 0), 1)

        local function Update()
            local prevhealth = huge
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    Box:Remove()
                    Bar:Remove()
                    Health:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Boxes_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") ~= nil and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        Box.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                Box.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                Box.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end
                        if ESP_Settings.Team_Color then
                            Box.Color = teamColor.Color
                        end  
                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            Box.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local newpos = v2(pos.X - newsize.X/2, pos.Y - newsize.Y/2)

                        Box.Size = newsize
                        Box.Position = newpos

                        local Right = newpos.X + newsize.X
                        local Top = newpos.Y
                        local Bottom = newpos.Y + newsize.Y

                        if ESP_Settings.Health_Bar then
                            local Hum = char:FindFirstChildOfClass("Humanoid")
                            local Hum_Health = Hum.Health
                            local Hum_MaxHealth = Hum.MaxHealth

                            local offsetX = clamp(round(100/(char.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude), 0, 5)

                            Bar.From = v2(Right + offsetX, Top)
                            Bar.To = v2(Right + offsetX, Bottom)

                            local HealthRatio = Hum_Health / Hum_MaxHealth
                            local Length = abs((Bottom - 1) - (Top + 1))
                                
                            local HealthLength = Length * HealthRatio
                            Health.From = v2(Right + offsetX, Bottom - 1 - HealthLength)
                            Health.To = v2(Right + offsetX, Bottom - 1)

                            if Hum_Health ~= prevhealth then
                                Health.Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))
                                prevhealth = Hum_Health
                            end

                            Health.Visible = true
                            Bar.Visible = true
                        else 
                            Health.Visible = false
                            Bar.Visible = false
                        end

                        Box.Visible = true
                    else 
                        Health.Visible = false
                        Bar.Visible = false
                        Box.Visible = false
                    end
                else
                    Health.Visible = false
                    Bar.Visible = false
                    Box.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        Health:Remove()
                        Bar:Remove()
                        Box:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local t = Players:GetChildren()
    for i = 1, #t do
        local v = t[i]
        if DESTROY_GUI == false and v.Name ~= Player.Name then
            coroutine.wrap(NameTag)(v) 
            coroutine.wrap(DrawBox)(v)
        end
    end

    Players.PlayerAdded:Connect(function(v)
        if DESTROY_GUI == false then
            coroutine.wrap(NameTag)(v)
            coroutine.wrap(DrawBox)(v)
        end
    end)

    -- AIMBOT 
    local AIMBOTSection = UniversalCategory:NewSection("Aimbot")

    AIMBOTSection:NewToggle("Aimbot", function (NewValue)
        AIMBOT_Settings.Toggle = NewValue
    end, {default = AIMBOT_Settings.Toggle})

    AIMBOTSection:NewSlider("Sensitivity", function (NewValue)
        AIMBOT_Settings.Sensitivity = NewValue
    end, {value = AIMBOT_Settings.Sensitivity, min = 0.01, max = 1, suffix = " factor", decimals = 2})

    AIMBOTSection:NewToggle("Team Check", function (NewValue)
        AIMBOT_Settings.Team_Check = NewValue
    end, {default = AIMBOT_Settings.Team_Check})

    do
        local default_option
        local list =  {
            "Head", 
            "Torso", 
            "Feet"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Lock_Part then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Part", function(Option)
            AIMBOT_Settings.Lock_Part = Option
        end, {
            options = list,
            default = default_option
        })
    end

    do
        local default_option
        local list =  {
            "Mouse", 
            "Character"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Distance_Type then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Distance Type", function(Option)
            AIMBOT_Settings.Distance_Type = Option
        end, {
            options = list,
            default = default_option
        })
    end

    AIMBOTSection:NewToggle("FOV Circle", function (NewValue)
        AIMBOT_Settings.FOV_Circle = NewValue
    end, {default = AIMBOT_Settings.FOV_Circle})

    AIMBOTSection:NewColorPicker("FOV Color", function (NewValue)
        AIMBOT_Settings.FOV_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)})

    AIMBOTSection:NewSlider("FOV Radius", function (NewValue)
        AIMBOT_Settings.FOV_Radius = NewValue
    end, {value = AIMBOT_Settings.FOV_Radius, min = 1, max = 400, suffix = "°"})

    local Aiming = false
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = false
        end
    end)

    local FOV = drawing("Circle")
    FOV.Visible = false
    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
    FOV.Position = v2(0, 0)
    FOV.Transparency = 0.6
    FOV.NumSides = 75
    FOV.Radius = AIMBOT_Settings.FOV_Radius
    FOV.Filled = false
    FOV.Thickness = 1

    local function SameTeam(plr)
        local deb = false
        if AIMBOT_Settings.Team_Check then
            if plr.TeamColor == Player.TeamColor then
                deb = true
            else 
                deb = false
            end
        else
            deb = false
        end
        return deb
    end

    local function GetClosest()
        local min = huge
        local closest = nil
        if AIMBOT_Settings.Distance_Type == "Mouse" then
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local dist = (v2(Mouse.X, Mouse.Y) - v2(pos.X, pos.Y)).magnitude
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        else
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local dist = (Player.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        end
        return closest
    end

    coroutine.wrap(function()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            Selected_Player = GetClosest()
        end)
    end)()

    local inset = game:GetService("GuiService"):GetGuiInset()

    local function Aimbot_Start()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                FOV:Remove()
                c:Disconnect()
            end
            if AIMBOT_Settings.Toggle then
                
                if AIMBOT_Settings.FOV_Circle then
                    FOV.Radius = AIMBOT_Settings.FOV_Radius
                    FOV.Thickness = 1
                    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
        
                    FOV.Position = v2(Mouse.X, Mouse.Y + 36)
                    FOV.Visible = true
                else 
                    FOV.Radius = 2000
        
                    FOV.Position = Camera.ViewportSize / 2
                    FOV.Visible = false
                end

                if Aiming and Selected_Player ~= nil then
                    local char = Selected_Player.Character
                    local pos
                    local part = AIMBOT_Settings.Lock_Part
                    if part == "Head" then
                        pos = Camera:WorldToViewportPoint(char.Head.Position)
                    elseif part == "Torso" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    elseif part == "Feet" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position - v3(0, 2.5, 0))
                    end
                    local sens = AIMBOT_Settings.Sensitivity
                    mousemoverel((pos.X - Mouse.X) * sens, (pos.Y - Mouse.Y - inset.Y) * sens)
                end
            else 
                FOV.Visible = false
            end
        end)
    end
    coroutine.wrap(Aimbot_Start)()

    AIMBOTSection:NewToggle("Show Player Tooltip", function (NewValue)
        AIMBOT_Settings.Tool_Tip = NewValue
    end, {default = AIMBOT_Settings.Tool_Tip})

    AIMBOTSection:NewColorPicker("Name Color", function (NewValue)
        AIMBOT_Settings.Tool_Tip_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)})

    coroutine.wrap(function() -- PLAYER TOOLTIP
        local HealthBarThickness = 5
        local Tip_Library = {
            [1] = NewSquare({ -- Tip
                Transparency = 0.75, 
                Color = RGB(10, 10, 10), 
                Size = v2(300, 50),
                Position = v2(810, 10),
                Filled = true
            }),
            [2] = NewText({ -- Name
                Transparency = 1, 
                Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B), 
                TextSize = 15,
                Font = 3,
                Position = v2(816, 12)
            }),
            [3] = NewText({ -- Health_Text
                Transparency = 1, 
                Color = RGB(225, 225, 225), 
                TextSize = 15,
                Font = 3,
                Position = v2(814, 30),
            }),
            [4] = NewSquare({ -- Bar
                Transparency = 0.75, 
                Color = RGB(50, 50, 50), 
                Size = v2(292, HealthBarThickness),
                Position = v2(814, 50),
                Filled = true
            }),
            [5] = NewSquare({ -- Health
                Transparency = 1, 
                Color = RGB(0, 255, 0), 
                Size = v2(290, HealthBarThickness - 2),
                Position = v2(815, 51),
                Filled = true
            })
        }
        local function Visibility(state)
            for i = 1, #Tip_Library do
                local v = Tip_Library[i]
                v.Visible = state
            end
        end

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i = 1, #Tip_Library do
                    local v = Tip_Library[i]
                    v:Remove()
                end
            end
            if AIMBOT_Settings.Tool_Tip then
                if Selected_Player ~= nil then
                    local char = Selected_Player
                    local Hum = char.Character:FindFirstChildOfClass("Humanoid")
                    local Hum_Health = Hum.Health
                    local Hum_MaxHealth = Hum.MaxHealth

                    -- TEXTS
                    Tip_Library[2].Text = Selected_Player.Name
                    Tip_Library[3].Text = "["..round(Hum_Health).."/"..round(Hum_MaxHealth).."]"

                    -- HEALTH BAR
                    local HealthRatio = Hum_Health / Hum_MaxHealth
                    local Length = abs((Tip_Library[4].Position.X + Tip_Library[4].Size.X) - Tip_Library[4].Position.X)

                    local HealthLength = Length * HealthRatio
                    Tip_Library[5].Size = v2(HealthLength, Tip_Library[5].Size.Y)
                    Tip_Library[5].Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))

                    Tip_Library[2].Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)
                    Visibility(true)
                else 
                    Visibility(false)
                end
            else 
                Visibility(false)
            end
        end)
    end)()
    
    -- RAGDOLL MAIN
    local MAIN_FeaturesCategory = MainWindow:NewPage(_G["pages"], "Ragdoll Universe")

    local GUNSection = MAIN_FeaturesCategory:NewSection("Weapon")

    local GUN_Settings = {
        Fast_Fire = false,
        No_Recoil = false,
        No_Spread = false,
        Fast_Bullet = false,
        No_Fall_Off = false,
        Automatic = false,
        Thick_Bullet = false,
    }

    local RAGDOLLFile = "BlissX/Ragdoll/Main.dat"

    local function LoadRAGDOLL()
        local u, Result = pcall(readfile, RAGDOLLFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if GUN_Settings[i] ~= nil then
                        GUN_Settings[i] = v
                        pcall(GUN_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadRAGDOLL()

    GUNSection:NewToggle("Fast Fire", function (NewValue)
        GUN_Settings.Fast_Fire = NewValue
    end, {default = GUN_Settings.Fast_Fire})

    GUNSection:NewToggle("No Recoil", function (NewValue)
        GUN_Settings.No_Recoil = NewValue
    end, {default = GUN_Settings.No_Recoil})

    GUNSection:NewToggle("No Spread", function (NewValue)
        GUN_Settings.No_Spread = NewValue
    end, {default = GUN_Settings.No_Spread})

    GUNSection:NewToggle("Fast Bullet", function (NewValue)
        GUN_Settings.Fast_Bullet = NewValue
    end, {default = GUN_Settings.Fast_Bullet})

    GUNSection:NewToggle("No Fall Off", function (NewValue)
        GUN_Settings.No_Fall_Off = NewValue
    end, {default = GUN_Settings.No_Fall_Off})

    GUNSection:NewToggle("Automatic", function (NewValue)
        GUN_Settings.Automatic = NewValue
    end, {default = GUN_Settings.Automatic})

    GUNSection:NewToggle("Thick Bullet", function (NewValue)
        GUN_Settings.Thick_Bullet = NewValue
    end, {default = GUN_Settings.Thick_Bullet})

    local function GetCurrentGun()
        local tool = Player.Character:FindFirstChildOfClass("Tool") 
        if Player.Character ~= nil and tool ~= nil and tool.Class.Value == "Weapon" then
            return tool
        end
        return nil
    end

    coroutine.wrap(function()
        local c 
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            local gun = GetCurrentGun()
            if gun ~= nil then
                if GUN_Settings.Fast_Fire then
                    gun.Configuration.Cooldown.Value = 0.02
                end
                if GUN_Settings.Fast_Bullet then
                    gun.Configuration.BulletSpeed.Value = 4000
                end
                if GUN_Settings.No_Fall_Off then
                    gun.Configuration.FalloffDistance.Value = 10000
                end
                if GUN_Settings.No_Recoil then
                    gun.Configuration.Recoil.Value = 0
                end
                if GUN_Settings.No_Spread then
                    gun.Configuration.SpreadAim.Value = 0
                    gun.Configuration.Spread.Value = 0
                    gun.Configuration.RecoilSpread.Value = 0
                end
                if GUN_Settings.Automatic then
                    gun.Configuration.Automatic.Value = true
                end
            end
        end)
        while wait(1) do
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Character ~= nil and v.Name ~= Player.Name and v.Character:FindFirstChild("Head") then
                    if GUN_Settings.Thick_Bullet then
                        v.Character.Head.Size = v3(5.99, 5.99, 5.99)
                        v.Character.Head.Transparency = 1
                    else
                        v.Character.Head.Size = v3(1, 1, 1)
                        v.Character.Head.Transparency = 0
                    end
                end
            end
        end
    end)()

    -- VISUALS
    local VISUALSCategory = MainWindow:NewPage(_G["pages"], "Visuals")

    -- SCREEN STUFF
    local SCREENSection = VISUALSCategory:NewSection("Screen")

    local Stats_Settings = {
        ShowFPS = false,
        ShowPing = false,
        ShowPosition = false,
        Color = {R = 255, G = 0, B = 175},
        Text_Size = 18,
        Max_Zoom_Distance = 100,
        Tool_Tip = false,
    }

    local STATSFile = "BlissX/Universal/ScreenStats.dat"

    local function LoadSTATS()
        local u, Result = pcall(readfile, STATSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Stats_Settings[i] ~= nil then
                        Stats_Settings[i] = v
                        pcall(Stats_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadSTATS()

    SCREENSection:NewToggle("Show FPS", function (NewValue)
        Stats_Settings.ShowFPS = NewValue
    end, {default = Stats_Settings.ShowFPS})

    SCREENSection:NewToggle("Show Ping", function (NewValue)
        Stats_Settings.ShowPing = NewValue
    end, {default = Stats_Settings.ShowPing})

    SCREENSection:NewToggle("Show Position", function (NewValue)
        Stats_Settings.ShowPosition = NewValue
    end, {default = Stats_Settings.ShowPosition})

    SCREENSection:NewColorPicker("Color", function (NewValue)
        Stats_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)})

    SCREENSection:NewSlider("Text Size", function (NewValue)
        Stats_Settings.Text_Size = NewValue
    end, {value = Stats_Settings.Text_Size, min = 1, max = 50, suffix = " px"})

    SCREENSection:NewSlider("Max Zoom Distance", function (NewValue)
        Stats_Settings.Max_Zoom_Distance = NewValue
    end, {value = Stats_Settings.Max_Zoom_Distance, min = 1, max = 5000, suffix = " studs"})

    coroutine.wrap(function() -- LOOP
        local function NewText()
            local t = drawing("Text")
            t.Visible = false
            t.Transparency = 0.8
            t.Color = RGB(255, 255, 255)
            t.Outline = true
            t.OutlineColor = RGB(10, 10, 10)
            t.Position = v2(0, 0)
            t.Size = 20
            t.Center = false
            t.Font = 3 
            t.Text = ""
            return t
        end
        local FPS = NewText()
        local PING = NewText()
        local POSITION = NewText()
        local c
        c = RS.RenderStepped:Connect(function(step)
            local fps_stat = 1/step
            if DESTROY_GUI then
                c:Disconnect()
                PING:Remove()
                FPS:Remove()
                POSITION:Remove()
            end
            local stats_col = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)
            if Stats_Settings.ShowFPS then
                FPS.Size = Stats_Settings.Text_Size
                FPS.Text = "FPS: "..tostring(round(fps_stat))
                FPS.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y)
                FPS.Color = stats_col
                FPS.Visible = true
            else 
                FPS.Visible = false
            end
            Player.CameraMaxZoomDistance = Stats_Settings.Max_Zoom_Distance
            if Stats_Settings.ShowPing then
                local ping_stat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                PING.Size = Stats_Settings.Text_Size
                PING.Text = "PING: "..tostring(round(ping_stat))
                PING.Color = stats_col
                PING.Visible = true

                local PingB = PING.TextBounds
                if FPS.Visible == false then
                    PING.Position = v2(5, Camera.ViewportSize.Y - PingB.Y)
                else
                    PING.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y - PingB.Y)
                end
            else 
                PING.Visible = false
            end
            if Stats_Settings.ShowPosition then
                if Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos_stat = Player.Character.PrimaryPart.Position
                    POSITION.Size = Stats_Settings.Text_Size
                    POSITION.Text = "POSITION: "..round(pos_stat.X).." "..round(pos_stat.Y).." "..round(pos_stat.Z)
                    POSITION.Color = stats_col
                    POSITION.Visible = true

                    local PB = POSITION.TextBounds
                    local FP = FPS.TextBounds
                    if FPS.Visible == false and PING.Visible == false then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y)
                    elseif (FPS.Visible and PING.Visible == false) or (FPS.Visible == false and PING.Visible == true) then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y)
                    elseif FPS.Visible and PING.Visible then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y*2)
                    end
                else 
                    POSITION.Visible = false
                end
            else 
                POSITION.Visible = false
            end
        end)
    end)()

    local CROSSHAIRSection = VISUALSCategory:NewSection("Crosshair")

    local Crosshair_Settings = {
        Enabled = false,
        Color = {R = 0, G = 255, B = 0},
        Lock = "Mouse",
        Size = 5,
        Offset = 2,
        Thickness = 1
    }

    local CROSSHAIRFile = "BlissX/Universal/Crosshair.dat"

    local function LoadCROSSHAIR()
        local u, Result = pcall(readfile, CROSSHAIRFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Crosshair_Settings[i] ~= nil then
                        Crosshair_Settings[i] = v
                        pcall(Crosshair_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadCROSSHAIR()

    CROSSHAIRSection:NewToggle("Custom Crosshair", function (NewValue)
        Crosshair_Settings.Enabled = NewValue
    end, {default = Crosshair_Settings.Enabled})

    CROSSHAIRSection:NewColorPicker("Color", function (NewValue)
        Crosshair_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)})

    CROSSHAIRSection:NewSlider("Size", function (NewValue)
        Crosshair_Settings.Size = NewValue
    end, {value = Crosshair_Settings.Size, min = 1, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Offset", function (NewValue)
        Crosshair_Settings.Offset = NewValue
    end, {value = Crosshair_Settings.Offset, min = 0, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Thickness", function (NewValue)
        Crosshair_Settings.Thickness = NewValue
    end, {value = Crosshair_Settings.Thickness, min = 1, max = 40, suffix = ""})

    do
        local default_option
        local list =  {
            "Mouse", 
            "Center"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Crosshair_Settings.Lock then
                default_option = i
            end
        end
        CROSSHAIRSection:NewDropdown("Lock", function(Option)
            Crosshair_Settings.Lock = Option
        end, {
            options = list,
            default = default_option
        })
    end


    coroutine.wrap(function()
        local inset = game:service("GuiService"):GetGuiInset()
        local lines = { -- CROSSHAIR LINES
            up = NewLine(RGB(255, 0, 0), 1, 1),
            down = NewLine(RGB(255, 0, 0), 1, 1),
            left = NewLine(RGB(255, 0, 0), 1, 1),
            right = NewLine(RGB(255, 0, 0), 1, 1)
        }
        local c 
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i,v in pairs(lines) do
                    v:Remove()
                end
                c:Disconnect()
            end
            if Crosshair_Settings.Enabled then
                local center = v2(0,0)
                if Crosshair_Settings.Lock == "Mouse" then
                    center = v2(Mouse.X, Mouse.Y + inset.Y)
                elseif Crosshair_Settings.Lock == "Center" then
                    center = Camera.ViewportSize/2
                else 
                    center = Camera.ViewportSize/2
                end
    
                lines.up.From = center - v2(0, Crosshair_Settings.Offset)
                lines.up.To = center - v2(0, Crosshair_Settings.Offset) - v2(0, Crosshair_Settings.Size)

                lines.down.From = center + v2(0, Crosshair_Settings.Offset)
                lines.down.To = center + v2(0, Crosshair_Settings.Offset) + v2(0, Crosshair_Settings.Size)

                lines.left.From = center - v2(Crosshair_Settings.Offset, 0)
                lines.left.To = center - v2(Crosshair_Settings.Offset, 0) - v2(Crosshair_Settings.Size, 0)

                lines.right.From = center + v2(Crosshair_Settings.Offset, 0)
                lines.right.To = center + v2(Crosshair_Settings.Offset, 0) + v2(Crosshair_Settings.Size, 0)

                local crosshair_col = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)
                for i,v in pairs(lines) do
                    v.Color = crosshair_col
                    v.Thickness = Crosshair_Settings.Thickness
                    v.Visible = true
                end
            else 
                for i,v in pairs(lines) do
                    v.Visible = false
                end
            end
        end)
    end)()

    -- GUI (LAST)
    local GUI_Settings = {
        theme = "Fire",
        toggle_bind = "End"
    }
    
    local GUIFile = "BlissX/Universal/GUI.dat"

    local function LoadGUI()
        local u, Result = pcall(readfile, GUIFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if GUI_Settings[i] ~= nil then
                        GUI_Settings[i] = v
                        pcall(GUI_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadGUI()

    _G["Theme"] = themes[GUI_Settings.theme]
    MainWindow:UpdateTheme()

    local GUICategory = MainWindow:NewPage(_G["pages"], "Settings")

    local GUISection = GUICategory:NewSection("GUI")

    GUISection:NewKeybind("Toggle", function(newbind)
        GUI_Settings.toggle_bind = string.sub(tostring(newbind), 14, #tostring(newbind))
        MainWindow:Toggle()
    end, {keybind = Enum.KeyCode[GUI_Settings.toggle_bind]})

    do
        local default_option
        local list =  {
            "Fire",
            "Forest",
            "Ocean",
            "Grayscale",
            "Midnight",
        }
        for i = 1, #list do
            local v = list[i]
            if v == GUI_Settings.theme then
                default_option = i
            end
        end
        GUISection:NewDropdown("Theme", function(Option)
            GUI_Settings.theme = Option
            _G["Theme"] = themes[Option]
            MainWindow:UpdateTheme()
        end, {
            options = list,
            default = default_option
        })
    end

    GUISection:NewButton("Update Theme", function()
        MainWindow:UpdateTheme()
    end)

    GUISection:NewButton("Kill", function()
        DESTROY_GUI = true
        MainWindow:Kill()
    end)

    GUISection:NewButton("Save Config", function()
        writefile(ESPFile, game:service("HttpService"):JSONEncode(ESP_Settings))
        writefile(AIMBOTFile, game:service("HttpService"):JSONEncode(AIMBOT_Settings))
        writefile(RAGDOLLFile, game:service("HttpService"):JSONEncode(GUN_Settings))
        writefile(STATSFile, game:service("HttpService"):JSONEncode(Stats_Settings))
        writefile(CROSSHAIRFile, game:service("HttpService"):JSONEncode(Crosshair_Settings))
        writefile(GUIFile, game:service("HttpService"):JSONEncode(GUI_Settings))
    end)

elseif Current_Game.Name == "Criminality" then
    --LOCALS
    local Players = game:GetService("Players")
    local Mouse = Player:GetMouse()
    local Camera = game:GetService("Workspace").CurrentCamera
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local MainWindow = Library:NewWindow()
    LOADED_START = true

    local DESTROY_GUI = false

    -- UNIVERSAL 
    local UniversalCategory = MainWindow:NewPage(_G["pages"], "Universal")

    local Selected_Player = nil

    -- ESP
    local ESPSection = UniversalCategory:NewSection("ESP")

    local ESP_Settings = {
        Names_Toggle = false,
        Text_Size = 15,
        Health = true,
        Boxes_Toggle = false,
        Health_Bar = true,
        Color =  {R = 255, G = 0, B = 175},
        Team_Check = false,
        Team =  {R = 0, G = 255, B = 0},
        Enemy =  {R = 255, G = 0, B = 0},
        Show_Selected = true,
        Selected =  {R = 255, G = 255, B = 255},
        Team_Color = false
    }

    local AIMBOT_Settings = {
        Toggle = false,
        Sensitivity = 0.5,
        Lock_Part = "Head",
        Distance_Type = "Character",
        Team_Check = false,
        FOV_Circle = false,
        FOV_Color = {R = 255, G = 0, B = 175},
        FOV_Radius = 10,
        Tool_Tip = false,
        Tool_Tip_Color = {R = 255, G = 0, B = 175}
    }

    local ESPFile = "BlissX/Universal/ESP.dat"
    local AIMBOTFile = "BlissX/Universal/Aimbot.dat"

    local function LoadESP()
        local u, Result = pcall(readfile, ESPFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if ESP_Settings[i] ~= nil then
                        ESP_Settings[i] = v
                        pcall(ESP_Settings[i], v)
                    end
                end
            end
        end
    end

    local function LoadAIMBOT()
        local u, Result = pcall(readfile, AIMBOTFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if AIMBOT_Settings[i] ~= nil then
                        AIMBOT_Settings[i] = v
                        pcall(AIMBOT_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadESP()
    LoadAIMBOT()

    ESPSection:NewToggle("Names", function (NewValue)
        ESP_Settings.Names_Toggle = NewValue
    end, {default = ESP_Settings.Names_Toggle})

    ESPSection:NewSlider("Text Size", function (NewValue)
        ESP_Settings.Text_Size = NewValue
    end, {value = ESP_Settings.Text_Size, min = 1, max = 75, suffix = " px"})

    ESPSection:NewToggle("Health", function (NewValue)
        ESP_Settings.Health = NewValue
    end, {default = ESP_Settings.Health})

    ESPSection:NewToggle("Boxes", function (NewValue)
        ESP_Settings.Boxes_Toggle = NewValue
    end, {default = ESP_Settings.Boxes_Toggle})

    ESPSection:NewToggle("Health Bar", function (NewValue)
        ESP_Settings.Health_Bar = NewValue
    end, {default = ESP_Settings.Health_Bar})

    ESPSection:NewColorPicker("Color", function (NewValue)
        ESP_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)})

    ESPSection:NewToggle("Team Check", function (NewValue)
        ESP_Settings.Team_Check = NewValue
    end, {default = ESP_Settings.Team_Check})

    ESPSection:NewColorPicker("Team", function (NewValue)
        ESP_Settings.Team = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)})

    ESPSection:NewColorPicker("Enemy", function (NewValue)
        ESP_Settings.Enemy = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)})

    ESPSection:NewToggle("Team Color", function (NewValue)
        ESP_Settings.Team_Color = NewValue
    end, {default = ESP_Settings.Team_Color})

    ESPSection:NewColorPicker("Selected Player", function (NewValue)
        ESP_Settings.Selected = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)})

    ESPSection:NewToggle("Show Selected", function (NewValue)
        ESP_Settings.Show_Selected = NewValue
    end, {default = ESP_Settings.Show_Selected})

    local function NameTag(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")
        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
        NAME.Outline = true
        NAME.OutlineColor = RGB(10, 10, 10)
        NAME.Position = v2(0, 0)
        NAME.Size = ESP_Settings.Text_Size
        NAME.Center = true
        NAME.Font = 3 
        NAME.Text = plr.Name

        local TB = NAME.TextBounds

        local HEALTH = drawing("Text")
        HEALTH.Visible = false
        HEALTH.Transparency = 0.8
        HEALTH.Color = RGB(255, 255, 255)
        HEALTH.Outline = true
        HEALTH.OutlineColor = RGB(10, 10, 10)
        HEALTH.Position = v2(0, 0)
        HEALTH.Size = ESP_Settings.Text_Size
        HEALTH.Font = 3 
        HEALTH.Text = "[]"

        local function Update()
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    HEALTH:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Names_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and char:FindFirstChild("Head") ~= nil and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local Hum = char:FindFirstChildOfClass("Humanoid")
                    Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        NAME.Size = ESP_Settings.Text_Size
                        HEALTH.Size = ESP_Settings.Text_Size

                        -- NAME.Color = ESP_Settings.Color
                        -- NAME.Position = v2(pos.X, pos.Y - TB.Y/2)

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local Top = pos.Y - newsize.Y/2

                        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        NAME.Position = v2(pos.X, Top - TB.Y - 2)

                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                NAME.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                NAME.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end

                        if ESP_Settings.Team_Color then
                            NAME.Color = teamColor.Color
                        end

                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            NAME.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        if ESP_Settings.Health then
                            HEALTH.Text = "["..tostring(round(Hum.Health)).."]"

                            NAME.Position = v2(pos.X - HEALTH.TextBounds.Y, Top - TB.Y - 2)
                            HEALTH.Position = v2(NAME.Position.X + TB.X/2, Top - TB.Y - 2)
                            HEALTH.Visible = true
                        else 
                            HEALTH.Visible = false
                        end

                        NAME.Visible = true
                    else 
                        NAME.Visible = false
                        HEALTH.Visible = false
                    end
                else 
                    if ESP_Settings.Names_Toggle == false and char and char:FindFirstChildOfClass("Humanoid") then 
                        char:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                    NAME.Visible = false
                    HEALTH.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        NAME:Remove()
                        HEALTH:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local function NewLine(color, thickness, transparency)
        local line = drawing("Line")
        line.Visible = false
        line.From = v2(0, 0)
        line.To = v2(0, 0)
        line.Color = color
        line.Thickness = thickness
        line.Transparency = transparency or 1
        return line
    end

    local function DrawBox(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")

        local Box = NewSquare({
            Transparency = 1, 
            Color = RGB(255, 255, 255), 
            Filled = false,
        })

        local Bar = NewLine(RGB(10, 10, 10), 3, 0.75)
        local Health = NewLine(RGB(0, 255, 0), 1)

        local function Update()
            local prevhealth = huge
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    Box:Remove()
                    Bar:Remove()
                    Health:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Boxes_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") ~= nil and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        Box.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                Box.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                Box.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end
                        if ESP_Settings.Team_Color then
                            Box.Color = teamColor.Color
                        end  
                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            Box.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local newpos = v2(pos.X - newsize.X/2, pos.Y - newsize.Y/2)

                        Box.Size = newsize
                        Box.Position = newpos

                        local Right = newpos.X + newsize.X
                        local Top = newpos.Y
                        local Bottom = newpos.Y + newsize.Y

                        if ESP_Settings.Health_Bar then
                            local Hum = char:FindFirstChildOfClass("Humanoid")
                            local Hum_Health = Hum.Health
                            local Hum_MaxHealth = Hum.MaxHealth

                            local offsetX = clamp(round(100/(char.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude), 0, 5)

                            Bar.From = v2(Right + offsetX, Top)
                            Bar.To = v2(Right + offsetX, Bottom)

                            local HealthRatio = Hum_Health / Hum_MaxHealth
                            local Length = abs((Bottom - 1) - (Top + 1))
                                
                            local HealthLength = Length * HealthRatio
                            Health.From = v2(Right + offsetX, Bottom - 1 - HealthLength)
                            Health.To = v2(Right + offsetX, Bottom - 1)

                            if Hum_Health ~= prevhealth then
                                Health.Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))
                                prevhealth = Hum_Health
                            end

                            Health.Visible = true
                            Bar.Visible = true
                        else 
                            Health.Visible = false
                            Bar.Visible = false
                        end

                        Box.Visible = true
                    else 
                        Health.Visible = false
                        Bar.Visible = false
                        Box.Visible = false
                    end
                else
                    Health.Visible = false
                    Bar.Visible = false
                    Box.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        Health:Remove()
                        Bar:Remove()
                        Box:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local t = Players:GetChildren()
    for i = 1, #t do
        local v = t[i]
        if DESTROY_GUI == false and v.Name ~= Player.Name then
            coroutine.wrap(NameTag)(v) 
            coroutine.wrap(DrawBox)(v)
        end
    end

    Players.PlayerAdded:Connect(function(v)
        if DESTROY_GUI == false then
            coroutine.wrap(NameTag)(v)
            coroutine.wrap(DrawBox)(v)
        end
    end)

    -- AIMBOT 
    local AIMBOTSection = UniversalCategory:NewSection("Aimbot")

    AIMBOTSection:NewToggle("Aimbot", function (NewValue)
        AIMBOT_Settings.Toggle = NewValue
    end, {default = AIMBOT_Settings.Toggle})

    AIMBOTSection:NewSlider("Sensitivity", function (NewValue)
        AIMBOT_Settings.Sensitivity = NewValue
    end, {value = AIMBOT_Settings.Sensitivity, min = 0.01, max = 1, suffix = " factor", decimals = 2})

    AIMBOTSection:NewToggle("Team Check", function (NewValue)
        AIMBOT_Settings.Team_Check = NewValue
    end, {default = AIMBOT_Settings.Team_Check})

    do
        local default_option
        local list =  {
            "Head", 
            "Torso", 
            "Feet"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Lock_Part then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Part", function(Option)
            AIMBOT_Settings.Lock_Part = Option
        end, {
            options = list,
            default = default_option
        })
    end

    do
        local default_option
        local list =  {
            "Mouse", 
            "Character"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Distance_Type then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Distance Type", function(Option)
            AIMBOT_Settings.Distance_Type = Option
        end, {
            options = list,
            default = default_option
        })
    end

    AIMBOTSection:NewToggle("FOV Circle", function (NewValue)
        AIMBOT_Settings.FOV_Circle = NewValue
    end, {default = AIMBOT_Settings.FOV_Circle})

    AIMBOTSection:NewColorPicker("FOV Color", function (NewValue)
        AIMBOT_Settings.FOV_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)})

    AIMBOTSection:NewSlider("FOV Radius", function (NewValue)
        AIMBOT_Settings.FOV_Radius = NewValue
    end, {value = AIMBOT_Settings.FOV_Radius, min = 1, max = 400, suffix = "°"})

    local Aiming = false
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = false
        end
    end)

    local FOV = drawing("Circle")
    FOV.Visible = false
    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
    FOV.Position = v2(0, 0)
    FOV.Transparency = 0.6
    FOV.NumSides = 75
    FOV.Radius = AIMBOT_Settings.FOV_Radius
    FOV.Filled = false
    FOV.Thickness = 1

    local function SameTeam(plr)
        local deb = false
        if AIMBOT_Settings.Team_Check then
            if plr.TeamColor == Player.TeamColor then
                deb = true
            else 
                deb = false
            end
        else
            deb = false
        end
        return deb
    end

    local function GetClosest()
        local min = huge
        local closest = nil
        if AIMBOT_Settings.Distance_Type == "Mouse" then
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local dist = (v2(Mouse.X, Mouse.Y) - v2(pos.X, pos.Y)).magnitude
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        else
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local dist = (Player.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        end
        return closest
    end

    coroutine.wrap(function()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            Selected_Player = GetClosest()
        end)
    end)()

    local inset = game:GetService("GuiService"):GetGuiInset()

    local function Aimbot_Start()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                FOV:Remove()
                c:Disconnect()
            end
            if AIMBOT_Settings.Toggle then
                
                if AIMBOT_Settings.FOV_Circle then
                    FOV.Radius = AIMBOT_Settings.FOV_Radius
                    FOV.Thickness = 1
                    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
        
                    FOV.Position = v2(Mouse.X, Mouse.Y + 36)
                    FOV.Visible = true
                else 
                    FOV.Radius = 2000
        
                    FOV.Position = Camera.ViewportSize / 2
                    FOV.Visible = false
                end

                if Aiming and Selected_Player ~= nil then
                    local char = Selected_Player.Character
                    local pos
                    local part = AIMBOT_Settings.Lock_Part
                    if part == "Head" then
                        pos = Camera:WorldToViewportPoint(char.Head.Position)
                    elseif part == "Torso" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    elseif part == "Feet" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position - v3(0, 2.5, 0))
                    end
                    local sens = AIMBOT_Settings.Sensitivity
                    mousemoverel((pos.X - Mouse.X) * sens, (pos.Y - Mouse.Y - inset.Y) * sens)
                end
            else 
                FOV.Visible = false
            end
        end)
    end
    coroutine.wrap(Aimbot_Start)()

    AIMBOTSection:NewToggle("Show Player Tooltip", function (NewValue)
        AIMBOT_Settings.Tool_Tip = NewValue
    end, {default = AIMBOT_Settings.Tool_Tip})

    AIMBOTSection:NewColorPicker("Name Color", function (NewValue)
        AIMBOT_Settings.Tool_Tip_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)})

    coroutine.wrap(function() -- PLAYER TOOLTIP
        local HealthBarThickness = 5
        local Tip_Library = {
            [1] = NewSquare({ -- Tip
                Transparency = 0.75, 
                Color = RGB(10, 10, 10), 
                Size = v2(300, 50),
                Position = v2(810, 10),
                Filled = true
            }),
            [2] = NewText({ -- Name
                Transparency = 1, 
                Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B), 
                TextSize = 15,
                Font = 3,
                Position = v2(816, 12)
            }),
            [3] = NewText({ -- Health_Text
                Transparency = 1, 
                Color = RGB(225, 225, 225), 
                TextSize = 15,
                Font = 3,
                Position = v2(814, 30),
            }),
            [4] = NewSquare({ -- Bar
                Transparency = 0.75, 
                Color = RGB(50, 50, 50), 
                Size = v2(292, HealthBarThickness),
                Position = v2(814, 50),
                Filled = true
            }),
            [5] = NewSquare({ -- Health
                Transparency = 1, 
                Color = RGB(0, 255, 0), 
                Size = v2(290, HealthBarThickness - 2),
                Position = v2(815, 51),
                Filled = true
            })
        }
        local function Visibility(state)
            for i = 1, #Tip_Library do
                local v = Tip_Library[i]
                v.Visible = state
            end
        end

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i = 1, #Tip_Library do
                    local v = Tip_Library[i]
                    v:Remove()
                end
            end
            if AIMBOT_Settings.Tool_Tip then
                if Selected_Player ~= nil then
                    local char = Selected_Player
                    local Hum = char.Character:FindFirstChildOfClass("Humanoid")
                    local Hum_Health = Hum.Health
                    local Hum_MaxHealth = Hum.MaxHealth

                    -- TEXTS
                    Tip_Library[2].Text = Selected_Player.Name
                    Tip_Library[3].Text = "["..round(Hum_Health).."/"..round(Hum_MaxHealth).."]"

                    -- HEALTH BAR
                    local HealthRatio = Hum_Health / Hum_MaxHealth
                    local Length = abs((Tip_Library[4].Position.X + Tip_Library[4].Size.X) - Tip_Library[4].Position.X)

                    local HealthLength = Length * HealthRatio
                    Tip_Library[5].Size = v2(HealthLength, Tip_Library[5].Size.Y)
                    Tip_Library[5].Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))

                    Tip_Library[2].Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)
                    Visibility(true)
                else 
                    Visibility(false)
                end
            else 
                Visibility(false)
            end
        end)
    end)()


    -- CRIMINALITY
    local CRIMCategory = MainWindow:NewPage(_G["pages"], "Criminality")

    local Selected_Player = nil

    local CRIMVISUALSection = CRIMCategory:NewSection("Visuals")

    local CRIM_Settings = {
        Safe_ESP = false,
        Safe_Color = {R = 110, G = 240, B = 150},
        Safe_Text_Size = 15,
        Only_Fresh = false,
        Scraps = false,
        Scraps_Color = {R = 110, G = 110, B = 255},
        Scraps_Text_Size = 15
    }

    local CRIMINALITYESP = "BlissX/Criminality/ESP.dat"

    local function LoadCRIMESP()
        local u, Result = pcall(readfile, CRIMINALITYESP)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if CRIM_Settings[i] ~= nil then
                        CRIM_Settings[i] = v
                        pcall(CRIM_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadCRIMESP()

    CRIMVISUALSection:NewToggle("Safe + Register", function (NewValue)
        CRIM_Settings.Safe_ESP = NewValue
    end, {default = CRIM_Settings.Safe_ESP})

    CRIMVISUALSection:NewColorPicker("Color", function (NewValue)
        CRIM_Settings.Safe_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(CRIM_Settings.Safe_Color.R, CRIM_Settings.Safe_Color.G, CRIM_Settings.Safe_Color.B)})

    CRIMVISUALSection:NewSlider("Text Size", function (NewValue)
        CRIM_Settings.Safe_Text_Size = NewValue
    end, {value = CRIM_Settings.Safe_Text_Size, min = 5, max = 50, suffix = " px"})

    CRIMVISUALSection:NewToggle("Only Show Fresh", function (NewValue)
        CRIM_Settings.Only_Fresh = NewValue
    end, {default = CRIM_Settings.Only_Fresh})

    CRIMVISUALSection:NewToggle("Scraps", function (NewValue)
        CRIM_Settings.Scraps = NewValue
    end, {default = CRIM_Settings.Scraps})

    CRIMVISUALSection:NewColorPicker("Color", function (NewValue)
        CRIM_Settings.Scraps_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(CRIM_Settings.Scraps_Color.R, CRIM_Settings.Scraps_Color.G, CRIM_Settings.Scraps_Color.B)})

    CRIMVISUALSection:NewSlider("Text Size", function (NewValue)
        CRIM_Settings.Scraps_Text_Size = NewValue
    end, {value = CRIM_Settings.Scraps_Text_Size, min = 5, max = 50, suffix = " px"})

    local BredMakurz = game:GetService("Workspace").Map:WaitForChild("BredMakurz")
    local function ESPSafe(v)
        local nameof = v.Name

        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(0,0,0)
        NAME.Outline = true
        NAME.OutlineColor = RGB(0, 0, 0)
        NAME.Position = v2(0, 0)
        NAME.Size = CRIM_Settings.Safe_Text_Size
        NAME.Center = true
        NAME.Font = 3 
        
        if match(v.Name, "Register") then
            NAME.Text = "Register"
        elseif match(v.Name, "MediumSafe") then
            NAME.Text = "Medium Safe"
        elseif match(v.Name, "SmallSafe") then
            NAME.Text = "Small Safe"
        else 
            NAME.Text = "????"
        end

        local STATE = drawing("Text")
        STATE.Visible = false
        STATE.Transparency = 0.8
        STATE.Color = RGB(255, 255, 255)
        STATE.Outline = true
        STATE.OutlineColor = RGB(0, 0, 0)
        STATE.Position = v2(0, 0)
        STATE.Size = CRIM_Settings.Safe_Text_Size
        STATE.Font = 3 
        STATE.Text = "[]"

        local function Update()
            local c 
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    STATE:Remove()
                    c:Disconnect()
                end
                if CRIM_Settings.Safe_ESP and v.Parent ~= nil and v.Parent.Parent ~= nil then
                    if v.PrimaryPart ~= nil then
                        local pos, vis = Camera:WorldToViewportPoint(v.PrimaryPart.Position)
                        if vis and v:FindFirstChild("Values") ~= nil then
                            NAME.Position = v2(pos.X, pos.Y)
                            NAME.Color = RGB(CRIM_Settings.Safe_Color.R, CRIM_Settings.Safe_Color.G, CRIM_Settings.Safe_Color.B)

                            NAME.Size = CRIM_Settings.Safe_Text_Size
                            STATE.Size = CRIM_Settings.Safe_Text_Size

                            if v.Values.Broken.Value == true then
                                STATE.Text = "[BROKEN]"
                            elseif v.Values.Broken.Value == false  then
                                STATE.Text = "[FRESH]"
                            end
                            STATE.Position = v2(pos.X + NAME.TextBounds.X/2, pos.Y)

                            if CRIM_Settings.Only_Fresh then
                                if v.Values.Broken.Value == false then
                                    NAME.Visible = true
                                    STATE.Visible = true
                                else
                                    NAME.Visible = false
                                    STATE.Visible = false
                                end
                            else 
                                NAME.Visible = true
                                STATE.Visible = true
                            end
                        else 
                            NAME.Visible = false
                            STATE.Visible = false
                        end
                    else 
                        NAME.Visible = false
                        STATE.Visible = false
                    end 
                else 
                    NAME.Visible = false
                    STATE.Visible = false
                    if v.Parent == nil or v.Parent.Parent == nil then
                        NAME:Remove()
                        STATE:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    for i, v in pairs(BredMakurz:GetChildren()) do
        coroutine.wrap(ESPSafe)(v)
    end

    BredMakurz.ChildAdded:Connect(function(new)
        coroutine.wrap(ESPSafe)(new)
    end)

    local piles = game:GetService("Workspace").Filter.SpawnedPiles
    local function ESPScrap(v)

        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(0,0,0)
        NAME.Outline = true
        NAME.OutlineColor = RGB(0, 0, 0)
        NAME.Position = v2(0, 0)
        NAME.Size = CRIM_Settings.Scraps_Text_Size
        NAME.Center = true
        NAME.Text = "Scrap"
        NAME.Font = 3 

        local function Update()
            local c 
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    c:Disconnect()
                end
                if CRIM_Settings.Scraps and v.Parent ~= nil and v.Parent.Parent ~= nil then
                    if v.Parent ~= nil then
                        local pos, vis = Camera:WorldToViewportPoint(v.PrimaryPart.Position)
                        if vis then
                            NAME.Position = v2(pos.X, pos.Y)
                            NAME.Color = RGB(CRIM_Settings.Scraps_Color.R, CRIM_Settings.Scraps_Color.G, CRIM_Settings.Scraps_Color.B)

                            NAME.Size = CRIM_Settings.Scraps_Text_Size
                            NAME.Visible = true
                        else 
                            NAME.Visible = false
                        end
                    else 
                        NAME.Visible = false
                    end 
                else 
                    NAME.Visible = false
                    if v.Parent == nil or v.Parent.Parent == nil then
                        NAME:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    for i, v in pairs(piles:GetChildren()) do
        coroutine.wrap(ESPScrap)(v)
    end

    piles.ChildAdded:Connect(function(new)
        coroutine.wrap(ESPScrap)(new)
    end)

    -- MAIN CRIM

    local Main_Features = {
        Speed = false,
        Speed_Value = 1
    }

    local CRIMINALITYMain = "BlissX/Criminality/Main.dat"

    local function LoadMAIN()
        local u, Result = pcall(readfile, CRIMINALITYMain)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Main_Features[i] ~= nil then
                        Main_Features[i] = v
                        pcall(Main_Features[i], v)
                    end
                end
            end
        end
    end

    LoadMAIN()

    local PLAYERSection = CRIMCategory:NewSection("Player")

    local Speed_Toggle = PLAYERSection:NewToggle("Speed", function (NewValue)
        Main_Features.Speed = NewValue
    end, {default = Main_Features.Speed})

    PLAYERSection:NewKeybind("Toggle", function(newbind)
        Speed_Toggle:Toggle()
    end, {keybind = Enum.KeyCode.T})

    PLAYERSection:NewSlider("Increase", function(NewValue)
        Main_Features.Speed_Value = NewValue
    end, {
        value = Main_Features.Speed_Value,
        min = 0.1,
        max = 2,
        decimals = 2,
        suffix = "s/s"
    })

    coroutine.wrap(function()
        while true do
            if Main_Features.Speed and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                local Speed = Main_Features.Speed_Value
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(0, 0, -Speed)
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(-Speed, 0, 0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(0, 0, Speed)
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(Speed, 0, 0)
                end
            end
            wait()
        end
    end)()

    PLAYERSection:NewButton("No ragdoll", function()
        for i, v in pairs(getgc()) do
            if type(v) == 'function' and debug.getinfo(v).name == "RagdollCheck" then
                local hook 
                hook = hookfunction(v, function()
                    return false
                end)
            elseif type(v) == 'function' and debug.getinfo(v).name == "RagdollChar" then
                local hook 
                hook = hookfunction(v, function()
                    return nil
                end)
            end
        end
    end)

    -- VISUALS
    local VISUALSCategory = MainWindow:NewPage(_G["pages"], "Visuals")

    -- ENVIRONMENT
    local ENVIRONMENTSection = VISUALSCategory:NewSection("Environment")

    local Environment_Settings = {
        Graphics_Enhancer = false,
        Toggle = false,
        Color_Change = false,
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = {R = Lighting.Ambient.R, G = Lighting.Ambient.G, B = Lighting.Ambient.B},
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    local ENVFile = "BlissX/Universal/Env.dat"

    local function LoadENV()
        local u, Result = pcall(readfile, ENVFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Environment_Settings[i] ~= nil then
                        Environment_Settings[i] = v
                        pcall(Environment_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadENV()

    local Previous_Environment = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = Lighting.Ambient,
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    ENVIRONMENTSection:NewToggle("Toggle", function (NewValue)
        Environment_Settings.Toggle = NewValue
    end, {default = Environment_Settings.Toggle})

    ENVIRONMENTSection:NewToggle("Change Color", function (NewValue)
        Environment_Settings.Color_Change = NewValue
    end, {default = Environment_Settings.Color_Change})

    ENVIRONMENTSection:NewColorPicker("Ambient", function (NewValue)
        Environment_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B)})

    ENVIRONMENTSection:NewSlider("Brightness", function (NewValue)
        Environment_Settings.Brightness = NewValue
    end, {value = Environment_Settings.Brightness, min = 0, max = 10, suffix = ""})

    ENVIRONMENTSection:NewSlider("Clock Time", function (NewValue)
        Environment_Settings.ClockTime = NewValue
    end, {value = Environment_Settings.ClockTime, min = 0, max = 24, suffix = " h"})

    do
        local default_option
        local list =  {
            "Compatibility", 
            "Voxel",
            "ShadowMap",
            "Legacy",
            "Future"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Environment_Settings.Technology then
                default_option = i
            end
        end
        ENVIRONMENTSection:NewDropdown("Technology", function(Option)
            Environment_Settings.Technology = Enum.Technology[Option]
        end, {
            options = list,
            default = default_option
        })
    end

    ENVIRONMENTSection:NewToggle("Graphics Enhancer", function (NewValue)
        Environment_Settings.Graphics_Enhancer = NewValue
    end, {default = Environment_Settings.Graphics_Enhancer})

    coroutine.wrap(function() -- LOOP
        local function MOD(brightness, color, time, technology)
            Lighting.Brightness = brightness
            Lighting.ClockTime = time
            if Environment_Settings.Color_Change then
                Lighting.ColorShift_Bottom = color
                Lighting.ColorShift_Top = color
            else 
                Lighting.ColorShift_Bottom = Previous_Environment.Color
                Lighting.ColorShift_Top = Previous_Environment.Color
            end
            if gethiddenproperty(Lighting, "Technology") ~= technology then
                sethiddenproperty(Lighting, "Technology", technology)
            end
        end
        local deb = false
        local graphic_deb = false
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            if Environment_Settings.Graphics_Enhancer == false then
                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end
                graphic_deb = true
                if Environment_Settings.Toggle then
                    deb = true
                    MOD(Environment_Settings.Brightness, RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B), Environment_Settings.ClockTime, Environment_Settings.Technology)
                elseif deb then
                    MOD(Previous_Environment.Brightness, Previous_Environment.Color, Previous_Environment.ClockTime, Previous_Environment.Technology)
                    deb = false
                end
            elseif graphic_deb then
                graphic_deb = false

                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end

                local ter = game:GetService("Workspace").Terrain
                local color = Instance.new("ColorCorrectionEffect")
                local bloom = Instance.new("BloomEffect")
                local sun = Instance.new("SunRaysEffect")
                local blur = Instance.new("BlurEffect")

                color.Parent = Lighting
                bloom.Parent = Lighting
                sun.Parent = Lighting
                blur.Parent = Lighting

                local config = {
                    Terrain = true;
                    ColorCorrection = true;
                    Sun = true;
                    Lighting = true;
                    BloomEffect = true;
                }

                color.Enabled = false
                color.Contrast = 0.15
                color.Brightness = 0.1
                color.Saturation = 0.25
                color.TintColor = RGB(255, 222, 211)

                bloom.Enabled = false
                bloom.Intensity = 0.1

                sun.Enabled = false
                sun.Intensity = 0.2
                sun.Spread = 1

                bloom.Enabled = false
                bloom.Intensity = 0.05
                bloom.Size = 32
                bloom.Threshold = 1

                blur.Enabled = false
                blur.Size = 6

                if config.ColorCorrection then
                    color.Enabled = true
                end

                if config.Sun then
                    sun.Enabled = true
                end

                if config.Terrain then
                    ter.WaterColor = RGB(10, 10, 24)
                    ter.WaterWaveSize = 0.1
                    ter.WaterWaveSpeed = 22
                    ter.WaterTransparency = 0.9
                    ter.WaterReflectance = 0.05
                end


                if config.Lighting then
                    Lighting.Ambient = RGB(0, 0, 0)
                    Lighting.Brightness = 4
                    Lighting.ColorShift_Bottom = RGB(0, 0, 0)
                    Lighting.ColorShift_Top = RGB(0, 0, 0)
                    Lighting.ExposureCompensation = 0
                    Lighting.FogColor = RGB(132, 132, 132)
                    Lighting.GlobalShadows = true
                    Lighting.OutdoorAmbient = RGB(112, 117, 128)
                    Lighting.Outlines = false
                end
            end
        end)
    end)()

    -- SCREEN STUFF
    local SCREENSection = VISUALSCategory:NewSection("Screen")

    local Stats_Settings = {
        ShowFPS = false,
        ShowPing = false,
        ShowPosition = false,
        Color = {R = 255, G = 0, B = 175},
        Text_Size = 18,
        Max_Zoom_Distance = 100,
        Tool_Tip = false,
    }

    local STATSFile = "BlissX/Universal/ScreenStats.dat"

    local function LoadSTATS()
        local u, Result = pcall(readfile, STATSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Stats_Settings[i] ~= nil then
                        Stats_Settings[i] = v
                        pcall(Stats_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadSTATS()

    SCREENSection:NewToggle("Show FPS", function (NewValue)
        Stats_Settings.ShowFPS = NewValue
    end, {default = Stats_Settings.ShowFPS})

    SCREENSection:NewToggle("Show Ping", function (NewValue)
        Stats_Settings.ShowPing = NewValue
    end, {default = Stats_Settings.ShowPing})

    SCREENSection:NewToggle("Show Position", function (NewValue)
        Stats_Settings.ShowPosition = NewValue
    end, {default = Stats_Settings.ShowPosition})

    SCREENSection:NewColorPicker("Color", function (NewValue)
        Stats_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)})

    SCREENSection:NewSlider("Text Size", function (NewValue)
        Stats_Settings.Text_Size = NewValue
    end, {value = Stats_Settings.Text_Size, min = 1, max = 50, suffix = " px"})

    SCREENSection:NewSlider("Max Zoom Distance", function (NewValue)
        Stats_Settings.Max_Zoom_Distance = NewValue
    end, {value = Stats_Settings.Max_Zoom_Distance, min = 1, max = 5000, suffix = " studs"})

    coroutine.wrap(function() -- LOOP
        local function NewText()
            local t = drawing("Text")
            t.Visible = false
            t.Transparency = 0.8
            t.Color = RGB(255, 255, 255)
            t.Outline = true
            t.OutlineColor = RGB(10, 10, 10)
            t.Position = v2(0, 0)
            t.Size = 20
            t.Center = false
            t.Font = 3 
            t.Text = ""
            return t
        end
        local FPS = NewText()
        local PING = NewText()
        local POSITION = NewText()
        local c
        c = RS.RenderStepped:Connect(function(step)
            local fps_stat = 1/step
            if DESTROY_GUI then
                c:Disconnect()
                PING:Remove()
                FPS:Remove()
                POSITION:Remove()
            end
            local stats_col = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)
            if Stats_Settings.ShowFPS then
                FPS.Size = Stats_Settings.Text_Size
                FPS.Text = "FPS: "..tostring(round(fps_stat))
                FPS.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y)
                FPS.Color = stats_col
                FPS.Visible = true
            else 
                FPS.Visible = false
            end
            Player.CameraMaxZoomDistance = Stats_Settings.Max_Zoom_Distance
            if Stats_Settings.ShowPing then
                local ping_stat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                PING.Size = Stats_Settings.Text_Size
                PING.Text = "PING: "..tostring(round(ping_stat))
                PING.Color = stats_col
                PING.Visible = true

                local PingB = PING.TextBounds
                if FPS.Visible == false then
                    PING.Position = v2(5, Camera.ViewportSize.Y - PingB.Y)
                else
                    PING.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y - PingB.Y)
                end
            else 
                PING.Visible = false
            end
            if Stats_Settings.ShowPosition then
                if Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos_stat = Player.Character.PrimaryPart.Position
                    POSITION.Size = Stats_Settings.Text_Size
                    POSITION.Text = "POSITION: "..round(pos_stat.X).." "..round(pos_stat.Y).." "..round(pos_stat.Z)
                    POSITION.Color = stats_col
                    POSITION.Visible = true

                    local PB = POSITION.TextBounds
                    local FP = FPS.TextBounds
                    if FPS.Visible == false and PING.Visible == false then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y)
                    elseif (FPS.Visible and PING.Visible == false) or (FPS.Visible == false and PING.Visible == true) then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y)
                    elseif FPS.Visible and PING.Visible then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y*2)
                    end
                else 
                    POSITION.Visible = false
                end
            else 
                POSITION.Visible = false
            end
        end)
    end)()

    local CROSSHAIRSection = VISUALSCategory:NewSection("Crosshair")

    local Crosshair_Settings = {
        Enabled = false,
        Color = {R = 0, G = 255, B = 0},
        Lock = "Mouse",
        Size = 5,
        Offset = 2,
        Thickness = 1
    }

    local CROSSHAIRFile = "BlissX/Universal/Crosshair.dat"

    local function LoadCROSSHAIR()
        local u, Result = pcall(readfile, CROSSHAIRFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Crosshair_Settings[i] ~= nil then
                        Crosshair_Settings[i] = v
                        pcall(Crosshair_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadCROSSHAIR()

    CROSSHAIRSection:NewToggle("Custom Crosshair", function (NewValue)
        Crosshair_Settings.Enabled = NewValue
    end, {default = Crosshair_Settings.Enabled})

    CROSSHAIRSection:NewColorPicker("Color", function (NewValue)
        Crosshair_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)})

    CROSSHAIRSection:NewSlider("Size", function (NewValue)
        Crosshair_Settings.Size = NewValue
    end, {value = Crosshair_Settings.Size, min = 1, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Offset", function (NewValue)
        Crosshair_Settings.Offset = NewValue
    end, {value = Crosshair_Settings.Offset, min = 0, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Thickness", function (NewValue)
        Crosshair_Settings.Thickness = NewValue
    end, {value = Crosshair_Settings.Thickness, min = 1, max = 40, suffix = ""})

    do
        local default_option
        local list =  {
            "Mouse", 
            "Center"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Crosshair_Settings.Lock then
                default_option = i
            end
        end
        CROSSHAIRSection:NewDropdown("Lock", function(Option)
            Crosshair_Settings.Lock = Option
        end, {
            options = list,
            default = default_option
        })
    end


    coroutine.wrap(function()
        local inset = game:service("GuiService"):GetGuiInset()
        local lines = { -- CROSSHAIR LINES
            up = NewLine(RGB(255, 0, 0), 1, 1),
            down = NewLine(RGB(255, 0, 0), 1, 1),
            left = NewLine(RGB(255, 0, 0), 1, 1),
            right = NewLine(RGB(255, 0, 0), 1, 1)
        }
        local c 
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i,v in pairs(lines) do
                    v:Remove()
                end
                c:Disconnect()
            end
            if Crosshair_Settings.Enabled then
                local center = v2(0,0)
                if Crosshair_Settings.Lock == "Mouse" then
                    center = v2(Mouse.X, Mouse.Y + inset.Y)
                elseif Crosshair_Settings.Lock == "Center" then
                    center = Camera.ViewportSize/2
                else 
                    center = Camera.ViewportSize/2
                end
    
                lines.up.From = center - v2(0, Crosshair_Settings.Offset)
                lines.up.To = center - v2(0, Crosshair_Settings.Offset) - v2(0, Crosshair_Settings.Size)

                lines.down.From = center + v2(0, Crosshair_Settings.Offset)
                lines.down.To = center + v2(0, Crosshair_Settings.Offset) + v2(0, Crosshair_Settings.Size)

                lines.left.From = center - v2(Crosshair_Settings.Offset, 0)
                lines.left.To = center - v2(Crosshair_Settings.Offset, 0) - v2(Crosshair_Settings.Size, 0)

                lines.right.From = center + v2(Crosshair_Settings.Offset, 0)
                lines.right.To = center + v2(Crosshair_Settings.Offset, 0) + v2(Crosshair_Settings.Size, 0)

                local crosshair_col = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)
                for i,v in pairs(lines) do
                    v.Color = crosshair_col
                    v.Thickness = Crosshair_Settings.Thickness
                    v.Visible = true
                end
            else 
                for i,v in pairs(lines) do
                    v.Visible = false
                end
            end
        end)
    end)()

    -- GUI (LAST)
    local GUI_Settings = {
        theme = "Fire",
        toggle_bind = "End"
    }
    
    local GUIFile = "BlissX/Universal/GUI.dat"

    local function LoadGUI()
        local u, Result = pcall(readfile, GUIFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if GUI_Settings[i] ~= nil then
                        GUI_Settings[i] = v
                        pcall(GUI_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadGUI()

    _G["Theme"] = themes[GUI_Settings.theme]
    MainWindow:UpdateTheme()

    local GUICategory = MainWindow:NewPage(_G["pages"], "Settings")

    local GUISection = GUICategory:NewSection("GUI")

    GUISection:NewKeybind("Toggle", function(newbind)
        GUI_Settings.toggle_bind = string.sub(tostring(newbind), 14, #tostring(newbind))
        MainWindow:Toggle()
    end, {keybind = Enum.KeyCode[GUI_Settings.toggle_bind]})

    do
        local default_option
        local list =  {
            "Fire",
            "Forest",
            "Ocean",
            "Grayscale",
            "Midnight",
        }
        for i = 1, #list do
            local v = list[i]
            if v == GUI_Settings.theme then
                default_option = i
            end
        end
        GUISection:NewDropdown("Theme", function(Option)
            GUI_Settings.theme = Option
            _G["Theme"] = themes[Option]
            MainWindow:UpdateTheme()
        end, {
            options = list,
            default = default_option
        })
    end

    GUISection:NewButton("Update Theme", function()
        MainWindow:UpdateTheme()
    end)

    GUISection:NewButton("Kill", function()
        DESTROY_GUI = true
        MainWindow:Kill()
    end)

    GUISection:NewButton("Save Config", function()
        writefile(ESPFile, game:service("HttpService"):JSONEncode(ESP_Settings))
        writefile(AIMBOTFile, game:service("HttpService"):JSONEncode(AIMBOT_Settings))
        writefile(ENVFile, game:service("HttpService"):JSONEncode(Environment_Settings))
        writefile(CRIMINALITYMain, game:service("HttpService"):JSONEncode(Main_Features))
        writefile(CRIMINALITYESP, game:service("HttpService"):JSONEncode(CRIM_Settings))
        writefile(STATSFile, game:service("HttpService"):JSONEncode(Stats_Settings))
        writefile(CROSSHAIRFile, game:service("HttpService"):JSONEncode(Crosshair_Settings))
        writefile(GUIFile, game:service("HttpService"):JSONEncode(GUI_Settings))
    end)
elseif Current_Game.Name == "The New World" then
    --LOCALS
    local Players = game:GetService("Players")
    local Mouse = Player:GetMouse()
    local Camera = game:GetService("Workspace").CurrentCamera
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local MainWindow = Library:NewWindow()
    LOADED_START = true

    local DESTROY_GUI = false

    -- AC BYPASS

    local function FIND(name, args)
        for i,v in pairs(args) do
            if match(name, v) then
                return true
            end
        end
        return false
    end
    for i,v in pairs(Player.PlayerScripts:GetChildren()) do
        if FIND(v.Name, {"Local", "Anti", "Sound", "Player", "Chat"}) == false then
            v:Destroy()
        end
    end

    for i,v in pairs(game:service("StarterPlayer").StarterPlayerScripts:GetChildren()) do
        if FIND(v.Name, {"Local", "Anti", "Sound", "Player", "Chat"}) == false then
            v:Destroy()
        end
    end

    if Player.PlayerScripts:FindFirstChild("MainAnti") then
        Player.PlayerScripts.MainAnti:Destroy()
    end

    if Player.PlayerScripts:FindFirstChild("LocalScript") then
        Player.PlayerScripts.LocalScript:Destroy()
    end

    if game:service("StarterPlayer").StarterPlayerScripts:FindFirstChild("MainAnti") then
        game:service("StarterPlayer").StarterPlayerScripts.MainAnti:Destroy()
    end

    if game:service("StarterPlayer").StarterPlayerScripts:FindFirstChild("LocalScript") then
        game:service("StarterPlayer").StarterPlayerScripts.LocalScript:Destroy()
    end

    -- UNIVERSAL 
    local UniversalCategory = MainWindow:NewPage(_G["pages"], "Universal")

    local Selected_Player = nil

    -- ESP
    local ESPSection = UniversalCategory:NewSection("ESP")

    local ESP_Settings = {
        Names_Toggle = false,
        Text_Size = 15,
        Health = true,
        Boxes_Toggle = false,
        Health_Bar = true,
        Color =  {R = 255, G = 0, B = 175},
        Team_Check = false,
        Team =  {R = 0, G = 255, B = 0},
        Enemy =  {R = 255, G = 0, B = 0},
        Show_Selected = true,
        Selected =  {R = 255, G = 255, B = 255},
        Team_Color = false
    }

    local AIMBOT_Settings = {
        Toggle = false,
        Sensitivity = 0.5,
        Lock_Part = "Head",
        Distance_Type = "Character",
        Team_Check = false,
        FOV_Circle = false,
        FOV_Color = {R = 255, G = 0, B = 175},
        FOV_Radius = 10,
        Tool_Tip = false,
        Tool_Tip_Color = {R = 255, G = 0, B = 175}
    }

    local ESPFile = "BlissX/Universal/ESP.dat"
    local AIMBOTFile = "BlissX/Universal/Aimbot.dat"

    local function LoadESP()
        local u, Result = pcall(readfile, ESPFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if ESP_Settings[i] ~= nil then
                        ESP_Settings[i] = v
                        pcall(ESP_Settings[i], v)
                    end
                end
            end
        end
    end

    local function LoadAIMBOT()
        local u, Result = pcall(readfile, AIMBOTFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if AIMBOT_Settings[i] ~= nil then
                        AIMBOT_Settings[i] = v
                        pcall(AIMBOT_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadESP()
    LoadAIMBOT()

    ESPSection:NewToggle("Names", function (NewValue)
        ESP_Settings.Names_Toggle = NewValue
    end, {default = ESP_Settings.Names_Toggle})

    ESPSection:NewSlider("Text Size", function (NewValue)
        ESP_Settings.Text_Size = NewValue
    end, {value = ESP_Settings.Text_Size, min = 1, max = 75, suffix = " px"})

    ESPSection:NewToggle("Health", function (NewValue)
        ESP_Settings.Health = NewValue
    end, {default = ESP_Settings.Health})

    ESPSection:NewToggle("Boxes", function (NewValue)
        ESP_Settings.Boxes_Toggle = NewValue
    end, {default = ESP_Settings.Boxes_Toggle})

    ESPSection:NewToggle("Health Bar", function (NewValue)
        ESP_Settings.Health_Bar = NewValue
    end, {default = ESP_Settings.Health_Bar})

    ESPSection:NewColorPicker("Color", function (NewValue)
        ESP_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)})

    ESPSection:NewToggle("Team Check", function (NewValue)
        ESP_Settings.Team_Check = NewValue
    end, {default = ESP_Settings.Team_Check})

    ESPSection:NewColorPicker("Team", function (NewValue)
        ESP_Settings.Team = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)})

    ESPSection:NewColorPicker("Enemy", function (NewValue)
        ESP_Settings.Enemy = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)})

    ESPSection:NewToggle("Team Color", function (NewValue)
        ESP_Settings.Team_Color = NewValue
    end, {default = ESP_Settings.Team_Color})

    ESPSection:NewColorPicker("Selected Player", function (NewValue)
        ESP_Settings.Selected = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)})

    ESPSection:NewToggle("Show Selected", function (NewValue)
        ESP_Settings.Show_Selected = NewValue
    end, {default = ESP_Settings.Show_Selected})

    local function NameTag(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")
        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
        NAME.Outline = true
        NAME.OutlineColor = RGB(10, 10, 10)
        NAME.Position = v2(0, 0)
        NAME.Size = ESP_Settings.Text_Size
        NAME.Center = true
        NAME.Font = 3 
        NAME.Text = plr.Name

        local TB = NAME.TextBounds

        local HEALTH = drawing("Text")
        HEALTH.Visible = false
        HEALTH.Transparency = 0.8
        HEALTH.Color = RGB(255, 255, 255)
        HEALTH.Outline = true
        HEALTH.OutlineColor = RGB(10, 10, 10)
        HEALTH.Position = v2(0, 0)
        HEALTH.Size = ESP_Settings.Text_Size
        HEALTH.Font = 3 
        HEALTH.Text = "[]"

        local function Update()
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    HEALTH:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Names_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and char:FindFirstChild("Head") ~= nil and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local Hum = char:FindFirstChildOfClass("Humanoid")
                    Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        NAME.Size = ESP_Settings.Text_Size
                        HEALTH.Size = ESP_Settings.Text_Size

                        -- NAME.Color = ESP_Settings.Color
                        -- NAME.Position = v2(pos.X, pos.Y - TB.Y/2)

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local Top = pos.Y - newsize.Y/2

                        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        NAME.Position = v2(pos.X, Top - TB.Y - 2)

                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                NAME.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                NAME.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end

                        if ESP_Settings.Team_Color then
                            NAME.Color = teamColor.Color
                        end

                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            NAME.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        if ESP_Settings.Health then
                            HEALTH.Text = "["..tostring(round(Hum.Health)).."]"

                            NAME.Position = v2(pos.X - HEALTH.TextBounds.Y, Top - TB.Y - 2)
                            HEALTH.Position = v2(NAME.Position.X + TB.X/2, Top - TB.Y - 2)
                            HEALTH.Visible = true
                        else 
                            HEALTH.Visible = false
                        end

                        NAME.Visible = true
                    else 
                        NAME.Visible = false
                        HEALTH.Visible = false
                    end
                else 
                    if ESP_Settings.Names_Toggle == false and char and char:FindFirstChildOfClass("Humanoid") then 
                        char:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                    NAME.Visible = false
                    HEALTH.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        NAME:Remove()
                        HEALTH:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local function NewLine(color, thickness, transparency)
        local line = drawing("Line")
        line.Visible = false
        line.From = v2(0, 0)
        line.To = v2(0, 0)
        line.Color = color
        line.Thickness = thickness
        line.Transparency = transparency or 1
        return line
    end

    local function DrawBox(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")

        local Box = NewSquare({
            Transparency = 1, 
            Color = RGB(255, 255, 255), 
            Filled = false,
        })

        local Bar = NewLine(RGB(10, 10, 10), 3, 0.75)
        local Health = NewLine(RGB(0, 255, 0), 1)

        local function Update()
            local prevhealth = huge
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    Box:Remove()
                    Bar:Remove()
                    Health:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Boxes_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") ~= nil and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        Box.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                Box.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                Box.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end
                        if ESP_Settings.Team_Color then
                            Box.Color = teamColor.Color
                        end  
                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            Box.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local newpos = v2(pos.X - newsize.X/2, pos.Y - newsize.Y/2)

                        Box.Size = newsize
                        Box.Position = newpos

                        local Right = newpos.X + newsize.X
                        local Top = newpos.Y
                        local Bottom = newpos.Y + newsize.Y

                        if ESP_Settings.Health_Bar then
                            local Hum = char:FindFirstChildOfClass("Humanoid")
                            local Hum_Health = Hum.Health
                            local Hum_MaxHealth = Hum.MaxHealth

                            local offsetX = clamp(round(100/(char.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude), 0, 5)

                            Bar.From = v2(Right + offsetX, Top)
                            Bar.To = v2(Right + offsetX, Bottom)

                            local HealthRatio = Hum_Health / Hum_MaxHealth
                            local Length = abs((Bottom - 1) - (Top + 1))
                                
                            local HealthLength = Length * HealthRatio
                            Health.From = v2(Right + offsetX, Bottom - 1 - HealthLength)
                            Health.To = v2(Right + offsetX, Bottom - 1)

                            if Hum_Health ~= prevhealth then
                                Health.Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))
                                prevhealth = Hum_Health
                            end

                            Health.Visible = true
                            Bar.Visible = true
                        else 
                            Health.Visible = false
                            Bar.Visible = false
                        end

                        Box.Visible = true
                    else 
                        Health.Visible = false
                        Bar.Visible = false
                        Box.Visible = false
                    end
                else
                    Health.Visible = false
                    Bar.Visible = false
                    Box.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        Health:Remove()
                        Bar:Remove()
                        Box:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local t = Players:GetChildren()
    for i = 1, #t do
        local v = t[i]
        if DESTROY_GUI == false and v.Name ~= Player.Name then
            coroutine.wrap(NameTag)(v) 
            coroutine.wrap(DrawBox)(v)
        end
    end

    Players.PlayerAdded:Connect(function(v)
        if DESTROY_GUI == false then
            coroutine.wrap(NameTag)(v)
            coroutine.wrap(DrawBox)(v)
        end
    end)

    -- AIMBOT 
    local AIMBOTSection = UniversalCategory:NewSection("Aimbot")

    AIMBOTSection:NewToggle("Aimbot", function (NewValue)
        AIMBOT_Settings.Toggle = NewValue
    end, {default = AIMBOT_Settings.Toggle})

    AIMBOTSection:NewSlider("Sensitivity", function (NewValue)
        AIMBOT_Settings.Sensitivity = NewValue
    end, {value = AIMBOT_Settings.Sensitivity, min = 0.01, max = 1, suffix = " factor", decimals = 2})

    AIMBOTSection:NewToggle("Team Check", function (NewValue)
        AIMBOT_Settings.Team_Check = NewValue
    end, {default = AIMBOT_Settings.Team_Check})

    do
        local default_option
        local list =  {
            "Head", 
            "Torso", 
            "Feet"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Lock_Part then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Part", function(Option)
            AIMBOT_Settings.Lock_Part = Option
        end, {
            options = list,
            default = default_option
        })
    end

    do
        local default_option
        local list =  {
            "Mouse", 
            "Character"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Distance_Type then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Distance Type", function(Option)
            AIMBOT_Settings.Distance_Type = Option
        end, {
            options = list,
            default = default_option
        })
    end

    AIMBOTSection:NewToggle("FOV Circle", function (NewValue)
        AIMBOT_Settings.FOV_Circle = NewValue
    end, {default = AIMBOT_Settings.FOV_Circle})

    AIMBOTSection:NewColorPicker("FOV Color", function (NewValue)
        AIMBOT_Settings.FOV_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)})

    AIMBOTSection:NewSlider("FOV Radius", function (NewValue)
        AIMBOT_Settings.FOV_Radius = NewValue
    end, {value = AIMBOT_Settings.FOV_Radius, min = 1, max = 400, suffix = "°"})

    local Aiming = false
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = false
        end
    end)

    local FOV = drawing("Circle")
    FOV.Visible = false
    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
    FOV.Position = v2(0, 0)
    FOV.Transparency = 0.6
    FOV.NumSides = 75
    FOV.Radius = AIMBOT_Settings.FOV_Radius
    FOV.Filled = false
    FOV.Thickness = 1

    local function SameTeam(plr)
        local deb = false
        if AIMBOT_Settings.Team_Check then
            if plr.TeamColor == Player.TeamColor then
                deb = true
            else 
                deb = false
            end
        else
            deb = false
        end
        return deb
    end

    local function GetClosest()
        local min = huge
        local closest = nil
        if AIMBOT_Settings.Distance_Type == "Mouse" then
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local dist = (v2(Mouse.X, Mouse.Y) - v2(pos.X, pos.Y)).magnitude
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        else
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local dist = (Player.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        end
        return closest
    end

    coroutine.wrap(function()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            Selected_Player = GetClosest()
        end)
    end)()

    local inset = game:GetService("GuiService"):GetGuiInset()

    local function Aimbot_Start()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                FOV:Remove()
                c:Disconnect()
            end
            if AIMBOT_Settings.Toggle then
                
                if AIMBOT_Settings.FOV_Circle then
                    FOV.Radius = AIMBOT_Settings.FOV_Radius
                    FOV.Thickness = 1
                    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
        
                    FOV.Position = v2(Mouse.X, Mouse.Y + 36)
                    FOV.Visible = true
                else 
                    FOV.Radius = 2000
        
                    FOV.Position = Camera.ViewportSize / 2
                    FOV.Visible = false
                end

                if Aiming and Selected_Player ~= nil then
                    local char = Selected_Player.Character
                    local pos
                    local part = AIMBOT_Settings.Lock_Part
                    if part == "Head" then
                        pos = Camera:WorldToViewportPoint(char.Head.Position)
                    elseif part == "Torso" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    elseif part == "Feet" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position - v3(0, 2.5, 0))
                    end
                    local sens = AIMBOT_Settings.Sensitivity
                    mousemoverel((pos.X - Mouse.X) * sens, (pos.Y - Mouse.Y - inset.Y) * sens)
                end
            else 
                FOV.Visible = false
            end
        end)
    end
    coroutine.wrap(Aimbot_Start)()

    AIMBOTSection:NewToggle("Show Player Tooltip", function (NewValue)
        AIMBOT_Settings.Tool_Tip = NewValue
    end, {default = AIMBOT_Settings.Tool_Tip})

    AIMBOTSection:NewColorPicker("Name Color", function (NewValue)
        AIMBOT_Settings.Tool_Tip_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)})

    coroutine.wrap(function() -- PLAYER TOOLTIP
        local HealthBarThickness = 5
        local Tip_Library = {
            [1] = NewSquare({ -- Tip
                Transparency = 0.75, 
                Color = RGB(10, 10, 10), 
                Size = v2(300, 50),
                Position = v2(810, 10),
                Filled = true
            }),
            [2] = NewText({ -- Name
                Transparency = 1, 
                Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B), 
                TextSize = 15,
                Font = 3,
                Position = v2(816, 12)
            }),
            [3] = NewText({ -- Health_Text
                Transparency = 1, 
                Color = RGB(225, 225, 225), 
                TextSize = 15,
                Font = 3,
                Position = v2(814, 30),
            }),
            [4] = NewSquare({ -- Bar
                Transparency = 0.75, 
                Color = RGB(50, 50, 50), 
                Size = v2(292, HealthBarThickness),
                Position = v2(814, 50),
                Filled = true
            }),
            [5] = NewSquare({ -- Health
                Transparency = 1, 
                Color = RGB(0, 255, 0), 
                Size = v2(290, HealthBarThickness - 2),
                Position = v2(815, 51),
                Filled = true
            })
        }
        local function Visibility(state)
            for i = 1, #Tip_Library do
                local v = Tip_Library[i]
                v.Visible = state
            end
        end

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i = 1, #Tip_Library do
                    local v = Tip_Library[i]
                    v:Remove()
                end
            end
            if AIMBOT_Settings.Tool_Tip then
                if Selected_Player ~= nil then
                    local char = Selected_Player
                    local Hum = char.Character:FindFirstChildOfClass("Humanoid")
                    local Hum_Health = Hum.Health
                    local Hum_MaxHealth = Hum.MaxHealth

                    -- TEXTS
                    Tip_Library[2].Text = Selected_Player.Name
                    Tip_Library[3].Text = "["..round(Hum_Health).."/"..round(Hum_MaxHealth).."]"

                    -- HEALTH BAR
                    local HealthRatio = Hum_Health / Hum_MaxHealth
                    local Length = abs((Tip_Library[4].Position.X + Tip_Library[4].Size.X) - Tip_Library[4].Position.X)

                    local HealthLength = Length * HealthRatio
                    Tip_Library[5].Size = v2(HealthLength, Tip_Library[5].Size.Y)
                    Tip_Library[5].Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))

                    Tip_Library[2].Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)
                    Visibility(true)
                else 
                    Visibility(false)
                end
            else 
                Visibility(false)
            end
        end)
    end)()

    -- The New World
    local NEWWORLDCategory = MainWindow:NewPage(_G["pages"], "The New World")

    local GAMEVISUALSSection = NEWWORLDCategory:NewSection("Visuals")

    local Game_Visuals = {
        Items = false,
        Items_Color = {R = 110, G = 110, B = 240},
        Animals = false,
        Animals_Color = {R = 240, G = 110, B = 110}
    }

    local NEWWORLDVISUALSFile = "BlissX/NewWorld/Visuals.dat"

    local function LoadNEWWORLDVISUALS()
        local u, Result = pcall(readfile, NEWWORLDVISUALSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Game_Visuals[i] ~= nil then
                        Game_Visuals[i] = v
                        pcall(Game_Visuals[i], v)
                    end
                end
            end
        end
    end

    LoadNEWWORLDVISUALS()

    GAMEVISUALSSection:NewToggle("Items", function (NewValue)
        Game_Visuals.Items = NewValue
    end, {default = Game_Visuals.Items})

    GAMEVISUALSSection:NewColorPicker("Color", function (NewValue)
        Game_Visuals.Items_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Game_Visuals.Items_Color.R, Game_Visuals.Items_Color.G, Game_Visuals.Items_Color.B)})

    GAMEVISUALSSection:NewToggle("Animals", function (NewValue)
        Game_Visuals.Animals = NewValue
    end, {default = Game_Visuals.Animals})

    GAMEVISUALSSection:NewColorPicker("Color", function (NewValue)
        Game_Visuals.Animals_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Game_Visuals.Animals_Color.R, Game_Visuals.Animals_Color.G, Game_Visuals.Animals_Color.B)})

    local function ESP(v, type)
        local parent = v.Parent
        
        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(0,0,0)
        NAME.Outline = true
        NAME.OutlineColor = RGB(0, 0, 0)
        NAME.Position = v2(0, 0)
        NAME.Size = 15
        NAME.Center = true
        NAME.Font = 3 
        NAME.Text = v.Name

        if type == "item" then
            local function Update()
                local c 
                c = RS.RenderStepped:Connect(function()
                    if DESTROY_GUI then
                        NAME:Remove()
                        c:Disconnect()
                    end
                    if Game_Visuals.Items and v.Parent ~= nil and v.Parent.Parent ~= nil then
                        local pos, vis = Camera:WorldToViewportPoint(v.PrimaryPart.Position)
                        if vis then
                            NAME.Color = RGB(Game_Visuals.Items_Color.R, Game_Visuals.Items_Color.G, Game_Visuals.Items_Color.B)
                            NAME.Position = v2(pos.X, pos.Y)
                            NAME.Visible = true
                        else 
                            NAME.Visible = false
                        end
                    else 
                        NAME.Visible = false
                        if v.Parent == nil or v.Parent.Parent == nil then
                            NAME:Remove()
                            c:Disconnect()
                        end
                    end
                end)
            end
            coroutine.wrap(Update)()
        elseif type == "animal" then
            local function Update()
                local c 
                c = RS.RenderStepped:Connect(function()
                    if DESTROY_GUI then
                        NAME:Remove()
                        c:Disconnect()
                    end

                    if Game_Visuals.Animals and v.Parent ~= nil and v.Parent.Parent ~= nil then
                        local pos, vis = Camera:WorldToViewportPoint(v.PrimaryPart.Position)
                        if vis then
                            NAME.Color = RGB(Game_Visuals.Animals_Color.R, Game_Visuals.Animals_Color.G, Game_Visuals.Animals_Color.B)
                            NAME.Position = v2(pos.X, pos.Y)
                            NAME.Visible = true
                        else 
                            NAME.Visible = false
                        end
                    else 
                        NAME.Visible = false
                        if v.Parent == nil or v.Parent.Parent == nil then
                            NAME:Remove()
                            c:Disconnect()
                        end
                    end 
                end)
            end
            coroutine.wrap(Update)()
        end
    end
    
    for _,v in pairs(game:GetService("Workspace").World.Items:GetChildren()) do
        ESP(v, "item")
    end
    
    game:GetService("Workspace").World.Items.ChildAdded:Connect(function(v)
        ESP(v, "item")
    end)
    
    for _,v in pairs(game:GetService("Workspace").World.Operables.Animals:GetChildren()) do
        ESP(v, "animal")
    end
    
    game:GetService("Workspace").World.Operables.Animals.ChildAdded:Connect(function(v)
        ESP(v, "animal")
    end)

    -- Player Category
    local PLAYERSection = NEWWORLDCategory:NewSection("Player")

    local list = {
        str1 = {'stamina', 100, false},
        str2 = {'hunger', 200, false},
        str3 = {'warmth', 5000, false}
    }

    PLAYERSection:NewToggle("Infinite Stamina", function (NewValue)
        list.str1[3] = NewValue
    end, {default = list.str1[3]})

    PLAYERSection:NewToggle("Infinite Hunger", function (NewValue)
        list.str2[3] = NewValue
    end, {default = list.str2[3]})

    PLAYERSection:NewToggle("Infinite Warmth", function (NewValue)
        list.str3[3] = NewValue
    end, {default = list.str3[3]})

    local function Mod(lib, str)
        if rawget(lib, str[1]) then
            coroutine.wrap(function()
                local c
                c = RS.RenderStepped:Connect(function()
                    if DESTROY_GUI then
                        c:Disconnect()
                    end
                    if str[3] == true then
                        lib[str[1]] = str[2]
                    end
                end)
            end)()
        end
    end

    for i, v in pairs(getgc(true)) do
        if type(v) == 'table' then
            for u, x in pairs(list) do
                Mod(v, x)
            end
        end
    end

    local Main_Features = {
        Speed = false,
        Speed_Value = 1,
    }

    local PLAYERSection = NEWWORLDCategory:NewSection("Player")

    local Speed_Toggle = PLAYERSection:NewToggle("Speed", function (NewValue)
        Main_Features.Speed = NewValue
    end, {default = Main_Features.Speed})

    PLAYERSection:NewKeybind("Toggle", function()
        Speed_Toggle:Toggle()
    end, {keybind = Enum.KeyCode.V})

    PLAYERSection:NewSlider("Increase", function(NewValue)
        Main_Features.Speed_Value = NewValue
    end, {
        value = Main_Features.Speed_Value,
        min = 0.1,
        max = 2,
        decimals = 2,
        suffix = "s/s"
    })

    coroutine.wrap(function()
        while true do
            if Main_Features.Speed and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                local Speed = Main_Features.Speed_Value
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(0, 0, -Speed)
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(-Speed, 0, 0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(0, 0, Speed)
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CF(Speed, 0, 0)
                end
            end
            wait()
        end
    end)()

    local WORLDSection = NEWWORLDCategory:NewSection("World")

    local no_cooldown = false
    WORLDSection:NewToggle("No Cooldown", function (NewValue)
        no_cooldown = NewValue
    end, {default = no_cooldown})

    local hook 
    hook = hookfunction(wait, function(a)
        if no_cooldown then
            hook(0.001)
        else 
            hook(a)
        end
    end)

    -- VISUALS
    local VISUALSCategory = MainWindow:NewPage(_G["pages"], "Visuals")

    -- ENVIRONMENT
    local ENVIRONMENTSection = VISUALSCategory:NewSection("Environment")

    local Environment_Settings = {
        Graphics_Enhancer = false,
        Toggle = false,
        Color_Change = false,
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = {R = Lighting.Ambient.R, G = Lighting.Ambient.G, B = Lighting.Ambient.B},
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    local ENVFile = "BlissX/Universal/Env.dat"

    local function LoadENV()
        local u, Result = pcall(readfile, ENVFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Environment_Settings[i] ~= nil then
                        Environment_Settings[i] = v
                        pcall(Environment_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadENV()

    local Previous_Environment = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = Lighting.Ambient,
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    ENVIRONMENTSection:NewToggle("Toggle", function (NewValue)
        Environment_Settings.Toggle = NewValue
    end, {default = Environment_Settings.Toggle})

    ENVIRONMENTSection:NewToggle("Change Color", function (NewValue)
        Environment_Settings.Color_Change = NewValue
    end, {default = Environment_Settings.Color_Change})

    ENVIRONMENTSection:NewColorPicker("Ambient", function (NewValue)
        Environment_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B)})

    ENVIRONMENTSection:NewSlider("Brightness", function (NewValue)
        Environment_Settings.Brightness = NewValue
    end, {value = Environment_Settings.Brightness, min = 0, max = 10, suffix = ""})

    ENVIRONMENTSection:NewSlider("Clock Time", function (NewValue)
        Environment_Settings.ClockTime = NewValue
    end, {value = Environment_Settings.ClockTime, min = 0, max = 24, suffix = " h"})

    do
        local default_option
        local list =  {
            "Compatibility", 
            "Voxel",
            "ShadowMap",
            "Legacy",
            "Future"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Environment_Settings.Technology then
                default_option = i
            end
        end
        ENVIRONMENTSection:NewDropdown("Technology", function(Option)
            Environment_Settings.Technology = Enum.Technology[Option]
        end, {
            options = list,
            default = default_option
        })
    end

    ENVIRONMENTSection:NewToggle("Graphics Enhancer", function (NewValue)
        Environment_Settings.Graphics_Enhancer = NewValue
    end, {default = Environment_Settings.Graphics_Enhancer})

    coroutine.wrap(function() -- LOOP
        local function MOD(brightness, color, time, technology)
            Lighting.Brightness = brightness
            Lighting.ClockTime = time
            if Environment_Settings.Color_Change then
                Lighting.ColorShift_Bottom = color
                Lighting.ColorShift_Top = color
            else 
                Lighting.ColorShift_Bottom = Previous_Environment.Color
                Lighting.ColorShift_Top = Previous_Environment.Color
            end
            if gethiddenproperty(Lighting, "Technology") ~= technology then
                sethiddenproperty(Lighting, "Technology", technology)
            end
        end
        local deb = false
        local graphic_deb = false
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            if Environment_Settings.Graphics_Enhancer == false then
                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end
                graphic_deb = true
                if Environment_Settings.Toggle then
                    deb = true
                    MOD(Environment_Settings.Brightness, RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B), Environment_Settings.ClockTime, Environment_Settings.Technology)
                elseif deb then
                    MOD(Previous_Environment.Brightness, Previous_Environment.Color, Previous_Environment.ClockTime, Previous_Environment.Technology)
                    deb = false
                end
            elseif graphic_deb then
                graphic_deb = false

                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end

                local ter = game:GetService("Workspace").Terrain
                local color = Instance.new("ColorCorrectionEffect")
                local bloom = Instance.new("BloomEffect")
                local sun = Instance.new("SunRaysEffect")
                local blur = Instance.new("BlurEffect")

                color.Parent = Lighting
                bloom.Parent = Lighting
                sun.Parent = Lighting
                blur.Parent = Lighting

                local config = {
                    Terrain = true;
                    ColorCorrection = true;
                    Sun = true;
                    Lighting = true;
                    BloomEffect = true;
                }

                color.Enabled = false
                color.Contrast = 0.15
                color.Brightness = 0.1
                color.Saturation = 0.25
                color.TintColor = RGB(255, 222, 211)

                bloom.Enabled = false
                bloom.Intensity = 0.1

                sun.Enabled = false
                sun.Intensity = 0.2
                sun.Spread = 1

                bloom.Enabled = false
                bloom.Intensity = 0.05
                bloom.Size = 32
                bloom.Threshold = 1

                blur.Enabled = false
                blur.Size = 6

                if config.ColorCorrection then
                    color.Enabled = true
                end

                if config.Sun then
                    sun.Enabled = true
                end

                if config.Terrain then
                    ter.WaterColor = RGB(10, 10, 24)
                    ter.WaterWaveSize = 0.1
                    ter.WaterWaveSpeed = 22
                    ter.WaterTransparency = 0.9
                    ter.WaterReflectance = 0.05
                end


                if config.Lighting then
                    Lighting.Ambient = RGB(0, 0, 0)
                    Lighting.Brightness = 4
                    Lighting.ColorShift_Bottom = RGB(0, 0, 0)
                    Lighting.ColorShift_Top = RGB(0, 0, 0)
                    Lighting.ExposureCompensation = 0
                    Lighting.FogColor = RGB(132, 132, 132)
                    Lighting.GlobalShadows = true
                    Lighting.OutdoorAmbient = RGB(112, 117, 128)
                    Lighting.Outlines = false
                end
            end
        end)
    end)()

    -- SCREEN STUFF
    local SCREENSection = VISUALSCategory:NewSection("Screen")

    local Stats_Settings = {
        ShowFPS = false,
        ShowPing = false,
        ShowPosition = false,
        Color = {R = 255, G = 0, B = 175},
        Text_Size = 18,
        Max_Zoom_Distance = 100,
        Tool_Tip = false,
    }

    local STATSFile = "BlissX/Universal/ScreenStats.dat"

    local function LoadSTATS()
        local u, Result = pcall(readfile, STATSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Stats_Settings[i] ~= nil then
                        Stats_Settings[i] = v
                        pcall(Stats_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadSTATS()

    SCREENSection:NewToggle("Show FPS", function (NewValue)
        Stats_Settings.ShowFPS = NewValue
    end, {default = Stats_Settings.ShowFPS})

    SCREENSection:NewToggle("Show Ping", function (NewValue)
        Stats_Settings.ShowPing = NewValue
    end, {default = Stats_Settings.ShowPing})

    SCREENSection:NewToggle("Show Position", function (NewValue)
        Stats_Settings.ShowPosition = NewValue
    end, {default = Stats_Settings.ShowPosition})

    SCREENSection:NewColorPicker("Color", function (NewValue)
        Stats_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)})

    SCREENSection:NewSlider("Text Size", function (NewValue)
        Stats_Settings.Text_Size = NewValue
    end, {value = Stats_Settings.Text_Size, min = 1, max = 50, suffix = " px"})

    SCREENSection:NewSlider("Max Zoom Distance", function (NewValue)
        Stats_Settings.Max_Zoom_Distance = NewValue
    end, {value = Stats_Settings.Max_Zoom_Distance, min = 1, max = 5000, suffix = " studs"})

    coroutine.wrap(function() -- LOOP
        local function NewText()
            local t = drawing("Text")
            t.Visible = false
            t.Transparency = 0.8
            t.Color = RGB(255, 255, 255)
            t.Outline = true
            t.OutlineColor = RGB(10, 10, 10)
            t.Position = v2(0, 0)
            t.Size = 20
            t.Center = false
            t.Font = 3 
            t.Text = ""
            return t
        end
        local FPS = NewText()
        local PING = NewText()
        local POSITION = NewText()
        local c
        c = RS.RenderStepped:Connect(function(step)
            local fps_stat = 1/step
            if DESTROY_GUI then
                c:Disconnect()
                PING:Remove()
                FPS:Remove()
                POSITION:Remove()
            end
            local stats_col = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)
            if Stats_Settings.ShowFPS then
                FPS.Size = Stats_Settings.Text_Size
                FPS.Text = "FPS: "..tostring(round(fps_stat))
                FPS.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y)
                FPS.Color = stats_col
                FPS.Visible = true
            else 
                FPS.Visible = false
            end
            Player.CameraMaxZoomDistance = Stats_Settings.Max_Zoom_Distance
            if Stats_Settings.ShowPing then
                local ping_stat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                PING.Size = Stats_Settings.Text_Size
                PING.Text = "PING: "..tostring(round(ping_stat))
                PING.Color = stats_col
                PING.Visible = true

                local PingB = PING.TextBounds
                if FPS.Visible == false then
                    PING.Position = v2(5, Camera.ViewportSize.Y - PingB.Y)
                else
                    PING.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y - PingB.Y)
                end
            else 
                PING.Visible = false
            end
            if Stats_Settings.ShowPosition then
                if Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos_stat = Player.Character.PrimaryPart.Position
                    POSITION.Size = Stats_Settings.Text_Size
                    POSITION.Text = "POSITION: "..round(pos_stat.X).." "..round(pos_stat.Y).." "..round(pos_stat.Z)
                    POSITION.Color = stats_col
                    POSITION.Visible = true

                    local PB = POSITION.TextBounds
                    local FP = FPS.TextBounds
                    if FPS.Visible == false and PING.Visible == false then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y)
                    elseif (FPS.Visible and PING.Visible == false) or (FPS.Visible == false and PING.Visible == true) then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y)
                    elseif FPS.Visible and PING.Visible then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y*2)
                    end
                else 
                    POSITION.Visible = false
                end
            else 
                POSITION.Visible = false
            end
        end)
    end)()

    local CROSSHAIRSection = VISUALSCategory:NewSection("Crosshair")

    local Crosshair_Settings = {
        Enabled = false,
        Color = {R = 0, G = 255, B = 0},
        Lock = "Mouse",
        Size = 5,
        Offset = 2,
        Thickness = 1
    }

    local CROSSHAIRFile = "BlissX/Universal/Crosshair.dat"

    local function LoadCROSSHAIR()
        local u, Result = pcall(readfile, CROSSHAIRFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Crosshair_Settings[i] ~= nil then
                        Crosshair_Settings[i] = v
                        pcall(Crosshair_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadCROSSHAIR()

    CROSSHAIRSection:NewToggle("Custom Crosshair", function (NewValue)
        Crosshair_Settings.Enabled = NewValue
    end, {default = Crosshair_Settings.Enabled})

    CROSSHAIRSection:NewColorPicker("Color", function (NewValue)
        Crosshair_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)})

    CROSSHAIRSection:NewSlider("Size", function (NewValue)
        Crosshair_Settings.Size = NewValue
    end, {value = Crosshair_Settings.Size, min = 1, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Offset", function (NewValue)
        Crosshair_Settings.Offset = NewValue
    end, {value = Crosshair_Settings.Offset, min = 0, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Thickness", function (NewValue)
        Crosshair_Settings.Thickness = NewValue
    end, {value = Crosshair_Settings.Thickness, min = 1, max = 40, suffix = ""})

    do
        local default_option
        local list =  {
            "Mouse", 
            "Center"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Crosshair_Settings.Lock then
                default_option = i
            end
        end
        CROSSHAIRSection:NewDropdown("Lock", function(Option)
            Crosshair_Settings.Lock = Option
        end, {
            options = list,
            default = default_option
        })
    end


    coroutine.wrap(function()
        local inset = game:service("GuiService"):GetGuiInset()
        local lines = { -- CROSSHAIR LINES
            up = NewLine(RGB(255, 0, 0), 1, 1),
            down = NewLine(RGB(255, 0, 0), 1, 1),
            left = NewLine(RGB(255, 0, 0), 1, 1),
            right = NewLine(RGB(255, 0, 0), 1, 1)
        }
        local c 
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i,v in pairs(lines) do
                    v:Remove()
                end
                c:Disconnect()
            end
            if Crosshair_Settings.Enabled then
                local center = v2(0,0)
                if Crosshair_Settings.Lock == "Mouse" then
                    center = v2(Mouse.X, Mouse.Y + inset.Y)
                elseif Crosshair_Settings.Lock == "Center" then
                    center = Camera.ViewportSize/2
                else 
                    center = Camera.ViewportSize/2
                end
    
                lines.up.From = center - v2(0, Crosshair_Settings.Offset)
                lines.up.To = center - v2(0, Crosshair_Settings.Offset) - v2(0, Crosshair_Settings.Size)

                lines.down.From = center + v2(0, Crosshair_Settings.Offset)
                lines.down.To = center + v2(0, Crosshair_Settings.Offset) + v2(0, Crosshair_Settings.Size)

                lines.left.From = center - v2(Crosshair_Settings.Offset, 0)
                lines.left.To = center - v2(Crosshair_Settings.Offset, 0) - v2(Crosshair_Settings.Size, 0)

                lines.right.From = center + v2(Crosshair_Settings.Offset, 0)
                lines.right.To = center + v2(Crosshair_Settings.Offset, 0) + v2(Crosshair_Settings.Size, 0)

                local crosshair_col = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)
                for i,v in pairs(lines) do
                    v.Color = crosshair_col
                    v.Thickness = Crosshair_Settings.Thickness
                    v.Visible = true
                end
            else 
                for i,v in pairs(lines) do
                    v.Visible = false
                end
            end
        end)
    end)()

    -- GUI (LAST)
    local GUI_Settings = {
        theme = "Fire",
        toggle_bind = "End"
    }
    
    local GUIFile = "BlissX/Universal/GUI.dat"

    local function LoadGUI()
        local u, Result = pcall(readfile, GUIFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if GUI_Settings[i] ~= nil then
                        GUI_Settings[i] = v
                        pcall(GUI_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadGUI()

    _G["Theme"] = themes[GUI_Settings.theme]
    MainWindow:UpdateTheme()

    local GUICategory = MainWindow:NewPage(_G["pages"], "Settings")

    local GUISection = GUICategory:NewSection("GUI")

    GUISection:NewKeybind("Toggle", function(newbind)
        GUI_Settings.toggle_bind = string.sub(tostring(newbind), 14, #tostring(newbind))
        MainWindow:Toggle()
    end, {keybind = Enum.KeyCode[GUI_Settings.toggle_bind]})

    do
        local default_option
        local list =  {
            "Fire",
            "Forest",
            "Ocean",
            "Grayscale",
            "Midnight",
        }
        for i = 1, #list do
            local v = list[i]
            if v == GUI_Settings.theme then
                default_option = i
            end
        end
        GUISection:NewDropdown("Theme", function(Option)
            GUI_Settings.theme = Option
            _G["Theme"] = themes[Option]
            MainWindow:UpdateTheme()
        end, {
            options = list,
            default = default_option
        })
    end

    GUISection:NewButton("Update Theme", function()
        MainWindow:UpdateTheme()
    end)

    GUISection:NewButton("Kill", function()
        DESTROY_GUI = true
        MainWindow:Kill()
    end)

    GUISection:NewButton("Save Config", function()
        writefile(ESPFile, game:service("HttpService"):JSONEncode(ESP_Settings))
        writefile(AIMBOTFile, game:service("HttpService"):JSONEncode(AIMBOT_Settings))
        writefile(ENVFile, game:service("HttpService"):JSONEncode(Environment_Settings))
        writefile(NEWWORLDVISUALSFile, game:service("HttpService"):JSONEncode(Game_Visuals))
        writefile(STATSFile, game:service("HttpService"):JSONEncode(Stats_Settings))
        writefile(CROSSHAIRFile, game:service("HttpService"):JSONEncode(Crosshair_Settings))
        writefile(GUIFile, game:service("HttpService"):JSONEncode(GUI_Settings))
    end)
elseif Current_Game.Name == "State of Anarchy" then
    --LOCALS
    local Players = game:GetService("Players")
    local Mouse = Player:GetMouse()
    local Camera = game:GetService("Workspace").CurrentCamera
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")

    local MainWindow = Library:NewWindow()
    LOADED_START = true

    local DESTROY_GUI = false

    -- UNIVERSAL 
    local UniversalCategory = MainWindow:NewPage(_G["pages"], "Universal")

    local Selected_Player = nil

    -- ESP
    local ESPSection = UniversalCategory:NewSection("ESP")

    local ESP_Settings = {
        Names_Toggle = false,
        Text_Size = 15,
        Health = true,
        Boxes_Toggle = false,
        Health_Bar = true,
        Color =  {R = 255, G = 0, B = 175},
        Team_Check = false,
        Team =  {R = 0, G = 255, B = 0},
        Enemy =  {R = 255, G = 0, B = 0},
        Show_Selected = true,
        Selected =  {R = 255, G = 255, B = 255},
        Team_Color = false
    }

    local AIMBOT_Settings = {
        Toggle = false,
        Sensitivity = 0.5,
        Lock_Part = "Head",
        Distance_Type = "Character",
        Team_Check = false,
        FOV_Circle = false,
        FOV_Color = {R = 255, G = 0, B = 175},
        FOV_Radius = 10,
        Tool_Tip = false,
        Tool_Tip_Color = {R = 255, G = 0, B = 175}
    }

    local ESPFile = "BlissX/Universal/ESP.dat"
    local AIMBOTFile = "BlissX/Universal/Aimbot.dat"

    local function LoadESP()
        local u, Result = pcall(readfile, ESPFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if ESP_Settings[i] ~= nil then
                        ESP_Settings[i] = v
                        pcall(ESP_Settings[i], v)
                    end
                end
            end
        end
    end

    local function LoadAIMBOT()
        local u, Result = pcall(readfile, AIMBOTFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if AIMBOT_Settings[i] ~= nil then
                        AIMBOT_Settings[i] = v
                        pcall(AIMBOT_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadESP()
    LoadAIMBOT()

    ESPSection:NewToggle("Names", function (NewValue)
        ESP_Settings.Names_Toggle = NewValue
    end, {default = ESP_Settings.Names_Toggle})

    ESPSection:NewSlider("Text Size", function (NewValue)
        ESP_Settings.Text_Size = NewValue
    end, {value = ESP_Settings.Text_Size, min = 1, max = 75, suffix = " px"})

    ESPSection:NewToggle("Health", function (NewValue)
        ESP_Settings.Health = NewValue
    end, {default = ESP_Settings.Health})

    ESPSection:NewToggle("Boxes", function (NewValue)
        ESP_Settings.Boxes_Toggle = NewValue
    end, {default = ESP_Settings.Boxes_Toggle})

    ESPSection:NewToggle("Health Bar", function (NewValue)
        ESP_Settings.Health_Bar = NewValue
    end, {default = ESP_Settings.Health_Bar})

    ESPSection:NewColorPicker("Color", function (NewValue)
        ESP_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)})

    ESPSection:NewToggle("Team Check", function (NewValue)
        ESP_Settings.Team_Check = NewValue
    end, {default = ESP_Settings.Team_Check})

    ESPSection:NewColorPicker("Team", function (NewValue)
        ESP_Settings.Team = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)})

    ESPSection:NewColorPicker("Enemy", function (NewValue)
        ESP_Settings.Enemy = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)})

    ESPSection:NewToggle("Team Color", function (NewValue)
        ESP_Settings.Team_Color = NewValue
    end, {default = ESP_Settings.Team_Color})

    ESPSection:NewColorPicker("Selected Player", function (NewValue)
        ESP_Settings.Selected = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)})

    ESPSection:NewToggle("Show Selected", function (NewValue)
        ESP_Settings.Show_Selected = NewValue
    end, {default = ESP_Settings.Show_Selected})

    local function NameTag(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")
        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
        NAME.Outline = true
        NAME.OutlineColor = RGB(10, 10, 10)
        NAME.Position = v2(0, 0)
        NAME.Size = ESP_Settings.Text_Size
        NAME.Center = true
        NAME.Font = 3 
        NAME.Text = plr.Name

        local TB = NAME.TextBounds

        local HEALTH = drawing("Text")
        HEALTH.Visible = false
        HEALTH.Transparency = 0.8
        HEALTH.Color = RGB(255, 255, 255)
        HEALTH.Outline = true
        HEALTH.OutlineColor = RGB(10, 10, 10)
        HEALTH.Position = v2(0, 0)
        HEALTH.Size = ESP_Settings.Text_Size
        HEALTH.Font = 3 
        HEALTH.Text = "[]"

        local function Update()
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    NAME:Remove()
                    HEALTH:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Names_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and char:FindFirstChild("Head") ~= nil and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local Hum = char:FindFirstChildOfClass("Humanoid")
                    Hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        NAME.Size = ESP_Settings.Text_Size
                        HEALTH.Size = ESP_Settings.Text_Size

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local Top = pos.Y - newsize.Y/2

                        NAME.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        NAME.Position = v2(pos.X, Top - TB.Y - 2)

                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                NAME.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                NAME.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end

                        if ESP_Settings.Team_Color then
                            NAME.Color = teamColor.Color
                        end

                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            NAME.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        if ESP_Settings.Health then
                            HEALTH.Text = "["..tostring(round(Hum.Health)).."]"

                            NAME.Position = v2(pos.X - HEALTH.TextBounds.Y, Top - TB.Y - 2)
                            HEALTH.Position = v2(NAME.Position.X + TB.X/2, Top - TB.Y - 2)
                            HEALTH.Visible = true
                        else 
                            HEALTH.Visible = false
                        end

                        NAME.Visible = true
                    else 
                        NAME.Visible = false
                        HEALTH.Visible = false
                    end
                else 
                    if ESP_Settings.Names_Toggle == false and char and char:FindFirstChildOfClass("Humanoid") then 
                        char:FindFirstChildOfClass("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                    NAME.Visible = false
                    HEALTH.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        NAME:Remove()
                        HEALTH:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local function NewLine(color, thickness, transparency)
        local line = drawing("Line")
        line.Visible = false
        line.From = v2(0, 0)
        line.To = v2(0, 0)
        line.Color = color
        line.Thickness = thickness
        line.Transparency = transparency or 1
        return line
    end

    local function DrawBox(plr)
        repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid")

        local Box = NewSquare({
            Transparency = 1, 
            Color = RGB(255, 255, 255), 
            Filled = false,
        })

        local Bar = NewLine(RGB(10, 10, 10), 3, 0.75)
        local Health = NewLine(RGB(0, 255, 0), 1)

        local function Update()
            local prevhealth = huge
            local c
            c = RS.RenderStepped:Connect(function()
                if DESTROY_GUI then
                    Box:Remove()
                    Bar:Remove()
                    Health:Remove()
                    c:Disconnect()
                end
                local char = plr.Character
                if ESP_Settings.Boxes_Toggle and char ~= nil and char:FindFirstChildOfClass("Humanoid") ~= nil and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 and Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos, vis = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    if vis then
                        Box.Color = RGB(ESP_Settings.Color.R, ESP_Settings.Color.G, ESP_Settings.Color.B)
                        local teamColor = plr.TeamColor
                        if ESP_Settings.Team_Check then
                            if teamColor == Player.TeamColor then
                                Box.Color = RGB(ESP_Settings.Team.R, ESP_Settings.Team.G, ESP_Settings.Team.B)
                            else 
                                Box.Color = RGB(ESP_Settings.Enemy.R, ESP_Settings.Enemy.G, ESP_Settings.Enemy.B)
                            end
                        end
                        if ESP_Settings.Team_Color then
                            Box.Color = teamColor.Color
                        end  
                        if AIMBOT_Settings.Toggle and ESP_Settings.Show_Selected and Selected_Player ~= nil and plr.Name == Selected_Player.Name then
                            Box.Color = RGB(ESP_Settings.Selected.R, ESP_Settings.Selected.G, ESP_Settings.Selected.B)
                        end

                        local ratio = 2500/pos.Z
                        local newsize = v2(ratio, ratio * 2)
                        local newpos = v2(pos.X - newsize.X/2, pos.Y - newsize.Y/2)

                        Box.Size = newsize
                        Box.Position = newpos

                        local Right = newpos.X + newsize.X
                        local Top = newpos.Y
                        local Bottom = newpos.Y + newsize.Y

                        if ESP_Settings.Health_Bar then
                            local Hum = char:FindFirstChildOfClass("Humanoid")
                            local Hum_Health = Hum.Health
                            local Hum_MaxHealth = Hum.MaxHealth

                            local offsetX = clamp(round(100/(char.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude), 0, 5)

                            Bar.From = v2(Right + offsetX, Top)
                            Bar.To = v2(Right + offsetX, Bottom)

                            local HealthRatio = Hum_Health / Hum_MaxHealth
                            local Length = abs((Bottom - 1) - (Top + 1))
                                
                            local HealthLength = Length * HealthRatio
                            Health.From = v2(Right + offsetX, Bottom - 1 - HealthLength)
                            Health.To = v2(Right + offsetX, Bottom - 1)

                            if Hum_Health ~= prevhealth then
                                Health.Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))
                                prevhealth = Hum_Health
                            end

                            Health.Visible = true
                            Bar.Visible = true
                        else 
                            Health.Visible = false
                            Bar.Visible = false
                        end

                        Box.Visible = true
                    else 
                        Health.Visible = false
                        Bar.Visible = false
                        Box.Visible = false
                    end
                else
                    Health.Visible = false
                    Bar.Visible = false
                    Box.Visible = false
                    if Players:FindFirstChild(plr.Name) == nil then
                        Health:Remove()
                        Bar:Remove()
                        Box:Remove()
                        c:Disconnect()
                    end
                end
            end)
        end
        coroutine.wrap(Update)()
    end

    local t = Players:GetChildren()
    for i = 1, #t do
        local v = t[i]
        if DESTROY_GUI == false and v.Name ~= Player.Name then
            coroutine.wrap(NameTag)(v) 
            coroutine.wrap(DrawBox)(v)
        end
    end

    Players.PlayerAdded:Connect(function(v)
        if DESTROY_GUI == false then
            coroutine.wrap(NameTag)(v)
            coroutine.wrap(DrawBox)(v)
        end
    end)

    -- AIMBOT 
    local AIMBOTSection = UniversalCategory:NewSection("Aimbot")

    AIMBOTSection:NewToggle("Aimbot", function (NewValue)
        AIMBOT_Settings.Toggle = NewValue
    end, {default = AIMBOT_Settings.Toggle})

    AIMBOTSection:NewSlider("Sensitivity", function (NewValue)
        AIMBOT_Settings.Sensitivity = NewValue
    end, {value = AIMBOT_Settings.Sensitivity, min = 0.01, max = 1, suffix = " factor", decimals = 2})

    AIMBOTSection:NewToggle("Team Check", function (NewValue)
        AIMBOT_Settings.Team_Check = NewValue
    end, {default = AIMBOT_Settings.Team_Check})

    do
        local default_option
        local list =  {
            "Head", 
            "Torso", 
            "Feet"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Lock_Part then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Part", function(Option)
            AIMBOT_Settings.Lock_Part = Option
        end, {
            options = list,
            default = default_option
        })
    end

    do
        local default_option
        local list =  {
            "Mouse", 
            "Character"
        }
        for i = 1, #list do
            local v = list[i]
            if v == AIMBOT_Settings.Distance_Type then
                default_option = i
            end
        end
        AIMBOTSection:NewDropdown("Distance Type", function(Option)
            AIMBOT_Settings.Distance_Type = Option
        end, {
            options = list,
            default = default_option
        })
    end

    AIMBOTSection:NewToggle("FOV Circle", function (NewValue)
        AIMBOT_Settings.FOV_Circle = NewValue
    end, {default = AIMBOT_Settings.FOV_Circle})

    AIMBOTSection:NewColorPicker("FOV Color", function (NewValue)
        AIMBOT_Settings.FOV_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)})

    AIMBOTSection:NewSlider("FOV Radius", function (NewValue)
        AIMBOT_Settings.FOV_Radius = NewValue
    end, {value = AIMBOT_Settings.FOV_Radius, min = 1, max = 400, suffix = "°"})

    local Aiming = false
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = false
        end
    end)

    local FOV = drawing("Circle")
    FOV.Visible = false
    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
    FOV.Position = v2(0, 0)
    FOV.Transparency = 0.6
    FOV.NumSides = 75
    FOV.Radius = AIMBOT_Settings.FOV_Radius
    FOV.Filled = false
    FOV.Thickness = 1

    local function SameTeam(plr)
        local deb = false
        if AIMBOT_Settings.Team_Check then
            if plr.TeamColor == Player.TeamColor then
                deb = true
            else 
                deb = false
            end
        else
            deb = false
        end
        return deb
    end

    local function GetClosest()
        local min = huge
        local closest = nil
        if AIMBOT_Settings.Distance_Type == "Mouse" then
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    local dist = (v2(Mouse.X, Mouse.Y) - v2(pos.X, pos.Y)).magnitude
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        else
            local t = Players:GetChildren()
            for i = 1, #t do
                local v = t[i]
                if v.Name ~= Player.Name and v.Character ~= nil and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 and v.Character.PrimaryPart ~= nil and SameTeam(v) == false then
                    local dist = (Player.Character.PrimaryPart.Position - v.Character.PrimaryPart.Position).magnitude
                    local pos, vis = Camera:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                    if vis then
                        local d = (v2(pos.X, pos.Y) - FOV.Position).magnitude
                        if d <= FOV.Radius and dist < min then
                            min = dist
                            closest = v
                        end
                    end
                end
            end
        end
        return closest
    end

    coroutine.wrap(function()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            Selected_Player = GetClosest()
        end)
    end)()

    local inset = game:GetService("GuiService"):GetGuiInset()

    local function Aimbot_Start()
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                FOV:Remove()
                c:Disconnect()
            end
            if AIMBOT_Settings.Toggle then
                
                if AIMBOT_Settings.FOV_Circle then
                    FOV.Radius = AIMBOT_Settings.FOV_Radius
                    FOV.Thickness = 1
                    FOV.Color = RGB(AIMBOT_Settings.FOV_Color.R, AIMBOT_Settings.FOV_Color.G, AIMBOT_Settings.FOV_Color.B)
        
                    FOV.Position = v2(Mouse.X, Mouse.Y + 36)
                    FOV.Visible = true
                else 
                    FOV.Radius = 2000
        
                    FOV.Position = Camera.ViewportSize / 2
                    FOV.Visible = false
                end

                if Aiming and Selected_Player ~= nil then
                    local char = Selected_Player.Character
                    local pos
                    local part = AIMBOT_Settings.Lock_Part
                    if part == "Head" then
                        pos = Camera:WorldToViewportPoint(char.Head.Position)
                    elseif part == "Torso" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position)
                    elseif part == "Feet" then
                        pos = Camera:WorldToViewportPoint(char.PrimaryPart.Position - v3(0, 2.5, 0))
                    end
                    local sens = AIMBOT_Settings.Sensitivity
                    mousemoverel((pos.X - Mouse.X) * sens, (pos.Y - Mouse.Y - inset.Y) * sens)
                end
            else 
                FOV.Visible = false
            end
        end)
    end
    coroutine.wrap(Aimbot_Start)()

    AIMBOTSection:NewToggle("Show Player Tooltip", function (NewValue)
        AIMBOT_Settings.Tool_Tip = NewValue
    end, {default = AIMBOT_Settings.Tool_Tip})

    AIMBOTSection:NewColorPicker("Name Color", function (NewValue)
        AIMBOT_Settings.Tool_Tip_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)})

    coroutine.wrap(function() -- PLAYER TOOLTIP
        local HealthBarThickness = 5
        local Tip_Library = {
            [1] = NewSquare({ -- Tip
                Transparency = 0.75, 
                Color = RGB(10, 10, 10), 
                Size = v2(300, 50),
                Position = v2(810, 10),
                Filled = true
            }),
            [2] = NewText({ -- Name
                Transparency = 1, 
                Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B), 
                TextSize = 15,
                Font = 3,
                Position = v2(816, 12)
            }),
            [3] = NewText({ -- Health_Text
                Transparency = 1, 
                Color = RGB(225, 225, 225), 
                TextSize = 15,
                Font = 3,
                Position = v2(814, 30),
            }),
            [4] = NewSquare({ -- Bar
                Transparency = 0.75, 
                Color = RGB(50, 50, 50), 
                Size = v2(292, HealthBarThickness),
                Position = v2(814, 50),
                Filled = true
            }),
            [5] = NewSquare({ -- Health
                Transparency = 1, 
                Color = RGB(0, 255, 0), 
                Size = v2(290, HealthBarThickness - 2),
                Position = v2(815, 51),
                Filled = true
            })
        }
        local function Visibility(state)
            for i = 1, #Tip_Library do
                local v = Tip_Library[i]
                v.Visible = state
            end
        end

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i = 1, #Tip_Library do
                    local v = Tip_Library[i]
                    v:Remove()
                end
            end
            if AIMBOT_Settings.Tool_Tip then
                if Selected_Player ~= nil then
                    local char = Selected_Player
                    local Hum = char.Character:FindFirstChildOfClass("Humanoid")
                    local Hum_Health = Hum.Health
                    local Hum_MaxHealth = Hum.MaxHealth

                    -- TEXTS
                    Tip_Library[2].Text = Selected_Player.Name
                    Tip_Library[3].Text = "["..round(Hum_Health).."/"..round(Hum_MaxHealth).."]"

                    -- HEALTH BAR
                    local HealthRatio = Hum_Health / Hum_MaxHealth
                    local Length = abs((Tip_Library[4].Position.X + Tip_Library[4].Size.X) - Tip_Library[4].Position.X)

                    local HealthLength = Length * HealthRatio
                    Tip_Library[5].Size = v2(HealthLength, Tip_Library[5].Size.Y)
                    Tip_Library[5].Color = HealthBarRed:Lerp(HealthBarGreen, (Hum_Health / Hum_MaxHealth))

                    Tip_Library[2].Color = RGB(AIMBOT_Settings.Tool_Tip_Color.R, AIMBOT_Settings.Tool_Tip_Color.G, AIMBOT_Settings.Tool_Tip_Color.B)
                    Visibility(true)
                else 
                    Visibility(false)
                end
            else 
                Visibility(false)
            end
        end)
    end)()

    -- The New World
    local ANARCHYCategory = MainWindow:NewPage(_G["pages"], "State of Anarchy")

    local GAMEVISUALSection = ANARCHYCategory:NewSection("Visuals")

    local Game_Visuals = {
        Containers = false,
        Containers_Range = 200,
        Container_Size = 15,
        Containers_Color = {R = 255, G = 0, B = 0}
    }

    local ANARCHYVISUALSFile = "BlissX/Anarchy/Visuals.dat"

    local function LoadANARCHYVisuals()
        local u, Result = pcall(readfile, ANARCHYVISUALSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Game_Visuals[i] ~= nil then
                        Game_Visuals[i] = v
                        pcall(Game_Visuals[i], v)
                    end
                end
            end
        end
    end

    LoadANARCHYVisuals()

    GAMEVISUALSection:NewToggle("Containers", function (NewValue)
        Game_Visuals.Containers = NewValue
    end, {default = Game_Visuals.Containers})

    GAMEVISUALSection:NewSlider("Range", function (NewValue)
        Game_Visuals.Containers_Range = NewValue
    end, {value = Game_Visuals.Containers_Range, min = 10, max = 4000, suffix = " studs"})

    GAMEVISUALSection:NewSlider("Text Size", function (NewValue)
        Game_Visuals.Container_Size = NewValue
    end, {value = Game_Visuals.Container_Size, min = 0, max = 50, suffix = " px"})

    GAMEVISUALSection:NewColorPicker("Color", function (NewValue)
        Game_Visuals.Containers_Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Game_Visuals.Containers_Color.R, Game_Visuals.Containers_Color.G, Game_Visuals.Containers_Color.B)})

    local Containers = {}
    local c = 0
    for i, v in pairs(game:GetService("Workspace").ChunkingSystem.Buildings:GetDescendants()) do
        if v.Name == "containers" then
            c = c + 1
            Containers[c] = v
        end
    end

    local function ESPContainer(v)
        local part_parent = v.Parent

        local NAME = drawing("Text")
        NAME.Visible = false
        NAME.Transparency = 0.8
        NAME.Color = RGB(0,0,0)
        NAME.Outline = true
        NAME.OutlineColor = RGB(0, 0, 0)
        NAME.Position = v2(0, 0)
        NAME.Size = 15
        NAME.Font = 3 
        NAME.Text = v.Name

        local function Update()
            local c 
            c = RS.RenderStepped:Connect(function()
                if Game_Visuals.Containers and v.Parent ~= nil then
                    local hook_part = v:FindFirstChildOfClass("Part") or v:FindFirstChildOfClass("BasePart") or v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("UnionOperation") 
                    if hook_part ~= nil then
                        local pos, vis = Camera:WorldToViewportPoint(hook_part.Position)
                        if vis and pos.Z < Game_Visuals.Containers_Range then
                            NAME.Position = v2(pos.X, pos.Y)
                            NAME.Color = RGB(Game_Visuals.Containers_Color.R, Game_Visuals.Containers_Color.G, Game_Visuals.Containers_Color.B)
                            NAME.Size = Game_Visuals.Container_Size

                            NAME.Visible = true
                        else 
                            NAME.Visible = false
                        end
                    else 
                        NAME.Visible = false
                    end
                else 
                    NAME.Visible = false
                    if v.Parent == nil then
                        NAME:Remove()
                        c:Disconnect()
                    end
                end 
            end)
        end
        coroutine.wrap(Update)()
    end

    for i, v in pairs(Containers) do
        for _, k in pairs(v:GetChildren()) do
            coroutine.wrap(ESPContainer)(k)
        end
    end

    for i, v in pairs(Containers) do
        v.ChildAdded:Connect(function(new)
            coroutine.wrap(ESPContainer)(new)
        end)
    end

    -- VISUALS
    local VISUALSCategory = MainWindow:NewPage(_G["pages"], "Visuals")

    -- ENVIRONMENT
    local ENVIRONMENTSection = VISUALSCategory:NewSection("Environment")

    local Environment_Settings = {
        Graphics_Enhancer = false,
        Toggle = false,
        Color_Change = false,
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = {R = Lighting.Ambient.R, G = Lighting.Ambient.G, B = Lighting.Ambient.B},
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    local ENVFile = "BlissX/Universal/Env.dat"

    local function LoadENV()
        local u, Result = pcall(readfile, ENVFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Environment_Settings[i] ~= nil then
                        Environment_Settings[i] = v
                        pcall(Environment_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadENV()

    local Previous_Environment = {
        ClockTime = Lighting.ClockTime,
        Brightness = Lighting.Brightness,
        Color = Lighting.Ambient,
        Technology = gethiddenproperty(Lighting, "Technology")
    }

    ENVIRONMENTSection:NewToggle("Toggle", function (NewValue)
        Environment_Settings.Toggle = NewValue
    end, {default = Environment_Settings.Toggle})

    ENVIRONMENTSection:NewToggle("Change Color", function (NewValue)
        Environment_Settings.Color_Change = NewValue
    end, {default = Environment_Settings.Color_Change})

    ENVIRONMENTSection:NewColorPicker("Ambient", function (NewValue)
        Environment_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B)})

    ENVIRONMENTSection:NewSlider("Brightness", function (NewValue)
        Environment_Settings.Brightness = NewValue
    end, {value = Environment_Settings.Brightness, min = 0, max = 10, suffix = ""})

    ENVIRONMENTSection:NewSlider("Clock Time", function (NewValue)
        Environment_Settings.ClockTime = NewValue
    end, {value = Environment_Settings.ClockTime, min = 0, max = 24, suffix = " h"})

    do
        local default_option
        local list =  {
            "Compatibility", 
            "Voxel",
            "ShadowMap",
            "Legacy",
            "Future"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Environment_Settings.Technology then
                default_option = i
            end
        end
        ENVIRONMENTSection:NewDropdown("Technology", function(Option)
            Environment_Settings.Technology = Enum.Technology[Option]
        end, {
            options = list,
            default = default_option
        })
    end

    ENVIRONMENTSection:NewToggle("Graphics Enhancer", function (NewValue)
        Environment_Settings.Graphics_Enhancer = NewValue
    end, {default = Environment_Settings.Graphics_Enhancer})

    coroutine.wrap(function() -- LOOP
        local function MOD(brightness, color, time, technology)
            Lighting.Brightness = brightness
            Lighting.ClockTime = time
            if Environment_Settings.Color_Change then
                Lighting.ColorShift_Bottom = color
                Lighting.ColorShift_Top = color
            else 
                Lighting.ColorShift_Bottom = Previous_Environment.Color
                Lighting.ColorShift_Top = Previous_Environment.Color
            end
            if gethiddenproperty(Lighting, "Technology") ~= technology then
                sethiddenproperty(Lighting, "Technology", technology)
            end
        end
        local deb = false
        local graphic_deb = false
        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                c:Disconnect()
            end
            if Environment_Settings.Graphics_Enhancer == false then
                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end
                graphic_deb = true
                if Environment_Settings.Toggle then
                    deb = true
                    MOD(Environment_Settings.Brightness, RGB(Environment_Settings.Color.R, Environment_Settings.Color.G, Environment_Settings.Color.B), Environment_Settings.ClockTime, Environment_Settings.Technology)
                elseif deb then
                    MOD(Previous_Environment.Brightness, Previous_Environment.Color, Previous_Environment.ClockTime, Previous_Environment.Technology)
                    deb = false
                end
            elseif graphic_deb then
                graphic_deb = false

                local t = Lighting:GetChildren()
                for i = 1, #t do
                    local v = t[i]
                    v:Destroy()
                end

                local ter = game:GetService("Workspace").Terrain
                local color = Instance.new("ColorCorrectionEffect")
                local bloom = Instance.new("BloomEffect")
                local sun = Instance.new("SunRaysEffect")
                local blur = Instance.new("BlurEffect")

                color.Parent = Lighting
                bloom.Parent = Lighting
                sun.Parent = Lighting
                blur.Parent = Lighting

                local config = {
                    Terrain = true;
                    ColorCorrection = true;
                    Sun = true;
                    Lighting = true;
                    BloomEffect = true;
                }

                color.Enabled = false
                color.Contrast = 0.15
                color.Brightness = 0.1
                color.Saturation = 0.25
                color.TintColor = RGB(255, 222, 211)

                bloom.Enabled = false
                bloom.Intensity = 0.1

                sun.Enabled = false
                sun.Intensity = 0.2
                sun.Spread = 1

                bloom.Enabled = false
                bloom.Intensity = 0.05
                bloom.Size = 32
                bloom.Threshold = 1

                blur.Enabled = false
                blur.Size = 6

                if config.ColorCorrection then
                    color.Enabled = true
                end

                if config.Sun then
                    sun.Enabled = true
                end

                if config.Terrain then
                    ter.WaterColor = RGB(10, 10, 24)
                    ter.WaterWaveSize = 0.1
                    ter.WaterWaveSpeed = 22
                    ter.WaterTransparency = 0.9
                    ter.WaterReflectance = 0.05
                end


                if config.Lighting then
                    Lighting.Ambient = RGB(0, 0, 0)
                    Lighting.Brightness = 4
                    Lighting.ColorShift_Bottom = RGB(0, 0, 0)
                    Lighting.ColorShift_Top = RGB(0, 0, 0)
                    Lighting.ExposureCompensation = 0
                    Lighting.FogColor = RGB(132, 132, 132)
                    Lighting.GlobalShadows = true
                    Lighting.OutdoorAmbient = RGB(112, 117, 128)
                    Lighting.Outlines = false
                end
            end
        end)
    end)()

    -- SCREEN STUFF
    local SCREENSection = VISUALSCategory:NewSection("Screen")

    local Stats_Settings = {
        ShowFPS = false,
        ShowPing = false,
        ShowPosition = false,
        Color = {R = 255, G = 0, B = 175},
        Text_Size = 18,
        Max_Zoom_Distance = 100,
        Tool_Tip = false,
    }

    local STATSFile = "BlissX/Universal/ScreenStats.dat"

    local function LoadSTATS()
        local u, Result = pcall(readfile, STATSFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Stats_Settings[i] ~= nil then
                        Stats_Settings[i] = v
                        pcall(Stats_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadSTATS()

    SCREENSection:NewToggle("Show FPS", function (NewValue)
        Stats_Settings.ShowFPS = NewValue
    end, {default = Stats_Settings.ShowFPS})

    SCREENSection:NewToggle("Show Ping", function (NewValue)
        Stats_Settings.ShowPing = NewValue
    end, {default = Stats_Settings.ShowPing})

    SCREENSection:NewToggle("Show Position", function (NewValue)
        Stats_Settings.ShowPosition = NewValue
    end, {default = Stats_Settings.ShowPosition})

    SCREENSection:NewColorPicker("Color", function (NewValue)
        Stats_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)})

    SCREENSection:NewSlider("Text Size", function (NewValue)
        Stats_Settings.Text_Size = NewValue
    end, {value = Stats_Settings.Text_Size, min = 1, max = 50, suffix = " px"})

    SCREENSection:NewSlider("Max Zoom Distance", function (NewValue)
        Stats_Settings.Max_Zoom_Distance = NewValue
    end, {value = Stats_Settings.Max_Zoom_Distance, min = 1, max = 5000, suffix = " studs"})

    coroutine.wrap(function() -- LOOP
        local function NewText()
            local t = drawing("Text")
            t.Visible = false
            t.Transparency = 0.8
            t.Color = RGB(255, 255, 255)
            t.Outline = true
            t.OutlineColor = RGB(10, 10, 10)
            t.Position = v2(0, 0)
            t.Size = 20
            t.Center = false
            t.Font = 3 
            t.Text = ""
            return t
        end
        local FPS = NewText()
        local PING = NewText()
        local POSITION = NewText()
        local c
        c = RS.RenderStepped:Connect(function(step)
            local fps_stat = 1/step
            if DESTROY_GUI then
                c:Disconnect()
                PING:Remove()
                FPS:Remove()
                POSITION:Remove()
            end
            local stats_col = RGB(Stats_Settings.Color.R, Stats_Settings.Color.G, Stats_Settings.Color.B)
            if Stats_Settings.ShowFPS then
                FPS.Size = Stats_Settings.Text_Size
                FPS.Text = "FPS: "..tostring(round(fps_stat))
                FPS.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y)
                FPS.Color = stats_col
                FPS.Visible = true
            else 
                FPS.Visible = false
            end
            Player.CameraMaxZoomDistance = Stats_Settings.Max_Zoom_Distance
            if Stats_Settings.ShowPing then
                local ping_stat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
                PING.Size = Stats_Settings.Text_Size
                PING.Text = "PING: "..tostring(round(ping_stat))
                PING.Color = stats_col
                PING.Visible = true

                local PingB = PING.TextBounds
                if FPS.Visible == false then
                    PING.Position = v2(5, Camera.ViewportSize.Y - PingB.Y)
                else
                    PING.Position = v2(5, Camera.ViewportSize.Y - FPS.TextBounds.Y - PingB.Y)
                end
            else 
                PING.Visible = false
            end
            if Stats_Settings.ShowPosition then
                if Player.Character ~= nil and Player.Character.PrimaryPart ~= nil then
                    local pos_stat = Player.Character.PrimaryPart.Position
                    POSITION.Size = Stats_Settings.Text_Size
                    POSITION.Text = "POSITION: "..round(pos_stat.X).." "..round(pos_stat.Y).." "..round(pos_stat.Z)
                    POSITION.Color = stats_col
                    POSITION.Visible = true

                    local PB = POSITION.TextBounds
                    local FP = FPS.TextBounds
                    if FPS.Visible == false and PING.Visible == false then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y)
                    elseif (FPS.Visible and PING.Visible == false) or (FPS.Visible == false and PING.Visible == true) then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y)
                    elseif FPS.Visible and PING.Visible then
                        POSITION.Position = v2(5, Camera.ViewportSize.Y - PB.Y - FP.Y*2)
                    end
                else 
                    POSITION.Visible = false
                end
            else 
                POSITION.Visible = false
            end
        end)
    end)()

    local CROSSHAIRSection = VISUALSCategory:NewSection("Crosshair")

    local Crosshair_Settings = {
        Enabled = false,
        Color = {R = 0, G = 255, B = 0},
        Lock = "Mouse",
        Size = 5,
        Offset = 2,
        Thickness = 1
    }

    local CROSSHAIRFile = "BlissX/Universal/Crosshair.dat"

    local function LoadCROSSHAIR()
        local u, Result = pcall(readfile, CROSSHAIRFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if Crosshair_Settings[i] ~= nil then
                        Crosshair_Settings[i] = v
                        pcall(Crosshair_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadCROSSHAIR()

    CROSSHAIRSection:NewToggle("Custom Crosshair", function (NewValue)
        Crosshair_Settings.Enabled = NewValue
    end, {default = Crosshair_Settings.Enabled})

    CROSSHAIRSection:NewColorPicker("Color", function (NewValue)
        Crosshair_Settings.Color = {R = NewValue.R*255, G = NewValue.G*255, B = NewValue.B*255}
    end, {default = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)})

    CROSSHAIRSection:NewSlider("Size", function (NewValue)
        Crosshair_Settings.Size = NewValue
    end, {value = Crosshair_Settings.Size, min = 1, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Offset", function (NewValue)
        Crosshair_Settings.Offset = NewValue
    end, {value = Crosshair_Settings.Offset, min = 0, max = 100, suffix = " px"})

    CROSSHAIRSection:NewSlider("Thickness", function (NewValue)
        Crosshair_Settings.Thickness = NewValue
    end, {value = Crosshair_Settings.Thickness, min = 1, max = 40, suffix = ""})

    do
        local default_option
        local list =  {
            "Mouse", 
            "Center"
        }
        for i = 1, #list do
            local v = list[i]
            if v == Crosshair_Settings.Lock then
                default_option = i
            end
        end
        CROSSHAIRSection:NewDropdown("Lock", function(Option)
            Crosshair_Settings.Lock = Option
        end, {
            options = list,
            default = default_option
        })
    end


    coroutine.wrap(function()
        local inset = game:service("GuiService"):GetGuiInset()
        local lines = { -- CROSSHAIR LINES
            up = NewLine(RGB(255, 0, 0), 1, 1),
            down = NewLine(RGB(255, 0, 0), 1, 1),
            left = NewLine(RGB(255, 0, 0), 1, 1),
            right = NewLine(RGB(255, 0, 0), 1, 1)
        }
        local c 
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                for i,v in pairs(lines) do
                    v:Remove()
                end
                c:Disconnect()
            end
            if Crosshair_Settings.Enabled then
                local center = v2(0,0)
                if Crosshair_Settings.Lock == "Mouse" then
                    center = v2(Mouse.X, Mouse.Y + inset.Y)
                elseif Crosshair_Settings.Lock == "Center" then
                    center = Camera.ViewportSize/2
                else 
                    center = Camera.ViewportSize/2
                end
    
                lines.up.From = center - v2(0, Crosshair_Settings.Offset)
                lines.up.To = center - v2(0, Crosshair_Settings.Offset) - v2(0, Crosshair_Settings.Size)

                lines.down.From = center + v2(0, Crosshair_Settings.Offset)
                lines.down.To = center + v2(0, Crosshair_Settings.Offset) + v2(0, Crosshair_Settings.Size)

                lines.left.From = center - v2(Crosshair_Settings.Offset, 0)
                lines.left.To = center - v2(Crosshair_Settings.Offset, 0) - v2(Crosshair_Settings.Size, 0)

                lines.right.From = center + v2(Crosshair_Settings.Offset, 0)
                lines.right.To = center + v2(Crosshair_Settings.Offset, 0) + v2(Crosshair_Settings.Size, 0)

                local crosshair_col = RGB(Crosshair_Settings.Color.R, Crosshair_Settings.Color.G, Crosshair_Settings.Color.B)
                for i,v in pairs(lines) do
                    v.Color = crosshair_col
                    v.Thickness = Crosshair_Settings.Thickness
                    v.Visible = true
                end
            else 
                for i,v in pairs(lines) do
                    v.Visible = false
                end
            end
        end)
    end)()

    -- BLATANT
    local BLATANTCategory = MainWindow:NewPage(_G["pages"], "Blatant (!)")

    -- PLAYER
    local PLAYER_BLATANTSection = BLATANTCategory:NewSection("Player")

    local PLAYER_Settings = {
        WalkSpeed = false,
        WalkSpeedValue = Player.Character.Humanoid.WalkSpeed,
        JumpPower = false,
        JumpPowerValue = Player.Character.Humanoid.JumpPower
    }

    local PLAYERFile = "BlissX/Universal/Player.dat"

    local function LoadPLAYERMODS()
        local u, Result = pcall(readfile, PLAYERFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if PLAYER_Settings[i] ~= nil then
                        PLAYER_Settings[i] = v
                        pcall(PLAYER_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadPLAYERMODS()

    PLAYER_BLATANTSection:NewToggle("Walk Speed", function (NewValue)
        PLAYER_Settings.WalkSpeed = NewValue
    end, {default = PLAYER_Settings.WalkSpeed})

    PLAYER_BLATANTSection:NewSlider("Speed Value", function (NewValue)
        PLAYER_Settings.WalkSpeedValue = NewValue
    end, {value = PLAYER_Settings.WalkSpeedValue,min = 0, max = 200, suffix = " studs/s"})

    PLAYER_BLATANTSection:NewToggle("Jump Power", function (NewValue)
        PLAYER_Settings.JumpPower = NewValue
    end, {default = PLAYER_Settings.JumpPower})

    PLAYER_BLATANTSection:NewSlider("Jump Value", function (NewValue)
        PLAYER_Settings.JumpPowerValue = NewValue
    end, {value = PLAYER_Settings.JumpPowerValue, min = round(PLAYER_Settings.JumpPowerValue), max = 5000, suffix = ""})

    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__index

    local ospeed = PLAYER_Settings.WalkSpeedValue
    local ojump = PLAYER_Settings.JumpPowerValue

    local function ModCharacterValues()
        mt.__index = newcclosure(function(self, a)
            if a == "WalkSpeed" then
                return ospeed
            elseif a == "JumpPower" then
                return ojump
            end
            return old(self, a)
        end)

        local c
        c = RS.RenderStepped:Connect(function()
            if DESTROY_GUI then
                if Player.Character ~= nil and Player.Character:FindFirstChildOfClass("Humanoid") then
                    Player.Character.Humanoid.WalkSpeed = ospeed
                    Player.Character.Humanoid.WalkSpeed = ojump
                end
                c:Disconnect()
            end
            
            if Player.Character ~= nil and Player.Character:FindFirstChildOfClass("Humanoid") then
                if PLAYER_Settings.WalkSpeed then
                    Player.Character.Humanoid.WalkSpeed = PLAYER_Settings.WalkSpeedValue
                else
                    Player.Character.Humanoid.WalkSpeed = ospeed
                end

                if PLAYER_Settings.JumpPower then
                    Player.Character.Humanoid.JumpPower = PLAYER_Settings.JumpPowerValue
                else
                    Player.Character.Humanoid.JumpPower = ojump
                end
            end
        end)
    end
    coroutine.wrap(ModCharacterValues)()

    -- GUI (LAST)
    local GUI_Settings = {
        theme = "Fire",
        toggle_bind = "End"
    }
    
    local GUIFile = "BlissX/Universal/GUI.dat"

    local function LoadGUI()
        local u, Result = pcall(readfile, GUIFile)
        if u then
            local x, Table = pcall(HttpService.JSONDecode, HttpService, Result)
            if x then
                for i, v in pairs(Table) do
                    if GUI_Settings[i] ~= nil then
                        GUI_Settings[i] = v
                        pcall(GUI_Settings[i], v)
                    end
                end
            end
        end
    end

    LoadGUI()

    _G["Theme"] = themes[GUI_Settings.theme]
    MainWindow:UpdateTheme()

    local GUICategory = MainWindow:NewPage(_G["pages"], "Settings")

    local GUISection = GUICategory:NewSection("GUI")

    GUISection:NewKeybind("Toggle", function(newbind)
        GUI_Settings.toggle_bind = string.sub(tostring(newbind), 14, #tostring(newbind))
        MainWindow:Toggle()
    end, {keybind = Enum.KeyCode[GUI_Settings.toggle_bind]})

    do
        local default_option
        local list =  {
            "Fire",
            "Forest",
            "Ocean",
            "Grayscale",
            "Midnight",
        }
        for i = 1, #list do
            local v = list[i]
            if v == GUI_Settings.theme then
                default_option = i
            end
        end
        GUISection:NewDropdown("Theme", function(Option)
            GUI_Settings.theme = Option
            _G["Theme"] = themes[Option]
            MainWindow:UpdateTheme()
        end, {
            options = list,
            default = default_option
        })
    end

    GUISection:NewButton("Update Theme", function()
        MainWindow:UpdateTheme()
    end)

    GUISection:NewButton("Kill", function()
        DESTROY_GUI = true
        MainWindow:Kill()
    end)

    GUISection:NewButton("Save Config", function()
        writefile(ESPFile, game:service("HttpService"):JSONEncode(ESP_Settings))
        writefile(AIMBOTFile, game:service("HttpService"):JSONEncode(AIMBOT_Settings))
        writefile(ANARCHYVISUALSFile, game:service("HttpService"):JSONEncode(Game_Visuals))
        writefile(ENVFile, game:service("HttpService"):JSONEncode(Environment_Settings))
        writefile(PLAYERFile, game:service("HttpService"):JSONEncode(PLAYER_Settings))
        writefile(STATSFile, game:service("HttpService"):JSONEncode(Stats_Settings))
        writefile(CROSSHAIRFile, game:service("HttpService"):JSONEncode(Crosshair_Settings))
        writefile(GUIFile, game:service("HttpService"):JSONEncode(GUI_Settings))
    end)
end