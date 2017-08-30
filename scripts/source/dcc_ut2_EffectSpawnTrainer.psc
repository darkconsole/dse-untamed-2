Scriptname dcc_ut2_EffectSpawnTrainer extends ActiveMagicEffect

Event OnEffectStart(Actor Who, Actor From)
	dcc_ut2_QuestController.Get().Feat.SpawnTrainer()
	Return
EndEvent
