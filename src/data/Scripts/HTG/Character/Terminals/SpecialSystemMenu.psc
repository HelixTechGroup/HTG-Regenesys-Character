Scriptname HTG:Character:Terminals:SpecialSystemMenu extends HTG:TerminalMenuExt
import HTG
import HTG:Character:Structs

Quest Property SQ_CharacterController Mandatory Const Auto
GlobalVariable Property FirstActivation Mandatory Const Auto

Group AttributeDisplay
Perk Property SpecialDisplay Mandatory Const Auto
EndGroup

Group AttributePoints
GlobalVariable Property AttributeMax Mandatory Const Auto
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
Guard _pointGuard ProtectsFunctionLogic

Event OnInit()
    Parent.OnInit()
    
    _stages = new CharacterStageIds
    AvailablePoints.SetValue(0)
    ClearChangedValues()
    ; TraceAttributes()
EndEvent

Event OnTerminalMenuEnter(TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    Parent.OnTerminalMenuEnter(akTerminalBase, akTerminalRef)

    Actor kPlayer = CurrentActor.GetActorRef()
    _initialPoints = kPlayer.GetValueInt(AvailablePointsValue)
    AvailablePoints.SetValue(_initialPoints)
    ClearChangedValues()
    TraceAttributes()

    SetTextValues(akTerminalRef)
EndEvent

Event OnTerminalMenuItemRun(int auiMenuItemID, TerminalMenu akTerminalBase, ObjectReference akTerminalRef)
    Parent.OnTerminalMenuItemRun(auiMenuItemID, akTerminalBase, akTerminalRef)
    Actor kPlayer = CurrentActor.GetActorRef()

    If (auiMenuItemID == _strengthAddItemId)
        AddPoint(StrengthValue, StrengthChanged)
    ElseIf (auiMenuItemID == _strengthRemoveItemId)
        RemovePoint(StrengthChanged)
    ElseIf (auiMenuItemID == _perceptionAddItemId)
        AddPoint(PerceptionValue, PerceptionChanged)
    ElseIf (auiMenuItemID == _perceptionRemoveItemId)
        RemovePoint(PerceptionChanged)
    ElseIf (auiMenuItemID == _enduranceAddItemId)
        AddPoint(EnduranceValue, EnduranceChanged)
    ElseIf (auiMenuItemID == _enduranceRemoveItemId)
        RemovePoint(EnduranceChanged)
    ElseIf (auiMenuItemID == _charismaAddItemId)
        AddPoint(CharismaValue, CharismaChanged)
    ElseIf (auiMenuItemID == _charismaRemoveItemId)
        RemovePoint(CharismaChanged)
    ElseIf (auiMenuItemID == _intelligenceAddItemId)
        AddPoint(IntelligenceValue, IntelligenceChanged)
    ElseIf (auiMenuItemID == _intelligenceRemoveItemId)
        RemovePoint(IntelligenceChanged)
    ElseIf (auiMenuItemID == _agilityAddItemId)
        AddPoint(AgilityValue, AgilityChanged)
    ElseIf (auiMenuItemID == _agilityRemoveItemId)
        RemovePoint(AgilityChanged)
    ElseIf (auiMenuItemID == _luckAddItemId)
        AddPoint(LuckValue, LuckChanged)
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
            ClearAllocatedPoints()
            ResetAttributes()
        EndIf

        If FirstActivation.GetValueInt() == 1
            FirstActivation.SetValueInt(0)
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

        ClearAllocatedPoints()
        TraceAttributes()
    ElseIf (auiMenuItemID == 65535)
        Logger.Log("Opening Terminal.")
    Else
        Logger.Log("Current ItemId: " + auiMenuItemID + \
                    "\n\tAvailable Points: " + AvailablePoints.GetValueInt())
        kPlayer.SetValue(AvailablePointsValue, AvailablePoints.GetValue())
        kPlayer.RemovePerk(SpecialDisplay)
        kPlayer.AddPerk(SpecialDisplay)
        ClearAllocatedPoints()
        ; TraceAttributes()
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

Function AddPoint(ActorValue akAttribute, GlobalVariable akAttributeChanged)
    Actor kPlayer = CurrentActor.GetActorRef()
    Int kMax = AttributeMax.GetValueInt()
    Int kCurrentAttr = kPlayer.GetValueInt(akAttribute)
    Int kChangedAttr = akAttributeChanged.GetValueInt()

    TryLockGuard _pointGuard
    Int kTotal = (kCurrentAttr + kChangedAttr) + 1
    Logger.Log("Player Add Point Check:" + \
                    "\n\tMax Value:" + kMax + \
                    "\n\tCurrent Value:" + kCurrentAttr + \
                    "\n\tChanged Value:" + kChangedAttr + \
                    "\n\tTotal:" + kTotal)

    If kTotal <= kMax
        akAttributeChanged.SetValue(akAttributeChanged.GetValue() + 1.0)        
        AvailablePoints.SetValue(AvailablePoints.GetValue() - 1.0) 
    EndIf
    EndTryLockGuard
EndFunction

Function RemovePoint(GlobalVariable akAttribute)
    TryLockGuard _pointGuard
    akAttribute.SetValue(akAttribute.GetValue() - 1.0)        
    AvailablePoints.SetValue(AvailablePoints.GetValue() + 1.0)
    EndTryLockGuard 
EndFunction

Function ClearChangedValues()
    TryLockGuard _pointGuard
    StrengthChanged.SetValueInt(0)
    PerceptionChanged.SetValueInt(0)
    EnduranceChanged.SetValueInt(0)
    CharismaChanged.SetValueInt(0)
    IntelligenceChanged.SetValueInt(0)
    AgilityChanged.SetValueInt(0)
    LuckChanged.SetValueInt(0)
    EndTryLockGuard
EndFunction

Function ApplyChangedValues()
    Actor kPlayer = CurrentActor.GetActorRef()
    TraceAttributes()
    CalculateNewValues()

    TryLockGuard _pointGuard
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

    _initialPoints = AvailablePoints.GetValueInt()
    kPlayer.SetValue(AvailablePointsValue, AvailablePoints.GetValue())
    EndTryLockGuard

    ClearChangedValues()
    TraceAttributes()
EndFunction

Function CalculateNewValues()
    Actor kPlayer = CurrentActor.GetActorRef()

    TryLockGuard _pointGuard
    newStrValue = kPlayer.GetValue(StrengthValue) + StrengthChanged.GetValue()
    newPerValue = kPlayer.GetValue(PerceptionValue) + PerceptionChanged.GetValue()
    newEndValue = kPlayer.GetValue(EnduranceValue) + EnduranceChanged.GetValue()
    newChrValue = kPlayer.GetValue(CharismaValue) + CharismaChanged.GetValue()
    newIntValue = kPlayer.GetValue(IntelligenceValue) + IntelligenceChanged.GetValue()
    newAgiValue = kPlayer.GetValue(AgilityValue) + AgilityChanged.GetValue()
    newLucValue = kPlayer.GetValue(LuckValue) + LuckChanged.GetValue()
    EndTryLockGuard
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

    ; Logger.Log("Attribute Max Conditions:" + \
    ;                 "\n\tStrength:" + StrengthMax.IsTrue()); + \
                    ; "\n\tPerception:" + kPlayer.GetValueInt(PerceptionValue) + \
                    ; "\n\tEndurance:" + kPlayer.GetValueInt(EnduranceValue) + \
                    ; "\n\tCharisma:" + kPlayer.GetValueInt(CharismaValue) + \
                    ; "\n\tIntelligence:" + kPlayer.GetValueInt(IntelligenceValue) + \
                    ; "\n\tAgility:" + kPlayer.GetValueInt(AgilityValue) + \
                    ; "\n\tLuck:" + kPlayer.GetValueInt(LuckValue))
