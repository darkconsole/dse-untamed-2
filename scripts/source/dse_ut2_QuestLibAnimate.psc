ScriptName dse_ut2_QuestLibAnimate extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Property Untamed Auto
SexlabFramework Property SexLab Auto

String Property NiKeyCancelNIOHH = "UT2.SizeCancelNIOHH" Auto Hidden
String Property NiKeySizeEqual = "UT2.SizeEqualise" Auto Hidden
String Property NiKeyEquips = "internal" Auto Hidden
String Property NiBoneRoot = "NPC" Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Public Animation API
;; These methods are usable for executing complete features.

Function PlaySexlab(Actor Who, Actor With)
{have an adult conversation with someone or something.}

	Actor[] Actors = new Actor[2]
	Actors[0] = Who
	Actors[1] = With

	Untamed.Util.SheatheWeapons(Who,FALSE)
	Untamed.Util.SheatheWeapons(With,TRUE)

	sslBaseAnimation[] Anims
	SexLab.StartSex(Actors,Anims)

	Return
EndFunction

Function DualSlowmoRoto(Actor Who1, Actor Who2, String Off1="", String Off2="")

	ObjectReference Here

	;;;;;;;;

	Here = Who1.PlaceAtMe(Untamed.StaticX)
	Who1.SetVehicle(Here)
	Who2.SetVehicle(Here)
	StorageUtil.SetFormValue(Who1,"UT2.Ani.Vehicle",Here)
	StorageUtil.SetFormValue(Who2,"UT2.Ani.Vehicle",Here)

	;; about face...
	Who2.SetAngle(Who1.GetAngleX(),Who1.GetAngleY(),Who1.GetAngleZ())

	;; commit hillarious collision hack: the slomoroto

	If(Off1 != "")
	;;	Debug.SendAnimationEvent(Who1,Off1)
	;;	Debug.SendAnimationEvent(Who2,Off2)
	EndIf

	Who1.TranslateTo(              \
		Here.GetPositionX(),       \
		Here.GetPositionY(),       \
		Here.GetPositionZ(),       \
		Here.GetAngleX(),          \
		Here.GetAngleY(),          \
		(Here.GetAngleZ() + 0.01), \
		10000,0.000001             \
	)

	Who2.TranslateTo(              \
		Here.GetPositionX(),       \
		Here.GetPositionY(),       \
		Here.GetPositionZ(),       \
		Here.GetAngleX(),          \
		Here.GetAngleY(),          \
		(Here.GetAngleZ() + 0.01), \
		10000,0.000001             \
	)

	Return
EndFunction

Function PlayDualAnimation(Actor Who1, String Ani1, Actor Who2, String Ani2, String Off1="", String Off2="")
{rig up and play stacked dual animations. sex without the lab.}

	;; if the actors are not mounted to a marker then they should not be in an
	;; animation yet, so go ahead and do an initization.

	If(StorageUtil.GetFormValue(Who1,"UT2.Ani.Vehicle") == None)
		Untamed.Util.SheatheWeapons(Who1,FALSE)
		Untamed.Util.SheatheWeapons(Who2,TRUE)
		self.LockActor(Who1)
		self.LockActor(Who2)
		self.ForceActorSize(Who1)
		self.ForceActorSize(Who2)

		self.DualSlowmoRoto(Who1,Who2,Off1,Off2)
		Utility.Wait(1.5)
	EndIf

	;; trigger the animation.

	Debug.SendAnimationEvent(Who1,Ani1)
	Debug.SendAnimationEvent(Who2,Ani2)

	Return
EndFunction

Function StopDualAnimation(Actor Who1, Actor Who2)
{stop animation for two actors.}

	ObjectReference Here

	self.StopAnimation(Who1)
	self.StopAnimation(Who2)

	;; dismount from vehicle.

	Here = StorageUtil.GetFormValue(Who1,"UT2.Ani.Vehicle") As ObjectReference
	If(Here != NONE)
		Here.Disable()
		Here.Delete()
	EndIf

	Here = StorageUtil.GetFormValue(Who2,"UT2.Ani.Vehicle") As ObjectReference
	If(Here != NONE)
		Here.Disable()
		Here.Delete()
	EndIf

	StorageUtil.UnsetFormValue(Who1,"UT2.Ani.Vehicle")
	StorageUtil.UnsetFormValue(Who2,"UT2.Ani.Vehicle")

	Who1.SetVehicle(NONE)
	Who2.SetVehicle(NONE)

	Return
