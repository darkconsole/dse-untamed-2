;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname dse_ut2_FragDiagFondle Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE

dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()
Untamed.QuestLove01.Dom = Untamed.Player
Untamed.QuestLove01.Sub = akSpeaker
Untamed.QuestLove01.Begin()

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
