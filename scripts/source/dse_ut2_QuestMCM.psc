Scriptname dse_ut2_QuestMCM extends SKI_ConfigBase Conditional

dse_ut2_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dependency states.

Bool Property HasNIO = FALSE Auto
Bool Property HasUIE = FALSE Auto
Bool Property HasSL = FALSE Auto
Bool Property HasPUtil = FALSE Auto
Bool Property HasBWA = FALSE Auto
Bool Property HasSLA = FALSE Auto
Bool Property HasEFF = FALSE Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; all of these properties need to go away we are using the new json config.

Int   Property Difficulty = 100 Auto Hidden
Int   Property OptPerkPackLeader0 = 1 Auto Hidden
Int   Property OptPerkPackLeader1 = 3 Auto Hidden
Int   Property OptPerkPackLeader2 = 6 Auto Hidden
Int   Property OptPerkPackLeader3 = 12 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int ModReset = 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnInit()
	Untamed.Util.PrintDebug("Configuration Reset")
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; dependency detection.

Bool Function IsInstalledNiOverride(Bool Popup=TRUE)
{make sure NiOverride is installed and active.}

	If(NiOverride.GetScriptVersion() < 6)
		If(Popup)
			Debug.MessageBox("NiOverride not installed. Install it by installing RaceMenu or by installing it standalone from the Nexus.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledUIExtensions(Bool Popup=TRUE)
{make sure UIExtensions is installed and active.}

	If(Game.GetModByName("UIExtensions.esp") == 255)
		If(Popup)
			Debug.MessageBox("UIExtensions not installed. Install it from the Nexus.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledSexLab(Bool Popup=TRUE)
{make sure SexLab is installed and active.}

	If(Game.GetModByName("SexLab.esm") == 255)
		If(Popup)
			Debug.MessageBox("SexLab not installed. Install it from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledPapyrusUtil(Bool Popup=TRUE)
{make sure papyrus util is a version we need. if we test this after sexlab we
can basically promise it will be there. we need to make sure that shlongs of
skyrim though didn't fuck it up again with an older version, that will break
the use of AdjustFloatValue and the like.}

	If(PapyrusUtil.GetVersion() < 31)
		If(Popup)
			Debug.MessageBox("Your PapyrusUtil is too old or has been overwritten by something like SOS. Install PapyrusUtil 3.1 from LoversLab and make sure it dominates the load order.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledBlushWhenAroused(Bool Popup=TRUE)
{make sure blush when aroused is installed and active.}

	If(Game.GetModByName("Blush When Aroused.esp") == 255)
		If(Popup)
			Debug.MessageBox("Blush When Aroused is not installed. Install it from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Bool Function IsInstalledSexLabAroused(Bool Popup=TRUE)
{make sure sexlab aroused is installed and active.}

	If(Game.GetModByName("SexLabAroused.esm") == 255)
		If(Popup)
			Debug.MessageBox("SexLab Aroused is not installed. Install it, preferably Redux, from LoversLab.")
		EndIf
		Return FALSE
	EndIf

	Return TRUE
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; MCM stuff

Int Function GetVersion()
{mcm's version request}

	Return 1
EndFunction

Event OnGameReload()
{things to do when the game is loaded from disk.}

	parent.OnGameReload()

	;; hard requirements
	self.HasNIO = self.IsInstalledNiOverride(TRUE)
	self.HasUIE = self.IsInstalledUIExtensions(TRUE)
	self.HasSL = self.IsInstalledSexLab(TRUE)
	self.HasPUtil = self.IsInstalledPapyrusUtil(TRUE)

	;; soft requirements
	self.HasSLA = self.IsInstalledSexLabAroused(FALSE)
	self.HasBWA = self.IsInstalledBlushWhenAroused(FALSE)
	self.HasEFF = dse_ut2_ExternEFF.IsEnabled()

	;;;;;;;;

	Untamed.Pack.OnGameReady()
	Untamed.PerkUI.OnGameReady()

	self.RegisterForSingleUpdate(2.22)
	Return
EndEvent

Event OnUpdate()

	Untamed.Util.PrintDebug("[QuestMCM:OnUpdate] delayed actions go")

	;; this should kick off the ui running off in its own thread im pretty
	;; sure such like.

	Untamed.XPBar.Reset()
	Untamed.XPBar.Stop()
	Untamed.XPBar.Start()

	Untamed.Pack.OnGameReadyDelayed()

	Return
EndEvent

Event OnConfigInit()
{things to do when the menu initalises (is opening)}

	self.Pages = new String[3]

	self.Pages[0] = "$UT2_Menu_General"
	self.Pages[1] = "$UT2_Menu_Splash"
	self.Pages[2] = "$UT2_Menu_Debug"

	Return
EndEvent

Event OnConfigOpen()
{things to do when the menu actually opens.}

	self.OnConfigInit()
	Return
EndEvent

Event OnConfigClose()
{things to do when the menu closes.}

	Return
EndEvent

Event OnPageReset(String Page)
{when a different tab is selected in the menu.}

	self.UnloadCustomContent()
	ModReset = 0

	If(Page == "$UT2_Menu_General")
		self.ShowPageGeneral()
	ElseIf(Page == "$UT2_Menu_Debug")
		self.ShowPageDebug()
	Else
		self.ShowPageSplash()
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionKeyMapChange(int Item, int KeyCode, string ExistCtrl, string ExistName)

	;; todo - check how that conflict detection works.

	If(Item == ItemMenuKey)
		Untamed.PerkUI.UnregisterGameKeys()
		Untamed.PerkUI.KeyMn = KeyCode
		Untamed.Config.SetInt(".MenuKey", KeyCode)
		self.SetKeyMapOptionValue(Item, KeyCode)
		Untamed.PerkUI.RegisterGameKeys()
	EndIf

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnOptionSelect(Int Item)

	Bool Val = FALSE
	Int Data = -1
	Actor Who = Game.GetCurrentCrosshairRef() as Actor

	If(Who == None)
		Who = Untamed.Player
	EndIf

	;;;;;;;;

	If(Item == ItemOptEnabled)
		Val = !Untamed.OptEnabled
		Untamed.OptEnabled = Val
		Debug.MessageBox("Close all the menus to allow the mod to process.")
		self.SetToggleOptionValue(Item, Val)
		Utility.Wait(0.1)

		If(Untamed.OptEnabled)
			Untamed.OnModEnabled()
		Else
			Untamed.OnModDisabled()
		EndIf

		Return
	ElseIf(Item == ItemDebugModReset1 || Item == ItemDebugModReset2)
		Val = TRUE
		ModReset += 1

		If(ModReset >= 2)
			Debug.MessageBox("Close all the menus to allow the mod to reset.")
			self.SetToggleOptionValue(Item, Val)
			Utility.Wait(0.1)

			Untamed.OnModReset()
			Return
		EndIf
	ElseIf(Item == ItemDebugActorXP0)
		Val = TRUE
		Untamed.Util.SetExperience(Who, 0)
		Untamed.XPBar.RequestUpdate()
	ElseIf(Item == ItemDebugActorXP25)
		Val = TRUE
		Untamed.Util.SetExperience(Who, (Untamed.Util.GetExperienceMax(Who) * 0.25))
		Untamed.XPBar.RequestUpdate()
	ElseIf(Item == ItemDebugActorXP50)
		Val = TRUE
		Untamed.Util.SetExperience(Who, (Untamed.Util.GetExperienceMax(Who) * 0.50))
		Untamed.XPBar.RequestUpdate()
	ElseIf(Item == ItemDebugActorXP75)
		Val = TRUE
		Untamed.Util.SetExperience(Who, (Untamed.Util.GetExperienceMax(Who) * 0.75))
		Untamed.XPBar.RequestUpdate()
	ElseIf(Item == ItemDebugActorXP100)
		Val = TRUE
		Untamed.Util.SetExperience(Who, Untamed.Util.GetExperienceMax(Who))
		Untamed.XPBar.RequestUpdate()
	ElseIf(Item == ItemDebugActorClearPreg)
		Val = TRUE
		Untamed.Util.ActorClearPregnant(Who)
	EndIf

	;;;;;;;;

	self.SetToggleOptionValue(Item,Val)

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int ItemOptEnabled
Int ItemMenuKey

Function ShowPageGeneral()

	self.SetTitleText("$UT2_Menu_Debug")
	self.SetCursorFillMode(TOP_TO_BOTTOM)
	self.SetCursorPosition(0)

	ItemOptEnabled = self.AddToggleOption("Enable Mod", Untamed.OptEnabled)
	ItemMenuKey = self.AddKeymapOption("$UT2_MenuOpt_MenuKey", Untamed.Config.GetInt(".MenuKey"))

	Return
EndFunction

Function ShowPageSplash()

	Int Selected
	String[] Graphics = new String[1]

	Graphics[0] = "dse-untamed-2/splash01.dds"
	Selected = Utility.RandomInt(1,Graphics.Length) - 1

	self.LoadCustomContent(Graphics[Selected])
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int ItemDebug
Int ItemDebugActorXP0
Int ItemDebugActorXP25
Int ItemDebugActorXP50
Int ItemDebugActorXP75
Int ItemDebugActorXP100
Int ItemDebugActorClearPreg
Int ItemDebugModReset1
Int ItemDebugModReset2

Function ShowPageDebug()

	Actor Who = Game.GetCurrentCrosshairRef() as Actor

	Actor[] Pack = Untamed.Pack.GetMemberList()
	Int Piter = 0
	Float GameTimeNow = Utility.GetCurrentGameTime()
	ActorBase PregWith
	String PregRight = "No"
	Float PregTime = 0.0
	String PackLeft
	String PackRight

	Actor TheMount = Untamed.Ride.TheMount.GetReference() as Actor

	If(Who == None)
		Who = Untamed.Player
	EndIf

	If(Untamed.Util.ActorIsPregnant(Who))
		PregWith = Untamed.Util.ActorGetPregnant(Who)
		PregTime = GameTimeNow - StorageUtil.GetFloatValue(Who, Untamed.KeyPregnantBase)
		PregRight = PregWith.GetRace().GetName() + " [" + Untamed.Util.DecToHex(PregWith.GetFormID()) + "] [" + (Untamed.Util.FloatToString(PregTime, 2)) + "d]"
	EndIf

	;;;;;;;;

	self.SetTitleText("$UT2_Menu_Debug")
	self.SetCursorFillMode(TOP_TO_BOTTOM)
	self.SetCursorPosition(0)

	self.AddHeaderOption(Who.GetDisplayName())
	ItemDebugActorXP0 = self.AddToggleOption("Set UXP to 0", FALSE)
	ItemDebugActorXP25 = self.AddToggleOption("Set UXP to 25%", FALSE)
	ItemDebugActorXP50 = self.AddToggleOption("Set UXP to 50%", FALSE)
	ItemDebugActorXP75 = self.AddToggleOption("Set UXP to 75%", FALSE)
	ItemDebugActorXP100 = self.AddToggleOption("Set UXP to 100%", FALSE)
	ItemDebugActorClearPreg = self.AddToggleOption("Reset Pregnancy", FALSE)
	self.AddEmptyOption()

	ItemDebugModReset1 = self.AddToggleOption("Nuclear Reset Key1", FALSE)
	ItemDebugModReset2 = self.AddToggleOption("Nuclear Reset Key2", FALSE)

	self.SetCursorPosition(1)
	ItemDebug = AddToggleOption("Debugging", TRUE)
	self.AddEmptyOption()

	self.AddHeaderOption(Who.GetDisplayName())
	self.AddTextOption("UXP",(Untamed.Experience(Who) as String))
	self.AddTextOption("Pack Count",(Untamed.Pack.GetMemberCount() as String))
	self.AddTextOption("Pack Max",(Untamed.Pack.GetMemberCountMax() as String))
	self.AddTextOption("Pregnant: ", PregRight)
	self.AddEmptyOption()

	self.AddEmptyOption()
	self.AddHeaderOption("Mount Info")
	self.AddTextOption("Mount", TheMount as String)
	self.AddTextOption("Skeleton", ((Untamed.Ride.WillItMount(Untamed.Player, TheMount) As Int) As String))

	Piter = 0
	While(Piter < Pack.Length)
		PackLeft = ((Piter + 1) as String) + ") " + Pack[Piter].GetDisplayName() + " [" + Untamed.Util.DecToHex(Pack[Piter].GetFormID()) + "]"
		PackRight = Untamed.Util.GetExperience(Pack[Piter]) + " UXP"
		self.AddTextOption(PackLeft, PackRight)
		Piter += 1
	EndWhile

	AddEmptyOption()

	Return
EndFunction
