Scriptname dcc_ut2test_EffectAddToPack extends ActiveMagicEffect

dcc_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Who, Actor From)

	If(Untamed.Pack.HasOpenSlot())
		Untamed.Tame(Who)
		Untamed.Pack.RemoveMember(Who)
		Untamed.Pack.AddMember(Who)
	Else
		Untamed.Util.Print("Cannot tame, pack is full.")
	EndIf

	Return
EndEvent
