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
        Protected_Check = false;
        Target_Faction_Members = false;
        Target_Dueler = false;

        List_Type = "None";

        FOV = false;
        FOV_Radius = 50;
        FOV_Color = {R = 255, G = 255, B = 255};
    }
}

UnivSettingsFile = "Solstice/" .. GameNameLowered .. ".dat";

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
    local Visuals = Window.newPage({Text = "Visuals"})

    Visuals:newToggle({
        Text = "Toggle", 
        Callback = function(bool) 
            UnivSettings.Visuals.Toggle = bool
        end, 
        Default = UnivSettings.Visuals.Toggle
    })

    Visuals:newSlider({
        Text = "Max Distance",
        Callback = function(newvalue)
            UnivSettings.Visuals.Max_Distance = newvalue
        end,
        Default = UnivSettings.Visuals.Max_Distance,
        Min = 10, Max = 6000, 
        Decimals = 0, 
        Suffix = " s"
    })

    Visuals:newColorPicker({
        Text = "Main", 
        Callback = function(col, a)
            UnivSettings.Visuals.Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Color), UnivSettings.Visuals.Color.A}
    })

    Visuals:newToggle({
        Text = "Team Check", 
        Callback = function(bool) 
            UnivSettings.Visuals.Team_Check = bool
        end, 
        Default = UnivSettings.Visuals.Team_Check
    })

    Visuals:newColorPicker({
        Text = "Team", 
        Callback = function(col, a)
            UnivSettings.Visuals.Team_Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Team_Color), UnivSettings.Visuals.Team_Color.A}
    })


    Visuals:newColorPicker({
        Text = "Enemies", 
        Callback = function(col, a)
            UnivSettings.Visuals.Enemy_Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Enemy_Color), UnivSettings.Visuals.Enemy_Color.A}
    })

    Visuals:newToggle({
        Text = "Show Enemy", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Enemy = bool
        end, 
        Default = UnivSettings.Visuals.Show_Enemy
    })

    Visuals:newToggle({
        Text = "Show Team", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Team = bool
        end, 
        Default = UnivSettings.Visuals.Show_Team
    })

    Visuals:newToggle({
        Text = "Show Team Color", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Team_Color = bool
        end, 
        Default = UnivSettings.Visuals.Show_Team_Color
    })

    Visuals:newToggle({
        Text = "Show Target", 
        Callback = function(bool) 
            UnivSettings.Visuals.Show_Target = bool
        end, 
        Default = UnivSettings.Visuals.Show_Target
    })

    Visuals:newColorPicker({
        Text = "Target", 
        Callback = function(col, a)
            UnivSettings.Visuals.Target_Color = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Target_Color), UnivSettings.Visuals.Target_Color.A}
    })

    -- Info
    Visuals:newSeparator();
    
    Visuals:newToggle({
        Text = "Toggle", 
        Callback = function(bool) 
            UnivSettings.Visuals.Info = bool
        end, 
        Default = UnivSettings.Visuals.Info
    })

    Visuals:newChipset({
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
    Visuals:newSeparator();

    Visuals:newToggle({
        Text = "Toggle", 
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
        Visuals:newDropdown({
            Text = "Box Type", 
            Callback = function(option)
                UnivSettings.Visuals.Boxes_Mode = option
            end, 
            Options = list, 
            Default = default_option
        })
    end

    Visuals:newToggle({
        Text = "Health Bar", 
        Callback = function(bool) 
            UnivSettings.Visuals.Health_Bar = bool
        end, 
        Default = UnivSettings.Visuals.Health_Bar
    })

    Visuals:newColorPicker({
        Text = "Health Bar High", 
        Callback = function(col, a)
            UnivSettings.Visuals.Health_Bar_High = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Health_Bar_High), UnivSettings.Visuals.Health_Bar_High.A}
    })

    Visuals:newColorPicker({
        Text = "Health Bar Low", 
        Callback = function(col, a)
            UnivSettings.Visuals.Health_Bar_Low = util.c3_Array(col, a)
        end, 
        Default = {util.Array_c3(UnivSettings.Visuals.Health_Bar_Low), UnivSettings.Visuals.Health_Bar_Low.A}
    })

    -- Tracers
    Visuals:newSeparator();

    Visuals:newToggle({
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
        Visuals:newDropdown({
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
            if not (UnivSettings.Visuals.Toggle and Player.Character and Character and Character:FindFirstChild("Humanoid") and Character.Head.PlayerInfo.Screen.HealthContainer.HealthBar.HealthProgressFrame.Size.X.Scale > 0) then
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


    for _, Other in next, Players do
        if Other.Name ~= Player.Name then
            WRAP(DRAW.AddPlayer)(Other)
        end
    end

    local c_added; c_added = Players.ChildAdded:Connect(function(Other)
        if DESTROY then
            c_added:Disconnect()
        else
            WRAP(DRAW.AddPlayer)(Other)
        end
    end)
end

if AIMBOT then

end