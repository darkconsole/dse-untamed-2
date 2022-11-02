Scriptname dse_ut2_EffectMatingCallPinger extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Target, Actor Caster)
	Untamed.Sexl.BeginMatingCall(Caster)
	Return
EndEvent
