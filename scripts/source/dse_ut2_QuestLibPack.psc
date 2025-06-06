ScriptName dse_ut2_QuestLibPack extends Quest
{to make pack animals more interactive, i am finally giving in and making a
mod where you cannot just infinite all the things. this will use a system
of reference aliases to hold pack members currently following you. however
unlike most mods that do this i am going to use actual computer science >_>}

;; terminology

;; pack member = actors currently following you having access to advanced
;; features. different from actors you may have parked.

dse_ut2_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReferenceAlias Property Target Auto

ReferenceAlias[] Property Members Auto
{compiled list of the aliases on our management quest.}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; pack meta api.

Int Function GetMemberCount()
{fetch how many things we have in our currently active pack.}

	Int Count
	Int Iter = self.Members.Length - 1

	While(Iter >= 0)
		If(self.Members[Iter].GetReference() != None)
			Count += 1
		EndIf

		Iter -= 1
	EndWhile

	Return Count
EndFunction

Int Function GetMemberCountMax()
{fetch the maximum number of things that can be in our pack.}

	If(Untamed.Player.HasPerk(Untamed.PerkPackLeader3))
		Return Untamed.KeyPackLeaderMax3
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackLeader2))
		Return Untamed.KeyPackLeaderMax2
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackLeader1))
		Return Untamed.KeyPackLeaderMax1
	EndIf

	Return Untamed.KeyPackLeaderMax0
EndFunction

Actor[] Function GetMemberList()
{fetch an array of just the actors that are filled.}

	Int Count = self.GetMemberCount()
	Int Iter = self.Members.Length - 1

	Actor[] Output = PapyrusUtil.ActorArray(Count)
	Int Next = 0

	While(Iter >= 0)
		If(self.Members[Iter].GetReference() != NONE)
			Output[Next] = self.Members[Iter].GetReference() As Actor
			Next += 1
		EndIf

		Iter -= 1
	EndWhile

	Return Output
EndFunction

Bool Function HasOpenSlot()
{determine if there is room in the pack for this.}

	Return (self.GetMemberCount() < self.GetMemberCountMax())
EndFunction

Float Function GetMemberExperience(Actor Who)
{get the experience of a specific member.}

	Return Untamed.Experience(Who)
EndFunction

Float[] Function GetPackExperience()
{return an array of floats with the xp of all the pack members.}

	Int Len = self.GetMemberCount()
	Int Iter = 0
	Float[] Output = Utility.CreateFloatArray(Len)

	While(Iter < Len)
		Output[Iter] = self.GetMemberExperience(self.Members[Iter].GetActorReference())
		Iter += 1
	EndWhile

	Return Output
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; member management api

Bool Function IsMember(Actor Who)
{check if the specified actor is in the pack or not.}

	Int Iter = self.Members.Length - 1

	While(Iter >= 0)
		If(self.Members[Iter].GetReference() == Who)
			Return TRUE
		EndIf

		Iter -= 1
	EndWhile

	Return FALSE
EndFunction

Bool Function AddMember(Actor Who)
{push a new actor into the pack. returns true if it was added, returns false
if the pack is already full.}

	Int Iter = self.Members.Length - 1
	Int MaxMemberCount = self.GetMemberCountMax()

	;; if they are already in the pack just pretend that we added them
	;; this should not really happen unless we lol'd somewhere.
	If(self.IsMember(Who))
		Untamed.Util.PrintDebug("Already in pack")
		Return TRUE
	EndIf

	;; make sure that we are not already at the limit of the number of
	;; members we can have.
	If(self.GetMemberCount() >= MaxMemberCount)
		Untamed.Util.PrintDebug("Pack is full")
		Return FALSE
	EndIf

	If(!Who.IsInFaction(Untamed.FactionTamed))
		Untamed.Util.SetTamed(Who, TRUE)
	EndIf

	Iter = 0
	While(Iter < MaxMemberCount)
		If(self.Members[Iter].GetReference() == None)
			self.Members[Iter].ForceRefTo(Who)

			ActorUtil.RemovePackageOverride(Who, Untamed.PackageFollow)

			Who.StopCombat()
			Who.StopCombatAlarm()
			Who.SetDoingFavor(FALSE)

			Untamed.Util.SendActorEvent(Who, "UT2.Pack.MemberJoin")
			Untamed.Util.PrintDebug(Who.GetDisplayName() + " added to pack as Member" + Iter)
			Untamed.Util.SetPassive(Who, FALSE)
			Untamed.XPBar.RequestUpdate()

			StorageUtil.SetFloatValue(Who, "UT2.Pack.TimeJoin", Utility.GetCurrentGameTime())

			If(Untamed.Menu.HasEFF)
				Untamed.Util.AddToEFF(Who)
			EndIf

			Return TRUE
		EndIf

		Iter += 1
	EndWhile

	Return FALSE
