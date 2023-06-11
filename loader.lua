-- Check
if _G.SolsticeExecuted then
	return;
end
-- _G.SolsticeExecuted = true;

-- Utilities
util = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Miscellaneous/main/util.lua"))();
library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/SimpleCSGO/main/src.lua"))();
notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Miscellaneous/main/notificationsJxereas.lua"))();
draw = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Miscellaneous/main/draw.lua"))();

request = request or http_request or syn and syn.request or function()end
getupvalue = getupvalue or debug and debug.getupvalue or function()end
getupvalues = getupvalues or debug and debug.getupvalues or function()end
setupvalue = setupvalue or debug and debug.setupvalue or function()end
getconstants = getconstants or debug and debug.getconstants or function()end
setconstant = setconstant or debug and debug.setconstant or function()end
getproto = getproto or debug and debug.getproto or function()end
queue_on_tp = queue_on_teleport or syn and syn.queue_on_teleport or function()end
setclipboard = setclipboard or toclipboard or syn and setclipboard or function()end
setreadonly = setreadonly or function()end
getrawmetatable = getrawmetatable or function()end
protect_gui = syn and syn.protect_gui or function()end
getconnections = getconnections or function()end

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
local ExecuteUniversal = {
	[580765040] = true,
	[1494262959] = true,
	[595270616] = true
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
if Supported then
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
end

RESET_FUNCTIONS = {}
function Close_Script()
	DESTROY = true
	for _,v in next, RESET_FUNCTIONS or {} do
		if type(v) == 'function' then
			v()
		end
	end
end

if ExecuteUniversal[game.GameId] and Supported then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Solstice/main/scripts/universal.lua"))();
end

-- Execute scripts + Inform player
notification.new("info", "Information", "Loading " .. GameNameClean);
loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/Solstice/main/scripts/" .. GameNameLowered .. ".lua"))();
notification.new("success", "Success", "Loaded " .. GameNameClean .. " !");

-- Window Theme
Window:newThemeControlPage({
	Folder = "SolsticeTheme",
	Default = "Theme",
})