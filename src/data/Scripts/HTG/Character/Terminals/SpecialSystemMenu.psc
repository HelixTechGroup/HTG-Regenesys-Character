Scriptname HTG:Character:Terminals:SpecialSystemMenu extends HTG:TerminalMenuExt
import HTG
import HTG:Character:Structs

Quest Property SQ_CharacterController Mandatory Const Auto
GlobalVariable Property Special_FirstActivation Mandatory Const Auto

Group AttributeDisplay
Perk Property SpecialDisplay Mandatory Const Auto
EndGroup

Group AttributePoints
GlobalVariable Property AvailablePoints Mandatory Const Auto
ActorValue Property AvailablePointsValue Mandatory Const Auto
EndGroup

Group Attributes
ActorValue Property StrengthValue Mandatory Const Auto
ActorValue Property PerceptionValue Mandatory Const Auto
ActorValue Property EnduranceValue Mandatory Const Auto
ActorValue Property CharismaValue Mandatory Const Auto
ActorValue Property IntelligenceValue Mandatory Const Auto
ActorValue Property AgilityValue Mandatory Const Auto
ActorValue Property LuckValue Mandatory Const Auto
EndGroup

Group AttributeRuntime
ReferenceAlias Property CurrentActor Mandatory Const Auto
GlobalVariable Property StrengthChanged Mandatory Const Auto
GlobalVariable Property PerceptionChanged Mandatory Const Auto
GlobalVariable Property EnduranceChanged Mandatory Const Auto
GlobalVariable Property CharismaChanged Mandatory Const Auto
GlobalVariable Property IntelligenceChanged Mandatory Const Auto
GlobalVariable Property AgilityChanged Mandatory Const Auto
GlobalVariable Property LuckChanged Mandatory Const Auto
GlobalVariable Property ResetPoints Mandatory Const Auto
EndGroup

Bool _resetAttributes
String _availableToken = "FreePoints"
String _strengthToken = "StrAttr"
String _perceptionToken = "PerAttr"
String _enduranceToken = "EndAttr"
String _charismaToken = "ChrAttr"
String _intelligenceToken = "IntAttr"
String _agilityToken = "AgiAttr"
String _luckToken = "LucAttr"
Int _exitItemId = 1000
Int _applyItemId = 100
Int _strengthAddItemId = 1
Int _strengthRemoveItemId = 2
Int _perceptionAddItemId = 3
Int _perceptionRemoveItemId = 4
Int _enduranceAddItemId = 5
Int _enduranceRemoveItemId = 6
Int _charismaAddItemId = 7
Int _charismaRemoveItemId = 8
Int _intelligenceAddItemId = 9
Int _intelligenceRemoveItemId = 10
Int _agilityAddItemId = 11
Int _agilityRemoveItemId = 12
Int _luckAddItemId = 13
Int _luckRemoveItemId = 14
Int _clearItemId = 15
Int _ResetItemId = 16
Int _yesResetItemId = 17
Int _noResetItemId = 18
Float newStrValue
Float newPerValue
Float newEndValue
Float newChrValue
Float newIntValue
Float newAgiValue
Float newLucValue
Int _initialPoints
CharacterStageIds _stages

Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    Parent.OnTerminalMenuEnter(akTerminalBase, akTerminalRef)

    If !CurrentActor.IsFilled()
        CurrentActor.ForceRefTo(Game.GetPlayer())
    EndIf

    Actor kPlayer = CurrentActor.GetActorRef()
    _initialPoints = kPlayer.GetValueInt(AvailablePointsValue)
    AvailablePoints.SetValue(_initialPoints)
    TraceAttributes()
    SetTextValues(akTerminalRef)
EndEvent

