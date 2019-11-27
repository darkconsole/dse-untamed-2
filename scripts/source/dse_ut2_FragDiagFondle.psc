;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname dse_ut2_FragDiagFondle Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()

Untamed.Anim.PlayDualAnimation(Untamed.Player,"ut-wolf-love1-s1-a2",akSpeaker,"ut-wolf-love1-s1-a1")
Utility.Wait(10)
Untamed.Experience(Untamed.Player,Untamed.Config.OptFondleXP)
Untamed.Anim.StopDualAnimation(Untamed.Player,akSpeaker)

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
