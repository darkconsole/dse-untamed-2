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
				Untamed.Util.ModExperience(Untamed.Player, 1)
				Untamed.Util.ModExperience(Members[Iter], 1)

			ElseIf(self.CommandNum == 2)
				Untamed.Pack.Target.ForceRefTo(Untamed.Player)
				Members[Iter].RemoveFromFaction(Untamed.FactionPackStay)
				Members[Iter].EvaluatePackage()
				Untamed.Util.ModExperience(Untamed.Player, 1)
				Untamed.Util.ModExperience(Members[Iter], 1)

				;; set the shout to take that long to cd.
				Utility.Wait(3.8)
				Untamed.Pack.Target.Clear()

			ElseIf(self.CommandNum == 3)
				Untamed.Pack.Target.ForceRefTo(Target)
				Members[Iter].RemoveFromFaction(Untamed.FactionPackStay)
				Members[Iter].EvaluatePackage()
				Untamed.Util.ModExperience(Untamed.Player, 1)
				Untamed.Util.ModExperience(Members[Iter], 1)
			EndIf

			Untamed.Util.PrintDebug(Members[Iter].GetDisplayName() + " heard your command (" + self.CommandNum + ")")
		EndIf

		Iter += 1
	EndWhile

	Return
EndEvent