EndFunction

Function StopAnimation(Actor Who)
{play the idle animation on an actor.}

	;; reset sizes...
	self.ResetActorSize(Who)

	;; stop the slowmo roto...
	Who.StopTranslation()

	self.ResetActor(Who)
	Return
EndFunction

Function ResetActor(Actor Who)
{trigger animation events that should cause most actors to reset to normal.}

	self.UnlockActor(Who)
	Debug.SendAnimationEvent(Who,"IdleForceDefaultState") ;; general npcs
	Debug.SendAnimationEvent(Who,"returnToDefault") ;; lots of animals
	Debug.SendAnimationEvent(Who,"RESET_GRAPH") ;; werewolves
	Debug.SendAnimationEvent(Who,"forceFurnExit") ;; trolls

	Return
EndFunction

;; Private Animation API
;; You should not use these unless you are sure of what you are doing.
;; Each of these only provides a small fragment of functionality.

Function ResetActorSize(Actor Who)
{clear the NIO transform that equalises actor size.}

	Int IsFemale = Who.GetLeveledActorBase().GetSex()

	;; unstandarise the actor's size
	NiOverride.RemoveNodeTransformScale(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeySizeEqual)

	;; restore niohh.
	NiOverride.RemoveNodeTransformPosition(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeyCancelNIOHH)
	NiOverride.RemoveNodeTransformScale(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeyCancelNIOHH)

	;; and apply.
	NiOverride.UpdateNodeTransform(Who,FALSE,IsFemale,self.NiBoneRoot)

	Return
EndFunction

Function ForceActorSize(Actor Who)
{apply an NIO transform to equalise actor size.}

	Int IsFemale = Who.GetLeveledActorBase().GetSex()
	Float ActorScale = Who.GetScale()
	Float ModScale = 1.0

	;; standardizse the actor's size to 1.0

	If(ActorScale < 1.0)
		ModScale += ModScale - ActorScale
	ElseIf(ActorScale > 1.0)
		ModScale -= ActorScale - ModScale
	EndIf

	NiOverride.AddNodeTransformScale(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeySizeEqual,ModScale)

	;; cancel out nio hh. based on how ashy-bae is doing it in sexlab, seemed pretty smrt.

	If(NiOverride.HasNodeTransformPosition(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeyEquips))
		Float HS = NiOverride.GetNodeTransformScale(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeyEquips)
		Float[] HH = NiOverride.GetNodeTransformPosition(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeyEquips)
		Untamed.Util.PrintDebug("Canceling Out NiO HH (" + HH[2] + ", " + HS + ")")

		HS = 1 / HS
		HH[0] = -HH[0]
		HH[1] = -HH[1]
		HH[2] = -HH[2]

		NiOverride.AddNodeTransformPosition(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeyCancelNIOHH,HH)
		NiOverride.AddNodeTransformScale(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeyCancelNIOHH,HS)
	EndIf

	NiOverride.UpdateNodeTransform(Who,FALSE,IsFemale,self.NiBoneRoot)
	Return
EndFunction

Function LockActor(Actor Who)
{lock the actor down}

	ActorUtil.AddPackageOverride(Who,Untamed.PackageDoNothing,100,1)
	Who.EvaluatePackage()

	If(Who == Untamed.Player)
		Game.ForceThirdPerson()
		Game.DisablePlayerControls(TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,0)
		Game.SetPlayerAIDriven(TRUE)
	Else
		Who.SetRestrained(TRUE)
		Who.SetDontMove(TRUE)
	EndIf

	Return
EndFunction

Function UnlockActor(Actor Who)
{unlock a locked actor.}

	ActorUtil.RemovePackageOverride(Who,Untamed.PackageDoNothing)
	Who.EvaluatePackage()

	If(Who == Untamed.Player)
		Game.EnablePlayerControls(TRUE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,0)
		Game.SetPlayerAIDriven(FALSE)
	Else
		Who.SetRestrained(FALSE)
		Who.SetDontMove(FALSE)
	EndIf

	Return
EndFunction

