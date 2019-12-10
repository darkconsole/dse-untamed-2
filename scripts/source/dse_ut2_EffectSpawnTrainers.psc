ScriptName dse_ut2_EffectSpawnTrainers extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Who, Actor From)

	Untamed.Feat.Reset()
	Untamed.Feat.Stop()
	Untamed.Feat.Start()

	Return
EndEvent

