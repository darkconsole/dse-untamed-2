ScriptName dse_ut2_QuestLibUtil extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Property Untamed Auto

String Property KeyXP = "UT2.Actor.Experience" Auto Hidden

String Property FileStrings = "../../../configs/dse-untamed-2/translations/English.json" AutoReadOnly Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Popup(String Msg)

	Debug.MessageBox(Msg)

	If(Untamed.OptDebug)
		MiscUtil.PrintConsole("[UT2] " + Msg)
		Debug.Trace("[UT2] " + Msg)
	EndIf

	Return
EndFunction

Function Print(String Msg)
{send a message to the notification area.}

	Debug.Notification("[UT2] " + Msg)

	If(Untamed.OptDebug)
		MiscUtil.PrintConsole("[UT2] " + Msg)
		Debug.Trace("[UT2] " + Msg)
	EndIf

	Return
EndFunction

Function PrintDebug(String Msg)
{send a message to the console.}

	If(Untamed.OptDebug)
		MiscUtil.PrintConsole("[UT2] " + Msg)
		Debug.Trace("[UT2] " + Msg)
	EndIf

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

String Function DecToHex(Int Number)
{base ten int to base sixteen string converter.}

	String Output = ""
	String[] HexChar = new String[16]
	Int HexKey = 0

	If(Number == 0)
		Output = "0"
	Else
		HexChar[0] = "0"
		HexChar[1] = "1"
		HexChar[2] = "2"
		HexChar[3] = "3"
		HexChar[4] = "4"
		HexChar[5] = "5"
		HexChar[6] = "6"
		HexChar[7] = "7"
		HexChar[8] = "8"
		HexChar[9] = "9"
		HexChar[10] = "A"
		HexChar[11] = "B"
		HexChar[12] = "C"
		HexChar[13] = "D"
		HexChar[14] = "E"
		HexChar[15] = "F"

		While(Number != 0)
			HexKey = Math.LogicalAnd(Number,0xF)
			Number = Math.RightShift(Number,4)
			Output = HexChar[HexKey] + Output
		EndWhile
	EndIf

	Return Output
EndFunction

String Function FloatToString(Float Val, Int Dec=0)
{"convert" a float into a string - e.g. get a printable float
that cuts off all the ending zeroes the game adds when casting
a float into a string directly.}

	Int Last = Math.Floor(Val)
	String Output = Last As String

	If(Dec > 0 && Val != Last)
		Output += "."

		While(Dec > 0)
			Val = (Val - Last) * 10
			Last = Math.Floor(Val)
			Output += Last As String

			Dec -= 1
		EndWhile
	EndIf

	Return Output
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

		;; turning set player teammate on and then off again is intentional
		;; here to get them to behave asap. but then we turn it off and
		;; allow the faction and actor values trigger them to aid in combat
		;; without the teammate status so that they can get credit for
		;; their own kills in the OnDying and OnDeath events.

		;; stop being a dick to everything.

		Who.SetPlayerTeammate(TRUE, TRUE)
		self.StopCombat(Who)
		Who.RemoveFromAllFactions()
		self.FixAnimalActor(Who)

		;; stop being a dick to the player.

		self.StopCombat(Who)
		Who.AddToFaction(Untamed.FactionTamed)
		Who.SetFactionRank(Untamed.FactionTamed, 1)
		Who.SetRelationshipRank(Untamed.Player, 3)

		self.StopCombat(Who)
		Untamed.Anim.ResetActor(Who)
		Untamed.Util.BookmarkActorStats(Who)
		Untamed.Util.AddToClassFaction(Who)
		Who.SetPlayerTeammate(FALSE, FALSE)
		self.FixAnimalActor(Who)
	Else
		self.PrintDebug("Untaming " + Who.GetDisplayName())
		Who.RemoveFromFaction(Untamed.FactionTamed)
		Who.SetPlayerTeammate(FALSE, FALSE)
		Who.AllowPCDialogue(FALSE)
		Untamed.Util.ResetActorStats(Who)
		Untamed.Util.ForgetActorStats(Who)
		Untamed.Util.RemoveFromClassFaction(Who)
	EndIf

	self.SetPersistHack(Who, Enable)
	self.SetPassive(Who, Enable)
	;;Untamed.XPBar.UpdateUI()

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
without having to edit their forms causing conflicts. these tend to not persist
in the save file which is another reason we have to fix them occasionally.}

	;; note we should do this
	;; 1) when a save is loaded to all pack members.
	;; 2) every time the pack follower ability gets reapplied by the alias.

	Untamed.Util.CanOpenDoors(Who)
	Untamed.Util.CanTalk(Who)
	Who.AllowPCDialogue(TRUE)

	Who.SetActorValue("Aggression", 1) ;; attack verified enemies
	Who.SetActorValue("Assistance", 2) ;; aid friends and allies
	Who.SetActorValue("Morality", 0)   ;; do crime
	Who.SetActorValue("Confidence", 4) ;; yolo

	If(Untamed.Player.HasPerk(Untamed.PerkPackHealing1))
		Who.SetActorValue("CombatHealthRegenMult", 1.0)
	EndIf

	Who.EquipItem(Untamed.WeapUnarmed, TRUE, TRUE)

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

