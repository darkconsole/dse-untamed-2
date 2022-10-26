Scriptname dse_ut2_EffectMatingCallTracker extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Target, Actor Caster)

	Bool Accept = Untamed.Util.ActorIsBeast(Target)

	If(!Accept)
		Return
	Endif

	StorageUtil.FormListAdd(NONE, Untamed.KeyMatingCallList, Target)
	Untamed.Util.SetTamed(Target, TRUE)

	;; if the player cast this have this actor echo a smaller radius version
	;; to try and avoid a situation where your call landed right on the edge
	;; and split up a pack giving you like one response and then combat.

	Untamed.Util.PrintDebug("[MatingCallTracker] " + Caster.GetDisplayName() + " => " + Target.GetDisplayName())
	If(Caster == Untamed.Player)
		Untamed.SpellMatingCallTracker.Cast(Target)
	EndIf

	Return
EndEvent
