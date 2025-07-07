#Persistent
SetBatchLines, -1
SetKeyDelay, 0, 0
SetControlDelay, 0
SetMouseDelay, 0
SetWinDelay, 0
SendMode, Input

~LShift::
    while GetKeyState("LShift", "P")
    {
        SendInput, {Blind}{LShift down}{L down}{L up}{LShift up}
    }
return
