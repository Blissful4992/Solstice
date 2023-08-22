-- UnivSettings
UnivSettings = {
    Visuals = {
        Toggle = false;
        Max_Distance = 1000;
    
        Info = false;
        Names = false;
        Health = false;
        Distance = false;
    
        Boxes = false;
        Boxes_Mode = "Corners";
    
        Health_Bar = false;
        Health_Bar_Low = {R = 255, G = 0, B = 0, A = 1};
        Health_Bar_High = {R = 0, G = 255, B = 0, A = 1};
    
        Tracers = false;
        Tracer_Origin = "Bottom";
    
        Color = {R = 255, G = 255, B = 0, A = 1};
    
        Show_Target = false;
        Target_Color = {R = 255, G = 255, B = 255, A = 1};
    
        Team_Check = false;
        Team_Color = {R = 0, G = 255, B = 0, A = 1};
        Enemy_Color = {R = 255, G = 0, B = 0, A = 1};
    
        Show_Enemy = true;
        Show_Team = true;
        Show_Team_Color = false;
    };

    Aimbot = {
        Group_Type = "Players";

        Toggle = false;
        -- Toggle_Keybind = "G";

        Prediction = false;
        Prediction_Delay = 2;
        Prediction_Key = "none";

        Bone = "Head";
        Smoothness = 25;
        
        Headshot_Chance = 100;

        Max_Distance = 500;

        Lock_On = false;

        Distance_Type = "Mouse";
        -- Aim_Key = "Q";
        Aim_Mode = "Mouse";

        Team_Check = false;

        FOV = false;
        FOV_Radius = 50;
        FOV_Color = {R = 255, G = 255, B = 255};
    }
}

UnivSettingsFile = "Solstice/universal.dat";

function UnivLoad() -- LOAD SETTINGS (can be forked into a multiple config system)
    local Result = readfile(UnivSettingsFile) or "{}";
    local Table = HttpService:JSONDecode(Result) or {};

    UnivSettings = util.merge(UnivSettings or {}, Table);
end

function UnivSave() -- SAVE SETTINGS
    writefile(UnivSettingsFile, HttpService:JSONEncode(UnivSettings or {}) or "{}");
end

function UnivSaveDefault() -- SAVE SETTINGS
    if not isfile(UnivSettingsFile) then
        writefile(UnivSettingsFile, HttpService:JSONEncode(UnivSettings or {}) or "{}");
    end
end
UnivSaveDefault()

-- Page Toggles
VISUALS = true;
AIMBOT = true;

