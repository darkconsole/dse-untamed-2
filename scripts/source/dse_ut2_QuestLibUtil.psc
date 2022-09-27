ScriptName dse_ut2_QuestLibUtil extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Property Untamed Auto

String Property KeyXP = "UT2.Actor.Experience" Auto Hidden

String Property FileStrings = "../../../configs/dse-untamed-2/translations/English.json" AutoReadOnly Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Print(String Msg)
{send a message to the notification area.}

	Debug.Notification("[UT2] " + Msg)
	Return
EndFunction

Function PrintDebug(String Msg)
{send a message to the console.}

	;;If(!self.OptDebug)
	;;	Return
	;;EndIf

	MiscUtil.PrintConsole("[UT2] " + Msg)
	Debug.Trace("[UT2] " + Msg)
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; mostly game data related.

Form Function GetForm(Int FormID)
{get a specific form from the soulgem oven esp.}

	Return Game.GetFormFromFile(FormID,Untamed.KeyESP)
EndFunction

Form Function GetFormFrom(String ModName, Int FormID)
{gets a form from a specific mod.}

	If(!Game.IsPluginInstalled(ModName))
		Return NONE
	EndIf

	Return Game.GetFormFromFile(FormID,ModName)
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; maths

Float[] Function GetPositionData(ObjectReference What)
{get an object's positional data.}

	Float[] Output = new Float[4]

	Output[0] = What.GetAngleZ()
	Output[1] = What.GetPositionX()
	Output[2] = What.GetPositionY()
	Output[3] = What.GetPositionZ()

	Return Output
EndFunction

Float[] Function GetPositionAtDistance(ObjectReference What, Float Dist)
{get an objects positional data if it was to be pushed away the specified
distance from itself.}

	Float[] Data = self.GetPositionData(What)

	Data[1] = Data[1] + (Math.Sin(Data[0]) * Dist)
	Data[2] = Data[2] + (Math.Cos(Data[0]) * Dist)

	Return Data
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; strings

String Function StringInsert(String Format, String InputList="")
{a cheeky af implementation of like an sprintf type thing but not.}

	Int Iter = 0
	Int Pos = -1
	String ToFind
	String[] Inputs

	;; short short circuit if we can.

	If(StringUtil.GetLength(InputList) == 0)
		Return Format
	EndIf

	;; rebuild a full string.

	Inputs = PapyrusUtil.StringSplit(InputList,"|")

	While(Iter < Inputs.Length)
		ToFind = "%" + (Iter+1)
		Pos = StringUtil.Find(Format,ToFind)

		;; substring with a length of 0 means full string so we had to test
		;; the position in case the token was the first thing in the string.

		If(Pos > -1)
			If(Pos > 0)
				Format = StringUtil.Substring(Format,0,Pos) + Inputs[Iter] + StringUtil.Substring(Format,(Pos+2))
			Else
				Format = Inputs[Iter] + StringUtil.Substring(Format,(Pos+2))
			EndIf
		EndIf

		Iter += 1
	EndWhile

	Return Format
EndFunction

String Function StringLookup(String Path, String InputList="")
{get a string from the translation file and run it through StringInsert.}

	String Format = JsonUtil.GetPathStringValue(self.FileStrings,Path,("MISSING STRING LOL: " + Path))

	Return self.StringInsert(Format,InputList)
EndFunction

String Function StringLookupRandom(String Path, String InputList="")
{get a random string from the translation file and run it through StringInsert.}

	Int Count = JsonUtil.PathCount(self.FileStrings,Path)
	Int Selected = Utility.RandomInt(0,(Count - 1))
	String Format = JsonUtil.GetPathStringValue(self.FileStrings,(Path + "[" + Selected + "]"))

	Return self.StringInsert(Format,InputList)
EndFunction

Function PrintLookup(String KeyName, String InputList="")
{print a notification string from the translation file.}

	self.Print(self.StringLookup(KeyName,InputList))
EndFunction

Function PrintLookupRandom(String KeyName, String InputList="")
{print a random string from the translation file.}

	self.Print(self.StringLookupRandom(KeyName,InputList))
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Public Actor API.
;; These functions are intended for direct use for complete manipulation of
;; actor features.

Function SetTamed(Actor Who, Bool Enable)
{tame an actor to make it friendly as a potential pack member.}

	If(Enable)
		self.PrintDebug("Taming " + Who.GetDisplayName())

		;; stop being a dick to everything.

		self.StopCombat(Who)
		Who.RemoveFromFaction(Untamed.FactionPredator)
		Who.SetAV("Aggression", 1)

		;; stop being a dick to the player.

		self.StopCombat(Who)
		Who.AddToFaction(Untamed.FactionTamed)
		Who.SetFactionRank(Untamed.FactionTamed, 1)
		Who.SetRelationshipRank(Untamed.Player, 3)
		Who.SetPlayerTeammate(TRUE, TRUE)
		Who.AllowPCDialogue(TRUE)

		self.StopCombat(Who)
		Untamed.Anim.ResetActor(Who)
		Untamed.Util.AddToClassFaction(Who)
	Else
		self.PrintDebug("Untaming " + Who.GetDisplayName())
		Who.RemoveFromFaction(Untamed.FactionTamed)
		Who.SetPlayerTeammate(FALSE, FALSE)
		Who.AllowPCDialogue(FALSE)
		Untamed.Util.RemoveFromClassFaction(Who)
	EndIf

	self.SetPersistHack(Who, Enable)
	self.SetPassive(Who, Enable)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Private Actor API.
;; These are small chunks that manage specific aspects. Do not use these
;; directly unless you are sure of what you are doing.

Function SetPersistHack(Actor Who, Bool Enable)
{little trick to keep temporary actors around.}

	If(Enable)
		Who.RegisterForUpdate(3600)
	Else
		Who.UnregisterForUpdate()
	EndIf

	Return
EndFunction

Function SetPassive(Actor Who, Bool Enable)
{make an actor passive by forcing a nothing package.}

	If(Enable)
		ActorUtil.AddPackageOverride(Who, Untamed.PackageDoNothing, 100)
	Else
		ActorUtil.RemovePackageOverride(Who, Untamed.PackageDoNothing)
	EndIf

	Who.EvaluatePackage()
	Return
EndFunction

Function CanOpenDoors(Actor Who)
{make an actor able to open doors...}

	Who.GetRace().ClearCantOpenDoors()

	Return
EndFunction

Function CanTalk(Actor Who)
{make an actor able to engage dialog...}

	Who.AllowPCDialogue(TRUE)

	Return
EndFunction

Function StopCombat(Actor Who)
{try to break an actor's current combat target.}

	Who.StopCombat()
	Who.StopCombatAlarm()

	Return
EndFunction

Function SheatheWeapons(Actor Who, Bool Wait=TRUE)
{sheathe weapons. optionally wait a while just to make sure. if you are needing
to command multiple actors to sheathe you should pass Wait as FALSE for all of
them except the last one. so clever.}

	If(Who.IsWeaponDrawn())
		Who.SheatheWeapon()

		If(Wait)
			Utility.Wait(3.0)
		EndIf
	EndIf

	Return
EndFunction

Function FixAnimalActor(Actor Who)
{animal actors have some flags set on them are problematic, but we can fix them
without having to edit their forms causing conflicts.}

	;; note we should do this
	;; 1) when a save is loaded to all pack members.
	;; 2) every time the pack follower ability gets reapplied by the alias.

	Untamed.Util.CanOpenDoors(Who)
	Untamed.Util.CanTalk(Who)

	Untamed.Util.PrintDebug("Fix Animal Actor: " + Who.GetDisplayName())
	Return
