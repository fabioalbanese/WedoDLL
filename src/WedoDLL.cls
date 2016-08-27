VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "WedoControl"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit



'******************************************************************************
'API constants, listed alphabetically
'******************************************************************************

'from setupapi.h
Private Const DIGCF_PRESENT = &H2
Private Const DIGCF_DEVICEINTERFACE = &H10
Private Const FILE_FLAG_OVERLAPPED = &H40000000
Private Const FILE_SHARE_READ = &H1
Private Const FILE_SHARE_WRITE = &H2
Private Const GENERIC_READ = &H80000000
Private Const GENERIC_WRITE = &H40000000

'Typedef enum defines a set of integer constants for HidP_Report_Type
'Remember to declare these as integers (16 bits)
Private Const HidP_Input = 0

Private Const OPEN_EXISTING = 3
Private Const WAIT_TIMEOUT = &H102&
Private Const WAIT_OBJECT_0 = 0

'******************************************************************************
'User-defined types for API calls, listed alphabetically
'******************************************************************************

Private Type GUID
    Data1 As Long
    Data2 As Integer
    Data3 As Integer
    Data4(7) As Byte
End Type

Private Type HIDD_ATTRIBUTES
    Size As Long
    VendorID As Integer
    ProductID As Integer
    VersionNumber As Integer
End Type

'Windows 98 DDK documentation is incomplete.
'Use the structure defined in hidpi.h
Private Type HIDP_CAPS
    Usage As Integer
    UsagePage As Integer
    InputReportByteLength As Integer
    OutputReportByteLength As Integer
    FeatureReportByteLength As Integer
    Reserved(16) As Integer
    NumberLinkCollectionNodes As Integer
    NumberInputButtonCaps As Integer
    NumberInputValueCaps As Integer
    NumberInputDataIndices As Integer
    NumberOutputButtonCaps As Integer
    NumberOutputValueCaps As Integer
    NumberOutputDataIndices As Integer
    NumberFeatureButtonCaps As Integer
    NumberFeatureValueCaps As Integer
    NumberFeatureDataIndices As Integer
End Type


Private Type OVERLAPPED
    Internal As Long
    InternalHigh As Long
    Offset As Long
    OffsetHigh As Long
    hEvent As Long
End Type

Private Type SECURITY_ATTRIBUTES
    nLength As Long
    lpSecurityDescriptor As Long
    bInheritHandle As Long
End Type

Private Type SP_DEVICE_INTERFACE_DATA
   cbSize As Long
   InterfaceClassGuid As GUID
   Flags As Long
   Reserved As Long
End Type

Private Type SP_DEVICE_INTERFACE_DETAIL_DATA
    cbSize As Long
    DevicePath As Byte
End Type

Private Type SP_DEVINFO_DATA
    cbSize As Long
    ClassGuid As GUID
    DevInst As Long
    Reserved As Long
End Type

'******************************************************************************
'API functions, listed alphabetically
'******************************************************************************

Private Declare Function CancelIo _
    Lib "kernel32" _
    (ByVal hFile As Long) _
As Long

Private Declare Function CloseHandle _
    Lib "kernel32" _
    (ByVal hObject As Long) _
As Long

Private Declare Function CreateEvent _
    Lib "kernel32" _
    Alias "CreateEventA" _
    (ByRef lpSecurityAttributes As SECURITY_ATTRIBUTES, _
    ByVal bManualReset As Long, _
    ByVal bInitialState As Long, _
    ByVal lpName As String) _
As Long

Private Declare Function CreateFile _
    Lib "kernel32" _
    Alias "CreateFileA" _
    (ByVal lpFileName As String, _
    ByVal dwDesiredAccess As Long, _
    ByVal dwShareMode As Long, _
    ByRef lpSecurityAttributes As SECURITY_ATTRIBUTES, _
    ByVal dwCreationDisposition As Long, _
    ByVal dwFlagsAndAttributes As Long, _
    ByVal hTemplateFile As Long) _
As Long


Private Declare Function HidD_FreePreparsedData _
    Lib "hid.dll" _
    (ByRef PreparsedData As Long) _
As Long

Private Declare Function HidD_GetAttributes _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef Attributes As HIDD_ATTRIBUTES) _
As Long

'Declared as a function for consistency,
'but returns nothing. (Ignore the returned value.)
Private Declare Function HidD_GetHidGuid _
    Lib "hid.dll" _
    (ByRef HidGuid As GUID) _
As Long

Private Declare Function HidD_GetPreparsedData _
    Lib "hid.dll" _
    (ByVal HidDeviceObject As Long, _
    ByRef PreparsedData As Long) _
As Long

