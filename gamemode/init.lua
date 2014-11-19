AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('cl_quake.lua')
include('shared.lua')
include('sv_quake.lua')
GM = GM or GAMEMODE




function GM:Initialize()
	print("///////////////////////////////////////////////")
	print("Initializing GunGame on Map - "..game.GetMap())
	print("///////////////////////////////////////////////")
	SetGlobalBool("gg_round_end_dm",false)
	Round = 1
	SetGlobalFloat("rounds", Round)
	RunConsoleCommand("sv_airaccelerate",100)
	RunConsoleCommand("sv_gravity",880)
		GMGG.Config = {}
		if not file.Exists("gungame-config.txt","DATA") then
					GMGG.Config.Guns = 
					{
					[1] = "weapon_cs_usp",
					[2] = "weapon_cs_p228",
					[3] = "weapon_cs_elites",
					[4] = "weapon_cs_deagle",
					[5] = "weapon_cs_pumpshotgun",
					[6] = "weapon_cs_p90",
					[7] = "weapon_cs_tmp",
					[8] = "weapon_cs_mp5",
					[9] = "weapon_cs_galil",
					[10] = "weapon_cs_m4",
					[11] = "weapon_cs_ak47",
					[12] = "weapon_cs_awp",
					[13] = "weapon_cs_para",
					[14] = "weapon_cs_knife"
					}
					GMGG.Config.Maps = 
					{
					[1] = "de_aztec",
					[2] = "de_cbble",
					[3] = "de_chateau",
					[4] = "de_dust",
					[5] = "de_dust2",
					[6] = "de_inferno",
					[7] = "cs_assault",
					[8] = "cs_compound",
					[9] = "cs_havana",
					[10] = "cs_italy",
					[11] = "cs_militia",
					[12] = "cs_office"
					}
					GMGG.Config.Terrorists = 
					{
					[1] = "models/player/leet.mdl",
					[2] = "models/player/guerilla.mdl",
					[3] = "models/player/phoenix.mdl",
					[4] = "models/player/arctic.mdl"
					}
					GMGG.Config.Counters = 
					{
					[1] = "models/player/swat.mdl",
					[2] = "models/player/urban.mdl",
					[3] = "models/player/riot.mdl",
					[4] = "models/player/gasmask.mdl"
					}
					
			file.Write("gungame-config.txt",util.TableToJSON(GMGG.Config))
			else
				GMGG.Config = util.JSONToTable(file.Read("gungame-config.txt","DATA"))
			end

	SetGlobalFloat("FinalLevel",#GMGG.Config.Guns)

	for k,v in pairs(GMGG.Config.Terrorists) do
		util.PrecacheModel( v )
	end
	for k,v in pairs(GMGG.Config.Counters) do
		util.PrecacheModel( v )
	end

	timer.Simple(0.01, PlaceSpawns)


end


local function CreateImportedEnt(cls, pos, ang, kv)
   if not cls or not pos or not ang or not kv then return false end

   local ent = ents.Create(cls)
   if not IsValid(ent) then return false end
   ent:SetPos(pos)
   ent:SetAngles(ang)

   for k,v in pairs(kv) do
      ent:SetKeyValue(k, v)
   end

   ent:Spawn()

   ent:PhysWake()

   return true
end


function CanImportEntities(map)
   if not tostring(map) then return false end

   local fname = "maps/" .. map .. "_ttt.txt"

   return file.Exists(fname, "GAME")
end

function CreateSpawns(map)
	if not CanImportEntities(map) then return end

		local fname = "maps/" .. map .. "_ttt.txt"

		local buf = file.Read(fname, "GAME")
		local lines = string.Explode("\n", buf)
		local num = 0
		for k, line in ipairs(lines) do
			if (not string.match(line, "^#")) and (not string.match(line, "^setting")) and line != "" and string.byte(line) != 0 then
				local data = string.Explode("\t", line)

				local fail = true -- pessimism

				if data[2] and data[3] then
					local cls = data[1]
					local ang = nil
					local pos = nil

					local posraw = string.Explode(" ", data[2])
					pos = Vector(tonumber(posraw[1]), tonumber(posraw[2]), tonumber(posraw[3]))

					local angraw = string.Explode(" ", data[3])
					ang = Angle(tonumber(angraw[1]), tonumber(angraw[2]), tonumber(angraw[3]))

					local kv = {}
					if data[4] then
						local kvraw = string.Explode(" ", data[4])
						local key = kvraw[1]
						local val = tonumber(kvraw[2])

					if key and val then
						kv[key] = val
					end
				end
				if cls == "ttt_playerspawn" then 
					CreateImportedEnt("info_player_deathmatch", pos, ang, kv)
				end
			end
		end
	end
end



function PlaceSpawns()

	CreateSpawns(game.GetMap())
end


----- first time level -----

function GM:PlayerDeathSound( )
	return true
end

function GM:PlayerSpawn(ply)

	ply:SetupHands()


	-- Call item loadout function
	hook.Call( "PlayerLoadout", GAMEMODE, ply )
	
	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, ply )


	local ang = ply:EyeAngles()
	if ang.r != 0 then
		ang.r = 0
		ply:SetEyeAngles(ang)
	end
