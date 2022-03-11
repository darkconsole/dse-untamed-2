Scriptname dse_ut2_QuestInterfacePerks extends dse_ut2_QuestWidgetBase

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int Property MainMenuCur = 0 Auto Hidden

Int Property KeyUp = 0 Auto Hidden
Int Property KeyDn = 0 Auto Hidden
Int Property KeyLf = 0 Auto Hidden
Int Property KeyRt = 0 Auto Hidden
Int Property KeyOk = 0 Auto Hidden
Int Property KeyFk = 0 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Int ScreenX = 1280
Int ScreenY = 720

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function OnUpdateWidget(Bool Flush=FALSE)

	If(self.Busy)
		Untamed.Util.PrintDebug("[Perks:OnUpdateWidget] Widget Busy")
		Return
	EndIf

	self.Busy = TRUE

	Untamed.Util.PrintDebug("[Perks:OnUpdateWidget] Update")

	If(Flush)
		self.MainMenuCur = 0
		self.UnregisterForKeyboardInput()
		self.DestroyAll()
	EndIf

	self.RegisterForKey(0x40) ;; f6
	self.OnRenderWidget()
	self.Busy = FALSE

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function RegisterForKeyboardInput()

	;; this method of locking the controls is used as locking movement
	;; with DisablePlayerControls also turns off the hud. which is where our
	;; ui lives.

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

Function UnregisterForKeyboardInput()

	self.UnregisterForKey(0x40)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function DestroyAll()

	Int Iter = self.Items.Length

	While(Iter > 0)
		Iter -= 1
		self.iWant.Destroy(self.Items[Iter])
	EndWhile

	self.Items = Utility.CreateIntArray(0)

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event zOnKeyDown(int KeyCode)

	Untamed.Util.PrintDebug("[Perks.OnKeyDown:Empty] " + KeyCode)

	If(KeyCode == 0x40)
		self.GotoState("On")
		Return
	EndIf

	Return
EndEvent

Auto State Off

	Event OnBeginState()
		Untamed.Util.PrintDebug("[Perks:OnBeginState:Off] UI OFF")
		self.OnUpdateWidget(TRUE)
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)

		Untamed.Util.PrintDebug("[Perks.OnKeyDown:Off] " + KeyCode)

		If(KeyCode == 0x40)

			self.GotoState("On")
			Return
		EndIf

		Return
	EndEvent

	Event OnKeyUp(int KeyCode, float Dur)
		Untamed.Util.PrintDebug("[Perks.OnKeyUp:Off] " + KeyCode)
		Return
	EndEvent

	Function OnRenderWidget()

		Return
	EndFunction

EndState

State On

	Event OnBeginState()
		Untamed.Util.PrintDebug("[Perks:OnBeginState:On] UI ON")
		self.OnUpdateWidget(TRUE)
		Return
	EndEvent

	Event OnKeyDown(int KeyCode)

		Untamed.Util.PrintDebug("[Perks.OnKeyDown:On] " + KeyCode)

		If(KeyCode == 0x40)
			self.GoToState("Off")
			Return
		EndIf

		If(KeyCode == self.KeyFk)
			self.GoToState("Off")
			Return
		EndIf

		;;;;;;;;

		If(KeyCode == self.KeyDn)
			If(self.MainMenuCur == 0)
				self.MainMenuCur = 1
			Else
				self.MainMenuCur = PapyrusUtil.ClampInt((self.MainMenuCur + 1), 1, 4)
			EndIf
		ElseIf(KeyCode == self.KeyUp)
			If(self.MainMenuCur == 0)
				self.MainMenuCur = 4
			Else
				self.MainMenuCur = PapyrusUtil.ClampInt((self.MainMenuCur - 1), 1, 4)
			EndIf
		EndIf

		self.iWant.SetVisible(self.Items[1], 1)
		self.iWant.SetVisible(self.Items[3], 1)
		self.iWant.SetVisible(self.Items[5], 1)
		self.iWant.SetVisible(self.Items[7], 1)

		self.iWant.SetVisible(self.Items[2], 0)
		self.iWant.SetVisible(self.Items[4], 0)
		self.iWant.SetVisible(self.Items[6], 0)
		self.iWant.SetVisible(self.Items[8], 0)

		If(self.MainMenuCur == 1)
			self.iWant.SetVisible(self.Items[1], 0)
			self.iWant.SetVisible(self.Items[2], 1)
		ElseIf(self.MainMenuCur == 2)
			self.iWant.SetVisible(self.Items[3], 0)
			self.iWant.SetVisible(self.Items[4], 1)
		ElseIf(self.MainMenuCur == 3)
			self.iWant.SetVisible(self.Items[5], 0)
			self.iWant.SetVisible(self.Items[6], 1)
		ElseIf(self.MainMenuCur == 4)
			self.iWant.SetVisible(self.Items[7], 0)
			self.iWant.SetVisible(self.Items[8], 1)
		EndIf

		Return
	EndEvent

	Event OnKeyUp(int KeyCode, float Dur)

		Untamed.Util.PrintDebug("[Perks.OnKeyUp:On] " + KeyCode)

		Return
	EndEvent

	Function OnRenderWidget()

		Int CX = ScreenX / 2
		Int CY = ScreenY / 2
		Int QX = CX / 2
		Int QY = CY / 2
		Int RY = (((ScreenY - 100) / 5) )
		Int Iter = 0

		If(self.Items.Length > 0)
			Return
		EndIf

		;;;;;;;;

		self.Items = Utility.CreateIntArray(9)
		Untamed.Util.PrintDebug("[Perks:OnRenderWidget] Loading UI")

		;;;;;;;;

		self.Items[0] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Background.dds")
		self.iWant.SetPos(self.Items[0], CX, CY)

		self.Items[1] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Tenacity-Off.dds")
		self.iWant.SetPos(self.Items[1], (QX - 20), (RY * 1) + 50)

		self.Items[2] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Tenacity-On.dds")
		self.iWant.SetPos(self.Items[2], (QX - 20), (RY * 1) + 50)

		self.Items[3] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Ferocity-Off.dds")
		self.iWant.SetPos(self.Items[3], (QX + 13), (RY * 2) + 50)

		self.Items[4] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Ferocity-On.dds")
		self.iWant.SetPos(self.Items[4], (QX + 13), (RY * 2) + 50)

		self.Items[5] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/BeastMastery-Off.dds")
		self.iWant.SetPos(self.Items[5], (QX - 2), (RY * 3) + 50)

		self.Items[6] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/BeastMastery-On.dds")
		self.iWant.SetPos(self.Items[6], (QX - 2), (RY * 3) + 50)

		self.Items[7] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Essence-Off.dds")
		self.iWant.SetPos(self.Items[7], (QX - 10), (RY * 4) + 50)

		self.Items[8] = self.iWant.LoadWidget("widgets/dse-untamed-2/MainMenu/Essence-On.dds")
		self.iWant.SetPos(self.Items[8], (QX - 10), (RY * 4) + 50)

		self.iWant.SetVisible(self.Items[0], 1)
		self.iWant.SetVisible(self.Items[1], 1)
		self.iWant.SetVisible(self.Items[3], 1)
		self.iWant.SetVisible(self.Items[5], 1)
		self.iWant.SetVisible(self.Items[7], 1)

		self.RegisterForKeyboardInput()

		Return
	EndFunction

EndState


