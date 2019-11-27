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

Function PlayDualAnimation(Actor Who1, String Ani1, Actor Who2, String Ani2)
{rig up and play stacked dual animations. sex without the lab.}

	ObjectReference Here = Who1.PlaceAtMe(Untamed.StaticX)
	Who1.SetVehicle(Here)
	Who2.SetVehicle(Here)

	;; equalise sizes...
	self.ForceActorSize(Who1)
	self.ForceActorSize(Who2)

	;; about face...
	Who2.SetAngle(Who1.GetAngleX(),Who1.GetAngleY(),Who1.GetAngleZ())

	;; commit hillarious collision hack: the slomoroto
	Who1.SplineTranslateTo(Here.GetPositionX(),Here.GetPositionY(),Here.GetPositionZ(),Here.GetAngleX(),Here.GetAngleY(),(Here.GetAngleZ() + 0.01),1.0,500,0.001)
	Who2.SplineTranslateTo(Here.GetPositionX(),Here.GetPositionY(),Here.GetPositionZ(),Here.GetAngleX(),Here.GetAngleY(),(Here.GetAngleZ() + 0.01),1.0,500,0.001)

	;; and animate.
	Debug.SendAnimationEvent(Who1,Ani1)
	Debug.SendAnimationEvent(Who2,Ani2)

	;; yoink.
	Who1.SetVehicle(None)
	Who2.SetVehicle(None)
	Here.Delete()

	;; honestly i think the vehicle trick may not even be needed here.
	;; i just emulated this after sexlab and cleaned it up a bit. the
	;; slomoroto is the key here.

	Return
EndFunction

Function StopDualAnimation(Actor Who1, Actor Who2)
{stop animation for two actors.}

	self.StopAnimation(Who1)
	self.StopAnimation(Who2)

	Return
EndFunction

Function StopAnimation(Actor Who)
{play the idle animation on an actor.}

	;; reset sizes...
	self.ResetActorSize(Who)

	;; stop the slowmo roto...
	Who.StopTranslation()

	;; reset the states.
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

