ScriptName dse_ut2_QuestLove01 extends Quest

dse_ut2_QuestController Property Untamed Auto
Actor Property Dom Auto Hidden
Actor Property Sub Auto Hidden
Int Property Iter Auto Hidden

String Property DomAnim1 Auto Hidden
String Property DomAnim2 Auto Hidden
String Property DomAnim3 Auto Hidden
String Property DomOff   Auto Hidden
String Property SubAnim1 Auto Hidden
String Property SubAnim2 Auto Hidden
String Property SubAnim3 Auto Hidden
String Property SubOff   Auto Hidden

Event OnAnimationEvent(ObjectReference What, String EvName)
{watch for animation events we use to progress the system.}

	If(EvName == "UT2.Stage")
		Return
	EndIf

	If(EvName == "UT2.LoopIter")
		self.HandleIter()
		Return
	EndIf

	If(EvName == "UT2.End")
		self.AnimateEnd()
		Return
	EndIf

	Return
EndEvent

Event OnUpdate()
{kick off the animation system on a delay.}

	self.AnimateStart()
	Return
EndEvent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Begin()
{calling this function after setting the dom and sub properties
will kick off the animation system for this action.}

	Int AnimalType

	;;;;;;;;

	If(self.Dom == None || self.Sub == None)
		Untamed.Util.Print("QuestLove01 halted due to missing input.")
		Return
	EndIf

	;;;;;;;;

	AnimalType = Untamed.Util.GetAnimalType(self.Sub)

	If(AnimalType == Untamed.KeyRaceWolf)
		self.DomOff   = "ut2-wolfoffset01-s1-human"
		self.DomAnim1 = "ut2-wolflove01-s1-human"
		self.DomAnim2 = "ut2-wolflove01-s3-human"
		self.DomAnim3 = "ut2-wolflove01-s4-human"
		self.SubOff   = "ut2-wolfoffset01-s1-wolf"
		self.SubAnim1 = "ut2-wolflove01-s1-wolf"
		self.SubAnim2 = "ut2-wolflove01-s3-wolf"
		self.SubAnim3 = "ut2-wolflove01-s4-wolf"
	Else
		Untamed.Util.PrintDebug("QuestLove01 unable to determine animal type.")
		Return
	EndIf

	;;;;;;;;

	self.Iter = 0
	self.RegisterForSingleUpdate(1.5)

	Untamed.Util.Print(self.Dom.GetDisplayName() + " is loving " + self.Sub.GetDisplayName())
	Return
EndFunction

Function AnimateStart()

	;; register for animation events on the humanoid actor.

	self.RegisterForAnimationEvent(self.Dom,"UT2.LoopIter")
	self.RegisterForAnimationEvent(self.Dom,"UT2.Stage")
	self.RegisterForAnimationEvent(self.Dom,"UT2.End")

	;; kick off the animationing.

	;;Untamed.Anim.StopDualAnimation(self.Sub,self.Dom)
	Untamed.Anim.PlayDualAnimation(self.Dom,self.DomAnim1,self.Sub,self.SubAnim1,self.DomOff,self.SubOff)

	Return
EndFunction

Function AnimateEnd()

	Float[] Where = Untamed.Util.GetPositionAtDistance(self.Dom,125)

	;; stop watching the animation events.

	self.UnregisterForAnimationEvent(self.Dom,"UT2.LoopIter")
	self.UnregisterForAnimationEvent(self.Dom,"UT2.Stage")
	self.UnregisterForAnimationEvent(self.Dom,"UT2.End")

	;; put the player in front of and facing the animal.

	;;self.Dom.TranslateTo(Where[1],Where[2],Where[3],self.Dom.GetAngleX(),self.Dom.GetAngleY(),(self.Dom.GetAngleZ()+180.0),10000,0)
	;;self.Dom.SetAngle(0.0,0.0,(self.Dom.GetAngleZ() + 180.0))

	;; shut down the animation system.

	Untamed.Anim.StopDualAnimation(self.Dom,self.Sub)

	;; clean up the data.

	self.Dom = None
	self.DomAnim1 = ""
	self.DomAnim2 = ""
	self.DomAnim3 = ""
	self.Sub = None
	self.SubAnim1 = ""
	self.SubAnim2 = ""
	self.SubAnim3 = ""

	Return
EndFunction

Function HandleIter()

	Float XP = Untamed.Config.GetFloat(".PackLoveIterXP")

	If(self.Iter == 7)
		;; after a few iteration of the slow animation kick off the fast animation.
		Untamed.Anim.PlayDualAnimation(self.Sub,self.SubAnim2,self.Dom,self.DomAnim2)
	ElseIf(self.Iter == 17)
		;; after a few iteration of the fast animation kick off the finisher animation.
		self.UnregisterForAnimationEvent(self.Dom,"UT2.LoopIter")
		self.UnregisterForAnimationEvent(self.Dom,"UT2.Stage")
		Untamed.Anim.PlayDualAnimation(self.Sub,self.SubAnim3,self.Dom,self.DomAnim3)
	EndIf

	;; award the player untamed xp for the iteration.

	Untamed.Experience(Untamed.Player,XP)

	self.Iter += 1
	Return
EndFunction
