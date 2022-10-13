ScriptName dse_ut2_EffectShoutAtPack extends ActiveMagicEffect
{CommandNum: 1 = stay, 2 = follow}

dse_ut2_QuestController Property Untamed Auto

Int Property CommandNum Auto
Int Property Distance Auto

Event OnEffectStart(Actor Caster, Actor Target)

	Actor[] Members = Untamed.Pack.GetMemberList()
	Int Iter = 0

	;;;;;;;;

	While(Iter < Members.Length)

		If(Members[Iter] != NONE && (Members[Iter].GetDistance(Caster) <= self.Distance))
			If(self.CommandNum == 1)
				Members[Iter].AddToFaction(Untamed.FactionPackStay)
			ElseIf(self.CommandNum == 2)
				Members[Iter].RemoveFromFaction(Untamed.FactionPackStay)
			EndIf

			Untamed.Util.PrintDebug(Members[Iter].GetDisplayName() + " heard your command.")
			Members[Iter].EvaluatePackage()
		EndIf

		Iter += 1
	EndWhile

	Return
EndEvent


