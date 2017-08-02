Scriptname dcc_ut2_EffectPackFollower_Main extends ActiveMagicEffect

dcc_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Who, Actor From)
	Untamed.Util.FixAnimalActor(Who)
	Return
EndEvent
