Scriptname dse_ut2_EffectCombatTracker extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto
Actor Property Me Auto Hidden

Actor[] Property HitLog Auto Hidden

MagicEffect Property EffectBleed Auto Hidden
Bool Property ShouldBleed Auto Hidden

Event OnEffectStart(Actor Caster, Actor Target)
	self.Me = self.GetTargetActor()
	self.HitLog = new Actor[6]

	self.EffectBleed = Untamed.SpellAttackBleed.GetNthEffectMagicEffect(0)
	self.ShouldBleed = Untamed.Player.HasPerk(Untamed.PerkPackBleed1)

	Untamed.Util.PrintDebug("[CombatTracker:Start] " + self.Me.GetDisplayName() + " (" + self.Me.GetName() + ") " + " (" + self.Me.GetFormID() + ")")
	Return
EndEvent

Event OnHit(ObjectReference Whom, Form What, Projectile Bullet, Bool IsPowerful, Bool IsSneak, Bool IsBash, Bool WasBlocked)

	Int HitIter
	Actor Atk
	Bool AtkPackMember
	Bool VicBleeding

	;; unarmed/creature attacks register as weapons so we can quick
	;; bail on spells, enchantments, and cloaks for our purposes.

	If((Whom == NONE) || (What == NONE) || (What as Weapon == NONE) || (Bullet != NONE))
		Return
	EndIf

	Atk = Whom as Actor
	AtkPackMember = Atk.IsInFaction(Untamed.FactionPack)

	;; we only care about interactions with the pack so we can bail again
	;; from handling sources that dont matter.

	If(!AtkPackMember && Atk != Untamed.Player)
		Return
	EndIf

	;; handle bleed. i did not want to do it this way but the game made me
	;; do it by just failing to work consistently when giving npcs enchanted
	;; weapons, effects, and effect-perks.

	VicBleeding = self.Me.HasMagicEffect(self.EffectBleed)

	If(!VicBleeding && AtkPackMember && self.ShouldBleed)
		Untamed.SpellAttackBleed.Cast(Atk, self.Me)
	EndIf

	;; handle the hit logging. just a quick spam fill if there are somehow
	;; ever more actors than this per encounter then i guess the last few
	;; just lose out.

	If(Atk != NONE)
		HitIter = 0

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

	;;Untamed.Util.PrintDebug(Me.GetDisplayName() + " hit by (" + What + ")->(" + Bullet + ") from (" + Whom.GetDisplayName() + ")")

	Return
EndEvent

Event OnDying(Actor Killer)

	If(Killer == NONE)
		;;Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was pseudodeathed by... something.")
		Return
	EndIf

	;;Untamed.Util.PrintDebug("[CombatTracker:OnDying] " + self.Me.GetDisplayName() + " was pseudodeathed by " + Killer.GetDisplayName())
	Return
EndEvent

Event OnDeath(Actor Killer)

	Float KXP = 0.0
	Float ShareMult = 0.0
	Int HitIter = 0

	;;;;;;;;

	If(Killer == NONE)
		Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was realdeathed by... something.")
	Else
		Untamed.Util.PrintDebug("[CombatTracker:OnDeath] " + self.Me.GetDisplayName() + " was realdeathed by " + Killer.GetDisplayName())

		;; give the primary killer the last hit xp.

		KXP = Untamed.Config.GetFloat(".PackKillXP")
		ShareMult = Untamed.Config.GetFloat(".PackKillShareXPM")

		If(Killer.IsInFaction(Untamed.FactionPack))
			Untamed.Util.ModExperience(Killer, KXP)
		EndIf
	EndIf

	;; give anyone else in the log participation xp.

	While(HitIter < self.HitLog.Length)
		If(self.HitLog[HitIter] != NONE && self.HitLog[HitIter] != Killer)
			If(self.HitLog[HitIter].IsInFaction(Untamed.FactionPack) || (self.HitLog[HitIter] == Untamed.Player))
				;;Untamed.Util.PrintDebug("[CombatTracker:OnDeath] >> " + self.Me.GetDisplayName() + " hitlog entry " + self.HitLog[HitIter].GetDisplayName())
				Untamed.Util.ModExperience(self.HitLog[HitIter], (KXP * ShareMult))
			EndIf
		EndIf

		HitIter += 1
	EndWhile

	self.Dispel()
	Return
EndEvent
