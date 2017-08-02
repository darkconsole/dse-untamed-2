Scriptname dcc_ut2test_EffectAddToPack extends ActiveMagicEffect

dcc_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Who, Actor From)

	Untamed.Tame(Who)
	Untamed.Pack.RemoveMember(Who)
	Untamed.Pack.AddMember(Who)

	Return
EndEvent
