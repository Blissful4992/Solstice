-- Check
if _G.SolsticeExecuted then
    return;
end
-- _G.SolsticeExecuted = true;

-- Utilities
util = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Miscellaneous/main/util.lua"))();
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

-- Find supported game
local Supported = Games[game.GameId] ~= nil;
if not Supported then
    warn("> Solstice : Game isn't supported, loading Universal...");
    notification.new("info", "Information", "Loading Universal...", true);


else
    GameName = Games[game.GameId]:gsub("_", " ");

    warn("> Solstice : Loading " .. GameName .. "...")
    notification.new("info", "Information", "Loading " .. GameName .. "...", true);
end