EndFunction

Function AddToClassFaction(Actor Who)
{add the animals to some factions we can use as single test points in various
condition checks.}

	Int Type = self.GetAnimalType(Who)

	If(Type == Untamed.KeyRaceBear)
		Who.AddToFaction(Untamed.FactionClassBear)
		Who.SetFactionRank(Untamed.FactionClassBear,1)
	ElseIf(Type == Untamed.KeyRaceHorse)
		Who.AddToFaction(Untamed.FactionClassHorse)
		Who.SetFactionRank(Untamed.FactionClassHorse,1)
	ElseIf(Type == Untamed.KeyRaceSaberCat)
		Who.AddToFaction(Untamed.FactionClassSaberCat)
		Who.SetFactionRank(Untamed.FactionClassSaberCat,1)
	ElseIf(Type == Untamed.KeyRaceWolf)
		Who.AddToFaction(Untamed.FactionClassWolf)
		Who.SetFactionRank(Untamed.FactionClassWolf,1)
	EndIf

	Return
EndFunction

Function RemoveFromClassFaction(Actor Who)
{remove the animal from all the class factions.}

	Who.RemoveFromFaction(Untamed.FactionClassBear)
	Who.RemoveFromFaction(Untamed.FactionClassHorse)
	Who.RemoveFromFaction(Untamed.FactionClassSaberCat)
	Who.RemoveFromFaction(Untamed.FactionClassWolf)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; simple event api

