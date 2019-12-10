ScriptName dse_ut2_EffectSpawnTrainers extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Who, Actor From)

	If(Untamed.Feat.IsRunning())
		Untamed.Feat.DespawnTrainers()
		Untamed.Feat.Reset()
		Untamed.Feat.Stop()
	Else
		Untamed.Feat.Start()
		Untamed.Feat.SpawnTrainers()
	EndIf

	Return
EndEvent

