Scriptname dse_ut2_QuestInterfacePerks extends Quest

dse_ut2_QuestController Property Untamed Auto
iWant_Widgets Property iWant Auto Hidden

Int[] Property MainItems Auto Hidden
Int[] Property SideItems Auto Hidden
Int[] Property SideX Auto Hidden
Int[] Property SideY Auto Hidden

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

Function RegisterGameKeys()
	self.RegisterForKey(self.KeyMn)
	Return
EndFunction

Function UnregisterGameKeys()
	self.UnregisterForKey(self.KeyMn)
	Return
EndFunction

Function OnGameReady()

	self.iWant = Game.GetFormFromFile(0x800, "iWant Widgets.esl") as iWant_Widgets
	self.KeyMn = Untamed.Config.GetInt(".MenuKey")

	self.UnregisterGameKeys()
	self.RegisterGameKeys()

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

	If(self.Busy)
		Return
	EndIf

	self.Busy = TRUE
	self.BuildMainMenu()
	self.UpdateMainMenu()
	self.Busy = FALSE

	Return
EndFunction

Function BuildMainMenu()

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

	Return
EndFunction

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function LoadSideMenu(String Menu, Bool Reload=FALSE)
{handle initial loading of the side menu.}

	If(self.Busy)
		Return
	EndIf

	self.Busy = TRUE
	self.BuildSideMenu(Reload)
	self.Busy = FALSE

	Return
EndFunction

Function BuildSideMenu(Bool Reload=FALSE)
{prototype: handle physical construction of the side menu.}

	Return
EndFunction

Function UpdateSideMenu()
{prototype: decide what needs to be shown and moving the cursor around.}

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function PlotSideMenuGrid(String Dir, String[] Files)

	Int ItemCount = Files.Length - 2

	;; 0 is the title graphic.
	;; 1 is the cursor graphic.
	;; 2+ are the menu items.

	;; 1 4 7
	;; 2 5 8
	;; 3 6 9

	Int Width = 168  ;; size of perk icon
	Int Height = 168 ;; size of perk icon
	Int MarkX = 920  ;; position of first perk icon.
	Int MarkY = 300  ;; position of first perk icon.
	Int Col = -1     ;; current column iter.
	Int Iter = 2     ;; current item iter.
	Int PosX = MarkX ;; current perk icon position.
	Int PosY = MarkY ;; current perk icon position.

	If(ItemCount > 6)
		Width = 200
		MarkX = 700
	ElseIf(ItemCount > 3)
		Width = 300
		MarkX = 800
	EndIf

	;;;;;;;;

	While(Iter < Files.Length)
		If(((Iter - 2) % 3) == 0)
			Col += 1
			PosX = MarkX + (Col * Width)
			PosY = MarkY
		EndIf

		Untamed.Util.PrintDebug("[PlotSideMenuGrid] " + Iter + ": " + PosX + " " + PosY)
		self.SideItems[Iter] = self.iWant.LoadWidget(Dir + Files[Iter])
		self.SideX[Iter] = PosX
		self.SideY[Iter] = PosY
		self.iWant.SetPos(self.SideItems[Iter], PosX, PosY)
		self.iWant.SetVisible(self.SideItems[Iter], 1)

		PosY += Height
		Iter += 1
	EndWhile

	Return
EndFunction

String[] Function GetFilenames()
{prototype: return a list of image filenames for the ui to plot around the screen.}

	Return Utility.CreateStringArray(0)
EndFunction

Perk Function GetNextPerk(Int Choice)
{prototype: return the next perk in series for the current selection.}

	Return NONE
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function IsTwoCol()

	;; plus two for title image and x image.

	Return (self.SideItems.Length >= 6) && (self.SideItems.Length <= 8)
EndFunction

Int Function GetColCount()

	;; first two are title and cursor.

	If((self.SideItems.Length - 2) > 6)
		Return 3
	EndIf

	If((self.SideItems.Length - 2) > 3)
		Return 2
	EndIf

	Return 1
EndFunction

