Scriptname dse_ut2_EffectMatingCall extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto
Actor Property Me Auto Hidden

Event OnEffectStart(Actor Target, Actor Caster)
	self.Me = Caster

	;; reset list.
	;; drop bomb.
	;; wait.
	;; process list.

	Return
EndEvent
