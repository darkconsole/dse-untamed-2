Scriptname dse_ut2_QuestInterfacePerks extends Quest

dse_ut2_QuestController Property Untamed Auto
iWant_Widgets Property iWant Auto Hidden

Int[] Property MainItems Auto Hidden
Int[] Property SideItems Auto Hidden

Int Property MainCur = 0 Auto Hidden
Int Property SideCur = 0 Auto Hidden
String Property StateCur = "Default" Auto Hidden
Bool Property Busy = FALSE Auto Hidden

Int Property KeyMn = 0x40 Auto Hidden
Int Property KeyUp = 0 Auto Hidden
Int Property KeyDn = 0 Auto Hidden
Int Property KeyLf = 0 Auto Hidden
Int Property KeyRt = 0 Auto Hidden
Int Property KeyOk = 0 Auto Hidden
Int Property KeyFk = 0 Auto Hidden
Int Property KeyHp = 0 Auto Hidden

Int ScreenX = 1280
Int ScreenY = 720

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnGameReady()

	self.iWant = Game.GetFormFromFile(0x800, "iWant Widgets.esl") as iWant_Widgets

	self.UnregisterForKey(self.KeyMn)
	self.RegisterForKey(self.KeyMn)

	self.GotoState("Default")
	self.GotoState("Off")

	Untamed.Util.PrintDebug("[Perks:OnGameReady] Done")
	Return
EndFunction

