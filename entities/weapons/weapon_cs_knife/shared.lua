
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if (CLIENT) then
	SWEP.PrintName 		= "Knife"
	SWEP.ViewModelFOV		= 75
	SWEP.Slot 			= 0
	SWEP.SlotPos 		= 0
	SWEP.IconLetter 		= "j"
	killicon.AddFont("weapon_cs_awp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Base = "btw_cs_base"
    
SWEP.HoldType = "knife"

SWEP.ViewModelFlip  = false
SWEP.ViewModel          = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel         = "models/weapons/w_knife_t.mdl"

SWEP.FaceStabDamage = 55
SWEP.Primary.Damage         = 65
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = true
SWEP.Primary.Delay = 1.1
SWEP.Primary.Ammo       = "none"
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = true
SWEP.Secondary.Ammo     = "none"
SWEP.Secondary.Delay = 1.4
SWEP.ViewModelFOV = 72
SWEP.m_WeaponDeploySpeed = 1

function SWEP:PrimaryAttack()
   self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
   self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
    
    if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
   self.Owner:LagCompensation(true)

   local spos = self.Owner:GetShootPos()
   local sdest = spos + (self.Owner:GetAimVector() * 70)

   local kmins = Vector(1,1,1) * -10
   local kmaxs = Vector(1,1,1) * 10

   local tr = util.TraceHull({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL, mins=kmins, maxs=kmaxs})

   -- Hull might hit environment stuff that line does not hit
   if not IsValid(tr.Entity) then
      tr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})
   end

   local hitEnt = tr.Entity

   -- effects
   if IsValid(hitEnt) then
      self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )

      local edata = EffectData()
      edata:SetStart(spos)
      edata:SetOrigin(tr.HitPos)
      edata:SetNormal(tr.Normal)
      edata:SetEntity(hitEnt)

      if hitEnt:IsPlayer() then
         util.Effect("BloodImpact", edata)
	  elseif hitEnt:GetClass() == "prop_ragdoll" then 
		
      end
   else
      self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
   end

   if SERVER then
      self.Owner:SetAnimation( PLAYER_ATTACK1 )
   end


   if SERVER and tr.Hit and tr.HitNonWorld and IsValid(hitEnt) then
      if hitEnt:IsPlayer() then
         -- knife damage is never karma'd, so don't need to take that into
         -- account we do want to avoid rounding error strangeness caused by
         -- other damage scaling, causing a death when we don't expect one, so
         -- when the target's health is close to kill-point we just kill
         if self:IsInstantKill(hitEnt) then
            self:StabKill(tr, spos, sdest)
         else
            local dmg = DamageInfo()
            dmg:SetDamage(self.FaceStabDamage)
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self.Weapon or self)
            dmg:SetDamageForce(self.Owner:GetAimVector() * 5)
            dmg:SetDamagePosition(self.Owner:GetPos())
            dmg:SetDamageType(DMG_SLASH)

            hitEnt:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)
			
         end
      end
   end

   self.Owner:LagCompensation(false)
end

function SWEP:IsInstantKill(target)
	return (target:GetAimVector():DotProduct(self.Owner:GetAimVector()) >= 0.2)
end

