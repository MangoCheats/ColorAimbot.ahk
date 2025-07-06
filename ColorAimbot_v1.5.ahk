version = 1.5
#NoEnv
#SingleInstance, Force
#Persistent
SetBatchLines, -1
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
Process, Priority, % DllCall("GetCurrentProcessId"), High

targetColor := 0x000000
colorVariation := 50
fov := 100
smoothing := 0.3

ZeroX := A_ScreenWidth // 2
ZeroY := A_ScreenHeight // 2
ScanL := ZeroX - fov
ScanT := ZeroY - fov
ScanR := ZeroX + fov
ScanB := ZeroY + fov

Loop {
    KeyWait, RButton, D
    While GetKeyState("RButton", "P") {
        PixelSearch, AimX, AimY, ScanL, ScanT, ScanR, ScanB, targetColor, colorVariation, Fast RGB
        if (!ErrorLevel) {
            MoveX := Floor((AimX - ZeroX) * smoothing)
            MoveY := Floor((AimY - ZeroY) * smoothing)
            if (MoveX != 0 || MoveY != 0)
                DllCall("mouse_event", "UInt", 1, "Int", MoveX, "Int", MoveY, "UInt", 0, "UInt", 0)
        }
    }
}
