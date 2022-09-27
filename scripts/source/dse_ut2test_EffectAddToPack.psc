Scriptname dse_ut2test_EffectAddToPack extends ActiveMagicEffect

dse_ut2_QuestController Property Untamed Auto

Event OnEffectStart(Actor Who, Actor From)

	Untamed.Pack.RemoveMember(Who)
	Untamed.Untame(Who)

	If(Untamed.Pack.HasOpenSlot())
		Untamed.Tame(Who)
		Untamed.Pack.AddMember(Who)
	Else
		Untamed.Util.Print("Cannot tame, pack is full.")
	EndIf

	Return
EndEvent