Function BookmarkActorStats(Actor Who)
{remember an actor's base stats when encountered.}

	float Health = Who.GetActorValueMax(Untamed.KeyActorValueHealth)
	float Stam = Who.GetActorValueMax(Untamed.KeyActorValueStamina)
	float Mana = Who.GetActorValueMax(Untamed.KeyActorValueMana)
	float Resist = Who.GetActorValueMax(Untamed.KeyActorValueResist)
	float Armour = Who.GetActorValueMax(Untamed.KeyActorValueArmour)
	float Attack = Who.GetActorValueMax(Untamed.KeyActorValueAttack)

	self.PrintDebug("[" + Who.GetDisplayName() + "] BookmarkActorStats(" + " Health: " + Health + ", Stam: " + Stam + ", Mana: " + Mana + ", AttackMult: " + Attack + ", Armour: " + Armour + ", Resist: " + Resist + ")")

	StorageUtil.SetFloatValue(Who, Untamed.KeyStatBaseHealth, Health)
	StorageUtil.SetFloatValue(Who, Untamed.KeyStatBaseStamina, Stam)
	StorageUtil.SetFloatValue(Who, Untamed.KeyStatBaseMana, Mana)
	StorageUtil.SetFloatValue(Who, Untamed.KeyStatBaseResist, Resist)
	StorageUtil.SetFloatValue(Who, Untamed.KeyStatBaseArmour, Armour)
	StorageUtil.SetFloatValue(Who, Untamed.KeyStatBaseAttack, Attack)

	Return
EndFunction

Function ResetActorStats(Actor Who)
{reset an actor to how we found it.}

	float Health = StorageUtil.GetFloatValue(Who, Untamed.KeyStatBaseHealth, -1.0)
	float Stam = StorageUtil.GetFloatValue(Who, Untamed.KeyStatBaseStamina, -1.0)
	float Mana = StorageUtil.GetFloatValue(Who, Untamed.KeyStatBaseMana, -1.0)
	float Resist = StorageUtil.GetFloatValue(Who, Untamed.KeyStatBaseResist, -1.0)
	float Armour = StorageUtil.GetFloatValue(Who, Untamed.KeyStatBaseArmour, -1.0)
	float Attack = StorageUtil.GetFloatValue(Who, Untamed.KeyStatBaseAttack, -1.0)

	self.PrintDebug("[" + Who.GetDisplayName() + "] ResetActorStats(" + " Health: " + Health + ", Stam: " + Stam + ", Mana: " + Mana + ", AttackMult: " + Attack + ", Armour: " + Armour + ", Resist: " + Resist + ")")

	If(Health != -1.0)
		Who.ForceActorValue(Untamed.KeyActorValueHealth, Health)
	EndIf

	If(Stam != -1.0)
		Who.ForceActorValue(Untamed.KeyActorValueStamina, Stam)
	EndIf

	If(Mana != -1.0)
		Who.ForceActorValue(Untamed.KeyActorValueMana, Mana)
	EndIf

	If(Resist != -1.0)
		Who.ForceActorValue(Untamed.KeyActorValueResist, Resist)
	EndIf

	If(Armour != -1.0)
		Who.ForceActorValue(Untamed.KeyActorValueArmour, Armour)
	EndIf

	If(Attack != -1.0)
		Who.ForceActorValue(Untamed.KeyActorValueAttack, Attack)
	EndIf

	Return
EndFunction

Function ForgetActorStats(Actor Who)
{and forget the actor's original base stats.}

	StorageUtil.ClearAllObjPrefix(Who, "UT2.StatBase.")

	Return
EndFunction

Function Rename(Actor Who)
{rename this animal.}

	String NewName

	UIExtensions.InitMenu("UITextEntryMenu")
	UIExtensions.SetMenuPropertyString("UITextEntryMenu", "text", Who.GetDisplayName())
	UIExtensions.OpenMenu("UITextEntryMenu")
	NewName = UIExtensions.GetMenuResultString("UITextEntryMenu")

	If(NewName != "")
		Who.SetDisplayName(NewName)
		self.Print(Who.GetDisplayName()  + " the " + Who.GetRace().GetName())
	EndIf

	Return
EndFunction

Function AddShout(Actor Who, Shout Which)

	Int Iter = 0
	WordOfPower Word

	Who.AddShout(Which)

	While(Iter < 3)

		Word = Which.GetNthWordOfPower(Iter)

		If(Word != NONE)
			Game.UnlockWord(Word)
		EndIf

		Iter += 1
	EndWhile

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

Int Function GetLevel(Actor Who)
{get the amount of xp this actor has.}

	Return StorageUtil.GetIntValue(Who, Untamed.KeyLevel, 0)
EndFunction

Int Function SetLevel(Actor Who, Int Lvl)
{get the amount of xp this actor has.}

	Return StorageUtil.SetIntValue(Who, Untamed.KeyLevel, Lvl)
EndFunction

Function ModLevel(Actor Who, Int Amount)
{give or take away untamed xp from an actor.}

	Int Lvl = self.GetLevel(Who) + Amount

	self.SetLevel(Who, Lvl)
	Return
EndFunction

Function ModExperience(Actor Who, Float Amount)
{give or take away untamed xp from an actor.}

	Float XP = self.GetExperience(Who) + Amount

	self.SetExperience(Who,XP)
	Return
EndFunction

Float Function GetExperience(Actor Who)
{get the amount of xp this actor has.}

	Return StorageUtil.GetFloatValue(Who, Untamed.KeyXP, 0.0)
EndFunction

Float Function GetExperienceMax(Actor Who)
{get the maximum amount of xp this actor can store at once.}

	Float Max = Untamed.Menu.OptExperienceMax

	If(Who.HasPerk(Untamed.PerkExperienced1))
		Max += Untamed.Menu.OptPerkExperiencedAdd
	EndIf

	Return Max
EndFunction

Float Function GetExperiencePercent(Actor Who)
{get the current xp as a percent}

	Return (self.GetExperience(Who) / self.GetExperienceMax(Who)) * 100
EndFunction

Function SetExperienceConceptWithLeveling(Actor Who, Float NXP)
{set the amount of xp this actor has.}

	Float MXP = self.GetExperienceMax(Who)
	Int Lvl = self.GetLevel(Who)
	Int LvlAdjust = 0
	Bool UpdatePlayer = (Who == Untamed.Player)

	If(NXP > MXP)
		While(NXP > MXP)
			LvlAdjust += 1
			NXP -= MXP
		EndWhile
	ElseIf(NXP < 0)
		While(NXP < 0)
			LvlAdjust -= 1

			If((Lvl + LvlAdjust) >= 0)
				NXP += MXP
			Else
				NXP = 0
			EndIf
		EndWhile
	EndIf

	self.PrintDebug("[SetExperience] " + Who.GetDisplayName() + " XP " + NXP + ", Lvl " + (Lvl + LvlAdjust) + " (" + LvlAdjust + ")")

	StorageUtil.SetFloatValue(Who, Untamed.KeyXP, NXP)
	StorageUtil.SetIntValue(Who, Untamed.KeyLevel, PapyrusUtil.ClampInt((Lvl + LvlAdjust), 0, 100))

	If(UpdatePlayer)
		If(Untamed.Player.HasPerk(Untamed.PerkThickHide))
			self.UpdateFeatThickHide(Untamed.Player)
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkResistantHide))
			self.UpdateFeatResistantHide(Untamed.Player)
		EndIf
	EndIf

	Return