Event OnKeyDown(int KeyCode)

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function EnableKeyboardInput(Bool Full=TRUE)

	If(Full)
		Untamed.Player.SetDontMove(TRUE)
		Untamed.Player.SetRestrained(TRUE)
		Game.DisablePlayerControls(FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
	EndIf

	;;;;;;;;

	self.KeyOk = Input.GetMappedKey("Activate")
	self.KeyFk = Input.GetMappedKey("Tween Menu")
	self.KeyUp = Input.GetMappedKey("Forward")
	self.KeyDn = Input.GetMappedKey("Back")
	self.KeyLf = Input.GetMappedKey("Strafe Left")
	self.KeyRt = Input.GetMappedKey("Strafe Right")
	self.KeyHp = Input.GetMappedKey("Ready Weapon")

	self.RegisterForKey(self.KeyOk)
	self.RegisterForKey(self.KeyFk)
	self.RegisterForKey(self.KeyUp)
	self.RegisterForKey(self.KeyDn)
	self.RegisterForKey(self.KeyLf)
	self.RegisterForKey(self.KeyRt)
	self.RegisterForKey(self.KeyHp)

	Return
EndFunction

Function DisableKeyboardInput(Bool Full=TRUE)

	self.UnregisterForKey(self.KeyOk)
	self.UnregisterForKey(self.KeyFk)
	self.UnregisterForKey(self.KeyUp)
	self.UnregisterForKey(self.KeyDn)
	self.UnregisterForKey(self.KeyLf)
	self.UnregisterForKey(self.KeyRt)
	self.UnregisterForKey(self.KeyHp)

	self.KeyOk = 0
	self.KeyFk = 0
	self.KeyUp = 0
	self.KeyDn = 0
	self.KeyLf = 0
	self.KeyRt = 0
	self.KeyHP = 0

	;;;;;;;;

	If(Full)
		Untamed.Player.SetDontMove(FALSE)
		Untamed.Player.SetRestrained(FALSE)
		Game.EnablePlayerControls()
	EndIf

	Return
EndFunction

Function DestroyMainItems()

	Int Iter = self.MainItems.Length

	While(Iter > 0)
		Iter -= 1
		self.iWant.Destroy(self.MainItems[Iter])
	EndWhile

	self.MainItems = Utility.CreateIntArray(0)

	Return
EndFunction

Function DestroySideItems(Bool Reload=FALSE)

	If(self.Busy)
		Return
	EndIf

	self.Busy = TRUE

	Int Iter = self.SideItems.Length
	Int Cap = 0

	If(Reload)
		Cap = 2
	EndIf

	While(Iter > Cap)
		Iter -= 1
		self.iWant.Destroy(self.SideItems[Iter])
	EndWhile

	If(!Reload)
		self.SideItems = Utility.CreateIntArray(0)
	EndIf

	self.Busy = FALSE

	Return
EndFunction

Function DestroyAllItems()

	self.DestroySideItems()
	self.DestroyMainItems()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function LoadMainMenu()

	Int CX = ScreenX / 2
	Int CY = ScreenY / 2
	Int QX = CX / 2
	Int QY = CY / 2
	Int RY = (((ScreenY - 100) / 5) )
	Int Iter = 0

	self.MainItems = Utility.CreateIntArray(9)
	Untamed.Util.PrintDebug("[Perks:OnRenderWidget] Loading UI")

	;;;;;;;;

	;; show the default after the highlighted version loads so that the menu
	;; feels like its progressing given how long it takes for flash to do
	;; its shit.

	self.MainItems[0] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/Background.dds")
	self.iWant.SetPos(self.MainItems[0], CX, CY)
	self.iWant.SetVisible(self.MainItems[0], 1)

	self.MainItems[1] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/Tenacity-Off.dds")
	self.iWant.SetPos(self.MainItems[1], (QX - 20), (RY * 1) + 50)

	self.MainItems[2] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/Tenacity-On.dds")
	self.iWant.SetPos(self.MainItems[2], (QX - 20), (RY * 1) + 50)
	self.iWant.SetVisible(self.MainItems[1], 1)

	self.MainItems[3] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/Ferocity-Off.dds")
	self.iWant.SetPos(self.MainItems[3], (QX + 13), (RY * 2) + 50)

	self.MainItems[4] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/Ferocity-On.dds")
	self.iWant.SetPos(self.MainItems[4], (QX + 13), (RY * 2) + 50)
	self.iWant.SetVisible(self.MainItems[3], 1)

	self.MainItems[5] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/BeastMastery-Off.dds")
	self.iWant.SetPos(self.MainItems[5], (QX - 2), (RY * 3) + 50)

	self.MainItems[6] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/BeastMastery-On.dds")
	self.iWant.SetPos(self.MainItems[6], (QX - 2), (RY * 3) + 50)
	self.iWant.SetVisible(self.MainItems[5],1)

	self.MainItems[7] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/Essence-Off.dds")
	self.iWant.SetPos(self.MainItems[7], (QX - 10), (RY * 4) + 50)

	self.MainItems[8] = self.iWant.LoadWidget("widgets/dse-untamed-2/MenuMain/Essence-On.dds")
	self.iWant.SetPos(self.MainItems[8], (QX - 10), (RY * 4) + 50)
	self.iWant.SetVisible(self.MainItems[7], 1)

	;;;;;;;;

	self.UpdateMainMenu()
	Return
EndFunction

Function LoadSideMenu(String Menu, Bool Reload=FALSE)

	If(self.Busy)
		Return
	EndIf

	self.Busy = TRUE

	If(Menu == Untamed.KeyTenacity)
		self.LoadSideMenu_Tenacity(Reload)
	ElseIf(Menu == Untamed.KeyFerocity)
		self.LoadSideMenu_Ferocity(Reload)
	ElseIf(Menu == Untamed.KeyBeastMastery)
		self.LoadSideMenu_BeastMastery(Reload)
	ElseIf(Menu == Untamed.KeyEssence)
		self.LoadSideMenu_Essence(Reload)
	EndIf

	self.Busy = FALSE

	Return
EndFunction

Function LoadSideMenu_Tenacity(Bool Reload=FALSE)

	String Dir = "widgets/dse-untamed-2/MenuTenacity/"
	String[] Files = self.GetTenacityFilenames()

	;;;;;;;;

	If(!Reload)
		Untamed.Util.PrintDebug("[LoadSideMenu:Tenacity] loading side menu")
		self.SideItems = Utility.CreateIntArray(Files.Length)
	Else
		Untamed.Util.PrintDebug("[LoadSideMenu:Tenacity] updating side menu")
	EndIf

	;;;;;;;;

	If(!Reload)
		;; title
		self.SideItems[0] = self.iWant.LoadWidget(Dir + Files[0])
		self.iWant.SetPos(self.SideItems[0], 950, 100)
		self.iWant.SetVisible(self.SideItems[0], 1)

		;; circle
		self.SideItems[1] = self.iWant.LoadWidget(Dir + Files[1])
		self.iWant.SetPos(self.SideItems[1], 950, 100)
		self.iWant.SetVisible(self.SideItems[1], 0)
	EndIf

	;; vitality
	self.SideItems[2] = self.iWant.LoadWidget(Dir + Files[2])
	self.iWant.SetPos(self.SideItems[2], 875, 300)
	self.iWant.SetVisible(self.SideItems[2], 1)

	;; thick hide
	self.SideItems[3] = self.iWant.LoadWidget(Dir + Files[3])
	self.iWant.SetPos(self.SideItems[3], 1100, 450)
	self.iWant.SetVisible(self.SideItems[3], 1)

	;; resist hide
	self.SideItems[4] = self.iWant.LoadWidget(Dir + Files[4])
	self.iWant.SetPos(self.SideItems[4], 900, 600)
	self.iWant.SetVisible(self.SideItems[4], 1)

	;;;;;;;;

	self.UpdateSideMenu_Tenacity()
	Return
EndFunction

Function LoadSideMenu_Ferocity(Bool Reload=FALSE)

	String Dir = "widgets/dse-untamed-2/MenuFerocity/"
	String[] Files = self.GetFerocityFilenames()

	;;;;;;;;

	If(!Reload)
		Untamed.Util.PrintDebug("[LoadSideMenu:Ferocity] loading side menu")
		self.SideItems = Utility.CreateIntArray(Files.Length)
	Else
		Untamed.Util.PrintDebug("[LoadSideMenu:Ferocity] updating side menu")
	EndIf

	;;;;;;;;

	If(!Reload)
		;; title
		self.SideItems[0] = self.iWant.LoadWidget(Dir + Files[0])
		self.iWant.SetPos(self.SideItems[0], 950, 100)
		self.iWant.SetVisible(self.SideItems[0], 1)

		;; circle
		self.SideItems[1] = self.iWant.LoadWidget(Dir + Files[1])
		self.iWant.SetPos(self.SideItems[1], 950, 100)
		self.iWant.SetVisible(self.SideItems[1], 0)
	EndIf

	;; attack
	self.SideItems[2] = self.iWant.LoadWidget(Dir + Files[2])
	self.iWant.SetPos(self.SideItems[2], 875, 300)
	self.iWant.SetVisible(self.SideItems[2], 1)

	;; stamina
	self.SideItems[3] = self.iWant.LoadWidget(Dir + Files[3])
	self.iWant.SetPos(self.SideItems[3], 1100, 450)
	self.iWant.SetVisible(self.SideItems[3], 1)

	;; bleed
	self.SideItems[4] = self.iWant.LoadWidget(Dir + Files[4])
	self.iWant.SetPos(self.SideItems[4], 900, 600)
	self.iWant.SetVisible(self.SideItems[4], 1)

	;;;;;;;;

	self.UpdateSideMenu_Ferocity()
	Return
EndFunction

Function LoadSideMenu_BeastMastery(Bool Reload=FALSE)

	Return
EndFunction

Function LoadSideMenu_Essence(Bool Reload=FALSE)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function UpdateMainMenu()

	self.iWant.SetVisible(self.MainItems[1], 1)
	self.iWant.SetVisible(self.MainItems[3], 1)
	self.iWant.SetVisible(self.MainItems[5], 1)
	self.iWant.SetVisible(self.MainItems[7], 1)

	self.iWant.SetVisible(self.MainItems[2], 0)
	self.iWant.SetVisible(self.MainItems[4], 0)
	self.iWant.SetVisible(self.MainItems[6], 0)
	self.iWant.SetVisible(self.MainItems[8], 0)

	If(self.MainCur == 1)
		self.iWant.SetVisible(self.MainItems[1], 0)
		self.iWant.SetVisible(self.MainItems[2], 1)
	ElseIf(self.MainCur == 2)
		self.iWant.SetVisible(self.MainItems[3], 0)
		self.iWant.SetVisible(self.MainItems[4], 1)
	ElseIf(self.MainCur == 3)
		self.iWant.SetVisible(self.MainItems[5], 0)
		self.iWant.SetVisible(self.MainItems[6], 1)
	ElseIf(self.MainCur == 4)
		self.iWant.SetVisible(self.MainItems[7], 0)
		self.iWant.SetVisible(self.MainItems[8], 1)
	EndIf

	Return
EndFunction

Function UpdateSideMenu()

	If(self.StateCur == Untamed.KeyTenacity)
		self.UpdateSideMenu_Tenacity()
	ElseIf(self.StateCur == Untamed.KeyFerocity)
		self.UpdateSideMenu_Ferocity()
	ElseIf(self.StateCur == Untamed.KeyBeastMastery)
		self.UpdateSideMenu_BeastMastery()
	ElseIf(self.StateCur == Untamed.KeyEssence)
		self.UpdateSideMenu_Essence()
	EndIf



	Return
EndFunction

Function UpdateSideMenu_Tenacity()

	;; icons
	self.iWant.SetVisible(self.SideItems[2], 1)
	self.iWant.SetVisible(self.SideItems[3], 1)
	self.iWant.SetVisible(self.SideItems[4], 1)

	;; cursor
	If(self.SideCur > 0)
		self.iWant.SetVisible(self.SideItems[1], 0)

		If(self.SideCur == 1)
			self.iWant.SetPos(self.SideItems[1], 875, 300)
			self.iWant.setRotation(self.SideItems[1], 0)
		ElseIf(self.SideCur == 2)
			self.iWant.SetPos(self.SideItems[1], 1100, 450)
			self.iWant.setRotation(self.SideItems[1], 45)
		ElseIf(self.SideCur == 3)
			self.iWant.SetPos(self.SideItems[1], 900, 600)
			self.iWant.setRotation(self.SideItems[1], -45)
		EndIf

		self.iWant.SetVisible(self.SideItems[1], 1)
	Else
		self.iWant.SetVisible(self.SideItems[1], 0)
	EndIf

	Return
EndFunction

Function UpdateSideMenu_Ferocity()

	;; icons
	self.iWant.SetVisible(self.SideItems[2], 1)
	self.iWant.SetVisible(self.SideItems[3], 1)
	self.iWant.SetVisible(self.SideItems[4], 1)

	;; cursor
	If(self.SideCur > 0)
		self.iWant.SetVisible(self.SideItems[1], 0)

		If(self.SideCur == 1)
			self.iWant.SetPos(self.SideItems[1], 875, 300)
			self.iWant.setRotation(self.SideItems[1], 0)
		ElseIf(self.SideCur == 2)
			self.iWant.SetPos(self.SideItems[1], 1100, 450)
			self.iWant.setRotation(self.SideItems[1], 45)
		ElseIf(self.SideCur == 3)
			self.iWant.SetPos(self.SideItems[1], 900, 600)
			self.iWant.setRotation(self.SideItems[1], -45)
		EndIf

		self.iWant.SetVisible(self.SideItems[1], 1)
	Else
		self.iWant.SetVisible(self.SideItems[1], 0)
	EndIf


	Return
EndFunction

Function UpdateSideMenu_BeastMastery()

	Return
EndFunction

Function UpdateSideMenu_Essence()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function HandleSideMenuKeys(Int KeyCode)

	If(self.Busy)
		Return FALSE
	EndIf

	;; return false if the function callng this should bail or true if the
	;; menu should keep going afterwards.

	If(self.IsMenuKey(KeyCode))
		self.GoToState("Off")
		Return FALSE
	EndIf

	If(self.IsBackKey(KeyCode))
		self.GoToState("On")
		Return FALSE
	EndIf

	;;;;;;;;

	If(self.IsDownKey(KeyCode))
		self.SideCur = PapyrusUtil.ClampInt((self.SideCur + 1), 1, (self.SideItems.Length - 2))
	ElseIf(self.IsUpKey(KeyCode))
		self.SideCur = PapyrusUtil.ClampInt((self.SideCur - 1), 1, (self.SideItems.Length - 2))
	ElseIf(self.IsActivateKey(KeyCode))
		If(!self.HandleBuyPerk() && !self.HandleGiveSpell() && !self.HandleGiveShout())
			Untamed.Util.Print("Nothing seemed to be selected.")
			Return FALSE
		EndIf

		self.DestroySideItems(TRUE)
		self.LoadSideMenu(self.StateCur, TRUE)
	ElseIf(self.IsHelpKey(KeyCode))
		self.HandleHelpText()
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Function HandleHelpText()

	If(self.MainCur == 1)
		If(self.SideCur == 1)
			Untamed.Util.Popup("Increases health of pack animals.")
		ElseIf(self.SideCur == 2)
			Untamed.Util.Popup("Increases natural armour of pack animals.")
		ElseIf(self.SideCur == 3)
			Untamed.Util.Popup("Increases magic resistance of pack animals.")
		EndIf
	ElseIf(self.MainCur == 2)
		If(self.SideCur == 1)
			Untamed.Util.Popup("Increases damage done by pack animals.")
		ElseIf(self.SideCur == 2)
			Untamed.Util.Popup("Increases stamina of pack animals.")
		ElseIf(self.SideCur == 3)
			Untamed.Util.Popup("Pack animals inflict bleed damage.")
		EndIf
	EndIf

	Return
EndFunction

Bool Function HandleBuyPerk()

	Perk Choice = NONE
	Int Cost = Untamed.Config.GetInt(".PerkCostXP")
	Int UXP = Untamed.Util.GetExperience(Untamed.Player) as Int

	If(UXP < Cost)
		Untamed.Util.Print("You need " + Cost + " UXP to buy a perk.")
		Return FALSE
	EndIf

	If(self.MainCur == 1)
		Choice = self.GetTenacityNextPerk(self.SideCur)
	ElseIf(self.MainCur == 2)
		Choice = self.GetFerocityNextPerk(self.SideCur)
	EndIf

	If(Choice == NONE)
		Return FALSE
	EndIf

	Untamed.Util.Print("Perk Added: " + Choice.GetName())
	Untamed.Player.AddPerk(Choice)
	;;Untamed.Util.SetExperience(Untamed.Player, (UXP - Cost))
	;;Untamed.XPBar.RegisterForSingleUpdate(0.1)

	Return TRUE
EndFunction

Bool Function HandleGiveSpell()

	Return FALSE
EndFunction

Bool Function HandleGiveShout()

	Return FALSE
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

String[] Function GetTenacityFilenames()

	String[] Output = Utility.CreateStringArray(5)

	Output[0] = "Title.dds"
	Output[1] = "Cursor.dds"

	If(Untamed.Player.HasPerk(Untamed.PerkPackVitality3))
		Output[2] = "Vitality3.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackVitality2))
		Output[2] = "Vitality2.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackVitality1))
		Output[2] = "Vitality1.dds"
	Else
		Output[2] = "Vitality0.dds"
	EndIf

	If(Untamed.Player.HasPerk(Untamed.PerkPackThickHide3))
		Output[3] = "ThickHide3.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackThickHide2))
		Output[3] = "ThickHide2.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackThickHide1))
		Output[3] = "ThickHide1.dds"
	Else
		Output[3] = "ThickHide0.dds"
	EndIf

	If(Untamed.Player.HasPerk(Untamed.PerkPackResistantHide3))
		Output[4] = "ResistHide3.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackResistantHide2))
		Output[4] = "ResistHide2.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackResistantHide1))
		Output[4] = "ResistHide1.dds"
	Else
		Output[4] = "ResistHide0.dds"
	EndIf

	Return Output
EndFunction

String[] Function GetFerocityFilenames()

	String[] Output = Utility.CreateStringArray(5)

	Output[0] = "Title.dds"
	Output[1] = "Cursor.dds"

	If(Untamed.Player.HasPerk(Untamed.PerkPackFerocious3))
		Output[2] = "Attack3.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackFerocious2))
		Output[2] = "Attack2.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackFerocious1))
		Output[2] = "Attack1.dds"
	Else
		Output[2] = "Attack0.dds"
	EndIf

	If(Untamed.Player.HasPerk(Untamed.PerkPackEndurance3))
		Output[3] = "Stamina3.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackEndurance2))
		Output[3] = "Stamina2.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackEndurance1))
		Output[3] = "Stamina1.dds"
	Else
		Output[3] = "Stamina0.dds"
	EndIf

	If(Untamed.Player.HasPerk(Untamed.PerkPackBleed3))
		Output[4] = "Bleed3.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackBleed2))
		Output[4] = "Bleed2.dds"
	ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackBleed1))
		Output[4] = "Bleed1.dds"
	Else
		Output[4] = "Bleed0.dds"
	EndIf

	Return Output
