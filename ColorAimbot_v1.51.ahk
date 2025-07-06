version = 1.51
#NoEnv
#SingleInstance, Force
#Persistent
SetBatchLines, -1
ListLines, Off
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
Process, Priority, % DllCall("GetCurrentProcessId"), High

; ===== CONFIG =====
targetColor := 0xFF67FF        ; Adjust based on glow/skin
colorVariation := 50           ; Very tight to avoid false locks
fov := 100                     ; Large FOV to catch targets fast
smoothing := 0.38              ; MAX snap strength (lower = harder)
; ===================

CenterX := A_ScreenWidth // 2
CenterY := A_ScreenHeight // 2

Loop {
    KeyWait, RButton, D
    While GetKeyState("RButton", "P") {
        ScanL := CenterX - fov
        ScanT := CenterY - fov
        ScanR := CenterX + fov
        ScanB := CenterY + fov

        PixelSearch, AimX, AimY, ScanL, ScanT, ScanR, ScanB, targetColor, colorVariation, Fast RGB
        if (!ErrorLevel) {
            dx := AimX - CenterX
            dy := AimY - CenterY

            moveX := Floor(dx * smoothing)
            moveY := Floor(dy * smoothing)

            DllCall("mouse_event", "UInt", 1, "Int", moveX, "Int", moveY, "UInt", 0, "UInt", 0)
        }
    }
}