EndFunction

Function SetExperience(Actor Who, Float XP)
{set the amount of xp this actor has.}

	Float MaxXP = self.GetExperienceMax(Who)
	Float ClampXP = PapyrusUtil.ClampFloat(XP, 0.0, MaxXP)
	Bool UpdatePlayer = (Who == Untamed.Player)

	StorageUtil.SetFloatValue(Who, Untamed.KeyXP, ClampXP)
	Untamed.Util.PrintDebug(Who.GetDisplayName() + " UXP " + ClampXP)

	;;;;;;;;

	If(UpdatePlayer)
		If(Untamed.Player.HasPerk(Untamed.PerkThickHide))
			self.UpdateFeatThickHide(Untamed.Player)
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkResistantHide))
			self.UpdateFeatResistantHide(Untamed.Player)
		EndIf
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

	self.PrintDebug(Who.GetDisplayName() + " Thick Hide " + Value)

	Untamed.PerkThickHide.GetNthEntrySpell(0).SetNthEffectMagnitude(0, Value)
	self.ReapplyPerk(Who,Untamed.PerkThickHide)

	Return
EndFunction

Function UpdateFeatResistantHide(Actor Who)
{update the resistant hide perk.}

	Float Value = (self.GetExperience(Who) * Untamed.Menu.OptPerkResistantHideMult)

	self.PrintDebug(Who.GetDisplayName() + " Resistant Hide " + Value)

	Untamed.PerkResistantHide.GetNthEntrySpell(0).SetNthEffectMagnitude(0,Value)
	self.ReapplyPerk(Who,Untamed.PerkResistantHide)

	Return