EndFunction

Perk Function GetTenacityNextPerk(Int Choice)

	Perk Output = NONE

	If(Choice == 1)
		If(Untamed.Player.HasPerk(Untamed.PerkPackVitality3))
			Output = NONE
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackVitality2))
			Output = Untamed.PerkPackVitality3
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackVitality1))
			Output = Untamed.PerkPackVitality2
		Else
			Output = Untamed.PerkPackVitality1
		EndIf
	ElseIf(Choice == 2)
		If(Untamed.Player.HasPerk(Untamed.PerkPackThickHide3))
			Output = NONE
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackThickHide2))
			Output = Untamed.PerkPackThickHide3
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackThickHide1))
			Output = Untamed.PerkPackThickHide2
		Else
			Output = Untamed.PerkPackThickHide1
		EndIf
	ElseIf(Choice == 3)
		If(Untamed.Player.HasPerk(Untamed.PerkPackResistantHide3))
			Output = NONE
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackResistantHide2))
			Output = Untamed.PerkPackResistantHide3
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackResistantHide1))
			Output = Untamed.PerkPackResistantHide2
		Else
			Output = Untamed.PerkPackResistantHide1
		EndIf
	EndIf

	Return Output
EndFunction

Perk Function GetFerocityNextPerk(Int Choice)

	Perk Output = NONE

	If(Choice == 1)
		If(Untamed.Player.HasPerk(Untamed.PerkPackFerocious3))
			Output = NONE
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackFerocious2))
			Output = Untamed.PerkPackFerocious3
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackFerocious1))
			Output = Untamed.PerkPackFerocious2
		Else
			Output = Untamed.PerkPackFerocious1
		EndIf
	ElseIf(Choice == 2)
		If(Untamed.Player.HasPerk(Untamed.PerkPackEndurance3))
			Output = NONE
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackEndurance2))
			Output = Untamed.PerkPackEndurance3
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackEndurance1))
			Output = Untamed.PerkPackEndurance2
		Else
			Output = Untamed.PerkPackEndurance1
		EndIf
	ElseIf(Choice == 3)
		If(Untamed.Player.HasPerk(Untamed.PerkPackBleed3))
			Output = NONE
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackBleed2))
			Output = Untamed.PerkPackBleed3
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackBleed1))
			Output = Untamed.PerkPackBleed2
		Else
			Output = Untamed.PerkPackBleed1
		EndIf
	EndIf

	Return Output
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function IsUpKey(Int KeyCode)

	Return (KeyCode == self.KeyUp)
