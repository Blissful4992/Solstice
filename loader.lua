-- Check
if _G.SolsticeExecuted then
    return;
end
-- _G.SolsticeExecuted = true;

-- Utilities
util = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Miscellaneous/main/util.lua"))();
library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/SimpleCSGO/main/src.lua"))();
notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Miscellaneous/main/notificationsJxereas.lua"))();

-- Wait for game
repeat
    WAIT();
until game:IsLoaded();

-- Exploit Stuff
if not isfolder("Solstice") then
    makefolder("Solstice");
end

-- Supported Games
local Games = {
    [1686265127] = "Quarantine-Z";
    [580765040] = "Ragdoll_Universe";
    [1494262959] = "Criminality";
    [595270616] = "State_Of_Anarchy";
}

-- Create folders
for Id, Game in next, Games do
    if not isfolder("Solstice/" .. Game) then
        makefolder("Solstice/" .. Game);
    end
end

-- Create the Window
Window = library.new({
    Size = V2(400, 500),
    Position = V2(200, 200)
})

-- Basic game info
Supported = Games[game.GameId] ~= nil;
GameName = Supported and Games[game.GameId] or "Universal";
GameNameLowered = GameName:lower();
GameNameClean = GameName:gsub("_", " ");

-- Settings
SettingsFile = "Solstice/" .. GameNameLowered .. ".dat";

function Load() -- LOAD SETTINGS (can be forked into a multiple config system)
    local Result = readfile(SettingsFile) or "{}";
    local Table = HttpService:JSONDecode(Result) or {};

    Settings = util.merge(Settings or {}, Table);
end

function Save() -- SAVE SETTINGS
    writefile(SettingsFile, HttpService:JSONEncode(Settings or {}) or "{}");
end

function SaveDefault() -- SAVE SETTINGS
    if not isfile(SettingsFile) then
        writefile(SettingsFile, HttpService:JSONEncode(Settings or {}) or "{}");
    end
end

-- Execute scripts + Inform player
notification.new("info", "Information", "Loading " .. GameNameClean);
loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Solstice/main/scripts/" .. GameNameClean))();
notification.new("success", "Success", "Loaded " .. GameNameClean .. " !");

-- Window Theme
Window:newThemeControlPage({
    Folder = "SolsticeTheme",
    Default = "Theme",
})