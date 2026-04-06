; TEC-1G GLCD demo (MON-3 layout, RAM @ 0x4000).
; Uses the MON-3 GLCD library (ST7920 graphics mode).
        ORG     0x4000

GLCD_INST:  .equ    07H
GLCD_DATA:  .equ    87H

START:
        CALL    initLCD
        CALL    clearGBUF

        ; Border box
        LD      B,00H
        LD      C,00H
        LD      D,7FH
        LD      E,3FH
        CALL    drawBox

        ; Diagonal line
        LD      B,00H
        LD      C,00H
DIAG:
        CALL    drawPixel
        INC     B
        INC     C
        LD      A,C
        CP      40H
        JR      NZ,DIAG

        CALL    plotToLCD

HALT_LOOP:
        JR      HALT_LOOP

        .include "lib/glcd_defs.z80"
        .include "lib/glcd_library.z80"
