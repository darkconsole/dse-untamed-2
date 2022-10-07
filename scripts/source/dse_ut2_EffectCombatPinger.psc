Scriptname dse_ut2_EffectCombatPinger extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto
Spell Property Tracker Auto

Actor Property Me Auto Hidden

Event OnEffectStart(Actor Caster, Actor Target)
	self.Me = Target
	self.EmitCombatTracker()
	Return
EndEvent

Event OnUpdate()
{conditions may register single updates}

	self.EmitCombatTracker()
	Return
EndEvent

Function EmitCombatTracker()

	Untamed.Util.PrintDebug("[EmitCombatTracker] ping")
	self.Tracker.Cast(self.Me, self.Me)

	self.RegisterForSingleUpdate(2.0)
	Return
EndFunction