-- Visuals
if VISUALS then
    VisualsPage = Window.newPage({Text = "Visuals"})

    VisualsPage:newToggle({
        Text = "Toggle", 
        Callback = function(bool) 
            UnivSettings.Visuals.Toggle = bool
        end, 
        Default = UnivSettings.Visuals.Toggle
    })

    VisualsPage:newSlider({
        Text = "Max Distance",
        Callback = function(newvalue)
            UnivSettings.Visuals.Max_Distance = newvalue
        end,
        Default = UnivSettings.Visuals.Max_Distance,
        Min = 10, Max = 6000, 
        Decimals = 0, 
        Suffix = " s"
    })

    VisualsPage:newPicker({
        Text = "Main", 
        Callback = function(col, a)
            UnivSettings.Visuals.Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Color), UnivSettings.Visuals.Color.A}
    })

    VisualsPage:newToggle({
        Text = "Team Check", 
        Callback = function(bool) 
            UnivSettings.Visuals.Team_Check = bool
        end, 
        Default = UnivSettings.Visuals.Team_Check
    })

    VisualsPage:newPicker({
        Text = "Team", 
        Callback = function(col, a)
            UnivSettings.Visuals.Team_Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Team_Color), UnivSettings.Visuals.Team_Color.A}
    })


    VisualsPage:newPicker({
        Text = "Enemies", 
        Callback = function(col, a)
            UnivSettings.Visuals.Enemy_Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Enemy_Color), UnivSettings.Visuals.Enemy_Color.A}
    })

    VisualsPage:newToggle({
        Text = "Show Enemy", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Enemy = bool
        end, 
        Default = UnivSettings.Visuals.Show_Enemy
    })

    VisualsPage:newToggle({
        Text = "Show Team", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Team = bool
        end, 
        Default = UnivSettings.Visuals.Show_Team
    })

    VisualsPage:newToggle({
        Text = "Show Team Color", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Team_Color = bool
        end, 
        Default = UnivSettings.Visuals.Show_Team_Color
    })

    VisualsPage:newToggle({
        Text = "Show Target", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Target = bool
        end, 
        Default = UnivSettings.Visuals.Show_Target
    })

    VisualsPage:newPicker({
        Text = "Target", 
        Callback = function(col, a)
            UnivSettings.Visuals.Target_Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Target_Color), UnivSettings.Visuals.Target_Color.A}
    })

    -- Info
    VisualsPage:newSeparator();
    
    VisualsPage:newToggle({
        Text = "Info", 
        Callback = function(bool) 
            UnivSettings.Visuals.Info = bool
        end, 
        Default = UnivSettings.Visuals.Info
    })

    VisualsPage:newChipset({
        Text = "Options", 
        Callback = function(tbl)
            UnivSettings.Visuals.Names = tbl["Names"]
            UnivSettings.Visuals.Health = tbl["Health"]
            UnivSettings.Visuals.Distance = tbl["Distance"]
        end, 
        Options = {
            Names = UnivSettings.Visuals.Names;
            Health = UnivSettings.Visuals.Health;
            Distance = UnivSettings.Visuals.Distance;
        }
    })

    -- Boxes
    VisualsPage:newSeparator();

    VisualsPage:newToggle({
        Text = "Boxes", 
        Callback = function(bool) 
            UnivSettings.Visuals.Boxes = bool
        end, 
        Default = UnivSettings.Visuals.Boxes
    })

    do
        local default_option
        local list = {
            "Corners";
            "Outline";
        }
        for i = 1, #list do
            local v = list[i]
            if v == UnivSettings.Visuals.Boxes_Mode then
                default_option = i
            end
        end
        VisualsPage:newDropdown({
            Text = "Box Type", 
            Callback = function(option)
                UnivSettings.Visuals.Boxes_Mode = option
            end, 
            Options = list, 
            Default = default_option
        })
    end

    VisualsPage:newToggle({
        Text = "Health Bar", 
        Callback = function(bool) 
            UnivSettings.Visuals.Health_Bar = bool
        end, 
        Default = UnivSettings.Visuals.Health_Bar
    })

    VisualsPage:newPicker({
        Text = "Health Bar High", 
        Callback = function(col, a)
            UnivSettings.Visuals.Health_Bar_High = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Health_Bar_High), UnivSettings.Visuals.Health_Bar_High.A}
    })

    VisualsPage:newPicker({
        Text = "Health Bar Low", 
        Callback = function(col, a)
            UnivSettings.Visuals.Health_Bar_Low = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Health_Bar_Low), UnivSettings.Visuals.Health_Bar_Low.A}
    })

    -- Tracers
    VisualsPage:newSeparator();

    VisualsPage:newToggle({
        Text = "Tracers", 
        Callback = function(bool) 
            UnivSettings.Visuals.Tracers = bool
        end, 
        Default = UnivSettings.Visuals.Tracers
    })

    do
        local default_option
        local list = {
            "Bottom";
            "Middle";
            "Mouse";
        }
        for i = 1, #list do
            local v = list[i]
            if v == UnivSettings.Visuals.Tracer_Origin then
                default_option = i
            end
        end
        VisualsPage:newDropdown({
            Text = "Tracer Origin", 
            Callback = function(option)
                UnivSettings.Visuals.Tracer_Origin = option
            end, 
            Options = list, 
            Default = default_option
        })
    end

    -- Draw function player
    draw.addPlayer = function(plr)
        repeat WAIT() until plr.Character;

        local INFO = draw.newText({Outline = true, OutlineColor = RGB(20, 20, 20)});
        INFO.Center = true;

        local Box = draw.newSquare({Thickness = 1});
        
        local healthBarBackground = draw.newLine({Color = RGB(0,0,0), Thickness = 3, Transparency = 0.4});
        local healthBar = draw.newLine({Thickness = 1});

        local cornerLines = {}
        for i = 1, 8 do
            cornerLines[i] = draw.newLine({});
        end

        local Tracer = draw.newLine({Thickness = 1})

        local function cornersVisibility(state)
            if cornerLines[1].Visible == not state then
                for i = 1,8 do
                    cornerLines[i].Visible = state;
                end
            end
        end
        local function boxVisibility(state, mode)
            if state then
                if mode == 1 then
                    Box.Visible = true;
                    cornersVisibility(false);
                else
                    Box.Visible = false;
                    cornersVisibility(true);
                end
            else
                Box.Visible = false;
                cornersVisibility(false);
            end
        end
        local function Visibility(state)
            boxVisibility(false);
            Tracer.Visible = false;
            INFO.Visible = false;
            healthBar.Visible = false;
            healthBarBackground.Visible = false;
        end

        local function destroyESP()
            INFO:Remove();
            Tracer:Remove();
            Box:Remove();
            healthBar:Remove();
            healthBarBackground:Remove();
            for i = 1, #cornerLines do
                cornerLines[i]:Remove();
            end
        end

        local function updateInfoColor(colorArray)
            local c = util.Array_c3(colorArray);

            INFO.Color = c;
            INFO.Transparency = colorArray.A;
        end

        local function updateLineColors(colorArray)
            local c = util.Array_c3(colorArray);

            Tracer.Color = c;
            Tracer.Transparency = colorArray.A;

            Box.Color = c;
            Box.Transparency = colorArray.A;

            for i = 1, #cornerLines do
                cornerLines[i].Color = c;
                cornerLines[i].Transparency = colorArray.A;
            end
        end

        -- UPDATE ESP
        local prevhealth = nil;
        local Character = nil;

        local hide_name = Enum.HumanoidDisplayDistanceType.None;
        local show_name = Enum.HumanoidDisplayDistanceType.Viewer;

        local c; c = RS.Heartbeat:Connect(function()
            -- Destroy Check
            if DESTROY then
                destroyESP();
                c:Disconnect();
                return;
            end

            --- Player Check
            local Character = plr.Character
            if not (UnivSettings.Visuals.Toggle and Player.Character and Character and Character:FindFirstChild("Humanoid")) then
                Visibility(false);
                if Players:FindFirstChild(plr.Name) == nil then
                    destroyESP();
                    c:Disconnect();
                end
                return;
            end

            -- Define player stuff..
            local local_root_part = Player.Character.PrimaryPart;
            local root_part = Character.PrimaryPart;
            local human = Character:FindFirstChild("Humanoid");

            if human.Health <= 0 then
                Visibility(false);
                return;
            end

            -- Team Check + Exists Check
            local teamCheck = true;
            if (not UnivSettings.Visuals.Show_Team) and (plr.TeamColor == Player.TeamColor) then
                teamCheck = false;
            elseif (not UnivSettings.Visuals.Show_Enemy) and (plr.TeamColor ~= Player.TeamColor) then
                teamCheck = false;
            end
            if not (teamCheck and local_root_part and root_part) then
                Visibility(false);
                human.DisplayDistanceType = show_name;
                return;
            end

            -- Update camera for those sneaky Games
            Camera = Space.CurrentCamera

            -- Dist Check + On Screen
            local dist = (root_part.Position - local_root_part.Position).magnitude;
            local root_pos, onscreen = toPoint(Camera, root_part.Position);
            if not (onscreen and dist < UnivSettings.Visuals.Max_Distance) then
                Visibility(false);
                human.DisplayDistanceType = show_name;
                return;
            end

            -- Get Current Color based on UnivSettings
            local Current_Color;
            if UnivSettings.Visuals.Team_Check then
                if plr.TeamColor == Player.TeamColor then
                    Current_Color = UnivSettings.Visuals.Team_Color;
                else 
                    Current_Color = UnivSettings.Visuals.Enemy_Color;
                end
            else
                Current_Color = UnivSettings.Visuals.Color;
            end

            -- Team Color
            if UnivSettings.Visuals.Show_Team_Color then
                Current_Color = util.c3_Array(plr.TeamColor.Color, 1);
            end

            updateInfoColor(Current_Color);

            local Hum_Health = human.Health
            local Hum_MaxHealth = human.MaxHealth

            if UnivSettings.Aimbot.Toggle and UnivSettings.Visuals.Show_Target and Selected_Player ~= nil and plr == Selected_Player then
                Current_Color = UnivSettings.Visuals.Target_Color
            end

            updateLineColors(Current_Color)

            local ratio = 2500/root_pos.Z

            local newsize_x = FLOOR(ratio/2)
            local newsize_y = FLOOR(ratio * 1.75 / 2)
            
            local root_x = FLOOR(root_pos.X)
            local root_y = FLOOR(root_pos.Y)

            -- BOX MAP
            local TL = V2(root_x-newsize_x, root_y-newsize_y)
            local TR = V2(root_x+newsize_x, root_y-newsize_y)
            local BL = V2(root_x-newsize_x, root_y+newsize_y)
            local BR = V2(root_x+newsize_x, root_y+newsize_y)

            -- TRACERS
            if UnivSettings.Visuals.Tracers then
                local Origin = UnivSettings.Visuals.Tracer_Origin
                if Origin == "Mouse" then
                    Tracer.From = V2(Mouse.X, Mouse.Y + UI_Inset.Y)
                elseif Origin == "Middle" then
                    Tracer.From = Camera.ViewportSize/2
                else
                    Tracer.From = V2(Camera.ViewportSize.X/2, Camera.ViewportSize.Y-10)
                end
                Tracer.To = V2(BL.X+(BL - BR).magnitude/2, BL.Y)
                Tracer.Visible = true
            else
                Tracer.Visible = false
            end

            -- HEALTH BAR
            if UnivSettings.Visuals.Health_Bar and dist < 1450 then
                local offsetX = CLAMP(ROUND(200/root_pos.Z), 4, 8)

                local Right = root_x + newsize_x
                local Top = root_y - newsize_y
                local Bottom = root_y + newsize_y
                local barPosX = Right + offsetX

                healthBarBackground.From = V2(barPosX, Top)
                healthBarBackground.To = V2(barPosX, Bottom)

                local HealthRatio = Hum_Health/Hum_MaxHealth
                local Length = ABS((Bottom-1) - (Top+1))
                local HealthLength = FLOOR(Length * HealthRatio)

                healthBar.From = V2(barPosX, Top+1)
                healthBar.To = V2(barPosX, Top+1 + HealthLength)

                if Hum_Health ~= prevhealth then
                    healthBar.Color = util.Array_c3(UnivSettings.Visuals.Health_Bar_Low):Lerp(util.Array_c3(UnivSettings.Visuals.Health_Bar_High), HealthRatio)
                    prevhealth = Hum_Health
                end

                healthBar.Visible = true
                healthBarBackground.Visible = true
            else 
                healthBar.Visible = false
                healthBarBackground.Visible = false
            end

            -- BOXES
            if UnivSettings.Visuals.Boxes and dist < 1200 then
                local box_mode = UnivSettings.Visuals.Boxes_Mode

                if box_mode == "Corners" then
                    local offset = FLOOR(ratio/4)
                    local Dir1 = V2(offset, 0)
                    local Dir2 = V2(0, offset)

                    -- 1
                    cornerLines[1].From = TL
                    cornerLines[1].To = TL + Dir1

                    cornerLines[2].From = TL
                    cornerLines[2].To = TL + Dir2

                    -- 2
                    cornerLines[3].From = TR
                    cornerLines[3].To = TR - Dir1

                    cornerLines[4].From = TR
                    cornerLines[4].To = TR + Dir2

                    -- 3
                    cornerLines[5].From = BL
                    cornerLines[5].To = BL + Dir1

                    cornerLines[6].From = BL
                    cornerLines[6].To = BL - Dir2

                    -- 4
                    cornerLines[7].From = BR
                    cornerLines[7].To = BR - Dir1

                    cornerLines[8].From = BR
                    cornerLines[8].To = BR - Dir2

                    boxVisibility(true, 2)
                else
                    Box.Position = TL;
                    Box.Size = V2(FLOOR(ratio), newsize_y*2);

                    boxVisibility(true, 1)
                end
            else 
                healthBar.Visible = false
                healthBarBackground.Visible = false
                boxVisibility(false)
            end

            -- INFO
            if UnivSettings.Visuals.Info then
                INFO.Position = V2(root_x, root_y-newsize_y-INFO.TextBounds.Y)
                INFO.Text = ""

                human.DisplayDistanceType = hide_name

                if UnivSettings.Visuals.Names then
                    INFO.Text = plr.Name
                end

                if UnivSettings.Visuals.Health then
                    INFO.Text = tostring(ROUND(Hum_Health/Hum_MaxHealth*100)).."% ".. INFO.Text
                end

                if UnivSettings.Visuals.Distance then
                    INFO.Text = INFO.Text.." ("..tostring(ROUND(dist)).."s)"
                end        
                
                INFO.Visible = true
            else
                INFO.Visible = false
                human.DisplayDistanceType = show_name
            end
        end)
    end


    for _, Other in next, Players:GetPlayers() do
        if Other.Name ~= Player.Name then
            WRAP(draw.addPlayer)(Other)
        end
    end

    local c_added; c_added = Players.ChildAdded:Connect(function(Other)
        if DESTROY then
            c_added:Disconnect()
        else
            WRAP(draw.addPlayer)(Other)
        end
    end)
