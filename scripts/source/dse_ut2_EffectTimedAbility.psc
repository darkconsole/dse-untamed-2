ScriptName dse_ut2_EffectTimedAbility extends ActiveMagicEffect

;;;;;;;;

dse_ut2_QuestController Property Untamed Auto
Spell Property TrackedSpell Auto
Float Property Hours = 0.0 Auto

;;;;;;;;

Event OnEffectStart(Actor Target, Actor Caster)

	Float HoursCalc = 1.0

	If(self.TrackedSpell == Untamed.SpellPackRested)
		HoursCalc = StorageUtil.GetFloatValue(Untamed.Player, Untamed.KeySleptHours, Untamed.Config.GetFloat(".PackSleepMinHr"))
		HoursCalc = HoursCalc * Untamed.Config.GetFloat(".PackSleepDurMult")
		StorageUtil.UnsetFloatValue(Untamed.Player, Untamed.KeySleptHours)
		Untamed.Util.PrintDebug("[EffectTimedAbility:PackRested] " + HoursCalc + "hr")
	EndIf

	self.Hours = HoursCalc
	self.RegisterForSingleUpdateGameTime(self.Hours)
	Return
EndEvent

Event OnUpdateGameTime()

	self.GetTargetActor().RemoveSpell(self.TrackedSpell)
	Return
EndEvent
