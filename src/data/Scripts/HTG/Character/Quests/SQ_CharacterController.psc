Scriptname HTG:Character:Quests:SQ_CharacterController extends HTG:QuestExt
{Regenesys:Character - System Controller}
import HTG:UtilityExt
import HTG:Character:Structs

ObjectReference Property PlayerRef Mandatory Const Auto

Group SPECIAL_System
GameplayOption Property SpecialEnabled Mandatory Const Auto 
GlobalVariable Property Special_FirstActivation Mandatory Const Auto
ActorValue Property AvailablePointsValue Mandatory Const Auto
Perk Property SpecialPlayerTrait Mandatory Const Auto
Message Property SpecialSetup Mandatory Const Auto
ObjectReference Property SpecialTerminal Mandatory Const Auto
EndGroup

CharacterStageIds _stages

Event OnQuestStarted()
    Parent.OnQuestStarted()

    RegisterForGameplayOptionChangedEvent()
    SetStage(_stages.SpecialId)
    ; Debug.Notification("Regenesys:Character has been started.")
EndEvent

Event OnQuestShutdown()
    UnregisterForGameplayOptionChangedEvent()
EndEvent

Event OnStageSet(int auiStageID, int auiItemID)
    Actor kPlayer = PlayerRef as Actor
    If auiStageID == _stages.SpecialId
        If SpecialEnabled.GetValue() == 1.0
            If Special_FirstActivation.GetValue() == 1.0
                Int kLevel = kPlayer.GetLevel()
                Int kPoints = 10
                If kLevel > 1
                    kPoints += (kLevel / 2) + (kLevel / 10)
                EndIf
        
                Logger.Log("Player Initial Point Allocation" + \
                        "\n\tLevel: " + kLevel + \
                        "\n\tInitial Points: " + kPoints)
                kPlayer.SetValue(AvailablePointsValue, kPoints)
                kPlayer.AddPerk(SpecialPlayerTrait)

                WaitForCombatEnd()
                Utility.Wait(1.333)
                Int _setupResponse = SpecialSetup.Show()
                If (_setupResponse == 0)
                    SpecialTerminal.Activate(kPlayer)
                Else
                    Debug.Notification("You currently have " + kPoints + " attribute points. Please use the RegeneSys Assistant to allocate points.")
                EndIf

                Debug.Notification("The S.P.E.C.I.A.L. System has been enabled.")
                Logger.Log("SPECIAL System is enabled.")
                SetStage(_stages.SpecialAlertId)
            EndIf
        Else
            kPlayer.RemovePerk(SpecialPlayerTrait)
            Debug.Notification("The S.P.E.C.I.A.L. System is disabled.")
            Logger.Log("SPECIAL System is disabled.")
            SetStage(_stages.SpecialNoPointsId)
            SetStage(0)
        EndIf
    EndIf

    If SpecialEnabled.GetValue() == 1.0
        If auiStageID == _stages.SpecialAlertId
            Int kPoints = kPlayer.GetValueInt(AvailablePointsValue)
            If kPoints > 1
                Logger.Log("Activating SPECIAL System quest objective.")
                SetObjectiveActive(_stages.SpecialAlertId)
                SetObjectiveDisplayed(_stages.SpecialAlertId)
            Else
                SetStage(_stages.SpecialNoPointsId)
            EndIf
        ElseIf auiStageID == _stages.SpecialNoPointsId
            Logger.Log("Deactivating SPECIAL System quest objective.")
            SetObjectiveCompleted(_stages.SpecialAlertId)
        EndIf
    EndIf
EndEvent

Event OnGameplayOptionChanged(GameplayOption[] aChangedOptions)
    If aChangedOptions.Find(SpecialEnabled) >= 0
        SetStage(_stages.SpecialId)
    EndIf
    GameplayOption.NotifyGameplayOptionUpdateFinished()
EndEvent

Bool Function _Init()
    _stages = new CharacterStageIds 
    
    return Parent._Init() && _stages
EndFunction