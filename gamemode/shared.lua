GM.Name = "Gun Game"
GM.Author = "Lost Alien"
DeriveGamemode("base")

GMGG = {}

function GMGG.AddTeam(n, str, col1, col2, col3)
team.SetUp(n, str, Color(col1, col2, col3))
end

GMGG.AddTeam(1, "Terrorist", 255, 0, 0)
GMGG.AddTeam(2, "CT", 255, 0, 0)
GMGG.AddTeam(3, "Screenshot and contact Lost Alien", 0, 255, 0)


CreateConVar("gg_ammo_on_kill",1,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Fill clip on kill")
CreateConVar("gg_spawnprotection",3,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Spawn protection seconds")
CreateConVar("gg_seconds_before_rankup_on_kill", 2, {FCVAR_REPLICATED,FCVAR_ARCHIVE},"Time before kill rankup in seconds")
CreateConVar("gg_maxrounds",3,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"Rounds per map")
CreateConVar("gg_kills_per_level",2,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"kills per level")
CreateConVar("gg_freeforall",0,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"free for all for TTT maps")
CreateConVar("gg_end_dm",10,{FCVAR_REPLICATED,FCVAR_ARCHIVE},"End of game Deathmatch")
