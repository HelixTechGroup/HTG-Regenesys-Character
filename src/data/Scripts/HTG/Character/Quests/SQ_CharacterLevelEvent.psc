Scriptname HTG:Character:Quests:SQ_CharacterLevelEvent extends HTG:QuestExt
{Regenesys:Character:LevelEvent - System Controller}
import HTG:FloatUtility
import HTG:UtilityExt
import HTG:Character:Structs
import Math

ObjectReference Property PlayerRef Mandatory Const Auto
Quest Property SQ_CharacterController Mandatory Const Auto
GameplayOption Property SpecialEnabled Mandatory Const Auto 
GameplayOption Property ShowAttributesOnLevelUp Mandatory Const Auto
GlobalVariable Property AttributeMax Mandatory Const Auto
ObjectReference Property SpecialTerminal Mandatory Const Auto
ActorValue Property AttributePointsValue Mandatory Const Auto
ActorValue Property LastLevelValue Mandatory Const Auto

CharacterStageIds _stages

Event OnQuestStarted()
    Parent.OnQuestStarted()

    Actor kPlayer = PlayerRef as Actor
    Int kLevel = kPlayer.GetLevel()
    Int kLevelMax = AttributeMax.GetValueInt() * 10
    
    If SpecialEnabled.GetValue() == 1.0 && kLevel <= kLevelMax
        Bool kShowUI = FloatToBool(ShowAttributesOnLevelUp.GetValue())
        Int kPoints = kPlayer.GetValueInt(AttributePointsValue)
        Int kLastLevel = kPlayer.GetValueInt(LastLevelValue)
        Int kNewPoints = 0

        Int kLevelDiff = kLevel - kLastLevel
        If kLevelDiff > 1
            Logger.Log("Level difference greater than 1 detected." + \
                        "\n\tLastLevel: " + kLastLevel + \
                        "\n\tLevelDifference: " + kLevelDiff)
            Int i = 1
            While i <= kLevelDiff
                Int kLevelCheck = kLastLevel + i
                kNewPoints += CalculatePoints(kLevelCheck)
                i += 1
            EndWhile
        Else
            kNewPoints = CalculatePoints(kLevel)
        EndIf

        Int kTotal = kPoints + kNewPoints
        Logger.Log("PlayerLevelUp\n\tLevel: " + kLevel + \
                    "\n\tLast Level: " + kLastLevel + \
                    "\n\tCurrent Points: " + kPoints + \
                    "\n\tAdded Points: " + kNewPoints + \
                    "\n\tTotal Points: " + kTotal + \
                    "\n\tShow UI: " + kShowUI)
        If kTotal > 0
            kPlayer.SetValue(AttributePointsValue, kTotal)

            If kShowUI
                WaitForCombatEnd()
                Utility.Wait(0.333)
                SpecialTerminal.Activate(kPlayer)
            Else
                Debug.Notification("You currently have " + kPoints + " attribute points. Please use the RegeneSys Assistant to allocate points.")
            EndIf

            SQ_CharacterController.SetStage(_stages.SpecialAlertId)
        ; Else
        ;     SQ_CharacterController.SetStage(_specialNoPointsStageId)
        EndIf
        kPlayer.SetValue(LastLevelValue, kLevel)
    EndIf
    Stop()
EndEvent

Bool Function _Init()
    _stages = new CharacterStageIds 
    
    return Parent._Init() && _stages
EndFunction

Int Function CalculatePoints(Int akLevel)
    Int kNewPoints = 0
    If akLevel % 2 == 0
        kNewPoints += 1
    ElseIf akLevel % 10 == 0
        kNewPoints += 2
    EndIf

    Logger.Log("Calculating Attribute Points." + \
                        "\n\tLevel: " + akLevel + \
                        "\n\tPoints: " + kNewPoints)

    return kNewPoints
EndFunction