EndFunction

Function ClearAllocatedPoints()
    Logger.Log("Initial Points to be reset: " + _initialPoints)
    AvailablePoints.SetValueInt(_initialPoints) 
    ClearChangedValues()
EndFunction

Function ResetAttributes()
    Actor kPlayer = CurrentActor.GetActorRef()

    TraceAttributes()

    TryLockGuard _pointGuard
    Int allocatedPoints = 0
    If FirstActivation.GetValueInt() == 0
        allocatedPoints = (kPlayer.GetValueInt(StrengthValue) - 1) +\
                            (kPlayer.GetValueInt(PerceptionValue) - 1) +\
                            (kPlayer.GetValueInt(EnduranceValue) - 1) +\
                            (kPlayer.GetValueInt(CharismaValue) - 1) +\
                            (kPlayer.GetValueInt(IntelligenceValue) - 1) +\
                            (kPlayer.GetValueInt(AgilityValue) - 1) +\
                            (kPlayer.GetValueInt(LuckValue) - 1)

        Logger.Log("Allocated Points to be returned: " + allocatedPoints)
        AvailablePoints.Mod(allocatedPoints)
    EndIf

    kPlayer.SetValue(StrengthValue, 1)
    kPlayer.SetValue(PerceptionValue, 1)
    kPlayer.SetValue(EnduranceValue, 1)
    kPlayer.SetValue(CharismaValue, 1)
    kPlayer.SetValue(IntelligenceValue, 1)
    kPlayer.SetValue(AgilityValue, 1)
    kPlayer.SetValue(LuckValue, 1)
    EndTryLockGuard

    ClearChangedValues()
    TraceAttributes()
EndFunction

Bool Function _Init()
    _stages = new CharacterStageIds
    return Parent._Init() && _stages
EndFunction