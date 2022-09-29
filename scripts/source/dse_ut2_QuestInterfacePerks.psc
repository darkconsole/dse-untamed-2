Scriptname dse_ut2_QuestInterfacePerks extends Quest ;;extends dse_ut2_QuestWidgetBase

dse_ut2_QuestController Property Untamed Auto
iWant_Widgets Property iWant Auto Hidden

Int[] Property MainItems Auto Hidden
Int[] Property SideItems Auto Hidden

Int Property MainCur = 0 Auto Hidden
Int Property SideCur = 0 Auto Hidden

Int Property KeyMn = 0x40 Auto Hidden
Int Property KeyUp = 0 Auto Hidden
Int Property KeyDn = 0 Auto Hidden
Int Property KeyLf = 0 Auto Hidden
Int Property KeyRt = 0 Auto Hidden
Int Property KeyOk = 0 Auto Hidden
Int Property KeyFk = 0 Auto Hidden

Int ScreenX = 1280
Int ScreenY = 720

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnGameReady()

	self.UnregisterForModEvent("iWantWidgetsReset")
	self.iWant = Game.GetFormFromFile(0x800, "iWant Widgets.esl") as iWant_Widgets

	self.UnregisterForKey(self.KeyMn)
	self.RegisterForKey(self.KeyMn)

	self.GotoState("Empty")
	self.GotoState("Off")

	Untamed.Util.PrintDebug("[Perks:OnGameReady] Done")
	Return
EndFunction

Event OnKeyDown(int KeyCode)

	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function EnableKeyboardInput()

	Untamed.Player.SetDontMove(TRUE)
	Untamed.Player.SetRestrained(TRUE)
	Game.DisablePlayerControls(FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)

	;;;;;;;;

	self.KeyOk = Input.GetMappedKey("Activate")
	self.KeyFk = Input.GetMappedKey("Tween Menu")
	self.KeyUp = Input.GetMappedKey("Forward")
	self.KeyDn = Input.GetMappedKey("Back")
	self.KeyLf = Input.GetMappedKey("Strafe Left")
	self.KeyRt = Input.GetMappedKey("Strafe Right")

	self.RegisterForKey(self.KeyOk)
	self.RegisterForKey(self.KeyFk)
	self.RegisterForKey(self.KeyUp)
	self.RegisterForKey(self.KeyDn)
	self.RegisterForKey(self.KeyLf)
	self.RegisterForKey(self.KeyRt)

	Return
EndFunction

Function DisableKeyboardInput()

	self.UnregisterForKey(self.KeyOk)
	self.UnregisterForKey(self.KeyFk)
	self.UnregisterForKey(self.KeyUp)
	self.UnregisterForKey(self.KeyDn)
	self.UnregisterForKey(self.KeyLf)
	self.UnregisterForKey(self.KeyRt)

	self.KeyOk = 0
	self.KeyFk = 0
	self.KeyUp = 0
	self.KeyDn = 0
	self.KeyLf = 0
	self.KeyRt = 0

	;;;;;;;;

	Untamed.Player.SetDontMove(FALSE)
	Untamed.Player.SetRestrained(FALSE)
	Game.EnablePlayerControls()

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

Function DestroySideItems()

	Int Iter = self.SideItems.Length

	While(Iter > 0)
		Iter -= 1
		self.iWant.Destroy(self.SideItems[Iter])
	EndWhile

	self.SideItems = Utility.CreateIntArray(0)

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

	self.MainItems[0] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Background.dds")
	self.iWant.SetPos(self.MainItems[0], CX, CY)
	self.iWant.SetVisible(self.MainItems[0], 1)

	self.MainItems[1] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Tenacity-Off.dds")
	self.iWant.SetPos(self.MainItems[1], (QX - 20), (RY * 1) + 50)

	self.MainItems[2] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Tenacity-On.dds")
	self.iWant.SetPos(self.MainItems[2], (QX - 20), (RY * 1) + 50)

	self.MainItems[3] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Ferocity-Off.dds")
	self.iWant.SetPos(self.MainItems[3], (QX + 13), (RY * 2) + 50)

	self.MainItems[4] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Ferocity-On.dds")
	self.iWant.SetPos(self.MainItems[4], (QX + 13), (RY * 2) + 50)

	self.MainItems[5] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/BeastMastery-Off.dds")
	self.iWant.SetPos(self.MainItems[5], (QX - 2), (RY * 3) + 50)

	self.MainItems[6] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/BeastMastery-On.dds")
	self.iWant.SetPos(self.MainItems[6], (QX - 2), (RY * 3) + 50)

	self.MainItems[7] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Essence-Off.dds")
	self.iWant.SetPos(self.MainItems[7], (QX - 10), (RY * 4) + 50)

	self.MainItems[8] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Essence-On.dds")
	self.iWant.SetPos(self.MainItems[8], (QX - 10), (RY * 4) + 50)

	self.UpdateMainMenu()

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

Function UpdateSideMenu()

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Auto State Empty

EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State Off

	Event OnBeginState()
		Untamed.Util.PrintDebug("[Perks:OnBeginState:Off] UI OFF")
		self.DestroyAllItems()
		self.DisableKeyboardInput()
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

	Event OnKeyUp(int KeyCode, float Dur)

		Untamed.Util.PrintDebug("[Perks.OnKeyUp:Off] " + KeyCode)

		Return
	EndEvent

EndState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

State On

	Event OnBeginState()
		Untamed.Util.PrintDebug("[Perks:OnBeginState:On] UI ON")

		self.MainCur = 0
		self.SideCur = 0

		self.LoadMainMenu()
		self.EnableKeyboardInput()

		Return
	EndEvent

	Event OnKeyDown(int KeyCode)

		Untamed.Util.PrintDebug("[Perks.OnKeyDown:On] " + KeyCode)

		If(KeyCode == self.KeyMn || KeyCode == self.KeyFk)
			self.GoToState("Off")
			Return
		EndIf

		;;;;;;;;

		If(KeyCode == self.KeyDn)
			If(self.MainCur == 0)
				self.MainCur = 1
			Else
				self.MainCur = PapyrusUtil.ClampInt((self.MainCur + 1), 1, 4)
			EndIf
		ElseIf(KeyCode == self.KeyUp)
			If(self.MainCur == 0)
				self.MainCur = 4
			Else
				self.MainCur = PapyrusUtil.ClampInt((self.MainCur - 1), 1, 4)
			EndIf
		ElseIf(KeyCode == self.KeyOk)
			;;
		EndIf

		self.UpdateMainMenu()
		Return
	EndEvent

	Event OnKeyUp(int KeyCode, float Dur)

		Untamed.Util.PrintDebug("[Perks.OnKeyUp:On] " + KeyCode)

		Return
	EndEvent

EndState


