include('shared.lua')
include('cl_quake.lua')

CreateClientConVar( "gg_hp_overlay", "0", true, false )
CreateClientConVar( "gg_quake_sounds", "0", true, false )
CreateClientConVar( "gg_large_Kill_Counter", "0", true, false )

local GM = GM or GAMEMODE

surface.CreateFont( "Hud", {
                font = "coolvetica",
                size = 25,
                weight = 200,
                antialias = true
} )   

surface.CreateFont( "HudH", {
                font = "coolvetica",
                size = 25,
                weight = 200,
                antialias = true
} )    
 
 surface.CreateFont( "HudS", {
                font = "coolvetica",
                size = 20,
                weight = 200,
                antialias = true
} )   
 
surface.CreateFont( "HudL", {
                font = "coolvetica",
                size = 50,
                weight = 200,
                antialias = true
} )    
 
surface.CreateFont( "HudR", {
                font = "coolvetica",
                size = 40,
                weight = 200,
                antialias = true
} )    
 

hook.Add("HUDPaint", "DrawStuff", function(ply)
 

ply = LocalPlayer()
 
local level = ply:GetNWInt("level")
local mlevel = ply:GetNWInt("maxlevel")
local round = GetGlobalFloat("rounds")
local streak = ply:GetNWInt("streak")
local kills = ply:GetNWInt("kills")
local healthpos = ScrH()/1.08
local armorpos = ScrH()/1.17
local healthcolor = Color(255,0,0,200)
local roundpos = ScrH()/9.3
local levelpos = ScrH()/50
local leader = GetGlobalFloat("Leader")

local hp = ply:Health()
local ap = ply:Armor() * 4
local height = ScrH() - 65
local width = ScrW() - 200.5
local heighr = ScrH() - 65
local widthr = ScrW()


draw.TexturedQuad
	{
	        texture = surface.GetTextureID "gui/gradient",
	        color = Color(10, 10, 10, 200),
	        x = 0,
	        y = ScrH()/10,
	        w = 150,
	        h = 95
	       
	}
 
struc = {}
struc["pos"] = {5, roundpos}
struc["color"] = Color(255, 255, 255, 240)
struc["text"] = "Round "..round
struc["font"] = "Hud"
struc["xalign"] = TEXT_ALIGN_LEFT
struc["yalign"] = TEXT_ALIGN_TOP
draw.TextShadow( struc, 2, 200 )

struc = {}
struc["pos"] = {5, roundpos + 20}
struc["color"] = Color(255, 255, 255, 240)
struc["text"] = "Leader "..leader
struc["font"] = "Hud"
struc["xalign"] = TEXT_ALIGN_LEFT
struc["yalign"] = TEXT_ALIGN_TOP
draw.TextShadow( struc, 2, 200 )

struc = {}
struc["pos"] = {5, roundpos + 40}
struc["color"] = Color(255, 255, 255, 240)
struc["text"] = "Streak x"..streak
struc["font"] = "Hud"
struc["xalign"] = TEXT_ALIGN_LEFT
struc["yalign"] = TEXT_ALIGN_TOP
draw.TextShadow( struc, 2, 200 )


struc = {}
struc["pos"] = {5, roundpos + 60}
struc["color"] = Color(255, 255, 255, 240)
struc["text"] = "Free for all"
struc["font"] = "Hud"
struc["xalign"] = TEXT_ALIGN_LEFT
struc["yalign"] = TEXT_ALIGN_TOP
draw.TextShadow( struc, 2, 200 )
 
if GetConVarNumber("gg_large_Kill_Counter") == 1 then
	if level == GetGlobalFloat("FinalLevel") then
		struc = {}
		struc["pos"] = {ScrW()/2, ScrH()/1.2}
		struc["color"] = Color(255, 255, 255, 240)
		struc["text"] = "Final Kill"
		struc["font"] = "HudR"
		struc["xalign"] = TEXT_ALIGN_CENTER
		struc["yalign"] = TEXT_ALIGN_TOP
		draw.TextShadow( struc, 2, 200 )

	else
		struc = {}
		struc["pos"] = {ScrW()/2, ScrH()/1.2}
		struc["color"] = Color(255, 255, 255, 240)
		struc["text"] = "Kills this level: "..kills.. "/" ..GetConVarNumber("gg_kills_per_level")
		struc["font"] = "HudR"
		struc["xalign"] = TEXT_ALIGN_CENTER
		struc["yalign"] = TEXT_ALIGN_TOP
		draw.TextShadow( struc, 2, 200 )
	end
else
	draw.TexturedQuad
	{
	        texture = surface.GetTextureID "gui/gradient",
	        color = Color(10, 10, 10, 200),
	        x = 0,
	        y = ScrH()/10+95,
	        w = 150,
	        h = 25
	       
	} 

	if level == GetGlobalFloat("FinalLevel") then
		struc = {}
		struc["pos"] = {5, roundpos + 80}
		struc["color"] = Color(255, 255, 255, 240)
		struc["text"] = "Final Kill"
		struc["font"] = "Hud"
		struc["xalign"] = TEXT_ALIGN_LEFT
		struc["yalign"] = TEXT_ALIGN_TOP
		draw.TextShadow( struc, 2, 200 )

	else
		struc = {}
		struc["pos"] = {5, roundpos + 80}
		struc["color"] = Color(255, 255, 255, 240)
		struc["text"] = "Kills: "..kills.. "/" ..GetConVarNumber("gg_kills_per_level")
		struc["font"] = "Hud"
		struc["xalign"] = TEXT_ALIGN_LEFT
		struc["yalign"] = TEXT_ALIGN_TOP
		draw.TextShadow( struc, 2, 200 )
 	end
 end
 
draw.TexturedQuad
{
        texture = surface.GetTextureID "gui/gradient",
        color = Color(10, 10, 10, 200),
        x = 0,
        y = levelpos,
        w = 350,
        h = 50,
}
 
 
struc = {}
struc["pos"] = {5, levelpos + 2}
struc["color"] = Color(255, 255, 255, 240)
struc["text"] = "Level "..level.." / "..mlevel
struc["font"] = "HudL"
struc["xalign"] = TEXT_ALIGN_LEFT
struc["yalign"] = TEXT_ALIGN_TOP
draw.TextShadow( struc, 2, 200 )

if ShowSpawnStuff and ply:Alive() then
	struc = {}
	struc["pos"] = {ScrW()/2, ScrH()/2}
	struc["color"] = Color(255, 255, 255, 240)
	struc["text"] = "Press JUMP to spawn!"
	struc["font"] = "HudR"
	struc["xalign"] = TEXT_ALIGN_CENTER
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.TextShadow( struc, 2, 200 )
end
 
if hp > 0 then
	if ply:GetActiveWeapon():IsValid() then
		ammo = ply:GetActiveWeapon():Clip1()
		wepname = ply:GetActiveWeapon():GetPrintName()
	end
end




if ammo and ammo > 0 then

	surface.SetTexture(surface.GetTextureID("gui/gradient"))
	surface.SetDrawColor(10, 10, 10, 255)
	surface.DrawTexturedRectRotated(width+100,height +40,305,115,180)
   
	struc = {}
	struc["pos"] = {width + 100, height + 20}
	struc["color"] = Color(255, 255, 255, 240)
	struc["text"] = ammo
	struc["font"] = "HudL"
	struc["xalign"] = TEXT_ALIGN_CENTER
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.TextShadow( struc, 2, 200 )

	struc = {}
	struc["pos"] = {width + 100, height - 5}
	struc["color"] = Color(255, 255, 255, 240)
	struc["text"] = wepname
	struc["font"] = "HudH"
	struc["xalign"] = TEXT_ALIGN_CENTER
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.TextShadow( struc, 2, 200 )
else


   surface.SetTexture(surface.GetTextureID("gui/gradient"))
   surface.SetDrawColor(10, 10, 10, 200)
   surface.DrawTexturedRectRotated(width+100,height +40,305,65,180)


	struc = {}
	struc["pos"] = {width + 100, height + 30}
	struc["color"] = Color(255, 255, 255, 240)
	struc["text"] = wepname or "No weapon"
	struc["font"] = "HudH"
	struc["xalign"] = TEXT_ALIGN_CENTER
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.TextShadow( struc, 2, 200 )
end

draw.TexturedQuad
{
        texture = surface.GetTextureID "gui/gradient",
        color = Color(10, 10, 10, 255),
        x = 0,
        y = ScrH()-160,
        w = 550,
        h = 160,
}

draw.TexturedQuad
{
        texture = surface.GetTextureID "gui/gradient",
        color = Color(166, 0, 0, 255),
        x = 0,
        y = ScrH()-145,
        w = hp*4.5,
        h = 33,
}
draw.TexturedQuad
{
        texture = surface.GetTextureID "gui/gradient",
        color = Color(133, 0, 0, 255),
        x = 0,
        y = ScrH()-112,
        w = hp*4.5,
        h = 33,
}

draw.TexturedQuad
{
        texture = surface.GetTextureID "gui/gradient",
        color = Color(0, 133, 189, 225),
        x = 0,
        y = ScrH()-61,
        w = ap*4.5,
        h = 19,
}
draw.TexturedQuad
{
        texture = surface.GetTextureID "gui/gradient",
        color = Color(0, 92, 187, 225),
        x = 0,
        y = ScrH()-42,
        w = ap*4.5,
        h = 19,
}


struc = {}
struc["pos"] = {105, height-70}
struc["color"] = Color(255, 255, 255, 240)
struc["text"] = hp.." HP"
struc["font"] = "HudL"
struc["xalign"] = TEXT_ALIGN_CENTER
struc["yalign"] = TEXT_ALIGN_TOP
draw.TextShadow( struc, 2, 200 )


struc = {}
struc["pos"] = {80, height + 13}
struc["color"] = Color(255, 255, 255, 240)
struc["text"] = ap.." AP"
struc["font"] = "Hud"
struc["xalign"] = TEXT_ALIGN_CENTER
struc["yalign"] = TEXT_ALIGN_TOP
draw.TextShadow( struc, 2, 200 )

end )

 
function GM:DrawDeathNotice(x, y)
	self.BaseClass:DrawDeathNotice(x, y)
