ScriptName dse_ut2_QuestController extends Quest
Int Version = 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; libraries ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestLibAnimate   Property Anim Auto
dse_ut2_QuestLibPack      Property Pack Auto
dse_ut2_QuestLibEncounter Property Sexl Auto
dse_ut2_QuestLibUtil      Property Util Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; subsystems ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestConfig Property Config Auto
dse_ut2_QuestMCM Property Menu Auto
dse_ut2_QuestInterfaceXP Property XPBar Auto
dse_ut2_QuestInterfacePerks Property PerkUI Auto
dse_ut2_QuestRideThings Property Ride Auto
dse_ut2_QuestLove01 Property QuestLove01 Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; form references ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor        Property Player Auto                   ;; skyrim.esm
Keyword      Property KeywordActorTypeAnimal Auto   ;; skyrim.esm
Keyword      Property KeywordActorTypeCreature Auto ;; skyrim.esm
Faction      Property FactionPredator Auto          ;; skyrim.esm
Faction      Property FactionTamed Auto             ;; untamed
Faction      Property FactionPackStay Auto          ;; untamed
Faction      Property FactionClassBear Auto         ;; untamed
Faction      Property FactionClassHorse Auto        ;; untamed
Faction      Property FactionClassSaberCat Auto     ;; untamed
Faction      Property FactionClassWolf Auto         ;; untamed
Faction      Property FactionPlayerFollower Auto    ;; skyrim.esm
Package      Property PackageDoNothing Auto         ;; untamed
Package      Property PackageFollow Auto            ;; untamed
Package      Property PackagePackStay Auto          ;; untamed
Spell        Property SpellMatingCallTracker Auto   ;; untamed
Shout        Property ShoutMatingCall Auto          ;; untamed
Static       Property StaticX Auto                  ;; skyrim.esm
Weapon       Property WeapUnarmed Auto              ;; untamed

Perk         Property PerkPackResistantHide1 Auto   ;; untamed (tenacity)
Perk         Property PerkPackResistantHide2 Auto   ;; untamed (tenacity)
Perk         Property PerkPackResistantHide3 Auto   ;; untamed (tenacity)
Perk         Property PerkPackResistantHide4 Auto   ;; untamed (tenacity)
Perk         Property PerkPackResistantHide5 Auto   ;; untamed (tenacity)
Perk         Property PerkPackThickHide1 Auto       ;; untamed (tenacity)
Perk         Property PerkPackThickHide2 Auto       ;; untamed (tenacity)
Perk         Property PerkPackThickHide3 Auto       ;; untamed (tenacity)
Perk         Property PerkPackThickHide4 Auto       ;; untamed (tenacity)
Perk         Property PerkPackThickHide5 Auto       ;; untamed (tenacity)
Perk         Property PerkPackVitality1 Auto        ;; untamed (tenacity)
Perk         Property PerkPackVitality2 Auto        ;; untamed (tenacity)
Perk         Property PerkPackVitality3 Auto        ;; untamed (tenacity)

Perk         Property PerkPackFerocious1 Auto       ;; untamed (ferocity)
Perk         Property PerkPackFerocious2 Auto       ;; untamed (ferocity)
Perk         Property PerkPackFerocious3 Auto       ;; untamed (ferocity)
Perk         Property PerkPackEndurance1 Auto       ;; untamed (ferocity)
Perk         Property PerkPackEndurance2 Auto       ;; untamed (ferocity)
Perk         Property PerkPackEndurance3 Auto       ;; untamed (ferocity)
Perk         Property PerkPackBleed1 Auto           ;; untamed (ferocity)
Perk         Property PerkPackBleed2 Auto           ;; untamed (ferocity)
Perk         Property PerkPackBleed3 Auto           ;; untamed (ferocity)

Shout        Property ShoutAttack Auto              ;; untamed (beast mastery)
Shout        Property ShoutStay Auto                ;; untamed (beast mastery)
Shout        Property ShoutFollow Auto              ;; untamed (beast mastery)
Perk         Property PerkDenMother Auto            ;; untamed (beast mastery)
Perk         Property PerkLoadBearing1 Auto         ;; untamed (beast mastery)
Perk         Property PerkLoadBearing2 Auto         ;; untamed (beast mastery)
Perk         Property PerkSecondWind1 Auto          ;; untamed (beast mastery)
Perk         Property PerkSecondWind2 Auto          ;; untamed (beast mastery)

Perk         Property PerkCrossbreeder Auto         ;; untamed (essence)
Perk         Property PerkExperienced1 Auto         ;; untamed (essence)
Perk         Property PerkPackLeader1 Auto          ;; untamed (essence)
Perk         Property PerkPackLeader2 Auto          ;; untamed (essence)
Perk         Property PerkPackLeader3 Auto          ;; untamed (essence)
Perk         Property PerkPackHealing1 Auto         ;; untamed (essence)
Perk         Property PerkPackHealing2 Auto         ;; untamed (essence)
Perk         Property PerkPackHealing3 Auto         ;; untamed (essence)
Perk         Property PerkResistantHide Auto        ;; untamed (essence)
Perk         Property PerkThickHide Auto            ;; untamed (essence)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; data lists ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FormList Property ListRaceWolves Auto
FormList Property ListRaceBears Auto
FormList Property ListRaceSabercats Auto
FormList Property ListRaceHorses Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; data keys ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Property KeyRaceWolf       = 1 AutoReadOnly Hidden
Int Property KeyRaceBear       = 2 AutoReadOnly Hidden
Int Property KeyRaceSabercat   = 3 AutoReadOnly Hidden
Int Property KeyRaceHorse      = 4 AutoReadOnly Hidden

