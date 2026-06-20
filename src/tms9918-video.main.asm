; Debug80 TMS9918 smoke test (TEC-1G)
; Origin    : 4000h
; VDP ports : data=$BE, control=$BF
;
; This is intentionally minimal. It configures Graphics I mode, defines one
; visible checkerboard tile, fills the 32x24 name table with that tile, then
; waits forever. A working TMS9918 panel should show a blue/white checkerboard.

VDP_DATA        .equ 0BEh
VDP_CONTROL     .equ 0BFh

VRAM_PATTERN    .equ 0000h
VRAM_NAME       .equ 0800h
VRAM_COLOR      .equ 2000h
VRAM_SPRITE_ATTR .equ 1B00h
VRAM_SPRITE_PAT .equ 3800h

        .org    04000h

Start:
        ld      sp,07fffh
        call    InitVdp
        call    LoadPattern
        call    LoadColor
        call    FillNameTable

Forever:
        jr      Forever

InitVdp:
        ld      hl,VdpRegisters
        ld      b,8
        ld      c,0

InitVdpLoop:
        ld      a,(hl)
        out     (VDP_CONTROL),a
        ld      a,c
        or      080h
        out     (VDP_CONTROL),a
        inc     hl
        inc     c
        djnz    InitVdpLoop
        ret

LoadPattern:
        ld      hl,VRAM_PATTERN + 8
        call    SetWriteAddress
        ld      hl,CheckerPattern
        ld      b,8

LoadPatternLoop:
        ld      a,(hl)
        out     (VDP_DATA),a
        inc     hl
        djnz    LoadPatternLoop
        ret

LoadColor:
        ld      hl,VRAM_COLOR
        call    SetWriteAddress
        ld      b,32
        ld      a,0F4h          ; white foreground, dark blue background

LoadColorLoop:
        out     (VDP_DATA),a
        djnz    LoadColorLoop
        ret

FillNameTable:
        ld      hl,VRAM_NAME
        call    SetWriteAddress
        ld      bc,0300h        ; 32 columns * 24 rows
        ld      a,1             ; tile 1 = checker pattern

FillNameLoop:
        out     (VDP_DATA),a
        dec     bc
        ld      d,a
        ld      a,b
        or      c
        ld      a,d
        jr      nz,FillNameLoop
        ret

SetWriteAddress:
        ld      a,l
        out     (VDP_CONTROL),a
        ld      a,h
        or      040h
        out     (VDP_CONTROL),a
        ret

; R0 = 00h  Graphics I
; R1 = C0h  display on, 16 KiB VRAM, 8x8 sprites
; R2 = 02h  name table @ 0800h
; R3 = 80h  color table @ 2000h
; R4 = 00h  pattern table @ 0000h
; R5 = 36h  sprite attribute table @ 1B00h
; R6 = 07h  sprite pattern table @ 3800h
; R7 = 04h  backdrop = dark blue
VdpRegisters:
        .db     000h,0C0h,002h,080h,000h,036h,007h,004h

CheckerPattern:
        .db     0AAh,055h,0AAh,055h,0AAh,055h,0AAh,055h