end
 
local tohide = { 
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
}

local function HUDShouldDraw(name) 
	if (tohide[name]) then   
		return false;   
	end
end
hook.Add("HUDShouldDraw", "How to: HUD Example HUD hider", HUDShouldDraw)

local function OVERLAY()
	if GetConVarNumber("gg_hp_overlay") == 1 then
        local health = LocalPlayer():Health()


        if health < 30 then
            local panic = 1 - health/30

            local fScale = 3

            local tab = {}
            
            local fColor = 1.0
            fColor = fColor * (1.0 - math.min(panic*fScale, 1.0))
            
            panic = math.max(panic, 0.0)
            panic = math.min(panic, 1.0)
            
            tab[ "$pp_colour_addr" ] = 0;
            tab[ "$pp_colour_addg" ] = 0;
            tab[ "$pp_colour_addb" ] = 0;
            tab[ "$pp_colour_brightness" ] = -0.075 * panic * fScale;
            tab[ "$pp_colour_contrast" ] = 1 + ( 0.385 * panic * fScale );
            tab[ "$pp_colour_colour" ] = fColor;
            tab[ "$pp_colour_mulr" ] = 1;
            tab[ "$pp_colour_mulg" ] = 1; 
            tab[ "$pp_colour_mulb" ] = 1;
            
            DrawColorModify( tab );
        end

		if health <= 10 then
			DrawToyTown( 8, ScrH()/2 )
		elseif health <= 20 then
			DrawToyTown( 6, ScrH()/2 )
		elseif health <= 35 then
			DrawToyTown( 4, ScrH()/2 )
		end

	end
