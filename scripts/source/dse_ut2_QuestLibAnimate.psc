ScriptName dse_ut2_QuestLibAnimate extends Quest

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

dse_ut2_QuestController Property Untamed Auto
SexlabFramework Property SexLab Auto

String Property NiKeyCancelNIOHH = "UT2.SizeCancelNIOHH" Auto Hidden
String Property NiKeySizeEqual = "UT2.SizeEqualise" Auto Hidden
String Property NiKeyEquips = "internal" Auto Hidden
String Property NiBoneRoot = "NPC" Auto Hidden
String Property KeyActorVehicle = "UT2.Ani.Vehicle" Auto Hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Public Animation API
;; These methods are usable for executing complete features.

Function PlaySexlab(Actor Who1, Actor Who2)
{have an adult conversation with someone or something.}

	Actor[] Actors = new Actor[2]
	sslBaseAnimation[] Anims

	Actors[0] = Who1
	Actors[1] = Who2

	Untamed.Util.SheatheWeapons(Who1,FALSE)
	Untamed.Util.SheatheWeapons(Who2,TRUE)

	SexLab.StartSex(Actors, Anims)

	Return
EndFunction

Function PlayAnimation(Actor Who, String Ani)
{tell one actor to play animations.}

	;; if the actors are not mounted to a marker then they should not be in an
	;; animation yet, so go ahead and do an initization.

	If(StorageUtil.GetFormValue(Who, self.KeyActorVehicle) == NONE)
		Untamed.Util.SheatheWeapons(Who, FALSE)
		self.LockActor(Who)
		self.ForceActorSize(Who)

		self.SingleSlowmoRoto(Who)
		Utility.Wait(1.5)
	EndIf

	;; trigger the animation.

	Debug.SendAnimationEvent(Who, Ani)
	Return
EndFunction

Function StopAnimation(Actor Who)
{play the idle animation on an actor.}

	ObjectReference Here

	;;;;;;;;

	Who.StopTranslation()
	Who.SetVehicle(NONE)

	;;;;;;;;

	Here = StorageUtil.GetFormValue(Who, "UT2.Ani.Vehicle") As ObjectReference

	If(Here != NONE)
		Here.Disable()
		Here.Delete()
	EndIf

	StorageUtil.UnsetFormValue(Who, "UT2.Ani.Vehicle")

	;;;;;;;;

	self.ResetActorSize(Who)
	self.ResetActor(Who)
	Return
EndFunction

Function PlayDualAnimation(Actor Who1, String Ani1, Actor Who2, String Ani2, String Off1="", String Off2="")
{tell two actors to play animations which hopefully appear in sync.}

	;; if the actors are not mounted to a marker then they should not be in an
	;; animation yet, so go ahead and do an initization.

	If(StorageUtil.GetFormValue(Who1, self.KeyActorVehicle) == NONE)
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

	self.StopAnimation(Who1)
	self.StopAnimation(Who2)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Private Animation API
;; You should not use these unless you are sure of what you are doing.
;; Each of these only provides a small fragment of functionality.

Function SingleSlowmoRoto(Actor Who)
{rig up the single slomo roto roflcopter.}

	ObjectReference Here

	;;;;;;;;

	Here = Who.PlaceAtMe(Untamed.StaticX)
	Who.SetVehicle(Here)
	StorageUtil.SetFormValue(Who, self.KeyActorVehicle, Here)

	;; commit hillarious collision hack: the slomoroto.

	Who.TranslateTo(                 \
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

Function DualSlowmoRoto(Actor Who1, Actor Who2, String Off1="", String Off2="")
{rig up the dual slomo roto roflcopter.}

	ObjectReference Here

	;;;;;;;;

	Here = Who1.PlaceAtMe(Untamed.StaticX)
	Who1.SetVehicle(Here)
	Who2.SetVehicle(Here)
	StorageUtil.SetFormValue(Who1, self.KeyActorVehicle, Here)
	StorageUtil.SetFormValue(Who2, self.KeyActorVehicle, Here)

	;; align actors.

	Who2.SetAngle(Who1.GetAngleX(),Who1.GetAngleY(),Who1.GetAngleZ())

	;; commit hillarious collision hack: the slomoroto.

	Who1.TranslateTo(                \
		Here.GetPositionX(),       \
		Here.GetPositionY(),       \
		Here.GetPositionZ(),       \
		Here.GetAngleX(),          \
		Here.GetAngleY(),          \
		(Here.GetAngleZ() + 0.01), \
		10000,0.000001             \
	)

	Who2.TranslateTo(                \
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
	Float ActorScale = NetImmerse.GetNodeScale(Who, "NPC Root [Root]", FALSE)
	Float ModScale = 1.0

	;; standardizse the actor's size to 1.0

	If(ActorScale < 1.0)
		ModScale += ModScale - ActorScale
	ElseIf(ActorScale > 1.0)
		ModScale -= ActorScale - ModScale
	EndIf

	NiOverride.AddNodeTransformScale(Who,FALSE,IsFemale,self.NiBoneRoot,self.NiKeySizeEqual,ModScale)

	;; cancel out nio hh.

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

