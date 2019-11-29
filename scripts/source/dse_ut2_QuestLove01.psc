ScriptName dse_ut2_QuestLove01 extends Quest

dse_ut2_QuestController Property Untamed Auto
Actor Property Dom Auto Hidden
Actor Property Sub Auto Hidden
Int Property Iter Auto Hidden

Event OnInit()

	Return
EndEvent

Event OnAnimationEvent(ObjectReference What, String EvName)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Begin()

	If(self.Dom == None || self.Sub == None)
		Untamed.Util.Print("QuestLove01 halted due to missing input.")
		Return
	EndIf

	Untamed.Util.Print(self.Dom.GetDisplayName() + " is loving " + self.Sub.GetDisplayName())
	self.Iter = 1
	self.AnimateStart()
	self.UnregisterForUpdate() ;; remove after my save is clean

	Return
EndFunction

Function AnimateStart()

	self.RegisterForAnimationEvent(self.Dom,"UT2.LoopIter")
	self.RegisterForAnimationEvent(self.Dom,"UT2.End")
	Untamed.Anim.PlayDualAnimation(self.Sub,"ut2-wolflove01-s1-wolf",self.Dom,"ut2-wolflove01-s1-human")

	Return
EndFunction

Function AnimateEnd()

	self.UnregisterForAnimationEvent(self.Dom,"UT2.LoopIter")
	self.UnregisterForAnimationEvent(self.Dom,"UT2.End")

	Untamed.Anim.StopDualAnimation(self.Sub,self.Dom)

	self.Dom = None
	self.Sub = None

	Return
EndFunction

Function HandleIter()

	If(self.Iter > 10)
		;;Untamed.Anim.PlayDualAnimation(self.Sub,"ut2-wolflove01-s3-wolf",self.Dom,"ut2-wolflove01-s3-human")
		;;Utility.Wait(2)
		self.AnimateEnd()
	EndIf

	Untamed.Experience(Untamed.Player,Untamed.Config.OptFondleXP)
	Untamed.Util.Print("QuestLove01 " + self.Iter + " XP +" + Untamed.Config.OptFondleXP)
	self.Iter += 1

	Return
EndFunction