EndFunction

Function ClearPerks(Actor Who)
{remove all the ut2 perks from the actor.}

	Who.RemoveShout(Untamed.ShoutMatingCall)

	;; tenacity
	Who.RemovePerk(Untamed.PerkPackResistantHide1)
	Who.RemovePerk(Untamed.PerkPackResistantHide2)
	Who.RemovePerk(Untamed.PerkPackResistantHide3)
	Who.RemovePerk(Untamed.PerkPackResistantHide4)
	Who.RemovePerk(Untamed.PerkPackResistantHide5)
	Who.RemovePerk(Untamed.PerkPackThickHide1)
	Who.RemovePerk(Untamed.PerkPackThickHide2)
	Who.RemovePerk(Untamed.PerkPackThickHide3)
	Who.RemovePerk(Untamed.PerkPackThickHide4)
	Who.RemovePerk(Untamed.PerkPackThickHide5)
	Who.RemovePerk(Untamed.PerkPackVitality1)
	Who.RemovePerk(Untamed.PerkPackVitality2)
	Who.RemovePerk(Untamed.PerkPackVitality3)

	;; ferocity
	Who.RemovePerk(Untamed.PerkPackFerocious1)
	Who.RemovePerk(Untamed.PerkPackFerocious2)
	Who.RemovePerk(Untamed.PerkPackFerocious3)
	Who.RemovePerk(Untamed.PerkPackEndurance1)
	Who.RemovePerk(Untamed.PerkPackEndurance2)
	Who.RemovePerk(Untamed.PerkPackEndurance3)
	Who.RemovePerk(Untamed.PerkPackBleed1)
	Who.RemovePerk(Untamed.PerkPackBleed2)
	Who.RemovePerk(Untamed.PerkPackBleed3)

	;; beast mastery
	Who.RemoveShout(Untamed.ShoutAttack)
	Who.RemoveShout(Untamed.ShoutStay)
	Who.RemoveShout(Untamed.ShoutFollow)
	Who.RemovePerk(Untamed.PerkDenMother)
	Who.RemovePerk(Untamed.PerkLoadBearing1)
	Who.RemovePerk(Untamed.PerkLoadBearing2)
	Who.RemovePerk(Untamed.PerkSecondWind1)
	Who.RemovePerk(Untamed.PerkSecondWind2)

	;; essence
	Who.RemovePerk(Untamed.PerkCrossbreeder)
	Who.RemovePerk(Untamed.PerkExperienced1)
	Who.RemovePerk(Untamed.PerkPackLeader1)
	Who.RemovePerk(Untamed.PerkPackLeader2)
	Who.RemovePerk(Untamed.PerkPackLeader3)
	Who.RemovePerk(Untamed.PerkPackHealing1)
	Who.RemovePerk(Untamed.PerkPackHealing2)
	Who.RemovePerk(Untamed.PerkPackHealing3)
	Who.RemovePerk(Untamed.PerkResistantHide)
	Who.RemovePerk(Untamed.PerkThickHide)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function ActorIsBeast(Actor Who)
{determine if this actor is one that untamed wants to deal with.}

	If(Who.HasKeyword(Untamed.KeywordActorTypeAnimal))
		Return TRUE
	EndIf

	If(Untamed.Config.GetBool(".IncludeCreatures") && Who.HasKeyword(Untamed.KeywordActorTypeCreature))
		Return TRUE
	EndIf

	Return FALSE
