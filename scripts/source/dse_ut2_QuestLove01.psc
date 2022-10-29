ScriptName dse_ut2_QuestLove01 extends Quest

dse_ut2_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actor Property Dom Auto Hidden
Actor Property Sub Auto Hidden

Int Property DomType Auto Hidden
Int Property SubType Auto Hidden

String[] Property DomStep Auto Hidden
String[] Property SubStep Auto Hidden

Int Property SeqLen = 4 Auto Hidden
Int Property Stage = 0 Auto Hidden
Int Property Iter = 0 Auto Hidden

Int Property KeyPrev = 0 Auto Hidden
Int Property KeyNext = 0 Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Begin()
{calling this function after setting the dom and sub properties
will kick off the animation system for this action.}

	If(self.Dom == NONE)
		Untamed.Util.Print("QuestLove01 missing Dom property.")
		Return
	EndIf

	If(self.Sub == NONE)
		Untamed.Util.Print("QuestLove01 missing Sub property.")
		Return
	EndIf

	;;;;;;;;

	self.DomType = Untamed.Util.GetAnimalType(self.Dom)
	self.DomStep = self.GetAnimationSet(self.DomType)

	self.SubType = Untamed.Util.GetAnimalType(self.Sub)
	self.SubStep = self.GetAnimationSet(self.SubType)

	self.AnimateStart()
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

String[] Function GetAnimationSet(Int ActorType)
{return the list of keys for the animation.}

	String[] Output = Utility.CreateStringArray(self.SeqLen)

	If(ActorType == 0)
		Output[0] = "ut2-wolflove01-s1-human"
		Output[1] = "ut2-wolflove01-s2-human"
		Output[2] = "ut2-wolflove01-s3-human"
		Output[3] = "ut2-wolflove01-s4-human"
	ElseIf(ActorType == Untamed.KeyRaceWolf)
		Output[0] = "ut2-wolflove01-s1-wolf"
		Output[1] = "ut2-wolflove01-s2-wolf"
		Output[2] = "ut2-wolflove01-s3-wolf"
		Output[3] = "ut2-wolflove01-s4-wolf"
	EndIf

	Return Output
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function AnimateStart()
{trigger starting an animated sequence.}

	;; register for animation events on the humanoid actor.

	self.RegisterForAnimationEvent(self.Dom, "UT2.LoopIter")
	self.RegisterForAnimationEvent(self.Dom, "UT2.Stage")
	self.RegisterForAnimationEvent(self.Dom, "UT2.End")
	self.RegisterForSceneControls()

	;; kick off the animationing.

	self.Stage = 0
	self.Iter = 0

	Untamed.Anim.StopDualAnimation(self.Dom, self.Sub)
	Untamed.Anim.PlayDualAnimation(self.Dom, self.DomStep[0], self.Sub, self.SubStep[0])

	Return
EndFunction

Function AnimateEnd()
{trigger releasing an animated sequence.}

	Float[] Where = Untamed.Util.GetPositionAtDistance(self.Dom,125)

	;; stop watching the animation events.

	self.UnregisterForAnimationEvent(self.Dom,"UT2.LoopIter")
	self.UnregisterForAnimationEvent(self.Dom,"UT2.Stage")
	self.UnregisterForAnimationEvent(self.Dom,"UT2.End")
	self.UnregisterForSceneControls()

	;; put the player in front of and facing the animal.

	;;self.Dom.TranslateTo(Where[1],Where[2],Where[3],self.Dom.GetAngleX(),self.Dom.GetAngleY(),(self.Dom.GetAngleZ()+180.0),10000,0)
	;;self.Dom.SetAngle(0.0,0.0,(self.Dom.GetAngleZ() + 180.0))

	;; shut down the animation system.

	Untamed.Anim.StopDualAnimation(self.Dom, self.Sub)

	Return
EndFunction

Event OnAnimationEvent(ObjectReference What, String EvName)
{watch for animation events we use to progress the system.}

	If(EvName == "UT2.Stage")
		self.OnAnimationStage()
		Return
	EndIf

	If(EvName == "UT2.LoopIter")
		self.OnAnimationIter()
		Return
	EndIf

	If(EvName == "UT2.End")
		self.AnimateEnd()
		Return
	EndIf

	Return
EndEvent

Function OnAnimationStage()
{watch for animation stage advancements.}

	If(self.Stage == 0)
		self.Stage += 1
		self.Iter = 0
	EndIf

	Untamed.Util.PrintDebug("AnimateStage " + self.Stage)
	Return
EndFunction

Function OnAnimationIter()
{watch for animation iter advancements.}

	Float MXP
	FLoat PXP

	self.Iter += 1
	Untamed.Util.PrintDebug("AnimateIter " + self.Iter)

	If(self.Stage > 0)
		;; player gets full xp from love.
		;; member gets partial xp.

		PXP = Untamed.Config.GetFloat(".PackLoveIterXP")
		MXP = PXP * Untamed.Config.GetFloat(".PackShareXPM")

		Untamed.Experience(self.Dom, PXP)
		Untamed.Experience(self.Sub, MXP)

		;;Untamed.XPBar.OnUpdateWidget()
	EndIf

	;; @todo 2022-03-09
	;; if fast stage, chance they blow early and end it. also causes debuff
	;; to prevent doing it again for a while.

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function RegisterForSceneControls()
{regsiter for input control.}

	self.KeyPrev = Input.GetMappedKey("Strafe Left")
	self.KeyNext = Input.GetMappedKey("Strafe Right")

	self.RegisterForKey(self.KeyPrev)
	self.RegisterForKey(self.KeyNext)

	Return
EndFunction

Function UnregisterForSceneControls()
{release input control.}

	self.UnregisterForKey(self.KeyPrev)
	self.UnregisterForKey(self.KeyNext)

	Return
EndFunction

Event OnKeyDown(Int KeyCode)
{when control pressed.}

	Return
EndEvent

Event OnKeyUp(int KeyCode, Float Dur)
{when control released.}

	Untamed.Util.PrintDebug("[QuestLove01.OnKeyUp] " + KeyCode)

	If(KeyCode == self.KeyPrev)
		If(self.Stage > 1)
			self.Stage -= 1
			self.Iter = 0
			Untamed.Anim.PlayDualAnimation(self.Dom, self.DomStep[self.Stage], self.Sub, self.SubStep[self.Stage])
		EndIf
	ElseIf(KeyCode == self.KeyNext)
		If(self.Stage < (self.SeqLen - 1))
			self.Stage += 1
			self.Iter = 0
			Untamed.Anim.PlayDualAnimation(self.Dom, self.DomStep[self.Stage], self.Sub, self.SubStep[self.Stage])
		EndIf
	EndIf

	Return
EndEvent