Private Declare Function HidP_GetCaps _
    Lib "hid.dll" _
    (ByVal PreparsedData As Long, _
    ByRef Capabilities As HIDP_CAPS) _
As Long

Private Declare Function HidP_GetValueCaps _
    Lib "hid.dll" _
    (ByVal ReportType As Integer, _
    ByRef ValueCaps As Byte, _
    ByRef ValueCapsLength As Integer, _
    ByVal PreparsedData As Long) _
As Long
       


Private Declare Function ReadFile _
    Lib "kernel32" _
    (ByVal hFile As Long, _
    ByRef lpBuffer As Byte, _
    ByVal nNumberOfBytesToRead As Long, _
    ByRef lpNumberOfBytesRead As Long, _
    ByRef lpOverlapped As OVERLAPPED) _
As Long

Private Declare Function ResetEvent _
    Lib "kernel32" _
    (ByVal hEvent As Long) _
As Long

Private Declare Function RtlMoveMemory _
    Lib "kernel32" _
    (dest As Any, _
    src As Any, _
    ByVal Count As Long) _
As Long


Private Declare Function SetupDiDestroyDeviceInfoList _
    Lib "setupapi.dll" _
    (ByVal DeviceInfoSet As Long) _
As Long

Private Declare Function SetupDiEnumDeviceInterfaces _
    Lib "setupapi.dll" _
    (ByVal DeviceInfoSet As Long, _
    ByVal DeviceInfoData As Long, _
    ByRef InterfaceClassGuid As GUID, _
    ByVal MemberIndex As Long, _
    ByRef DeviceInterfaceData As SP_DEVICE_INTERFACE_DATA) _
As Long

Private Declare Function SetupDiGetClassDevs _
    Lib "setupapi.dll" _
    Alias "SetupDiGetClassDevsA" _
    (ByRef ClassGuid As GUID, _
    ByVal Enumerator As String, _
    ByVal hwndParent As Long, _
    ByVal Flags As Long) _
As Long

Private Declare Function SetupDiGetDeviceInterfaceDetail _
   Lib "setupapi.dll" _
   Alias "SetupDiGetDeviceInterfaceDetailA" _
   (ByVal DeviceInfoSet As Long, _
   ByRef DeviceInterfaceData As SP_DEVICE_INTERFACE_DATA, _
   ByVal DeviceInterfaceDetailData As Long, _
   ByVal DeviceInterfaceDetailDataSize As Long, _
   ByRef RequiredSize As Long, _
   ByVal DeviceInfoData As Long) _
As Long
    
Private Declare Function WaitForSingleObject _
    Lib "kernel32" _
    (ByVal hHandle As Long, _
    ByVal dwMilliseconds As Long) _
As Long
    
Private Declare Function WriteFile _
    Lib "kernel32" _
    (ByVal hFile As Long, _
    ByRef lpBuffer As Byte, _
    ByVal nNumberOfBytesToWrite As Long, _
    ByRef lpNumberOfBytesWritten As Long, _
    ByVal lpOverlapped As Long) _
As Long

Private MotorA   As Integer
Private MotorB   As Integer

Dim bAlertable As Long
Dim Capabilities As HIDP_CAPS
Dim DataString As String
Dim DetailData As Long
Dim DetailDataBuffer() As Byte
Dim DeviceAttributes As HIDD_ATTRIBUTES
Dim DevicePathName As String
Dim DeviceInfoSet As Long
Dim EventObject As Long
Dim HIDHandle As Long
Dim HIDOverlapped As OVERLAPPED
Dim LastDevice As Boolean
Dim MyDeviceDetected As Boolean
Dim MyDeviceInfoData As SP_DEVINFO_DATA
Dim MyDeviceInterfaceDetailData As SP_DEVICE_INTERFACE_DETAIL_DATA
Dim MyDeviceInterfaceData As SP_DEVICE_INTERFACE_DATA
Dim Needed As Long
Dim OutputReportData(7) As Byte
Dim PreparsedData As Long
Dim ReadHandle As Long
Dim result As Long
Dim Security As SECURITY_ATTRIBUTES
Dim ReadBuffer() As Byte

Const MyVendorID = &H694
Const MyProductID = &H3

Property Get Author() As String
    Author = "Fabio Albanese 2016"
End Property

Property Get Release() As String
    Release = Format(App.Major, "0000") & "." & Format(App.Minor, "00") & Format(App.Revision, "00")
End Property

Public Sub SetMotorA(ByVal pValue As Integer)
    If pValue < -100 Then pValue = -100
    If pValue > 100 Then pValue = 100
    MotorA = pValue
    Call SetMotors
End Sub

