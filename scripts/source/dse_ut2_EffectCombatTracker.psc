Scriptname dse_ut2_EffectCombatTracker extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto
Actor Property Me Auto Hidden

Actor[] Property HitLog Auto Hidden

Event OnEffectStart(Actor Caster, Actor Target)
	self.Me = self.GetTargetActor()
	self.HitLog = new Actor[10]

	Untamed.Util.PrintDebug("[CombatTracker:Start] " + self.Me.GetDisplayName() + " (" + self.Me.GetName() + ") " + " (" + self.Me.GetFormID() + ")")
	Return
EndEvent

Event OnHit(ObjectReference Whom, Form What, Projectile Bullet, Bool IsPowerful, Bool IsSneak, Bool IsBash, Bool WasBlocked)

	Int HitIter = 0

	;; unarmed/creature attacks register as weapons so we can quick
	;; bail on spells, enchantments, and cloaks for our purposes.

	If((Whom == NONE) || (What == NONE) || (What as Weapon == NONE) || (Bullet != NONE))
		Return
	EndIf

	;; handle the hit logging.

	If((Whom as Actor) != NONE)
		While(HitIter < self.HitLog.Length)

			If(self.HitLog[HitIter] == Whom)
				;; if we are already in the hit log nothing to do.
				HitIter = self.HitLog.Length
			ElseIf(self.HitLog[HitIter] == NONE)
				;; if we hit a blank entry then add ourselves.
				self.HitLog[HitIter] = Whom as Actor
				HitIter = self.HitLog.Length
			EndIf

			HitIter += 1
		EndWhile
	EndIf

	;;;;;;;;

	Untamed.Util.PrintDebug(Me.GetDisplayName() + " hit by (" + What + ")->(" + Bullet + ") from (" + Whom.GetDisplayName() + ")")

	Return
EndEvent

Event OnDying(Actor Killer)

	If(Killer == NONE)
		Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was pseudodeathed by... something.")
		Return
	EndIf

	Untamed.Util.PrintDebug("[CombatTracker:OnDying] " + self.Me.GetDisplayName() + " was pseudodeathed by " + Killer.GetDisplayName())
	Return
EndEvent

Event OnDeath(Actor Killer)

	Float KXP = 0.0
	Float ShareMult = 0.0
	Int HitIter = 0

	;;;;;;;;

	If(Killer == NONE)
		Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was realdeathed by... something.")
		self.Dispel()
		Return
	EndIf

	Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was realdeathed by " + Killer.GetDisplayName())

	;;;;;;;;

	KXP = Untamed.Config.GetFloat(".PackKillXP")
	ShareMult = Untamed.Config.GetFloat(".PackKillShareXPM")

	If(Killer.IsInFaction(Untamed.FactionPack))
		Untamed.Util.ModExperience(Killer, KXP)
	EndIf

	;; anyone in the hit log gets the pack share xp value from the kill.

	While(HitIter < self.HitLog.Length)
		If(self.HitLog[HitIter] != Killer)
			If(self.HitLog[HitIter].IsInFaction(Untamed.FactionPack) || (self.HitLog[HitIter] == Untamed.Player))
				Untamed.Util.PrintDebug("[CombatTracker:OnDeath] >> " + self.Me.GetDisplayName() + " hitlog entry " + self.HitLog[HitIter].GetDisplayName())
				Untamed.Util.ModExperience(self.HitLog[HitIter], (KXP * ShareMult))
			EndIf
		EndIf

		HitIter += 1
	EndWhile

	Untamed.XPBar.RequestUpdate()

	self.Dispel()
	Return
EndEvent
