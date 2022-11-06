ScriptName dse_ut2_EffectTimedAbility extends ActiveMagicEffect

;;;;;;;;

dse_ut2_QuestController Property Untamed Auto
Spell Property TrackedSpell Auto
Float Property Hours = 0.0 Auto

;;;;;;;;

Event OnEffectStart(Actor Target, Actor Caster)

	Float HoursCalc = self.Hours

	;; if no time has been set then we will use some coded logic for
	;; determining a time.

	If(HoursCalc == 0.0)
		If(self.TrackedSpell == Untamed.SpellPackRested)
			;; well rested - calc time based on how long player slept.
			HoursCalc = StorageUtil.GetFloatValue(Untamed.Player, Untamed.KeySleptHours, Untamed.Config.GetFloat(".PackSleepMinHr"))
			HoursCalc = HoursCalc * Untamed.Config.GetFloat(".PackSleepDurMult")
			StorageUtil.UnsetFloatValue(Untamed.Player, Untamed.KeySleptHours)
			Untamed.Util.PrintDebug("[EffectTimedAbility:PackRested] " + HoursCalc + "hr")
		EndIf
	EndIf

	self.Hours = HoursCalc
	self.RegisterForSingleUpdateGameTime(self.Hours)
	Return
EndEvent

Event OnUpdateGameTime()

	self.GetTargetActor().RemoveSpell(self.TrackedSpell)
	Return
EndEvent