Public Sub SetMotorB(ByVal pValue As Integer)
    If pValue < -100 Then pValue = -100
    If pValue > 100 Then pValue = 100
    MotorB = pValue
    Call SetMotors
End Sub

Public Function GetTilt() As Integer
  Dim myTilt As Integer
  Dim Found As Boolean
    Found = False
    MyDeviceDetected = FindTheHid
    If MyDeviceDetected Then
        If ReadReport() Then
            If ReadBuffer(4) = 38 Or ReadBuffer(4) = 39 Then
                Found = True
                myTilt = ReadBuffer(3)
            End If
            If ReadBuffer(6) = 38 Or ReadBuffer(6) = 39 Then
                Found = True
                myTilt = ReadBuffer(5)
            End If
        End If
    End If
    If Found Then
        Select Case myTilt
            Case 10 To 40
                GetTilt = 1
            Case 60 To 90
                GetTilt = 2
            Case 170 To 190
                GetTilt = 3
            Case 220 To 240
                GetTilt = 4
            Case Else
                GetTilt = 0
        End Select
    Else
        GetTilt = -1
    End If
End Function

Public Function GetDistance() As Integer
  Dim myDistance As Double
  Dim Found As Boolean
    Found = False
    MyDeviceDetected = FindTheHid
    If MyDeviceDetected Then
        If ReadReport() Then
            If ReadBuffer(4) >= 176 And ReadBuffer(4) <= 179 Then
                Found = True
                myDistance = ReadBuffer(3)
            End If
            If ReadBuffer(6) >= 176 And ReadBuffer(6) <= 179 Then
                Found = True
                myDistance = ReadBuffer(5)
            End If
        End If
    End If
    If Found Then
        myDistance = myDistance - 68
        myDistance = myDistance / 145 * 100
        If myDistance < 0 Then myDistance = 0
        If myDistance > 100 Then myDistance = 100
        GetDistance = myDistance
    Else
        GetDistance = -1
    End If
End Function

Private Function processMotorValues(ByVal pValue As Integer) As Integer
 Dim result As Integer
    pValue = pValue * 127 / 100
    If 0 < pValue <= 100 Then
        result = pValue
    ElseIf -100 <= pValue < 0 Then
        result = &H81 + pValue
    Else
        result = 0
    End If
    result = result And &HFF
    processMotorValues = result
End Function

Private Sub SetMotors()
    MyDeviceDetected = FindTheHid
    If MyDeviceDetected = True Then
        OutputReportData(0) = 64
        OutputReportData(1) = processMotorValues(MotorA)
        OutputReportData(2) = processMotorValues(MotorB)
        Call WriteReport
    Else
        MotorA = 0
        MotorB = 0
    End If
End Sub

Private Function ReadReport() As Boolean
 Dim NumberOfBytesRead As Long
    ReDim ReadBuffer(Capabilities.InputReportByteLength - 1)
    result = ReadFile(ReadHandle, ReadBuffer(0), CLng(Capabilities.InputReportByteLength), NumberOfBytesRead, HIDOverlapped)
    bAlertable = True
    result = WaitForSingleObject(EventObject, 3000)
    Select Case result
        Case WAIT_OBJECT_0
            ReadReport = True
        Case WAIT_TIMEOUT
            result = CancelIo(ReadHandle)
            CloseHandle (HIDHandle)
            CloseHandle (ReadHandle)
            MyDeviceDetected = False
            ReadReport = False
        Case Else
            MyDeviceDetected = False
            ReadReport = False
    End Select
    Call ResetEvent(EventObject)
End Function

Private Sub WriteReport()
  Dim Count As Integer
  Dim NumberOfBytesWritten As Long
  Dim SendBuffer() As Byte
    ReDim SendBuffer(Capabilities.OutputReportByteLength - 1)
    SendBuffer(0) = 0
    For Count = 1 To Capabilities.OutputReportByteLength - 1
        SendBuffer(Count) = OutputReportData(Count - 1)
    Next Count
    NumberOfBytesWritten = 0
    result = WriteFile _
        (HIDHandle, _
        SendBuffer(0), _
        CLng(Capabilities.OutputReportByteLength), _
        NumberOfBytesWritten, _
        0)
End Sub