EndFunction

Bool Function RemoveMember(Actor Who)
{remove an actor from the pack. returns true if they were found and removed,
returns false under any other condition.}

	Bool Found = FALSE
	Int Iter = self.Members.Length - 1

	;; we won't stop after the first occurrence just in case something
	;; totally fucked happened and the same actor is in two aliases.

	If(Who == NONE)
		Return Found
	EndIf

	While(Iter >= 0)
		If(self.Members[Iter].GetReference() == Who)
			self.Members[Iter].Clear()
			Untamed.Util.PrintDebug(Who.GetDisplayName() + " removed from pack as Member" + Iter)
			Found = TRUE
		EndIf

		Iter -= 1
	EndWhile

	If(Found)
		Untamed.Util.SetPassive(Who, TRUE)
		Untamed.Util.SendActorEvent(Who,"UT2.Pack.MemberLeave")
		StorageUtil.UnsetFloatValue(Who, "UT2.Pack.TimeJoin")

		If(Untamed.Menu.HasEFF)
			Untamed.Util.RemoveFromEFF(Who)
		EndIf
	EndIf

	Untamed.XPBar.RequestUpdate()

	Return Found
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function FixMembers()
{update all the active pack members to make sure they can do everything they
need to be able to do.}

	Int Iter = 0
	Actor Who = NONE

	While(Iter < self.Members.Length)
		Who = self.Members[Iter].GetActorReference()

		If(Who != NONE)
			Untamed.Util.FixAnimalActor(Who)

			If(Untamed.Menu.HasEFF)
				Untamed.Util.AddToEFF(Who)
			EndIf
		EndIf

		Iter += 1
	EndWhile

	Return
EndFunction

Function ClearMembers()
{delete them all.}

	Int Iter = 0
	Actor Who = NONE

	While(Iter < self.Members.Length)
		self.Members[Iter].Clear()
		Iter += 1
	EndWhile

	Return
EndFunction

Function UpdatePreggos()
{update pregnant actor data.}

	Actor[] Preggos = Untamed.Util.GetPregnantActors()
	Int Iter = 0
	Float Percent

	While(Iter < Preggos.Length)

		If(Preggos[Iter] != NONE)
			Percent = Untamed.Util.ActorUpdatePregnant(Preggos[Iter])
			Utility.Wait(1.25)
		EndIf

		Iter += 1
	EndWhile

	Return
EndFunction

Function RequestUpdate(Float Time=60.0)
{provide for update request bashing.}

	self.UnregisterForUpdate()
	self.RegisterForSingleUpdate(Time)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnGameReady()

	self.OnUpdate()

	Return
EndFunction

Function OnGameReadyDelayed()

	;; run through and fix all pack members.

	self.FixMembers()

	;; update player abilities.

	If(Untamed.Player.HasPerk(Untamed.PerkThickHide))
		Untamed.Util.UpdateFeatThickHide(Untamed.Player)
	EndIf

	If(Untamed.Player.HasPerk(Untamed.PerkResistantHide))
		Untamed.Util.UpdateFeatResistantHide(Untamed.Player)
	EndIf

	Return
EndFunction

Event OnUpdate()

	Untamed.Util.PrintDebug("[LibPack:OnUpdate] ping")

	If(Untamed.Util.CountPregnantActors())
		self.UpdatePreggos()
	EndIf

	If(self.IsRunning())
		self.RegisterForSingleUpdate(120)
	EndIf

	Return
EndEvent

