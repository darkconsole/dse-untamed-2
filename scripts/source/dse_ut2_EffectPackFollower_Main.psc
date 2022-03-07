Scriptname dse_ut2_EffectPackFollower_Main extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Who, Actor From)
	Untamed.Util.Print("PackFollower OnEffectStart")
	Untamed.Util.FixAnimalActor(Who)
	Return
EndEvent