Bool Function HandleSideMenuKeys(Int KeyCode)

	Int ColCount

	;;;;;;;;

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

	ColCount = self.GetColCount()

	;;;;;;;;

	If(self.IsDownKey(KeyCode))
		self.SideCur = PapyrusUtil.ClampInt((self.SideCur + 1), 1, (self.SideItems.Length - 2))
	ElseIf(self.IsUpKey(KeyCode))
		self.SideCur = PapyrusUtil.ClampInt((self.SideCur - 1), 1, (self.SideItems.Length - 2))
	ElseIf(self.IsRightKey(KeyCode))
		If(self.SideCur == 0)
			self.SideCur = 1
		EndIf

		If(ColCount > 1)
			self.SideCur = PapyrusUtil.ClampInt((self.SideCur + 3), 1, (self.SideItems.Length - 2))
		Else
			self.SideCur = PapyrusUtil.ClampInt((self.SideCur + 1), 1, (self.SideItems.Length - 2))
		EndIf
	ElseIf(self.IsLeftKey(KeyCode))
		If(self.SideCur == 0)
			self.SideCur = 1
		EndIf

		If(ColCount > 1)
			self.SideCur = PapyrusUtil.ClampInt((self.SideCur - 3), 1, (self.SideItems.Length - 2))
		Else
			self.SideCur = PapyrusUtil.ClampInt((self.SideCur - 1), 1, (self.SideItems.Length - 2))
		EndIf
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
			Untamed.Util.Popup("Increases health of pack members.")
		ElseIf(self.SideCur == 2)
			Untamed.Util.Popup("Increases natural armour of pack members.")
		ElseIf(self.SideCur == 3)
			Untamed.Util.Popup("Increases magic resistance of pack members.")
		ElseIf(self.SideCur == 4)
			Untamed.Util.Popup("Command pack members to follow from range.")
		ElseIf(self.SideCur == 5)
			Untamed.Util.Popup("Command pack members to stay put from range.")
		EndIf
	ElseIf(self.MainCur == 2)
		If(self.SideCur == 1)
			Untamed.Util.Popup("Increases damage done by pack members.")
		ElseIf(self.SideCur == 2)
			Untamed.Util.Popup("Increases stamina of pack members.")
		ElseIf(self.SideCur == 3)
			Untamed.Util.Popup("Pack members inflict bleed damage.")
		ElseIf(self.SideCur == 4)
			Untamed.Util.Popup("Command pack members to attack the specified target.")
		EndIf
	ElseIf(self.MainCur == 3)
		If(self.SideCur == 1)
			Untamed.Util.Popup("Increaes maximum pack size.\n(3, 6, 12)")
		ElseIf(self.SideCur == 2)
			Untamed.Util.Popup("Consume UXP to get healed when downed.")
		ElseIf(self.SideCur == 3)
			Untamed.Util.Popup("Pack members will carry things for you.")
		ElseIf(self.SideCur == 4)
			Untamed.Util.Popup("Visual IFF during combat.")
		ElseIf(self.SideCur == 5)
			Untamed.Util.Popup("Able to become pregnant and birth new animals.")
		EndIf
	ElseIf(self.MainCur == 4)
		If(self.SideCur == 1)
			Untamed.Util.Popup("LVL1: Increase maximum UXP.\nLVL2: Pack UXP overflow goes to you.")
		ElseIf(self.SideCur == 2)
			Untamed.Util.Popup("Damage resist based on current UXP while nude.")
		ElseIf(self.SideCur == 3)
			Untamed.Util.Popup("Magicka resist based on current UXP while nude.")
		ElseIf(self.SideCur == 4)
			Untamed.Util.Popup("Pack members heal over time.")
		ElseIf(self.SideCur == 5)
			Untamed.Util.Popup("Lay with humanoids without the UXP penalty.")
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

	Choice = self.GetNextPerk(self.SideCur)

	If(Choice == NONE)
		Return FALSE
	EndIf

	Untamed.Util.Print("Perk Added: " + Choice.GetName())
	Untamed.Player.AddPerk(Choice)

	If(Choice == Untamed.PerkThickHide)
		Untamed.Util.UpdateFeatThickHide(Untamed.Player)
	ElseIf(Choice == Untamed.PerkResistantHide)
		Untamed.Util.UpdateFeatResistantHide(Untamed.Player)
	ElseIf(Choice == Untamed.PerkPackHealing1)
		Untamed.Pack.FixMembers()
	EndIf

	Untamed.Util.ModExperience(Untamed.Player, (Cost * -1))

	Return TRUE