end

if AIMBOT then
    AimbotPage = Window.newPage({Text = "Aiming"})

    AimbotPage:newToggle({
        Text = "Aimbot", 
        Callback = function(bool) 
            UnivSettings.Aimbot.Toggle = bool

            if bool then 
                Aimbot_Once_HB = RS.Heartbeat:Connect(Aimbot_Once);
            elseif Aimbot_Once_HB then
                Aimbot_Once_HB:Disconnect();
            end
        end, 
        Default = UnivSettings.Aimbot.Toggle
    })

    AimbotPage:newToggle({
        Text = "Lock On", 
        Callback = function(bool) 
            UnivSettings.Aimbot.Lock_On = bool
        end, 
        Default = UnivSettings.Aimbot.Lock_On
    })

    AimbotPage:newSlider({
        Text = "Smoothness",
        Callback = function(newvalue)
            UnivSettings.Aimbot.Smoothness = newvalue
        end,
        Default = UnivSettings.Aimbot.Smoothness,
        Min = 0, Max = 100, 
        Decimals = 0, 
        Suffix = " f"
    })

    AimbotPage:newSlider({
        Text = "Max Distance",
        Callback = function(newvalue)
            UnivSettings.Aimbot.Max_Distance = newvalue
        end,
        Default = UnivSettings.Aimbot.Max_Distance,
        Min = 10, Max = 1500, 
        Decimals = 0, 
        Suffix = " s"
    })

    do
        local default_option
        local list =  {
            "Head"; 
            "Torso"; 
            "Feet";
        }
        for i = 1, #list do
            local v = list[i]
            if v == UnivSettings.Aimbot.Bone then
                default_option = i
            end
        end

        AimbotPage:newDropdown({
            Text = "Bone", 
            Callback = function(option)
                UnivSettings.Aimbot.Bone = option
            end, 
            Options = list, 
            Default = default_option
        })
    end

    do
        local default_option
        local list =  {
            "Mouse";
            "Distance";
        }
        for i = 1, #list do
            local v = list[i]
            if v == UnivSettings.Aimbot.Distance_Type then
                default_option = i
            end
        end

        AimbotPage:newDropdown({
            Text = "Distance Type", 
            Callback = function(option)
                UnivSettings.Aimbot.Distance_Type = option
            end, 
            Options = list, 
            Default = default_option
        })
    end

    AimbotPage:newToggle({
        Text = "Team Check", 
        Callback = function(bool) 
            UnivSettings.Aimbot.Team_Check = bool
        end, 
        Default = UnivSettings.Aimbot.Team_Check
    })

    -- Silent Aim
    AimbotPage:newSeparator()

    AimbotPage:newToggle({
        Text = "Silent Aim", 
        Callback = function(bool) 
            UnivSettings.Aimbot.Silent_Aim = bool
        end, 
        Default = UnivSettings.Aimbot.Silent_Aim
    })

    AimbotPage:newSlider({
        Text = "Headshot Chance",
        Callback = function(newvalue)
            UnivSettings.Aimbot.Headshot_Chance = newvalue
        end,
        Default = UnivSettings.Aimbot.Headshot_Chance,
        Min = 0, Max = 100, 
        Decimals = 0, 
        Suffix = "%"
    })

    AimbotPage:newToggle({
        Text = "Prediction", 
        Callback = function(bool) 
            UnivSettings.Aimbot.Prediction = bool
        end, 
        Default = UnivSettings.Aimbot.Prediction
    })

    AimbotPage:newSlider({
        Text = "Prediction Delay",
        Callback = function(newvalue)
            UnivSettings.Aimbot.Prediction_Delay = newvalue
        end,
        Default = UnivSettings.Aimbot.Prediction_Delay,
        Min = 1, Max = 15, 
        Decimals = 0, 
        Suffix = " f"
    })

    -- FOV
    FOV = draw.newCircle({Transparency = 0.75, NumSides = 75, Radius = 1, Filled = false, Thickness = 1})
    function updateFov()
        while WAIT() do
            if DESTROY then
                if FOV then
                    FOV:Remove()
                end
                return;
            end

            if UnivSettings.Aimbot.FOV then
                FOV.Radius = UnivSettings.Aimbot.FOV_Radius
                FOV.Thickness = 1
                FOV.Color = util.Array_c3(UnivSettings.Aimbot.FOV_Color)
                FOV.Transparency = UnivSettings.Aimbot.FOV_Color.A
                FOV.Position = V2(Mouse.X, Mouse.Y + 36)
                FOV.Visible = true
            else 
                FOV.Radius = 2000
                FOV.Position = Camera.ViewportSize / 2
                FOV.Visible = false
                return
            end
        end
    end
    function RESET_FUNCTIONS.Reset_FOV()
        FOV:Remove()
    end

    AimbotPage:newToggle({
        Text = "FOV Circle", 
        Callback = function(bool) 
            UnivSettings.Aimbot.FOV = bool

            if bool then 
                SPAWN(updateFov)
            end
        end, 
        Default = UnivSettings.Aimbot.FOV
    })
    if UnivSettings.Aimbot.FOV then
        SPAWN(updateFov)
    end

    AimbotPage:newSlider({
        Text = "Radius",
        Callback = function(newvalue)
            UnivSettings.Aimbot.FOV_Radius = newvalue
        end,
        Default = UnivSettings.Aimbot.FOV_Radius,
        Min = 0, Max = 500, 
        Decimals = 0, 
        Suffix = " px"
    })

    AimbotPage:newPicker({
        Text = "Color", 
        Callback = function(col, a)
            UnivSettings.Aimbot.FOV_Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Aimbot.FOV_Color), UnivSettings.Aimbot.FOV_Color.A}
    })

    -- Aimbot Functions
    local Aiming = false

    local aim_c_1; aim_c_1 = UIS.InputBegan:Connect(function(input)
        if DESTROY then
            if aim_c_1 then
                aim_c_1:Disconnect();
            end
            aim_c_1 = nil;
            Aiming = false;
        elseif Settings.Aimbot.Aim_Mode == "Key" and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[Settings.Aimbot.Aim_Key] then
            Aiming = true
        elseif Settings.Aimbot.Aim_Mode == "Mouse" and input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = true
        end
    end)

    local aim_c_2; aim_c_2 = UIS.InputEnded:Connect(function(input)
        if DESTROY then
            if aim_c_2 then
                aim_c_2:Disconnect();
            end
            aim_c_2 = nil;
            Aiming = false;
        elseif Settings.Aimbot.Aim_Mode == "Key" and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[Settings.Aimbot.Aim_Key] then
            Aiming = false
        elseif Settings.Aimbot.Aim_Mode == "Mouse" and input.UserInputType == Enum.UserInputType.MouseButton2 then
            Aiming = false
        end
    end)

    gravity = V3(0, 0, 0)
    function getBulletDrop(travelDistance, bulletSpeed)
        local travelTime = travelDistance/bulletSpeed
        return gravity * travelTime ^ 2
    end
    
    function predictVelocity(part, offset, Vp)
        if not Player.Character or not Player.Character.PrimaryPart then return nil end

        if UnivSettings.Aimbot.Prediction and (Vp or HUGE) < 10000 then
            -- Vp => Projectile Speed
            -- warn("Projectile speed:", Vp)

            local T1 = part.Position + offset -- Target Position 1

            local St = tick()
            for i = 1, UnivSettings.Aimbot.Prediction_Delay do -- time to wait in Frames to calculate Velc.
                RS.RenderStepped:Wait()
            end
            local t = tick() - St

            local P2 = Player.Character.PrimaryPart.Position          -- Local Position 2
            local T2 = part.Position + offset                   -- Target Position 2
            local Vt = (T1-T2).magnitude/t                               -- Explicit Target Speed
            local Tf = (P2-T2).magnitude/Vp                           -- Explicit Bullet Fly Time
            local To = Vt * Tf                                      -- Distance Moved during Arrow Fly Time
            local Ot = T2-T1                                     -- Offset between 1st T Pos and 2nd T Pos
            local Dt = CF(T2, T2 + Ot + V3(SMALL,SMALL,SMALL))     -- Target Facing Direction

            local Fp = (Dt * CF(0, 0, -To)).p                    -- Final Position without Bullet Drop Compensated
            local Bd = getBulletDrop((P2-Fp).magnitude, Vp)         -- Calculate Bullet Drop
            Fp = Fp + Bd                                              -- Final Position with Bullet Drop Compensated

            return Fp
        end
        return part.Position + offset
    end

    -- function isTargetable(plr)
    --     if UnivSettings.Aimbot.List_Type == "None" then
    --         return true
    --     elseif UnivSettings.Aimbot.List_Type == "Blacklist" then
    --         return Whitelisted_Players[plr.Name]
    --     elseif UnivSettings.Aimbot.List_Type == "Whitelist" then
    --         return not Whitelisted_Players[plr.Name]
    --     end
    -- end

    function isValidTarget(target, localPos, MIN)
        if not target then
            return false
        end

        -- Self check
        if target == Player then
            return false
        end

        -- Char check
        local char = target.Character
        if not char or not char.PrimaryPart then
            return false
        end
        local root = char.PrimaryPart;

        local human = char:FindFirstChildOfClass("Humanoid")
        if not human then
            return false
        end

        -- Health Check
        if human.Health <= 0 then
            return false
        end
        
        -- -- Check that player can be targeted
        -- if not isTargetable(target) then
        --     return false
        -- end
        
        -- Team Check
        if UnivSettings.Aimbot.Team_Check and target.TeamColor == Player.TeamColor then
            return false
        end
        
        -- Distance Check
        if (root.Position - localPos).magnitude > UnivSettings.Aimbot.Max_Distance then
            return false
        end

        -- Update closest player
        local pos2D, visible = toPoint(Camera, root.Position)
        if not visible then
            return false
        end

        if UnivSettings.Aimbot.Distance_Type == "Mouse" then
            local d = (V2(pos2D.X, pos2D.Y) - FOV.Position).magnitude
            if d <= FOV.Radius and d < MIN then
                return true, d
            end
        elseif UnivSettings.Aimbot.Distance_Type == "Distance" then 
            local d = (root.Position - localPos).magnitude
            if d < MIN then
                return true, d
            end
        end
    end


    function getClosest()
        if not Player.Character or not Player.Character.PrimaryPart then return nil end

        local Closest;

        do -- main loop
            local bone = UnivSettings.Aimbot.Bone

            if bone ~= "Head" and bone ~= "Torso" and bone ~= "Feet" then return nil end

            local MIN = HUGE
            local localPos = Player.Character.PrimaryPart.Position

            for _, target in next, Players:GetPlayers() do
                local valid, d = isValidTarget(target, localPos, MIN)
                if valid then
                    Closest = target
                    MIN = d
                end
            end
        end

        return Closest
    end

    function Update_Selected()
        -- If there was a selected thing before
        if UnivSettings.Aimbot.Lock_On and Selected_Player then
            local localPos = Player.Character.PrimaryPart.Position;
            local valid, d = isValidTarget(Selected_Player, localPos, HUGE);
            if not valid then
                Selected_Player = getClosest();
            end
        else
            Selected_Player = getClosest();
        end

        if Selected_Player then
            local char = Selected_Player.Character;
            if not char then
                return;
            end

            local root = char.PrimaryPart
            if not root then
                return;
            end

            -- Get Projectile Power
            local ProjectilePower = getProjectilePower and getProjectilePower() or 1500;

            -- 
            local p = root.Position
            local part = UnivSettings.Aimbot.Bone

            -- Regular Aimbot Pos
            do
                if part == "Head" and char:FindFirstChild("Head") then
                    p = predictVelocity(char.Head or root, V3(0,0,0), ProjectilePower)
                elseif part == "Torso" then
                    p = predictVelocity(root, V3(0,0,0), ProjectilePower)
                elseif part == "Feet" then
                    p = predictVelocity(root, V3(0, -2.5, 0), ProjectilePower)
                else 
                    p = predictVelocity(root, V3(0,0,0), ProjectilePower)
                end
                Selected_Aim_Pos = p;
            end

            -- Silent Aim Pos (headshot chance)
            if UnivSettings.Aimbot.Headshot_Chance < 90 and part == "Head" and char:FindFirstChild("Head") then
                if RANDOM(0, 100) <= UnivSettings.Aimbot.Headshot_Chance then
                    -- AIM HEAD
                    p = predictVelocity(char.Head or root, V3(0,0,0), ProjectilePower)
                else
                    -- AIM BODY
                    p = predictVelocity(root, V3(0,0,0), ProjectilePower)
                end
                Selected_Silent_Pos = p;
            else
                Selected_Silent_Pos = Selected_Aim_Pos;
            end
        end
    end

    local RCB = Enum.RaycastFilterType.Blacklist
    Aimbot_Once = function()
        if DESTROY then
            if Aimbot_Once_HB then
                Aimbot_Once_HB:Disconnect();
            end
            return
        elseif UnivSettings.Aimbot.Toggle then -- and not UnivSettings.Camera.Free_Cam
            Update_Selected()

            if Aiming and Selected_Player and Selected_Aim_Pos then
                if not Selected_Player.Character or not Player.Character then
                    return;
                end

                if not Selected_Player.Character.PrimaryPart or not Player.Character.PrimaryPart then
                    return;
                end

                if (Selected_Player.Character.PrimaryPart.Position - Player.Character.PrimaryPart.Position).magnitude < UnivSettings.Aimbot.Max_Distance then
                    local pos, vis = toPoint(Camera, Selected_Aim_Pos)
                    if vis then
                        local smoothness = CLAMP(100-UnivSettings.Aimbot.Smoothness, 1, 100)/100
                        local sens = CLAMP(smoothness, 0.01, 1)/2
                        -- mousemoverel(ROUND((pos.X - Mouse.X - UI_Inset.X) * sens), ROUND((pos.Y - Mouse.Y - UI_Inset.Y) * sens))

                        Camera.CFrame = CF(Camera.CFrame.p, Selected_Aim_Pos);
                    end
                end
            end
        end
    end;
    if UnivSettings.Aimbot.Toggle then
        Aimbot_Once_HB = RS.Heartbeat:Connect(Aimbot_Once);
    end
end