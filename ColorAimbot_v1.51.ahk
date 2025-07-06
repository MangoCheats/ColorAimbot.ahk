#NoEnv
#SingleInstance, Force
#Persistent
SetBatchLines, -1
ListLines, Off
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
Process, Priority, % DllCall("GetCurrentProcessId"), High

; ===== CONFIG =====
targetColor := 0xFF67FF        ; Adjust based on enemy glow
colorVariation := 40           ; Tolerance for glow shift
fov := 70                      ; Field of view radius
smoothing := 0.38              ; Lower = faster (0.08–0.15 good range)
; ===================

CenterX := A_ScreenWidth // 2
CenterY := A_ScreenHeight // 2

Loop {
    KeyWait, RButton, D
    While GetKeyState("RButton", "P") {
        ; PixelSearch box
        ScanL := CenterX - fov
        ScanT := CenterY - fov
        ScanR := CenterX + fov
        ScanB := CenterY + fov

        PixelSearch, AimX, AimY, ScanL, ScanT, ScanR, ScanB, targetColor, colorVariation, Fast RGB

        if (!ErrorLevel) {
            dx := AimX - CenterX
            dy := AimY - CenterY

            ; Only move if outside deadzone
            if (Abs(dx) > 1 || Abs(dy) > 1) {
                moveX := Round(dx * smoothing)
                moveY := Round(dy * smoothing)
                DllCall("mouse_event", "UInt", 1, "Int", moveX, "Int", moveY, "UInt", 0, "UInt", 0)
            }
        }
    }
}
