Scriptname dse_ut2_EffectMatingCallTracker extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Target, Actor Caster)

	Bool Accept = FALSE

	;;;;;;;;

	Accept = Target.HasKeyword(Untamed.KeywordActorTypeAnimal)

	If(!Accept)
		If(Untamed.Config.GetBool(".IncludeCreatures"))
			Accept = Target.HasKeyword(Untamed.KeywordActorTypeCreature)
		EndIf
	EndIf

	If(!Accept)
		Return
	Endif

	;;;;;;;;

	StorageUtil.FormListAdd(NONE, Untamed.KeyMatingCallList, Target)
	Return
EndEvent