function SWEP:StabKill(tr, spos, sdest)
   local target = tr.Entity
   
   local dmg = DamageInfo()
   local dobleed = false
   
   dmg:SetDamage(1000)

   dmg:SetAttacker(self.Owner)
   dmg:SetInflictor(self.Weapon or self)
   dmg:SetDamageForce(self.Owner:GetAimVector())
   dmg:SetDamagePosition(self.Owner:GetPos())
   dmg:SetDamageType(DMG_SLASH)

   -- now that we use a hull trace, our hitpos is guaranteed to be
   -- terrible, so try to make something of it with a separate trace and
   -- hope our effect_fn trace has more luck

   -- first a straight up line trace to see if we aimed nicely
   local retr = util.TraceLine({start=spos, endpos=sdest, filter=self.Owner, mask=MASK_SHOT_HULL})

   -- if that fails, just trace to worldcenter so we have SOMETHING
   if retr.Entity != target then
      local center = target:LocalToWorld(target:OBBCenter())
      retr = util.TraceLine({start=spos, endpos=center, filter=self.Owner, mask=MASK_SHOT_HULL})
   end


   -- create knife effect creation fn
   local bone = retr.PhysicsBone
   local pos = retr.HitPos
   local norm = tr.Normal
   local ang = Angle(-28,0,0) + norm:Angle()
   ang:RotateAroundAxis(ang:Right(), -90)
   pos = pos - (ang:Forward() * 7)

   local prints = self.fingerprints
   local ignore = self.Owner

   target.effect_fn = function(rag)
                         -- we might find a better location
                         local rtr = util.TraceLine({start=pos, endpos=pos + norm * 40, filter=ignore, mask=MASK_SHOT_HULL})

                         if IsValid(rtr.Entity) and rtr.Entity == rag then
                            bone = rtr.PhysicsBone
                            pos = rtr.HitPos
                            ang = Angle(-28,0,0) + rtr.Normal:Angle()
                            ang:RotateAroundAxis(ang:Right(), -90)
                            pos = pos - (ang:Forward() * 10)

                         end

                         local knife = ents.Create("prop_physics")
                         knife:SetModel("models/weapons/w_knife_t.mdl")
                         knife:SetPos(pos)
                         knife:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                         knife:SetAngles(ang)
                         knife.CanPickup = false

                         knife:Spawn()

                         local phys = knife:GetPhysicsObject()
                         if IsValid(phys) then
                            phys:EnableCollisions(false)
                         end

                         constraint.Weld(rag, knife, bone, 0, 0, true)

                         -- need to close over knife in order to keep a valid ref to it
                         rag:CallOnRemove("weapon_knife_cleanup", function() SafeRemoveEntity(knife) end)
						 
                      end


   -- seems the spos and sdest are purely for effects/forces?
   target:DispatchTraceAttack(dmg, spos + (self.Owner:GetAimVector() * 3), sdest)

   -- target appears to die right there, so we could theoretically get to
   -- the ragdoll in here...
    
end

function SWEP:SecondaryAttack()
end

function SWEP:Equip()
   self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay * 1.5) )
   self.Weapon:SetNextSecondaryFire( CurTime() + (self.Secondary.Delay * 1.5) )
end

function SWEP:DrawHUD()


	local x, y

	// If we're drawing the local player, draw the crosshair where they're aiming,
	// instead of in the center of the screen.
	if ( self.Owner == LocalPlayer() && self.Owner:ShouldDrawLocalPlayer() ) then

		local tr = util.GetPlayerTrace( self.Owner )
		tr.mask = bit.bor( CONTENTS_SOLID,CONTENTS_MOVEABLE,CONTENTS_MONSTER,CONTENTS_WINDOW,CONTENTS_DEBRIS,CONTENTS_GRATE,CONTENTS_AUX )
		local trace = util.TraceLine( tr )
		
		local coords = trace.HitPos:ToScreen()
		x, y = coords.x, coords.y

	else
		x, y = ScrW() / 2.0, ScrH() / 2.0
	end
	
	local scale = 1 
	
	// Scale the size of the crosshair according to how long ago we fired our weapon
	local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))

	surface.SetDrawColor( 0, 255, 0, 255 )
	
	
	// Draw an awesome crosshair
	local gap = scale
	local length = gap + 6 * scale
	surface.DrawLine( x - length, y, x - gap, y )
	surface.DrawLine( x + length, y, x + gap, y )
	surface.DrawLine( x, y - length, x, y - gap )
	surface.DrawLine( x, y + length, x, y + gap )

end

function SWEP:OnRemove()
   if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() and self.Owner:Alive() then
      RunConsoleCommand("lastinv")
   end
end