EndFunction

Bool Function ActorIsPregnant(Actor Who)
{determine if this actor should is pregnant.}

	return (self.ActorGetPregnant(Who) != NONE)
EndFunction

ActorBase Function ActorGetPregnant(Actor Who)
{get the actorbase actor is pregnant with or none if not.}

	Return StorageUtil.GetFormValue(Who, Untamed.KeyPregnantBase) As ActorBase
EndFunction

Function ActorSetPregnant(Actor Who, Actor With, Bool Force=FALSE)
{set an actor to become pregnant with another of the specified type. will not
override an existing pregnancy unless forced.}

	ActorBase What = self.ActorGetPregnant(Who)

	If(What != NONE && Force != TRUE)
		Return
	EndIf

	;;;;;;;;

	What = With.GetActorBase()

	If(What == NONE)
		self.PrintDebug("[ActorSetPregnant] failed to find actor ActorBase lmao ok")
		Return
	EndIf

	;;;;;;;;

	;; start the pregnancy.
	self.PrintDebug("[ActorSetPregnant] " + Who.GetDisplayName() + " => " + With.GetDisplayName() + " " + What)
	StorageUtil.SetFormValue(Who, Untamed.KeyPregnantBase, What)
	StorageUtil.SetFloatValue(Who, Untamed.KeyPregnantBase, Utility.GetCurrentGameTime())

	;; note the actor as pregnant.
	StorageUtil.FormListAdd(NONE, Untamed.KeyPregnantBase, Who, FALSE)

	Return
EndFunction

Float Function ActorUpdatePregnant(Actor Who, Int Amount=1)
{increment an actor's pregnancy data.}

	Float MaxDays = Untamed.Config.GetFloat(".PregnancyDays")
	Float Now = Utility.GetCurrentGameTime()
	Float Then = StorageUtil.GetFloatValue(Who, Untamed.KeyPregnantBase, Now)
	Float Diff = Now - Then
	Float Percent = Diff / MaxDays

	self.PrintDebug("[ActorUpdatePregnant] " + Who.GetDisplayName() + " " + (Percent * 100) + "%")

	;; todo - body scaling

	Return Percent
EndFunction

Function ActorClearPregnant(Actor Who)
{depreggo and clean up this actor.}

	StorageUtil.FormListRemove(NONE, Untamed.KeyPregnantBase, Who, TRUE)
	StorageUtil.UnsetFormValue(Who, Untamed.KeyPregnantBase)
	StorageUtil.UnsetFloatValue(Who, Untamed.KeyPregnantBase)

	Return
EndFunction

Int Function CountPregnantActors()
{return how many actors are being tracked for pregnancy.}

	Return StorageUtil.FormListCount(NONE, Untamed.KeyPregnantBase)
EndFunction

Actor[] Function GetPregnantActors()
{return an array of pregnant actors.}

	Actor[] Output = PapyrusUtil.ActorArray(self.CountPregnantActors())
	Int Iter = 0

	While(Iter < Output.Length)
		Output[Iter] = StorageUtil.FormListGet(NONE, Untamed.KeyPregnantBase, Iter) as Actor
		Iter += 1
	EndWhile

	Return Output
Endfunction
