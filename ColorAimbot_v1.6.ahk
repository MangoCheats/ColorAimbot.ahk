#NoEnv
#SingleInstance, Force
#Persistent
SetBatchLines, -1
ListLines, Off
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
Process, Priority, % DllCall("GetCurrentProcessId"), High

; --- Configuration Variables ---

; IMPORTANT: targetColor - Set to your hex code other wise aimbot will not work
targetColor := 0x000000 ; Black default
colorVariation := 50    ; Reduced variation for a very specific color match.
fov := 100               ; Field of View: Defines the square search area around the crosshair (pixels)

; --- "ONE-SHOT LOCK ON" SETTINGS ---
; These settings ensure an immediate, aggressive snap to the target.
; Smoothing is set very high (near 1.0) for a direct movement.
lockOnSmoothing := 0.29 ; Extremely high for a direct, immediate snap.

; Mouse Event Constants (for DllCall)
MOUSEEVENTF_MOVE := 0x0001

; --- Calculate Center of Screen ---
CenterX := A_ScreenWidth // 2
CenterY := A_ScreenHeight // 2

; --- Main Loop ---
Loop {
    ; Wait for the Right Mouse Button to be pressed down.
    ; The script will only attempt to lock on *once* per press.
    KeyWait, RButton, D

    ; Once RButton is pressed, attempt to find target and move.
    ; This part will execute only once per RButton press because we're not
    ; using a 'While GetKeyState("RButton", "P")' loop here for continuous movement.
    ScanL := CenterX - fov
    ScanT := CenterY - fov
    ScanR := CenterX + fov
    ScanB := CenterY + fov

    PixelSearch, AimX, AimY, ScanL, ScanT, ScanR, ScanB, targetColor, colorVariation, Fast RGB

    if (!ErrorLevel) {
        ; Target found, calculate movement for a direct snap
        dx := AimX - CenterX
        dy := AimY - CenterY

        ; Apply the lockOnSmoothing for an immediate, near-full move
        moveX := Round(dx * lockOnSmoothing)
        moveY := Round(dy * lockOnSmoothing)

        ; Only move if there's an actual movement needed
        if (moveX != 0 || moveY != 0) {
            DllCall("mouse_event", "UInt", MOUSEEVENTF_MOVE, "Int", moveX, "Int", moveY, "UInt", 0, "UInt", 0)
        }
    }
    ; After attempting the move (or if no target found), the script will
    ; loop back to KeyWait, RButton, D, effectively waiting for the RButton
    ; to be released and pressed again for another snap.
}