end


function GM:PlayerInitialSpawn(ply)
	ply:SetNWInt("level", 1)
	ply:SetNWInt("streak", 0)
	ply:SetNWInt("perk1",tonumber(ply:GetPData("perk1",1)))
	ply:SetNWInt("perk2",tonumber(ply:GetPData("perk2",1)))
	ply:SetNWInt("perk3",tonumber(ply:GetPData("perk3",1)))
	ply:SetNWInt("Kills",0)
	ply:SetNWFloat("lastspawn", CurTime())

	ply:SetTeam(1)

end




function GM:PlayerSetModel( ply )
	ply:SetModel( table.Random( GMGG.Config.Terrorists))
end

----friendly fire disable----
function GM:PlayerShouldTakeDamage( victim, pl )
	return true 
end


----spawn selection-----


function GM:PlayerSelectSpawn( ply )

	local bestDist = 0
	local bestSpawn = nil

	for k, v in pairs( ents.FindByClass("info_player_deathmatch")) do

		sPos = v:GetPos()

		-- Find the  distance to the closest player from this spawn
		local closestToThisSpawn = 100000000000
		for l, w in pairs(player.GetAll()) do

			if not (ply == w) then
				delta = sPos:Distance(w:GetPos())


				if delta < closestToThisSpawn then
					closestToThisSpawn = delta
				end
			end


		end



		if closestToThisSpawn > bestDist then


			bestDist = closestToThisSpawn
			bestSpawn = v
		end
	end

	-- Something went wrong and no best spawn was found, just return something random
	if bestSpawn == nil then


		local spawnsFFA = ents.FindByClass( "info_player_deathmatch" )

		local random_entryFFA = math.random(#spawnsFFA)

		return spawnsFFA[random_entryFFA]

	-- Return the spawn furthest from any player
	else

		return bestSpawn
	end
end


------spawn loadout----

function GM:PlayerLoadout(ply)


	---remove perks----
	ply:SetWalkSpeed(250)
	ply:SetRunSpeed(300)
	ply:SetGravity( 1 )
	ply:SetJumpPower(200)
	ply:SetMaxHealth(100)
	ply.isBuffed = false
	ply.isVamp = false
	timer.Destroy("Regen: "..ply:Nick())
	ply:SetNWInt("xray",0)
	ply:SetJumpPower( math.sqrt(2 * 800 * 57.0) )


	----give items----
	local level = ply:GetNWInt("level")
	local weptogive = GMGG.Config.Guns[level]
	ply:SetNWInt("maxlevel", #GMGG.Config.Guns)
	ply:StripWeapons()
	ply:SetNWInt("streak", 0)
	ply:Give(weptogive)
	ply:Give("weapon_cs_knife")
	ply:GiveAmmo(10000000, "pistol")
	ply:GiveAmmo(10000000, "smg1")
	ply:GiveAmmo(10000000, "buckshot")
	ply:AllowFlashlight(true)
end


------ level up and weapons ----
function GM:PlayerDeath( ply, inflictor, attacker )
	if IsValid(ply) and IsValid(attacker) and ply != attacker and attacker:IsPlayer() then
		local randomsound = math.random(1,9)
		ply:EmitSound(Sound("vo/npc/male01/pain0"..randomsound..".wav"),100)
		local killingwep = inflictor:GetClass()
		winkills = #GMGG.Config.Guns
		if attacker:GetNWInt("level") < winkills then
			local leveladd = attacker:GetNWInt("level") + 1
			local streakadd = attacker:GetNWInt("streak") + 1
			local newwep = GMGG.Config.Guns[leveladd]
			local killadd = attacker:GetNWInt("kills") + 1
			
			
			
			local shouldPromote = false
			
			if (CurTime() - ply:GetNWFloat("lastspawn", 0)) > GetConVarNumber("gg_seconds_before_rankup_on_kill") then
				attacker:SetNWInt("streak", streakadd)
				attacker:SetNWInt("Kills",killadd)
				
				shouldPromote = true;
			else
				attacker:ChatPrint("You will not be promoted for killing players who just spawned!")
				
				local warnings = attacker:GetNWInt("spawn_camp_warnings", 0)
				warnings = warnings +1
				attacker:SetNWInt("spawn_camp_warnings", warnings)
				
				if warnings >= 3 and warnings < 6 then
					local newLevel = leveladd - 5
					if newLevel < 1 then
						newLevel = 1
					end
					attacker:SetNWInt("level", newLevel)
					attacker:Kill()
					attacker:ChatPrint("You have been demoted for spawn camping!")
				elseif warnings == 6 then
					attacker:Kick("You have been kicked for spawn camping.")
				end
					
			end
				
		
			if attacker:GetNWInt("Kills") >= GetConVarNumber("gg_kills_per_level") and killingwep ~= "weapon_cs_knife" and shouldPromote then
							
				
				hook.Call("gg_levelup",GM,attacker,leveladd)
				attacker:SendLua([[hook.Call("gg_levelup",GM,leveladd)]])
				attacker:SetNWInt("Kills",0)
				attacker:SetNWInt("level", leveladd)
				timer.Simple(0.05, function()
				    attacker:StripWeapon(tostring(GMGG.Config.Guns[attacker:GetNWInt("level") - 1]))
				    local wep = attacker:Give(newwep)
				    function wep:Deploy()
				        return true
				    end
				    attacker:Give("weapon_cs_knife")
				    attacker:SelectWeapon(GMGG.Config.Guns[attacker:GetNWInt("level")])
				    
				    timer.Simple(0.1,function()
				        function wep:Deploy()
				            self:SendWeaponAnim(ACT_VM_DRAW)
				            return true
				        end
				    end)
				end)
			elseif (GetConVarNumber("gg_ammo_on_kill") == 1 and killingwep ~= "weapon_cs_knife") then
				attacker:GetActiveWeapon():SetClip1(attacker:GetActiveWeapon().Primary.ClipSize + 1)
			end

			if killingwep == "weapon_cs_knife" then
				hook.Call("gg_demote",GM,ply,attacker)

				if ply:GetNWInt("Level") > 1 then
					ply:SetNWInt("Level", ply:GetNWInt("Level") - 1)
				end
			end

		elseif GetGlobalBool("gg_round_end_dm") then
			return
		else

			if killingwep == "weapon_cs_knife" then
				hook.Call("gg_demote",GM,ply,attacker)

				if ply:GetNWInt("Level") > 1 then
					ply:SetNWInt("Level", ply:GetNWInt("Level") - 1)
				end
			else 

				attacker:StripWeapons()
				timer.Simple(0.05, function()
				    attacker:Give("weapon_cs_knife")
					end)
				hook.Call("gg_round_end",GM,attacker)
			end
		end
	elseif ply == attacker then
		hook.Call("gg_demote",GM,ply,attacker)

		if ply:GetNWInt("Level") > 1 then
			ply:SetNWInt("Level", ply:GetNWInt("Level") - 1)
		end
	end
		
	LevelTable = {}
	
	for k, v in pairs(player.GetAll()) do
		local data = {ply = v,level = v:GetNWInt("level")}
		table.insert( LevelTable, data)
	end
table.SortByMember(LevelTable,"level")
Leader = LevelTable[1]
SetGlobalFloat("Leader",Leader.ply:Nick()..": "..Leader.level)
end

function CleanUp()
	for k, v in pairs( ents.FindByClass("prop_physics")) do
		if v:IsValid() and v:IsInWorld()  then
			v:Remove()
		end
	end
	game.CleanUpMap()
	CreateSpawns(game.GetMap())
end
----- round end -----

function GM:gg_round_end(attacker)
	LevelTable = {}
	SetGlobalBool("gg_round_end_dm",true)
	local dm_time = tonumber(GetConVarNumber("gg_end_dm"))
	timer.Simple(dm_time, function()
		Round = (Round + 1)
		if tonumber(Round) > tonumber(GetConVarNumber("gg_maxrounds"))then
			if FC_VOTE then
				FC_VOTE:StartVote()
			elseif MapVote then
				MapVote.Start(15, nil, nil, nil)
			else
    			print("[GunGame] Finding new map")
    			if table.KeyFromValue(GMGG.Config.Maps,game.GetMap()) then
    				if tonumber(table.KeyFromValue(GMGG.Config.Maps,game.GetMap())) == tonumber(#GMGG.Config.Maps) then
    				print("[GunGame] End of rotation, running first map")
    			RunConsoleCommand("changelevel", ""..GMGG.Config.Maps[1].."")				
    				else
    				print("[GunGame] Running next map in cycle")
    			RunConsoleCommand("changelevel", ""..GMGG.Config.Maps[table.KeyFromValue(GMGG.Config.Maps,game.GetMap())+1].."")
    				end
    			else
    			print("[GunGame] Map not in cycle, running first map")
    			RunConsoleCommand("changelevel", ""..GMGG.Config.Maps[1].."")
    			end
	        end
        else
		CleanUp()
        hook.Call("gg_round_begin",GM)	
		BroadcastLua([[hook.Call("gg_round_begin",GM)]])
		end
	end)
	
end

function GM:gg_round_begin()
	SetGlobalBool("gg_round_end_dm",false)
	print("[GunGame] Starting round: "..Round)
	for k, v in pairs(player.GetAll()) do
		v:SetNWInt("level", 1)
		v:SetFrags(0)
		v:SetDeaths(0)
		v:Freeze(false)
		v:Spawn()
		v:SetNWFloat("lastspawn", CurTime())
		v:SetNWInt("spawn_camp_warnings", 0)
		umsg.Start( "IsSpawning", v ) 
			umsg.Bool(false)
		umsg.End()
		v:PrintMessage( HUD_PRINTCENTER, "Starting round ["..Round.." / "..GetConVarNumber("gg_maxrounds").." ]")
		net.Start("start")
		net.Send(v)
	end
		SetGlobalFloat("rounds", Round)
		SetGlobalFloat("Leader", 1)
	timer.Simple(3, function()
		for k, v in pairs(player.GetAll()) do
			umsg.Start( "IsSpawning", v ) 
				umsg.Bool(false)
			umsg.End()
		end			
	end)

end


function GM:PlayerDeathThink( pl)
	if (  pl.NextSpawnTime and pl.NextSpawnTime > CurTime() and not pl:IsSuperAdmin() ) then return end

	if pl:KeyPressed( IN_JUMP ) then
		
		pl:Spawn()
		pl:SetNWFloat("lastspawn", CurTime())
		SpawnProtection(pl)
		pl:SetNWInt("IsSpawning",0)
		umsg.Start( "IsSpawning", pl ) 
			umsg.Bool(false)
		umsg.End()
		pl:Freeze(false)
		pl:Spawn()
		pl:GodEnable()
		pl:SetMaterial( "models/props_combine/stasisshield_sheet" )
		
	end
end

-----Spawn Protection-----

hook.Add("PlayerDeath","spawnProtection",function(ply)
	ply:Freeze(true)
	timer.Simple(2,function()
	if not ply:IsValid() then return end
	ply:Freeze(false)
	ply:SetNWInt("IsSpawning",1)
		umsg.Start( "IsSpawning", ply ) 
			umsg.Bool(true)
		umsg.End()
	end)
end)

function SpawnProtection(ply)
	timer.Simple(GetConVarNumber("gg_spawnprotection"), function()
		if ply:IsValid() then
			ply:GodDisable()
			ply:SetMaterial( "" )
		end
	end)
end

function GM:KeyPress( ply, key )
 	if ( key == IN_ATTACK ) then
		if ply:Alive() then
			ply:GodDisable()
			ply:SetMaterial( "" )
		end
	 	if ( key == IN_JUMP ) and ply:GetNWInt("IsSpawning") == 1 then
			SpawnFunction(ply)
		end
	end
end


---- client convars for hud related stuff -----
CreateClientConVar( "gg_hp_overlay", "1", true, false )
CreateClientConVar( "gg_quake_sounds", "0", true, false )

----- perks -----

hook.Add("PlayerDeath","StreakBonus",function(vic,wep,ply) -- streak is 1 kill behind
	if vic == ply then return end
		if ply:GetNWInt("streak") > 1 then -- 3 kills, due to hooks and shit
			if ply:GetNWInt("perk1") == 1 then
				ply:SetRunSpeed(400)
				ply:SetGravity(1)
				ply:SetJumpPower(200)
			elseif ply:GetNWInt("perk1") == 2 then
				ply:SetGravity(0.6)
				ply:SetJumpPower(300)
				ply:SetRunSpeed(300)
			elseif ply:GetNWInt("perk1") == 3 then
				ply:SetGravity(1)
				ply:SetJumpPower(200)
				ply:SetRunSpeed(300)
			end
		end
		if ply:GetNWInt("streak") > 3 then -- 5 kills, due to hooks and shit
			if ply:GetNWInt("perk2") == 1 then
				if ply:Health() <= (ply:GetMaxHealth() - 15) then
					ply:SetHealth(ply:Health() + 15)
				else
					ply:SetHealth(ply:GetMaxHealth())
				end
				ply:SetArmor(0)
				ply.isVamp = false
			elseif ply:GetNWInt("perk2") == 2 then
				ply:SetArmor(25)
				ply.isVamp = false
			elseif ply:GetNWInt("perk2") == 3 then
				ply:SetArmor(0)
				ply.isVamp = true
			end
		end
		if ply:GetNWInt("streak") > 5 then -- 7 kills, due to hooks and shit
			if ply:GetNWInt("perk3") == 1 then
				ply:SetMaxHealth(125)
				ply.isBuffed = false
				ply:SetNWInt("xray",0)
				timer.Destroy("Regen: "..ply:Nick())
			elseif ply:GetNWInt("perk3") == 2 then
				ply.isBuffed = true
				ply:SetMaxHealth(100)
				ply:SetNWInt("xray",0)
				timer.Destroy("Regen: "..ply:Nick())
			elseif ply:GetNWInt("perk3") == 3 then
				ply.isBuffed = false
				ply:SetMaxHealth(100)
				ply:SetNWInt("xray",1)
				timer.Destroy("Regen: "..ply:Nick())
			elseif ply:GetNWInt("perk3") == 4 then
				ply.isBuffed = false
				ply:SetMaxHealth(100)
				ply:SetNWInt("xray",0)
				timer.Create("Regen: "..ply:Nick(),1,0,function()
					if ply:Health() < ply:GetMaxHealth() then
						ply:SetHealth(ply:Health() + 1)
					end
				end)
			end
		end
end)

util.AddNetworkString("Perk1Change")
util.AddNetworkString("Perk2Change")
util.AddNetworkString("Perk3Change")

net.Receive("Perk1Change", function(len,ply)
	local newPerkString = net.ReadFloat()
	local newPerk = tonumber(newPerkString)
	ply:SetNWInt("perk1", newPerk)
	ply:SetPData("perk1", newPerk)
	if ply:GetNWInt("streak") > 3 then 
				if ply:GetNWInt("perk1") == 1 then
				ply:SetRunSpeed(400)
				ply:SetGravity(1)
				ply:SetJumpPower(200)
			elseif ply:GetNWInt("perk1") == 2 then
				ply:SetGravity(0.6)
				ply:SetJumpPower(300)
				ply:SetRunSpeed(300)
			elseif ply:GetNWInt("perk1") == 3 then
				ply:SetGravity(1)
				ply:SetJumpPower(200)
				ply:SetRunSpeed(300)
			end
	end
end)

net.Receive("Perk2Change", function(len,ply)
	local newPerkString = net.ReadFloat()
	local newPerk = tonumber(newPerkString)
	ply:SetNWInt("perk2", newPerk)
	ply:SetPData("perk2", newPerk)
end)

net.Receive("Perk3Change", function(len,ply)
	local newPerkString = net.ReadFloat()
	local newPerk = tonumber(newPerkString)
	ply:SetNWInt("perk3", newPerk)
	ply:SetPData("perk3", newPerk)
	
end)

function GM:ScalePlayerDamage(ply,hitgroup,dmginfo)
	local aply = dmginfo:GetAttacker()
   if aply.isBuffed == true then
		dmginfo:AddDamage(10)
   end
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 )
	end
	if aply.isVamp == true then
		if aply:Health() < aply:GetMaxHealth() then
			aply:SetHealth(aply:Health() + (dmginfo:GetDamage()/6))
				if aply:Health() > aply:GetMaxHealth() then
					aply:SetHealth(aply:GetMaxHealth())
				end
		end
	end
end


---options menu----
function GM:ShowHelp( ply ) 
    umsg.Start( "HelpMenu", ply ) 
    umsg.End()
end



util.AddNetworkString("AmmoonKill")
util.AddNetworkString("KillsPerLevel")
util.AddNetworkString("SpawnProtection")
util.AddNetworkString("MaxRounds")
--admin menu--
function SuperMenu( ply )
	umsg.Start( "SuperMenu", ply ) 
    umsg.End()
end
hook.Add("ShowSpare1", "SuperMenu", SuperMenu)

--cvar change--
net.Receive("KillsPerLevel", function(len,ply)
	if ply:IsSuperAdmin() then
	local kpl = net.ReadFloat()
	local rkpl = (math.Round(kpl))
	RunConsoleCommand("gg_kills_per_level",rkpl)
	else
	ply:Kick("Attempt to change Gun Game CVars")
	end
end)

net.Receive("AmmoonKill", function(len,ply)
	if ply:IsSuperAdmin() then
	local kpl = net.ReadFloat()
	local rkpl = (math.Round(kpl))
	RunConsoleCommand("gg_ammo_on_kill",rkpl)
	else
	ply:Kick("Attempt to change Gun Game CVars")
	end
end)

net.Receive("SpawnProtection", function(len,ply)
	if ply:IsSuperAdmin() then
	local kpl = net.ReadFloat()
	local rkpl = (math.Round(kpl))
	RunConsoleCommand("gg_spawnprotection",rkpl)
	else
	ply:Kick("Attempt to change Gun Game CVars")
	end
end)

net.Receive("MaxRounds", function(len,ply)
	if ply:IsSuperAdmin() then
	local kpl = net.ReadFloat()
	local rkpl = (math.Round(kpl))
	RunConsoleCommand("gg_maxrounds",rkpl)
	else
	ply:Kick("Attempt to change Gun Game CVars")
	end
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
	return true
end