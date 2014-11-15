net.Receive("tripplekill", function()
local killer = net.ReadEntity() 
	
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/triplekill.mp3" )
		chat.AddText(team.GetColor(killer:Team()),killer:Nick(),Color(255,255,255)," scored a",Color(255,220,0)," triple kill!")
	end
end)

net.Receive("multikill", function()
local killer = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/multikill.mp3" )
		chat.AddText(team.GetColor(killer:Team()),killer:Nick(),Color(255,255,255)," scored a",Color(255,220,0)," multi kill!")
	end
end)

net.Receive("godlike", function()
local killer = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/godlike.mp3" )
		chat.AddText(team.GetColor(killer:Team()),killer:Nick(),Color(255,255,255)," is",Color(255,220,0)," godlike!")
	end
end)

net.Receive("gg_quake_end", function()
local killer = net.ReadEntity() 
		chat.AddText(team.GetColor(killer:Team()),killer:Nick(),Color(255,220,0)," won!")
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/impressive.mp3" )
	end
end)

net.Receive("start", function()
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/play.wav" )
	end
end)

net.Receive("rampage", function()
local killer = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/rampage.mp3" )
		chat.AddText(team.GetColor(killer:Team()),killer:Nick(),Color(255,255,255)," is on a",Color(255,220,0)," rampage!")
	end
end)

net.Receive("monsterkill", function()
local killer = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/monsterkill.mp3" )
		chat.AddText(team.GetColor(killer:Team()),killer:Nick(),Color(255,255,255)," scored a",Color(255,220,0)," monster kill!")
	end
end)

net.Receive("demote", function()
local killer = net.ReadEntity() 
local victim = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/humiliation.mp3" )
		chat.AddText(team.GetColor(killer:Team()),killer:Nick(),Color(255,255,255)," humiliated ",team.GetColor(victim:Team()),victim:Nick())
	end
end)