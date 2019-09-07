local NapalmMissileProjectile = import('/lua/terranweapons.lua').NapalmMissileProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local Explosion = import('/lua/defaultexplosions.lua')

Napalm_Missile = Class(NapalmMissileProjectile) {

	PolyTrail = '/effects/emitters/default_polytrail_06_emit.bp',

	OnCreate = function(self)
		NapalmMissileProjectile.OnCreate(self)
		self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)
		
		self.TargetSpread = 3
		
		NapalmMissileProjectile.OnCreate(self)
        self.TargetPos = self:GetCurrentTargetPosition()
        self.TargetPos[1] = self.TargetPos[1] + RandomFloat(-self.TargetSpread,self.TargetSpread)
        self.TargetPos[3] = self.TargetPos[3] + RandomFloat(-self.TargetSpread,self.TargetSpread)

		self:SetTurnRate(0)
		self:ForkThread(self.StageThread)
	end,

	StageThread = function(self)
        WaitSeconds(0.2 +Random(0,100)*0.01)
        self:SetTurnRate(self:GetBlueprint().Physics.TurnRate)

        self:SetNewTargetGround(self.TargetPos)
	end,
	
	OnImpact = function(self, TargetType, targetEntity)
		if not self:BeenDestroyed() then
			if TargetType == 'Terrain' then
				local size = RandomFloat(0.75,1.5)
				Explosion.CreateScorchMarkDecal(self, size, self:GetArmy())
			end
		end
		NapalmMissileProjectile.OnImpact( self, TargetType, targetEntity )
	end,

}
TypeClass = Napalm_Missile