Event OnTerminalMenuItemRun(int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    Parent.OnTerminalMenuItemRun(auiMenuItemID, akTerminalBase, akTerminalRef)
    Actor kPlayer = CurrentActor.GetActorRef()

    If (auiMenuItemID == _strengthAddItemId)
        AddPoint(StrengthChanged)
    ElseIf (auiMenuItemID == _strengthRemoveItemId)
        RemovePoint(StrengthChanged)
    ElseIf (auiMenuItemID == _perceptionAddItemId)
        AddPoint(PerceptionChanged)
    ElseIf (auiMenuItemID == _perceptionRemoveItemId)
        RemovePoint(PerceptionChanged)
    ElseIf (auiMenuItemID == _enduranceAddItemId)
        AddPoint(EnduranceChanged)
    ElseIf (auiMenuItemID == _enduranceRemoveItemId)
        RemovePoint(EnduranceChanged)
    ElseIf (auiMenuItemID == _charismaAddItemId)
        AddPoint(CharismaChanged)
    ElseIf (auiMenuItemID == _charismaRemoveItemId)
        RemovePoint(CharismaChanged)
    ElseIf (auiMenuItemID == _intelligenceAddItemId)
        AddPoint(IntelligenceChanged)
    ElseIf (auiMenuItemID == _intelligenceRemoveItemId)
        RemovePoint(IntelligenceChanged)
    ElseIf (auiMenuItemID == _agilityRemoveItemId)
        AddPoint(AgilityChanged)
    ElseIf (auiMenuItemID == _strengthRemoveItemId)
        RemovePoint(AgilityChanged)
    ElseIf (auiMenuItemID == _luckAddItemId)
        AddPoint(LuckChanged)
    ElseIf (auiMenuItemID == _luckRemoveItemId)
        RemovePoint(LuckChanged)
    ElseIf (auiMenuItemID == _clearItemId)
        ClearAllocatedPoints()
    ElseIf (auiMenuItemID == _applyItemId)
        ApplyChangedValues()
    ElseIf (auiMenuItemID == _ResetItemId)
        ResetPoints.SetValueInt(1)
    ElseIf (auiMenuItemID == _yesResetItemId) || (auiMenuItemID == _noResetItemId)
        If (auiMenuItemID == _yesResetItemId)
            ResetAttributes()
        EndIf

        If Special_FirstActivation.GetValueInt() == 1
            Special_FirstActivation.SetValue(0.0)
        EndIf
        ResetPoints.SetValueInt(0)
    ElseIf (auiMenuItemID == _exitItemId)
        kPlayer.SetValue(AvailablePointsValue, AvailablePoints.GetValue())
        kPlayer.RemovePerk(SpecialDisplay)
        kPlayer.AddPerk(SpecialDisplay)

        If AvailablePoints.GetValue() > 0
            SQ_CharacterController.SetStage(_stages.SpecialAlertId)
        Else
            SQ_CharacterController.SetStage(_stages.SpecialNoPointsId)
        EndIf

        ClearChangedValues()
        TraceAttributes()
    EndIf

    SetTextValues(akTerminalRef)
EndEvent

Function SetTextValues(ObjectReference akTerminalRef)
    Actor kPlayer = CurrentActor.GetActorRef()

    CalculateNewValues()
    akTerminalRef.AddTextReplacementValue(_strengthToken, newStrValue)
    akTerminalRef.AddTextReplacementValue(_perceptionToken, newPerValue)
    akTerminalRef.AddTextReplacementValue(_enduranceToken, newEndValue)
    akTerminalRef.AddTextReplacementValue(_charismaToken, newChrValue)
    akTerminalRef.AddTextReplacementValue(_intelligenceToken, newIntValue)
    akTerminalRef.AddTextReplacementValue(_agilityToken, newAgiValue)
    akTerminalRef.AddTextReplacementValue(_luckToken, newLucValue)
    akTerminalRef.AddTextReplacementValue(_availableToken, AvailablePoints.GetValue())
EndFunction

Function AddPoint(GlobalVariable akAttribute)
    akAttribute.SetValue(akAttribute.GetValue() + 1.0)        
    AvailablePoints.SetValue(AvailablePoints.GetValue() - 1.0) 
EndFunction

Function RemovePoint(GlobalVariable akAttribute)
    akAttribute.SetValue(akAttribute.GetValue() - 1.0)        
    AvailablePoints.SetValue(AvailablePoints.GetValue() + 1.0) 
EndFunction

Function ClearChangedValues()
    StrengthChanged.SetValueInt(0)
    PerceptionChanged.SetValueInt(0)
    EnduranceChanged.SetValueInt(0)
    CharismaChanged.SetValueInt(0)
    IntelligenceChanged.SetValueInt(0)
    AgilityChanged.SetValueInt(0)
    LuckChanged.SetValueInt(0)
EndFunction

Function ApplyChangedValues()
    Actor kPlayer = CurrentActor.GetActorRef()
    TraceAttributes()
    CalculateNewValues()
    If StrengthChanged.GetValue() > 0.0
        kPlayer.SetValue(StrengthValue, newStrValue)
    EndIf
    If PerceptionChanged.GetValue() > 0.0
        kPlayer.SetValue(PerceptionValue, newPerValue)
    EndIf
    If EnduranceChanged.GetValue() > 0.0
        kPlayer.SetValue(EnduranceValue, newEndValue)
    EndIf
    If CharismaChanged.GetValue() > 0.0
        kPlayer.SetValue(CharismaValue, newChrValue)
    EndIf
    If IntelligenceChanged.GetValue() > 0.0
        kPlayer.SetValue(IntelligenceValue, newIntValue)
    EndIf
    If AgilityChanged.GetValue() > 0.0
        kPlayer.SetValue(AgilityValue, newAgiValue)
    EndIf
    If LuckChanged.GetValue() > 0.0
        kPlayer.SetValue(LuckValue, newLucValue)
    EndIf

    ClearChangedValues()
    TraceAttributes()
EndFunction

Function CalculateNewValues()
    Actor kPlayer = CurrentActor.GetActorRef()

    newStrValue = kPlayer.GetValue(StrengthValue) + StrengthChanged.GetValue()
    newPerValue = kPlayer.GetValue(PerceptionValue) + PerceptionChanged.GetValue()
    newEndValue = kPlayer.GetValue(EnduranceValue) + EnduranceChanged.GetValue()
    newChrValue = kPlayer.GetValue(CharismaValue) + CharismaChanged.GetValue()
    newIntValue = kPlayer.GetValue(IntelligenceValue) + IntelligenceChanged.GetValue()
    newAgiValue = kPlayer.GetValue(AgilityValue) + AgilityChanged.GetValue()
    newLucValue = kPlayer.GetValue(LuckValue) + LuckChanged.GetValue()
EndFunction

Function TraceAttributes()
    Actor kPlayer = CurrentActor.GetActorRef()

    Logger.Log("Player Attributes:" + \
                    "\n\tStrength:" + kPlayer.GetValueInt(StrengthValue) + \
                    "\n\tPerception:" + kPlayer.GetValueInt(PerceptionValue) + \
                    "\n\tEndurance:" + kPlayer.GetValueInt(EnduranceValue) + \
                    "\n\tCharisma:" + kPlayer.GetValueInt(CharismaValue) + \
                    "\n\tIntelligence:" + kPlayer.GetValueInt(IntelligenceValue) + \
                    "\n\tAgility:" + kPlayer.GetValueInt(AgilityValue) + \
                    "\n\tLuck:" + kPlayer.GetValueInt(LuckValue))
EndFunction

Function ClearAllocatedPoints()
    AvailablePoints.SetValue(_initialPoints) 
    ClearChangedValues()
EndFunction

Function ResetAttributes()
    Actor kPlayer = CurrentActor.GetActorRef()

    ClearAllocatedPoints()
    TraceAttributes()

    kPlayer.SetValue(StrengthValue, 1)
    kPlayer.SetValue(PerceptionValue, 1)
    kPlayer.SetValue(EnduranceValue, 1)
    kPlayer.SetValue(CharismaValue, 1)
    kPlayer.SetValue(IntelligenceValue, 1)
    kPlayer.SetValue(AgilityValue, 1)
    kPlayer.SetValue(LuckValue, 1)

    TraceAttributes()
EndFunction

Bool Function _Init()
    _stages = new CharacterStageIds
    return Parent._Init() && _stages
EndFunction