Int Property KeyPackLeaderMax0 = 1 AutoReadOnly Hidden
Int Property KeyPackLeaderMax1 = 3 AutoReadOnly Hidden
Int Property KeyPackLeaderMax2 = 6 AutoReadOnly Hidden
Int Property KeyPackLeaderMax3 = 12 AutoReadOnly Hidden

String Property KeyESP = "dse-soulgem-oven.esp" AutoReadOnly Hidden
String Property KeySplashGraphic = "dse-soulgem-oven/splash.dds" AutoReadOnly Hidden
String Property KeyTenacity = "Tenacity" AutoReadOnly Hidden
String Property KeyFerocity = "Ferocity" AutoReadOnly Hidden
String Property KeyBeastMastery = "BeastMastery" AutoReadOnly Hidden
String Property KeyEssence = "Essence" AutoReadOnly Hidden

String Property KeyActorValueHealth = "Health" AutoReadOnly Hidden
String Property KeyActorValueStamina = "Stamina" AutoReadOnly Hidden
String Property KeyActorValueMana = "Magicka" AutoReadOnly Hidden
String Property KeyActorValueResist = "MagicResist" AutoReadOnly Hidden
String Property KeyActorValueArmour = "DamageResist" AutoReadOnly Hidden
String Property KeyActorValueAttack = "AttackDamageMult" AutoReadOnly Hidden

String Property KeyXP = "UT2.Actor.Experience" Auto Hidden
String Property KeyLevel = "UT2.Actor.Level" Auto Hidden
String Property KeyStatBaseHealth = "UT2.StatBase.Health" AutoReadOnly Hidden
String Property KeyStatBaseStamina = "UT2.StatBase.Stamina" AutoReadOnly Hidden
String Property KeyStatBaseMana = "UT2.StatBase.Magicka" AutoReadOnly Hidden
String Property KeyStatBaseResist = "UT2.StatBase.MagicResist" AutoReadOnly Hidden
String Property KeyStatBaseArmour = "UT2.StatBase.DamageResist" AutoReadOnly Hidden
String Property KeyStatBaseAttack = "UT2.StatBase.AttackDamageMult" AutoReadOnly Hidden
String Property KeyPregnantBase = "UT2.Actor.DenMother.ActorBase" AutoReadOnly Hidden
String Property KeyMatingCallList = "UT2.Actor.MatingCallList" AutoReadOnly Hidden

Bool Property OptValidateActor = TRUE Auto Hidden
Bool Property OptDebug = TRUE Auto Hidden
Bool Property OptEnabled = FALSE Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mod management api ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Function Get() Global
{Return the API object for access without binding. Primarily for use in things
like dialog fragments where IDGAF.}

	Return Game.GetFormFromFile(0xD62,"dse-untamed-2.esp") as dse_ut2_QuestController
EndFunction

Int Function GetVersion()
{Return the scripting version. Probably will not match release versions.}

	Return Version
EndFunction

Function ResetMod()
{cause the mod to reset itself.}

	self.Reset()
	self.Stop()
	self.Start()

	Return
EndFunction

Function ResetMod_Subsystems()
{handle rebooting the libraries and subsystems.}

	Int Iter = 0
	Form[] Systems = new Form[8]

	Systems[0] = self.Menu
	Systems[1] = self.Util
	Systems[2] = self.Anim
	Systems[3] = self.Sexl
	Systems[4] = self.Pack
	Systems[5] = self.Util
	Systems[6] = self.XPBar
	Systems[7] = self.PerkUI

	While(Iter < Systems.Length)
		(Systems[Iter] as Quest).Reset()
		(Systems[Iter] as Quest).Stop()
		(Systems[Iter] as Quest).Start()

		Iter += 1
	EndWhile

	self.PerkUI.OnGameReady()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
{detect mod reset}

	self.Util.PrintDebug("HELO")
	self.ResetMod_Subsystems()

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Tame(Actor Who, Bool AddToPack=TRUE)
{shortcut for SetTamed to force an actor friendly.}

	self.Util.SetTamed(Who, TRUE)
	Return
EndFunction

Function Untame(Actor Who, Bool RemoveFromPack=TRUE)
{shortcut for SetTamed to reset an actor to untamed behaviour.}

	self.Util.SetTamed(Who, FALSE)
	Return
EndFunction

Float Function Experience(Actor Who, Float Amount=0.0)
{get how much xp the actor has, modding it by amount first if specified.}

	If(Amount != 0.0)
		self.Util.ModExperience(Who,Amount)
		self.XPBar.UpdateUI()
	EndIf

	Return self.Util.GetExperience(Who)
EndFunction

Int Function Level(Actor Who, Int Amount=1)

	Return 0
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnModReset()

	self.OnModDisabled()
	self.Pack.ClearMembers()
	self.Util.ClearPerks(self.Player)
	self.Config.DeletePath(".")
	StorageUtil.ClearAllPrefix("UT2.")

	self.ResetMod()

	Return
EndFunction

Function OnModEnabled()

	self.OptEnabled = TRUE
	self.Util.AddShout(self.Player, self.ShoutMatingCall)

	self.XPBar.Reset()
	Utility.Wait(0.50)
	self.XPBar.Stop()
	self.XPBar.Start()

	self.Util.Print("Untamed is Ready.")
	Return
EndFunction

Function OnModDisabled()

	self.OptEnabled = FALSE
	self.Player.RemoveShout(self.ShoutMatingCall)

	self.XPBar.Reset()
	Utility.Wait(0.50)
	self.XPBar.Stop()

	self.Util.Print("Untamed is Disabled.")
	Return
EndFunction