end
hook.Add( "RenderScreenspaceEffects", "HealthAffectedOverlay", OVERLAY )




local function HelpMenu()

	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos(ScrW()/2-295, ScrH()/2-275)
	DermaPanel:SetSize( 270, 670 )
	DermaPanel:SetTitle( "" )
	DermaPanel:Center()
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( true )
	DermaPanel:ShowCloseButton( true)
	DermaPanel.Paint = function() -- Paint function
    surface.SetDrawColor( 75, 75, 75, 255 ) -- Set our rect color below us; we do this so you can see items added to this panel
	end
	DermaPanel:MakePopup()
	
	local Settings = vgui.Create( "DPanel", DermaPanel )
	Settings:SetPos( 45, 20 )
	Settings:SetSize( 250, 250 )
	Settings:SetVisible( true )
	Settings.Paint = function() -- Paint function
    surface.SetDrawColor( 15, 15, 15, 200 ) -- Set our rect color below us; we do this so you can see items added to this panel
    surface.DrawRect( 0, 0, 220, 165 ) -- Draw the rect
	draw.DrawText( "Settings", "HudR", 75, 5, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
	 
	DermaList = vgui.Create( "DPanelList", Settings )
	DermaList:SetPos( 10,50 )
	DermaList:SetSize( 240, 200 )
	DermaList:SetSpacing( 15 ) 
	DermaList:EnableHorizontal( false ) 
	DermaList:EnableVerticalScrollbar( true )
	 

    local QuakeSounds = vgui.Create( "DCheckBoxLabel"  )
    QuakeSounds:SetText( "Quake Sounds" )
	QuakeSounds:SetTextColor(Color(255,255,255))
    QuakeSounds:SetConVar( "gg_quake_sounds" )
    QuakeSounds:SizeToContents()
	DermaList:AddItem( QuakeSounds )
 
 
    local HPOverlay = vgui.Create( "DCheckBoxLabel"  )
    HPOverlay:SetText( "Health Overlay" )
	HPOverlay:SetTextColor(Color(255,255,255))
    HPOverlay:SetConVar( "gg_hp_overlay" )
    HPOverlay:SizeToContents()
	DermaList:AddItem( HPOverlay )
	
    local KillCounter = vgui.Create( "DCheckBoxLabel"  )
    KillCounter:SetText( "Large Kill Counter" )
	KillCounter:SetTextColor(Color(255,255,255))
    KillCounter:SetConVar( "gg_large_Kill_Counter" )
    KillCounter:SizeToContents()
	DermaList:AddItem( KillCounter )


	
	local Perks = vgui.Create( "DPanel", DermaPanel )
	Perks:SetPos( 45, 200 )
	Perks:SetSize( 250, 250 )
	Perks:SetVisible( true )
	Perks.Paint = function() -- Paint function
    surface.SetDrawColor( 15, 15, 15, 200 ) -- Set our rect color below us; we do this so you can see items added to this panel
    surface.DrawRect( 0, 0, 220, 240 ) -- Draw the rect
	draw.DrawText( "Perks", "HudR", 55, 5, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	draw.DrawText( "#1", "HudR", 40, 55, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	draw.DrawText( "#2", "HudR", 40, 115, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	draw.DrawText( "#3", "HudR", 40, 175, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
	
	local Perk1 = vgui.Create( "DButton" )
	Perk1:SetParent( DermaPanel )
		if LocalPlayer():GetNWInt("perk1") == 1 then
			Perk1:SetText("Speed Boost")
		elseif LocalPlayer():GetNWInt("perk1") == 2 then
			Perk1:SetText("Jump Boost")
		elseif LocalPlayer():GetNWInt("perk1") == 3 then
			Perk1:SetText("Bunny Hop")
		end
	Perk1:SetPos( 115, 250 )
	Perk1:SetSize(130,50)
	Perk1.DoClick = function ()
		if LocalPlayer():GetNWInt("perk1") == 1 then
			net.Start("Perk1Change")
				net.WriteFloat(2)
			net.SendToServer()
			Perk1:SetText("Jump Boost")
		elseif LocalPlayer():GetNWInt("perk1") == 2 then
			net.Start("Perk1Change")
				net.WriteFloat(3)
			net.SendToServer()
			Perk1:SetText("Bunny Hop")
		elseif LocalPlayer():GetNWInt("perk1") == 3 then
			net.Start("Perk1Change")
				net.WriteFloat(1)
			net.SendToServer()
			Perk1:SetText("Speed Boost")
		else
			Perk1:SetText("shiieeeeeeeet")
		end
	end
	
	local Perk2 = vgui.Create( "DButton" )
	Perk2:SetParent( DermaPanel )
		if LocalPlayer():GetNWInt("perk2") == 1 then
			Perk2:SetText("HP on kill")
		elseif LocalPlayer():GetNWInt("perk2") == 2 then
			Perk2:SetText("Shield")
		elseif LocalPlayer():GetNWInt("perk2") == 3 then
			Perk2:SetText("Vampire")
		end
	Perk2:SetPos( 115, 310 )
	Perk2:SetSize(130,50)
	Perk2.DoClick = function ()
		if LocalPlayer():GetNWInt("perk2") == 1 then
			net.Start("Perk2Change")
				net.WriteFloat(2)
			net.SendToServer()
			Perk2:SetText("Shield")
		elseif LocalPlayer():GetNWInt("perk2") == 2 then
			net.Start("Perk2Change")
				net.WriteFloat(3)
			net.SendToServer()
			Perk2:SetText("Vampire")
		elseif LocalPlayer():GetNWInt("perk2") == 3 then
			net.Start("Perk2Change")
				net.WriteFloat(1)
			net.SendToServer()
			Perk2:SetText("HP on kill")
		end
	end

	local Perk3 = vgui.Create( "DButton" )
	Perk3:SetParent( DermaPanel )
		if LocalPlayer():GetNWInt("perk3") == 1 then
			Perk3:SetText("Juggernaut")
		elseif LocalPlayer():GetNWInt("perk3") == 2 then
			Perk3:SetText("Damage Buff")
		elseif LocalPlayer():GetNWInt("perk3") == 3 then
			Perk3:SetText("X-Ray")
		elseif LocalPlayer():GetNWInt("perk3") == 4 then
			Perk3:SetText("Health Regen")
		end
	Perk3:SetPos( 115, 370 )
	Perk3:SetSize(130,50)
	Perk3.DoClick = function ()
		if LocalPlayer():GetNWInt("perk3") == 1 then
			net.Start("Perk3Change")
				net.WriteFloat(2)
			net.SendToServer()
			Perk3:SetText("Damage Buff")
		elseif LocalPlayer():GetNWInt("perk3") == 2 then
			net.Start("Perk3Change")
				net.WriteFloat(3)
			net.SendToServer()
			Perk3:SetText("X-Ray")
		elseif LocalPlayer():GetNWInt("perk3") == 3 then
			net.Start("Perk3Change")
				net.WriteFloat(4)
			net.SendToServer()
			Perk3:SetText("Health Regen")
		elseif LocalPlayer():GetNWInt("perk3") == 4 then
			net.Start("Perk3Change")
				net.WriteFloat(1)
			net.SendToServer()
			Perk3:SetText("Juggernaut")
		end
    end
--[[
    local Settings = vgui.Create( "DPanel", DermaPanel )
	Settings:SetPos( 45, 455 )
	Settings:SetSize( 250, 250 )
	Settings.Paint = function() -- Paint function
    surface.SetDrawColor( 15, 15, 15, 200 ) -- Set our rect color below us; we do this so you can see items added to this panel
    surface.DrawRect( 0, 0, 220, 140 ) -- Draw the rect
	end
]]--
	 

end
usermessage.Hook("HelpMenu", HelpMenu)


local function SuperMenu()
if LocalPlayer():IsSuperAdmin() == false then
			chat.AddText(Color(255,150,0),"You are not SuperAdmin!")
			surface.PlaySound("common/wpn_denyselect.wav")
else

	local DermaPanel = vgui.Create( "DFrame" )
	DermaPanel:SetPos(ScrW()/2-295, ScrH()/2-275)
	DermaPanel:SetSize( 270, 470 )
	DermaPanel:SetTitle( "" )
	DermaPanel:Center()
	DermaPanel:SetVisible( true )
	DermaPanel:SetDraggable( true )
	DermaPanel:ShowCloseButton( true)
	DermaPanel.Paint = function() -- Paint function
    surface.SetDrawColor( 15, 15, 15, 255 ) -- Set our rect color below us; we do this so you can see items added to this panel
	end
	DermaPanel:MakePopup()
	
	local Settings = vgui.Create( "DPanel", DermaPanel )
	Settings:SetPos( 45, 20 )
	Settings:SetSize( 250, 270 )
	Settings:SetVisible( true )
	Settings.Paint = function() -- Paint function
    surface.SetDrawColor( 15, 15, 15, 200 ) -- Set our rect color below us; we do this so you can see items added to this panel
    surface.DrawRect( 0, 0, 220, 225 ) -- Draw the rect
	draw.DrawText( "Admin Menu", "HudR", 95, 5, Color( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	end
	 
	DermaList = vgui.Create( "DPanelList", Settings )
	DermaList:SetPos( 10,50 )
	DermaList:SetSize( 240, 200 )
	DermaList:SetSpacing( 15 ) 
	DermaList:EnableHorizontal( false ) 
	DermaList:EnableVerticalScrollbar( true )
	 

    local AmmoOnKill = vgui.Create( "DCheckBoxLabel"  )
    AmmoOnKill:SetText( "Ammo on kill" )
	AmmoOnKill:SetTextColor(Color(255,255,255))
	if GetConVarNumber("gg_ammo_on_kill") == 1 then
		AmmoOnKill:SetChecked( true )
	else
		AmmoOnKill:SetChecked( false )
	end
	function AmmoOnKill.OnChange()
		if GetConVarNumber("gg_ammo_on_kill") == 1 then
		net.Start("AmmoOnKill")
			net.WriteFloat(0)
		net.SendToServer()
		else
		net.Start("AmmoOnKill")
			net.WriteFloat(1)
		net.SendToServer()
		end
	end
    AmmoOnKill:SizeToContents()
	DermaList:AddItem( AmmoOnKill )
 
    local KillsPerLevel = vgui.Create( "DNumSlider" )
    KillsPerLevel:SetText( "Kills per level" )
	KillsPerLevel:SetMin(1)
	KillsPerLevel:SetMax(5)
	KillsPerLevel:SetDecimals(0)
	KillsPerLevel:SetValue(GetConVarNumber("gg_kills_per_level"))
	KillsPerLevel.ValueChanged = function(Self, Value)
     	net.Start("KillsPerLevel")
			net.WriteFloat(Value)
		net.SendToServer()
	end
    KillsPerLevel:SizeToContents()
	DermaList:AddItem( KillsPerLevel )
 
    local MaxRounds = vgui.Create( "DNumSlider" )
    MaxRounds:SetText( "Max Rounds" )
	MaxRounds:SetMin(1)
	MaxRounds:SetMax(10)
	MaxRounds:SetDecimals(0)
	MaxRounds:SetValue(GetConVarNumber("gg_maxrounds"))
	MaxRounds.ValueChanged = function(Self, Value)
     	net.Start("MaxRounds")
			net.WriteFloat(Value)
		net.SendToServer()
	end
    MaxRounds:SizeToContents()
	DermaList:AddItem( MaxRounds )
	
	    local SpawnProtection = vgui.Create( "DNumSlider" )
    SpawnProtection:SetText( "Spawn Protection" )
	SpawnProtection:SetMin(0)
	SpawnProtection:SetMax(10)
	SpawnProtection:SetDecimals(0)
	SpawnProtection:SetValue(GetConVarNumber("gg_spawnprotection"))
	SpawnProtection.ValueChanged = function(Self, Value)
     	net.Start("SpawnProtection")
			net.WriteFloat(Value)
		net.SendToServer()
	end
    SpawnProtection:SizeToContents()
	DermaList:AddItem( SpawnProtection )


end
end
usermessage.Hook("SuperMenu", SuperMenu)

hook.Add("CreateMove", "BHop", function(ucmd)
	local ply = LocalPlayer()
	if LocalPlayer():GetNWInt("perk1") == 3 and LocalPlayer():GetNWInt("streak") > 2 and IsValid(ply) and bit.band(ucmd:GetButtons(), IN_DUCK) > 0 then
		if ply:OnGround() then
			ucmd:SetButtons( bit.bor(ucmd:GetButtons(), IN_JUMP) )
		end
	end
end)

hook.Add( "PreDrawHalos", "X-Ray", function()
	if LocalPlayer():GetNWInt("xray") == 1 and LocalPlayer():GetNWInt("streak") > 6 then
		local allplayers = player.GetAll()
		table.Remove(allplayers,table.KeyFromValue(allplayers,LocalPlayer()))
		halo.Add( allplayers, Color(255,0,0), 2, 2, 2, true, true)
	end
end)

function SpawnMessageOn(data)
	ShowSpawnStuff = data:ReadBool()
end
usermessage.Hook("IsSpawning", SpawnMessageOn)