Private Function FindTheHid() As Boolean
  Dim HidGuid As GUID
  Dim MemberIndex As Long
    LastDevice = False
    MyDeviceDetected = False
    Security.lpSecurityDescriptor = 0
    Security.bInheritHandle = True
    Security.nLength = Len(Security)
    result = HidD_GetHidGuid(HidGuid)
    DeviceInfoSet = SetupDiGetClassDevs _
        (HidGuid, _
        vbNullString, _
        0, _
        (DIGCF_PRESENT Or DIGCF_DEVICEINTERFACE))
    DataString = GetDataString(DeviceInfoSet, 32)
    MemberIndex = 0
    Do
        MyDeviceInterfaceData.cbSize = LenB(MyDeviceInterfaceData)
        result = SetupDiEnumDeviceInterfaces _
            (DeviceInfoSet, _
            0, _
            HidGuid, _
            MemberIndex, _
            MyDeviceInterfaceData)
        If result = 0 Then
            LastDevice = True
        Else
            MyDeviceInfoData.cbSize = Len(MyDeviceInfoData)
            result = SetupDiGetDeviceInterfaceDetail _
               (DeviceInfoSet, _
               MyDeviceInterfaceData, _
               0, _
               0, _
               Needed, _
               0)
            DetailData = Needed
            MyDeviceInterfaceDetailData.cbSize = _
                Len(MyDeviceInterfaceDetailData)
            ReDim DetailDataBuffer(Needed)
            Call RtlMoveMemory _
                (DetailDataBuffer(0), _
                MyDeviceInterfaceDetailData, _
                4)
            result = SetupDiGetDeviceInterfaceDetail _
               (DeviceInfoSet, _
               MyDeviceInterfaceData, _
               VarPtr(DetailDataBuffer(0)), _
               DetailData, _
               Needed, _
               0)
            DevicePathName = CStr(DetailDataBuffer())
            DevicePathName = StrConv(DevicePathName, vbUnicode)
            DevicePathName = Right$(DevicePathName, Len(DevicePathName) - 4)
            HIDHandle = CreateFile _
                (DevicePathName, _
                GENERIC_READ Or GENERIC_WRITE, _
                (FILE_SHARE_READ Or FILE_SHARE_WRITE), _
                Security, _
                OPEN_EXISTING, _
                0&, _
                0)
            DeviceAttributes.Size = LenB(DeviceAttributes)
            result = HidD_GetAttributes _
                (HIDHandle, _
                DeviceAttributes)
            If (DeviceAttributes.VendorID = MyVendorID) And _
                (DeviceAttributes.ProductID = MyProductID) Then
                    MyDeviceDetected = True
            Else
                    MyDeviceDetected = False
                    result = CloseHandle _
                        (HIDHandle)
            End If
        End If
        MemberIndex = MemberIndex + 1
    Loop Until (LastDevice = True) Or (MyDeviceDetected = True)
    result = SetupDiDestroyDeviceInfoList _
        (DeviceInfoSet)
    If MyDeviceDetected = True Then
        FindTheHid = True
        Call GetDeviceCapabilities
        ReadHandle = CreateFile _
                (DevicePathName, _
                (GENERIC_READ Or GENERIC_WRITE), _
                (FILE_SHARE_READ Or FILE_SHARE_WRITE), _
                Security, _
                OPEN_EXISTING, _
                FILE_FLAG_OVERLAPPED, _
                0)
        Call PrepareForOverlappedTransfer
    End If
End Function

Private Sub PrepareForOverlappedTransfer()
    If EventObject = 0 Then EventObject = CreateEvent(Security, True, True, "")
    HIDOverlapped.Offset = 0
    HIDOverlapped.OffsetHigh = 0
    HIDOverlapped.hEvent = EventObject
End Sub

Private Sub GetDeviceCapabilities()
  Dim ppData(29) As Byte
  Dim ppDataString As Variant
    result = HidD_GetPreparsedData _
        (HIDHandle, _
        PreparsedData)
    result = RtlMoveMemory _
        (ppData(0), _
        PreparsedData, _
        30)
    ppDataString = ppData()
    ppDataString = StrConv(ppDataString, vbUnicode)
    result = HidP_GetCaps _
        (PreparsedData, _
        Capabilities)
    Dim ValueCaps(1023) As Byte
    result = HidP_GetValueCaps _
        (HidP_Input, _
        ValueCaps(0), _
        Capabilities.NumberInputValueCaps, _
        PreparsedData)
    result = HidD_FreePreparsedData _
        (PreparsedData)
End Sub

Private Function GetDataString(Address As Long, Bytes As Long) As String
 Dim Offset As Integer
 Dim result$
 Dim ThisByte As Byte
    For Offset = 0 To Bytes - 1
        Call RtlMoveMemory(ByVal VarPtr(ThisByte), ByVal Address + Offset, 1)
        If (ThisByte And &HF0) = 0 Then
            result$ = result$ & "0"
        End If
        result$ = result$ & Hex$(ThisByte) & " "
    Next Offset
    GetDataString = result$
End Function

