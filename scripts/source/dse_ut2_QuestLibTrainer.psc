Scriptname dse_ut2_QuestLibTrainer extends Quest

dse_ut2_QuestController Property Untamed Auto

ActorBase Property TrainerType01 Auto ;; essence
ActorBase Property TrainerType02 Auto ;; ferocity
ActorBase Property TrainerType03 Auto ;; tenacity
ActorBase Property TrainerType04 Auto ;; mastery

ReferenceAlias Property Trainer01 Auto
ReferenceAlias Property Trainer02 Auto
ReferenceAlias Property Trainer03 Auto
ReferenceAlias Property Trainer04 Auto

Event OnInit()

	Return
EndEvent

Function SpawnTrainers()

	ObjectReference[] Who = new ObjectReference[4]
	Float Rot = Untamed.Player.GetAngleZ()
	Actor[] Trainer = new Actor[4]
	Float[] X = new Float[4]
	Float[] Y = new Float[4]
	Int Titer = 0

	;;;;;;;;

	self.DespawnTrainers()

	X[0] = 0.0
	X[1] = 0.0
	X[2] = 150.0
	X[3] = -150.0

	Y[0] = 150.0
	Y[1] = -150.0
	Y[2] = 0.0
	Y[3] = 0.0

	;;;;;;;;

	self.Trainer01.ForceRefTo(Untamed.Player.PlaceAtMe(self.TrainerType01,1,TRUE,TRUE))
	self.Trainer02.ForceRefTo(Untamed.Player.PlaceAtMe(self.TrainerType02,1,TRUE,TRUE))
	self.Trainer03.ForceRefTo(Untamed.Player.PlaceAtMe(self.TrainerType03,1,TRUE,TRUE))
	self.Trainer04.ForceRefTo(Untamed.Player.PlaceAtMe(self.TrainerType04,1,TRUE,TRUE))

	Trainer[0] = self.Trainer01.GetActorRef()
	Trainer[1] = self.Trainer02.GetActorRef()
	Trainer[2] = self.Trainer03.GetActorRef()
	Trainer[3] = self.Trainer04.GetActorRef()

	;;;;;;;;

	;; get all the trainers ready.

	Titer = 0
	While(Titer < Trainer.Length)
		Untamed.Util.SetTamed(Trainer[Titer],TRUE)
		Untamed.Util.FixAnimalActor(Trainer[Titer])
		Trainer[Titer].MoveTo(Untamed.Player,X[Titer],Y[Titer],0.0)
		Trainer[Titer].SetAngle(0.0,0.0,(Untamed.Player.GetHeadingAngle(Trainer[Titer]) + Rot + 180))
		Titer += 1
	EndWhile

	;;;;;;;;

	;; enable all the trainers.

	Titer = 0
	While(Titer < Trainer.Length)
		Trainer[Titer].Enable(TRUE)
		Titer += 1
	EndWhile

	Return
EndFunction

Function DespawnTrainers()

	If(self.Trainer01.GetRef() != NONE)
		self.Trainer01.GetRef().Disable()
		self.Trainer01.GetRef().Delete()
		self.Trainer01.Clear()
	EndIf

	If(self.Trainer02.GetRef() != NONE)
		self.Trainer02.GetRef().Disable()
		self.Trainer02.GetRef().Delete()
		self.Trainer02.Clear()
	EndIf

	If(self.Trainer03.GetRef() != NONE)
		self.Trainer03.GetRef().Disable()
		self.Trainer03.GetRef().Delete()
		self.Trainer03.Clear()
	EndIf

	If(self.Trainer04.GetRef() != NONE)
		self.Trainer04.GetRef().Disable()
		self.Trainer04.GetRef().Delete()
		self.Trainer04.Clear()
	EndIf

	Return
EndFunction

