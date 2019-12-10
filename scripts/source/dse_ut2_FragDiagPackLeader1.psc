;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname dse_ut2_FragDiagPackLeader1 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()
Untamed.Player.AddPerk(Untamed.PerkPackLeader1)
Debug.MessageBox(Untamed.Util.StringLookup("HelpPackLeader1"))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()
Untamed.Player.AddPerk(Untamed.PerkPackLeader2)
Debug.MessageBox(Untamed.Util.StringLookup("HelpPackLeader2"))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
dse_ut2_QuestController Untamed = dse_ut2_QuestController.Get()
Untamed.Player.AddPerk(Untamed.PerkPackLeader3)
Debug.MessageBox(Untamed.Util.StringLookup("HelpPackLeader3"))
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
