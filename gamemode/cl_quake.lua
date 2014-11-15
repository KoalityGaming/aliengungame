net.Receive("tripplekill", function()
local killer = net.ReadEntity() 
	
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/triplekill.mp3" )
		chat.AddText(killer:Nick()," scored a triple kill!")
	end
end)

net.Receive("multikill", function()
local killer = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/multikill.mp3" )
		chat.AddText(killer:Nick()," scored a multi kill!")
	end
end)

net.Receive("godlike", function()
local killer = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/godlike.mp3" )
		chat.AddText(killer:Nick()," is godlike!")
	end
end)

net.Receive("gg_quake_end", function()
local killer = net.ReadEntity() 
		chat.AddText(killer:Nick()," won!")
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
		chat.AddText(killer:Nick()," is on a rampage!")
	end
end)

net.Receive("monsterkill", function()
local killer = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/monsterkill.mp3" )
		chat.AddText(killer:Nick()," scored a monster kill!")
	end
end)

net.Receive("demote", function()
local killer = net.ReadEntity() 
local victim = net.ReadEntity() 
	if GetConVarNumber("gg_quake_sounds") == 1 then
		surface.PlaySound( "quake/humiliation.mp3" )
		chat.AddText(killer:Nick()," humiliated ",victim:Nick())
	end
end)