EndFunction

Bool Function HandleGiveSpell()

	Return FALSE
EndFunction

Bool Function HandleGiveShout()

	Shout Choice = NONE
	Int Cost = Untamed.Config.GetInt(".PerkCostXP")
	Int UXP = Untamed.Util.GetExperience(Untamed.Player) as Int

	If(UXP < Cost)
		Untamed.Util.Print("You need " + Cost + " UXP to buy a perk.")
		Return FALSE
	EndIf

	;; tenacity
	If(self.MainCur == 1)
		If(self.SideCur == 4)
			Choice = Untamed.ShoutFollow
		ElseIf(self.SideCur == 5)
			Choice = Untamed.ShoutStay
		EndIf

	;; ferocity
	ElseIf(self.MainCur == 2)
		If(self.SideCur == 4)
			Choice = Untamed.ShoutAttack
		EndIf
	EndIf

	If(Choice == NONE)
		Return FALSE
	EndIf

	Untamed.Util.Print("Shout Added: " + Choice.GetName())
	Untamed.Util.AddShout(Untamed.Player, Choice)
	Untamed.Util.ModExperience(Untamed.Player, (Cost * -1))

	Return TRUE
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

		If(!Untamed.OptEnabled)
			Return
		EndIf

		If(self.Busy || Untamed.XPBar.Busy)
			Untamed.Util.Print("One of UT2's menus are busy please wait a moment.")
			Return
		EndIf

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

		If(self.Busy)
			Return
		EndIf

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

	Function BuildSideMenu(Bool Reload=FALSE)

		String Dir = "widgets/dse-untamed-2/MenuTenacity/"
		String[] Files = self.GetFilenames()

		;;;;;;;;

		If(!Reload)
			;; allocate.
			self.SideItems = Utility.CreateIntArray(Files.Length)
			self.SideX = Utility.CreateIntArray(Files.Length)
			self.SideY = Utility.CreateIntArray(Files.Length)

			;; title.
			self.SideItems[0] = self.iWant.LoadWidget(Dir + Files[0])
			self.iWant.SetPos(self.SideItems[0], 950, 100)
			self.iWant.SetVisible(self.SideItems[0], 1)

			;; cursor.
			self.SideItems[1] = self.iWant.LoadWidget(Dir + Files[1])
			self.iWant.SetPos(self.SideItems[1], 950, 100)
			self.iWant.SetVisible(self.SideItems[1], 0)
		EndIf

		self.PlotSideMenuGrid(Dir, Files)
		self.UpdateSideMenu()

		Return
	EndFunction

	Function UpdateSideMenu()

		;; icons
		self.iWant.SetVisible(self.SideItems[2], 1)
		self.iWant.SetVisible(self.SideItems[3], 1)
		self.iWant.SetVisible(self.SideItems[4], 1)
		self.iWant.SetVisible(self.SideItems[5], 1)
		self.iWant.SetVisible(self.SideItems[6], 1)

		;; cursor
		If(self.SideCur > 0)
			self.iWant.SetVisible(self.SideItems[1], 0)
			self.iWant.SetPos( self.SideItems[1], self.SideX[( self.SideCur + 1 )], self.SideY[( self.SideCur + 1 )] )
			self.iWant.SetRotation(self.SideItems[1], 0)
			self.iWant.SetVisible(self.SideItems[1], 1)
		Else
			self.iWant.SetVisible(self.SideItems[1], 0)
		EndIf

		Return
	EndFunction

	String[] Function GetFilenames()

		String[] Output = Utility.CreateStringArray(7)

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

		If(Untamed.Player.HasSpell(Untamed.ShoutFollow))
			Output[5] = "Follow1.dds"
		Else
			Output[5] = "Follow0.dds"
		EndIf

		If(Untamed.Player.HasSpell(Untamed.ShoutStay))
			Output[6] = "Stay1.dds"
		Else
			Output[6] = "Stay0.dds"
		EndIf

		Return Output
	EndFunction

	Perk Function GetNextPerk(Int Choice)

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

	Function BuildSideMenu(Bool Reload=FALSE)

		String Dir = "widgets/dse-untamed-2/MenuFerocity/"
		String[] Files = self.GetFilenames()

		;;;;;;;;

		If(!Reload)
			Untamed.Util.PrintDebug("[LoadSideMenu:Ferocity] loading side menu")
			self.SideItems = Utility.CreateIntArray(Files.Length)
			self.SideX = Utility.CreateIntArray(Files.Length)
			self.SideY = Utility.CreateIntArray(Files.Length)
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

		self.PlotSideMenuGrid(Dir, Files)
		self.UpdateSideMenu()

		Return
	EndFunction

	Function UpdateSideMenu()

		;; icons
		self.iWant.SetVisible(self.SideItems[2], 1)
		self.iWant.SetVisible(self.SideItems[3], 1)
		self.iWant.SetVisible(self.SideItems[4], 1)
		self.iWant.SetVisible(self.SideItems[5], 1)

		;; cursor
		If(self.SideCur > 0)
			self.iWant.SetVisible(self.SideItems[1], 0)
			self.iWant.SetPos( self.SideItems[1], self.SideX[( self.SideCur + 1 )], self.SideY[( self.SideCur + 1 )] )
			self.iWant.SetRotation(self.SideItems[1], 0)
			self.iWant.SetVisible(self.SideItems[1], 1)
		Else
			self.iWant.SetVisible(self.SideItems[1], 0)
		EndIf

		Return
	EndFunction

	String[] Function GetFilenames()

		String[] Output = Utility.CreateStringArray(6)

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

		If(Untamed.Player.HasSpell(Untamed.ShoutAttack))
			Output[5] = "ShoutAttack1.dds"
		Else
			Output[5] = "ShoutAttack0.dds"
		EndIf

		Return Output
	EndFunction

	Perk Function GetNextPerk(Int Choice)

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

	Function BuildSideMenu(Bool Reload=FALSE)

		String Dir = "widgets/dse-untamed-2/MenuBeastMastery/"
		String[] Files = self.GetFilenames()

		;;;;;;;;

		If(!Reload)
			Untamed.Util.PrintDebug("[LoadSideMenu:BeastMastery] loading side menu")
			self.SideItems = Utility.CreateIntArray(Files.Length)
			self.SideX = Utility.CreateIntArray(Files.Length)
			self.SideY = Utility.CreateIntArray(Files.Length)
		EndIf

		;;;;;;;;

		If(!Reload)
			;; title
			self.SideItems[0] = self.iWant.LoadWidget(Dir + Files[0])
			self.iWant.SetPos(self.SideItems[0], 950, 120)
			self.iWant.SetVisible(self.SideItems[0], 1)

			;; circle
			self.SideItems[1] = self.iWant.LoadWidget(Dir + Files[1])
			self.iWant.SetPos(self.SideItems[1], 950, 100)
			self.iWant.SetVisible(self.SideItems[1], 0)
		EndIf

		self.PlotSideMenuGrid(Dir, Files)
		self.UpdateSideMenu()

		Return
	EndFunction

	Function UpdateSideMenu()

		;; icons
		self.iWant.SetVisible(self.SideItems[2], 1)
		self.iWant.SetVisible(self.SideItems[3], 1)
		self.iWant.SetVisible(self.SideItems[4], 1)
		self.iWant.SetVisible(self.SideItems[5], 1)
		self.iWant.SetVisible(self.SideItems[6], 1)
		self.iWant.SetVisible(self.SideItems[7], 1)

		;; cursor
		If(self.SideCur > 0)
			self.iWant.SetVisible(self.SideItems[1], 0)
			self.iWant.SetPos( self.SideItems[1], self.SideX[( self.SideCur + 1 )], self.SideY[( self.SideCur + 1 )] )
			self.iWant.SetRotation(self.SideItems[1], 0)
			self.iWant.SetVisible(self.SideItems[1], 1)
		Else
			self.iWant.SetVisible(self.SideItems[1], 0)
		EndIf

		Return
	EndFunction

	String[] Function GetFilenames()

		String[] Output = Utility.CreateStringArray(8)

		Output[0] = "Title.dds"
		Output[1] = "Cursor.dds"

		If(Untamed.Player.HasPerk(Untamed.PerkPackLeader3))
			Output[2] = "Leader3.dds"
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackLeader2))
			Output[2] = "Leader2.dds"
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackLeader1))
			Output[2] = "Leader1.dds"
		Else
			Output[2] = "Leader0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkSecondWind2))
			Output[3] = "SecondWind2.dds"
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkSecondWind1))
			Output[3] = "SecondWind1.dds"
		Else
			Output[3] = "SecondWind0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkLoadBearing2))
			Output[4] = "LoadBearing2.dds"
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkLoadBearing1))
			Output[4] = "LoadBearing1.dds"
		Else
			Output[4] = "LoadBearing0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkSituationAware))
			Output[5] = "KeenSenses1.dds"
		Else
			Output[5] = "KeenSenses0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkDenMother))
			Output[6] = "DenMother1.dds"
		Else
			Output[6] = "DenMother0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkRideShare))
			Output[7] = "RideShare1.dds"
		Else
			Output[7] = "RideShare0.dds"
		EndIf

		Return Output
	EndFunction

	Perk Function GetNextPerk(Int Choice)

		Perk Output = NONE

		If(Choice == 1)
			If(Untamed.Player.HasPerk(Untamed.PerkPackLeader3))
				Output = NONE
			ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackLeader2))
				Output = Untamed.PerkPackLeader3
			ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackLeader1))
				Output = Untamed.PerkPackLeader2
			Else
				Output = Untamed.PerkPackLeader1
			EndIf
		ElseIf(Choice == 2)
			If(Untamed.Player.HasPerk(Untamed.PerkSecondWind2))
				Output = NONE
			ElseIf(Untamed.Player.HasPerk(Untamed.PerkSecondWind1))
				Output = Untamed.PerkSecondWind2
			Else
				Output = Untamed.PerkSecondWind1
			EndIf
		ElseIf(Choice == 3)
			If(Untamed.Player.HasPerk(Untamed.PerkLoadBearing2))
				Output = NONE
			ElseIf(Untamed.Player.HasPerk(Untamed.PerkLoadBearing1))
				Output = Untamed.PerkLoadBearing2
			Else
				Output = Untamed.PerkLoadBearing1
			EndIf
		ElseIf(Choice == 4)
			If(Untamed.Player.HasPerk(Untamed.PerkSituationAware))
				Output = NONE
			Else
				Output = Untamed.PerkSituationAware
			EndIf
		ElseIf(Choice == 5)
			If(Untamed.Player.HasPerk(Untamed.PerkDenMother))
				Output = NONE
			Else
				Output = Untamed.PerkDenMother
			EndIf
		ElseIf(Choice == 6)
			If(Untamed.Player.HasPerk(Untamed.PerkRideShare))
				Output = NONE
			Else
				Output = Untamed.PerkRideShare
			EndIf
		EndIf

		Return Output
	EndFunction

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

	Function BuildSideMenu(Bool Reload=FALSE)

		String Dir = "widgets/dse-untamed-2/MenuEssence/"
		String[] Files = self.GetFilenames()

		;;;;;;;;

		If(!Reload)
			Untamed.Util.PrintDebug("[LoadSideMenu:Essence] loading side menu")
			self.SideItems = Utility.CreateIntArray(Files.Length)
			self.SideX = Utility.CreateIntArray(Files.Length)
			self.SideY = Utility.CreateIntArray(Files.Length)
		EndIf

		;;;;;;;;

		If(!Reload)
			;; title
			self.SideItems[0] = self.iWant.LoadWidget(Dir + Files[0])
			self.iWant.SetPos(self.SideItems[0], 950, 120)
			self.iWant.SetVisible(self.SideItems[0], 1)

			;; circle
			self.SideItems[1] = self.iWant.LoadWidget(Dir + Files[1])
			self.iWant.SetPos(self.SideItems[1], 950, 100)
			self.iWant.SetVisible(self.SideItems[1], 0)
		EndIf

		self.PlotSideMenuGrid(Dir, Files)
		self.UpdateSideMenu()

		Return
	EndFunction

	Function UpdateSideMenu()

		;; icons
		self.iWant.SetVisible(self.SideItems[2], 1)
		self.iWant.SetVisible(self.SideItems[3], 1)
		self.iWant.SetVisible(self.SideItems[4], 1)
		self.iWant.SetVisible(self.SideItems[5], 1)
		self.iWant.SetVisible(self.SideItems[6], 1)

		;; cursor
		If(self.SideCur > 0)
			self.iWant.SetVisible(self.SideItems[1], 0)
			self.iWant.SetPos( self.SideItems[1], self.SideX[( self.SideCur + 1 )], self.SideY[( self.SideCur + 1 )] )
			self.iWant.SetRotation(self.SideItems[1], 0)
			self.iWant.SetVisible(self.SideItems[1], 1)
		Else
			self.iWant.SetVisible(self.SideItems[1], 0)
		EndIf

		Return
	EndFunction

	String[] Function GetFilenames()

		String[] Output = Utility.CreateStringArray(7)

		Output[0] = "Title.dds"
		Output[1] = "Cursor.dds"

		If(Untamed.Player.HasPerk(Untamed.PerkExperienced2))
			Output[2] = "Exp2.dds"
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkExperienced1))
			Output[2] = "Exp1.dds"
		Else
			Output[2] = "Exp0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkThickHide))
			Output[3] = "ThickHide1.dds"
		Else
			Output[3] = "ThickHide0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkResistantHide))
			Output[4] = "ResistHide1.dds"
		Else
			Output[4] = "ResistHide0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkPackHealing3))
			Output[5] = "Grace3.dds"
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackHealing2))
			Output[5] = "Grace2.dds"
		ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackHealing1))
			Output[5] = "Grace1.dds"
		Else
			Output[5] = "Grace0.dds"
		EndIf

		If(Untamed.Player.HasPerk(Untamed.PerkCrossbreeder))
			Output[6] = "Crossbreeder1.dds"
		Else
			Output[6] = "Crossbreeder0.dds"
		EndIf

		Return Output
	EndFunction

	Perk Function GetNextPerk(Int Choice)

		Perk Output = NONE

		If(Choice == 1)
			If(Untamed.Player.HasPerk(Untamed.PerkExperienced2))
				Output = NONE
			ElseIf(Untamed.Player.HasPerk(Untamed.PerkExperienced1))
				Output = Untamed.PerkExperienced2
			Else
				Output = Untamed.PerkExperienced1
			EndIf
		ElseIf(Choice == 2)
			If(Untamed.Player.HasPerk(Untamed.PerkThickHide))
				Output = NONE
			Else
				Output = Untamed.PerkThickHide
			EndIf
		ElseIf(Choice == 3)
			If(Untamed.Player.HasPerk(Untamed.PerkResistantHide))
				Output = NONE
			Else
				Output = Untamed.PerkResistantHide
			EndIf
		ElseIf(Choice == 4)
			If(Untamed.Player.HasPerk(Untamed.PerkPackHealing3))
				Output = NONE
			ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackHealing2))
				Output = Untamed.PerkPackHealing3
			ElseIf(Untamed.Player.HasPerk(Untamed.PerkPackHealing1))
				Output = Untamed.PerkPackHealing2
			Else
				Output = Untamed.PerkPackHealing1
			EndIf
		ElseIf(Choice == 5)
			If(Untamed.Player.HasPerk(Untamed.PerkCrossbreeder))
				Output = NONE
			Else
				Output = Untamed.PerkCrossbreeder
			EndIf
		EndIf

		Return Output
	EndFunction

EndState
