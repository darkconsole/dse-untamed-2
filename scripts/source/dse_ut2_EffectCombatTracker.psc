Scriptname dse_ut2_EffectCombatTracker extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto
Actor Property Me Auto Hidden

Event OnEffectStart(Actor Caster, Actor Target)
	self.Me = self.GetTargetActor()
	Untamed.Util.PrintDebug("[CombatTracker:Start] " + self.Me.GetDisplayName() + " (" + self.Me.GetName() + ") " + " (" + self.Me.GetFormID() + ")")
	Return
EndEvent

Event OnHit(ObjectReference Whom, Form What, Projectile Bullet, Bool IsPowerful, Bool IsSneak, Bool IsBash, Bool WasBlocked)

	;; unarmed/creature attacks register as weapons so we can quick
	;; bail on spells, enchantments, and cloaks for our purposes.

	If((Whom == NONE) || (What == NONE) || (What as Weapon == NONE) || (Bullet != None))
		Return
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

	If(Killer == NONE)
		;;self.Dispel()
		Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was realdeathed by... something.")
		Return
	EndIf

	Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was realdeathed by " + Killer.GetDisplayName())

	If(Untamed.Pack.IsMember(Killer))
		Untamed.Experience(Killer, Untamed.Config.GetFloat(".PackKillXP"))
	EndIf

	;;self.Dispel()
	Return
EndEvent
