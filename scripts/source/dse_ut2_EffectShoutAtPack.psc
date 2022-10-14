ScriptName dse_ut2_EffectShoutAtPack extends ActiveMagicEffect
{CommandNum: 1 = stay, 2 = follow, 3 = attack target}

dse_ut2_QuestController Property Untamed Auto

Int Property CommandNum Auto
Int Property Distance Auto

Event OnEffectStart(Actor Target, Actor Caster)

	Actor[] Members = Untamed.Pack.GetMemberList()
	Int Iter = 0

	;;;;;;;;

	While(Iter < Members.Length)

		If(Members[Iter] != NONE && (Members[Iter].GetDistance(Caster) <= self.Distance))
			If(self.CommandNum == 1)
				Members[Iter].AddToFaction(Untamed.FactionPackStay)
				Members[Iter].EvaluatePackage()
			ElseIf(self.CommandNum == 2)
				Members[Iter].RemoveFromFaction(Untamed.FactionPackStay)
				Members[Iter].EvaluatePackage()
			ElseIf(self.CommandNum == 3)
				Untamed.Pack.Target.ForceRefTo(Target)
				Members[Iter].RemoveFromFaction(Untamed.FactionPackStay)
				Members[Iter].EvaluatePackage()
			EndIf

			Untamed.Util.PrintDebug(Members[Iter].GetDisplayName() + " heard your command (" + self.CommandNum + ")")
		EndIf

		Iter += 1
	EndWhile

	Return
EndEvent