EndFunction

Bool Function IsDownKey(Int KeyCode)

	Return (KeyCode == self.KeyDn)
EndFunction

Bool Function IsLeftKey(Int KeyCode)

	Return (KeyCode == self.KeyLf)
EndFunction

Bool Function IsRightKey(Int KeyCode)

	Return (KeyCode == self.KeyRt)
EndFunction

Bool Function IsActivateKey(Int KeyCode)

	Return (KeyCode == self.KeyOk)
EndFunction

Bool Function IsCancelKey(Int KeyCode)

	Return (KeyCode == self.KeyMn || KeyCode == self.KeyFk)
EndFunction

Bool Function IsBackKey(Int KeyCode)

	Return (KeyCode == self.KeyFk)
EndFunction

Bool Function IsMenuKey(Int KeyCode)

	Return (KeyCode == self.KeyMn)
EndFunction

Bool Function IsHelpKey(Int KeyCode)

	Return (KeyCode == self.KeyHp)
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Auto State Default
	Event OnBeginState()
		self.StateCur = "Default"
		Return
	EndEvent
EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State Off

	Event OnBeginState()
		Untamed.Util.PrintDebug("[Perks:OnBeginState:Off] UI OFF")
		self.MainCur = 0
		self.SideCur = 0
		self.DestroyAllItems()
		self.DisableKeyboardInput()
		self.StateCur = "Off"

		self.iWant.SetSkyrimVisible("compass", 1)
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)

		Untamed.Util.PrintDebug("[Perks.OnKeyDown:Off] " + KeyCode)

		If(KeyCode == self.KeyMn)
			self.GotoState("On")
			Return
		EndIf

		Return
	EndEvent

EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State On

	Event OnBeginState()
		Untamed.Util.PrintDebug("[Perks:OnBeginState:On] UI ON")

		If(self.StateCur == "Off")
			self.MainCur = 0
			self.EnableKeyboardInput()
			self.LoadMainMenu()
		Else
			self.DestroySideItems()
			self.UpdateMainMenu()
		EndIf

		self.SideCur = 0
		self.StateCur = "On"

		self.iWant.SetSkyrimVisible("compass", 0)
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)

		Untamed.Util.PrintDebug("[Perks.OnKeyDown:On] " + KeyCode)

		If(self.IsCancelKey(KeyCode))
			self.GoToState("Off")
			Return
		EndIf

		;;;;;;;;

		If(self.IsDownKey(KeyCode))
			If(self.MainCur == 0)
				self.MainCur = 1
			Else
				self.MainCur = PapyrusUtil.ClampInt((self.MainCur + 1), 1, 4)
			EndIf
		ElseIf(self.IsUpKey(KeyCode))
			If(self.MainCur == 0)
				self.MainCur = 4
			Else
				self.MainCur = PapyrusUtil.ClampInt((self.MainCur - 1), 1, 4)
			EndIf
		ElseIf(self.IsActivateKey(KeyCode))
			If(self.MainCur == 1)
				self.GotoState(Untamed.KeyTenacity)
			ElseIf(self.MainCur == 2)
				self.GotoState(Untamed.KeyFerocity)
			Elseif(self.MainCur == 3)
				self.GotoState(Untamed.KeyBeastMastery)
			ElseIf(self.MainCur == 4)
				self.GotoState(Untamed.KeyEssence)
			EndIf
		EndIf

		self.UpdateMainMenu()
		Return
	EndEvent

EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State Tenacity

	Event OnBeginState()
		self.SideCur = 0
		self.DestroySideItems()
		self.LoadSideMenu(Untamed.KeyTenacity)

		self.StateCur = Untamed.KeyTenacity
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)
		If(!self.HandleSideMenuKeys(KeyCode))
			Return
		EndIf

		self.UpdateSideMenu()
		Return
	EndEvent

EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State Ferocity

	Event OnBeginState()
		self.SideCur = 0
		self.DestroySideItems()
		self.LoadSideMenu(Untamed.KeyFerocity)

		self.StateCur = Untamed.KeyFerocity
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)
		If(!self.HandleSideMenuKeys(KeyCode))
			Return
		EndIf

		self.UpdateSideMenu()
		Return
	EndEvent

EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State BeastMastery

	Event OnBeginState()
		self.SideCur = 0
		self.DestroySideItems()
		self.LoadSideMenu(Untamed.KeyBeastMastery)

		self.StateCur = Untamed.KeyBeastMastery
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)
		If(!self.HandleSideMenuKeys(KeyCode))
			Return
		EndIf

		self.UpdateSideMenu()
		Return
	EndEvent

EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State Essence

	Event OnBeginState()
		self.SideCur = 0
		self.DestroySideItems()
		self.LoadSideMenu(Untamed.KeyEssence)

		self.StateCur = Untamed.KeyEssence
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)
		If(!self.HandleSideMenuKeys(KeyCode))
			Return
		EndIf

		self.UpdateSideMenu()
		Return
	EndEvent

EndState
