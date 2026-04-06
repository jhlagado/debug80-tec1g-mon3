; GLCD Text Mode Demo
; -------------------
; Demonstrates ST7920 native text mode (DDRAM writes).
; Writes characters directly to the ST7920 text layer
; without using the graphics buffer.
;
; Uses: A, B, C, HL

        ORG 4000H

        .include "lib/mon3_api.z80"

; GLCD Graphics Library function indices (RST 18H dispatch)
G_INIT_LCD:     EQU 0
G_CLEAR_TXT_LCD: EQU 3
G_SET_TXT_MODE: EQU 5
G_PRINT_STRING: EQU 13
G_PRINT_CHARS:  EQU 14

START:
        LD      A,G_INIT_LCD    ; Initialise the 128x64 LCD
        RST     18H

        ; Clear text layer
        LD      A,G_CLEAR_TXT_LCD
        RST     18H

        ; --- Row 0: Title ---
        LD      C,0             ; Row 0
        LD      A,G_PRINT_STRING
        RST     18H
        DB      " TEC-1G GLCD Text ",0

        ; --- Row 1: Subtitle ---
        LD      C,1             ; Row 1
        LD      A,G_PRINT_STRING
        RST     18H
        DB      "ST7920 128x64 LCD ",0

        ; --- Row 2: Character showcase ---
        LD      C,2             ; Row 2
        LD      A,G_PRINT_STRING
        RST     18H
        DB      "ABCDEFGHIJKLMNOP",0

        ; --- Row 3: More characters ---
        LD      C,3             ; Row 3
        LD      A,G_PRINT_STRING
        RST     18H
        DB      "0123456789 !@#$%",0

DONE:
        JP      DONE
