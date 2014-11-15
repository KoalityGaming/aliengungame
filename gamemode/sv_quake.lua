util.AddNetworkString("tripplekill")
util.AddNetworkString("multikill")
util.AddNetworkString("godlike")
util.AddNetworkString("rampage")
util.AddNetworkString("gg_quake_end")
util.AddNetworkString("start")
util.AddNetworkString("monsterkill")
util.AddNetworkString("demote")

hook.Add("PlayerDeath","quakesounds",function( ply, inflictor, attacker )
		if IsValid(ply) and IsValid(attacker) and ply != attacker and attacker:IsPlayer() then
			local killingwep = attacker:GetActiveWeapon():GetClass()
			winkills = #GMGG.Config.Guns
			if attacker:GetNWInt("level") < winkills then
			local streakadd = attacker:GetNWInt("streak") + 1
				if streakadd == 3 then
						net.Start("tripplekill")
							net.WriteEntity(attacker)
						net.Broadcast()
				elseif streakadd == 5 then
						net.Start("multikill")
							net.WriteEntity(attacker)
						net.Broadcast()
				elseif streakadd == 7 then
						net.Start("rampage")
							net.WriteEntity(attacker)
						net.Broadcast()
				elseif streakadd == 10 then
						net.Start("monsterkill")
							net.WriteEntity(attacker)
						net.Broadcast()
				elseif streakadd == 13 then
						net.Start("godlike")
							net.WriteEntity(attacker)
						net.Broadcast()
				end
		end
		
end
end)
hook.Add("gg_demote","humiliation",function(demoted,demoter)
	net.Start("demote")
		net.WriteEntity(demoter)
		net.WriteEntity(demoted)
	net.Broadcast()
end)

hook.Add("gg_round_end","endofround",function(winner)
	net.Start("gg_quake_end")
		net.WriteEntity(winner)
	net.Broadcast()
end)

hook.Add("gg_round_begin","startofround",function()
	net.Start("start")
	net.Broadcast()
end)