Function SendActorEvent(Actor Who, String EventName)
{sends a simple mod event that just notifies that an actor did something
that has no values associated with it.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

Function SendActorEventInt(Actor Who, String EventName, Int Value)
{sends a simple mod event that just notifies that an actor did something
with a value that is an integer.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.PushInt(EventID,Value)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

Function SendActorEventFloat(Actor Who, String EventName, Float Value)
{sends a simple mod event that just notifies that an actor did something
with a value that is a float.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.PushFloat(EventID,Value)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

Function SendActorEventString(Actor Who, String EventName, String Value)
{sends a simple mod event that just notifies that an actor did something
with a value that is a string.}

	Int EventID = ModEvent.Create(EventName)

	If(EventID)
		ModEvent.PushForm(EventID,Who)
		ModEvent.PushString(EventID,Value)
		ModEvent.Send(EventID)
	EndIf

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; actor experience api

Function ModExperience(Actor Who, Float Amount)
{give or take away untamed xp from an actor.}

	Float XP = self.GetExperience(Who) + Amount

	self.SetExperience(Who,XP)
	Return
EndFunction

Float Function GetExperience(Actor Who)
{get the amount of xp this actor has.}

	Return StorageUtil.GetFloatValue(Who,self.KeyXP)
EndFunction

Float Function GetExperienceMax(Actor Who)
{get the maximum amount of xp this actor can store at once.}

	Float Max = Untamed.Menu.OptExperienceMax

	If(Who.HasPerk(Untamed.PerkExperienced))
		Max += Untamed.Menu.OptPerkExperiencedAdd
	EndIf

	Return Max
EndFunction

Float Function GetExperiencePercent(Actor Who)
{get the current xp as a percent}

	Return (self.GetExperience(Who) / self.GetExperienceMax(Who)) * 100
EndFunction

Function SetExperience(Actor Who, Float XP)
{set the amount of xp this actor has.}

	Float MaxXP = self.GetExperienceMax(Who)
	Float ClampXP = PapyrusUtil.ClampFloat(XP, 0.0, MaxXP)
	Bool UpdatePlayer = (Who == Untamed.Player)

	StorageUtil.SetFloatValue(Who, self.KeyXP, ClampXP)

	;;;;;;;;

	If(UpdatePlayer)
		;;If(Untamed.Player.HasPerk(Untamed.PerkThickHide))
		;;	Untamed.Feat.UpdateThickHide(Untamed.Player)
		;;EndIf

		;;If(Untamed.Player.HasPerk(Untamed.PerkResistantHide))
		;;	Untamed.Feat.UpdateResistantHide(Untamed.Player)
		;;EndIf
	EndIf

	Return
EndFunction

Function UpdateExperienceBar()
{update xp bar with current value.}

	;; Untamed.XPBar.SetPercent(self.GetExperiencePercent(Untamed.Player))
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; perk functions

Function ReapplyPerk(Actor Who, Perk Feat)
{remove and reapply the specified perk. mostly for changing the strength of
the effects given.}

	;; i know perks can only be dynamically added and removed from the player
	;; and not npcs, but i prefer to code as though it can be done on anyone
	;; just in case that magically changes in the future with some skse magic.

	Who.RemovePerk(Feat)
	Who.AddPerk(Feat)
	Return
EndFunction

Function UpdateFeatThickHide(Actor Who)
{update the thick hide perk.}

	Float Value = (self.GetExperience(Who) * Untamed.Menu.OptPerkThickHideMult)

	Untamed.PerkThickHide.GetNthEntrySpell(0).SetNthEffectMagnitude(0,Value)
	self.ReapplyPerk(Who,Untamed.PerkThickHide)
	Return
EndFunction

Function UpdateFeatResistantHide(Actor Who)
{update the resistant hide perk.}

	Float Value = (self.GetExperience(Who) * Untamed.Menu.OptPerkResistantHideMult)

	Untamed.PerkResistantHide.GetNthEntrySpell(0).SetNthEffectMagnitude(0,Value)
	self.ReapplyPerk(Who,Untamed.PerkResistantHide)
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function IsFormInList(Form What, FormList Where)
{determine if something is in a form list.}

	Return (Where.Find(What) >= 0)
EndFunction

Int Function GetAnimalType(Actor Who)
{determine what kind of broad animal type this is. fourth party mods can add
support for any custom versions they may create with unique races by adding
those races to these formlists.}

	Race What = Who.GetRace()

	If(self.IsFormInList(What,Untamed.ListRaceWolves))
		Return Untamed.KeyRaceWolf
	ElseIf(self.IsFormInList(What,Untamed.ListRaceBears))
		Return Untamed.KeyRaceBear
	ElseIf(self.IsFormInList(What,Untamed.ListRaceSabercats))
		Return Untamed.KeyRaceSabercat
	ElseIf(self.IsFormInList(What,Untamed.ListRaceHorses))
		Return Untamed.KeyRaceHorse
	EndIf

	Return 0
EndFunction

