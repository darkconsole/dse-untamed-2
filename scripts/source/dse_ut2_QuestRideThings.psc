ScriptName dse_ut2_QuestRideThings extends Quest

dse_ut2_QuestController Property Untamed Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ReferenceAlias Property TheMount Auto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function Mount(Actor Mount)

	Actor Rider = Game.GetPlayer()

	If(!self.WillItMount(Rider, Mount))
		Return
	EndIf

	self.PrepareActors(Rider, Mount)
	self.TriggerActors(Rider, Mount)
	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Bool Function WillItMount(Actor Rider, Actor Mount)
{check if conditions are ok to proceed.}

	If(!Untamed.Pack.IsMember(Mount))
		Untamed.Util.Print(Mount.GetDisplayName() + " is not a member of your pack.")
		Return FALSE
	EndIf

	If(!NetImmerse.HasNode(Mount, "SaddleBone", FALSE))
		Untamed.Util.Print(Mount.GetDisplayName() + " has not had its skeleton altered to allow riding yet.")
		Return FALSE
	EndIf

	Return TRUE
EndFunction

Function PrepareActors(Actor Rider, Actor Mount)
{prepare references for triggering.}

	self.TheMount.Clear()
	self.TheMount.ForceRefTo(Mount)
	Mount.AllowPCDialogue(FALSE)
	Mount.BlockActivation(TRUE)

	Utility.Wait(0.1)

	Return
EndFunction

Function TriggerActors(Actor Rider, Actor Mount)
{trigger mounting.}

	Utility.Wait(0.1)
	Mount.Activate(Rider, TRUE)
	self.RegisterForRidingControls()

	Utility.Wait(0.1)
	Debug.SendAnimationEvent(Mount, "moveStart")

	Return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function RegisterForRidingControls()
{enable listening for input controls.}

	self.RegisterForControl("Activate")
	Return
EndFunction

Function UnregisterForRidingControls()
{disable listening fore input controls.}

	self.UnregisterForControl("Activate")
	return
EndFunction

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Event OnControlDown(String Ctrl)
{on input down}

	If(Untamed.PerkUI.GetState() != "Off")
		;; don't fuck about while the perks menu is open.
		Return
	EndIf

	Return
EndEvent

Event OnControlUp(String Ctrl, Float Dur)
{on input up}

	Actor Rider = Game.GetPlayer()
	Actor What = self.TheMount.GetActorReference()

	If(Untamed.PerkUI.GetState() != "Off")
		;; don't fuck about while the perks menu is open.
		Return
	EndIf

	If(Ctrl == "Activate")
		Untamed.Util.PrintDebug("[RideThings:ControlUp] dismount uptown")
		Rider.Dismount()
		;;If(Rider.Dismount())
			Untamed.Util.PrintDebug("[RideThings:ControlUp] dismount downtown")
			Debug.SendAnimationEvent(Rider, "JumpStandingStart")
			Debug.SendAnimationEvent(Rider, "JumpLandEnd")
			What.AllowPCDialogue(TRUE)
			What.BlockActivation(FALSE)
			self.UnregisterForRidingControls()
			self.TheMount.Clear()
		;;EndIf
	EndIf

	Return
EndEvent
