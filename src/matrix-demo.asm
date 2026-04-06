; TEC-1G 8x8 matrix demo (MON-3 layout, RAM @ 0x4000).
; - Uses the current TEC-1G mono 8x8 ports:
;     OUT 0x06 = column data latch
;     OUT 0x05 = row select
; - Continuously rescans the rows with a delay so the display only persists
;   when refreshed, which is a better baseline for scan-aware emulation.

        ORG     0x4000

PORT_ROW:       EQU     0x05
PORT_DATA:      EQU     0x06
ROW_COUNT:      EQU     8
ROLL_FRAMES:    EQU     8

START:  LD      C,0x01
        LD      E,ROLL_FRAMES

FRAME:  LD      HL,ROW_DATA
        LD      D,C
        LD      B,ROW_COUNT
ROWLP:  LD      A,(HL)
        OUT     (PORT_DATA),A
        LD      A,D
        OUT     (PORT_ROW),A
        CALL    DELAY
        INC     HL
        RLC     D
        DJNZ    ROWLP

        DEC     E
        JR      NZ, FRAME
        LD      E,ROLL_FRAMES
        RLC     C
        JR      FRAME

DELAY:  PUSH    BC
        LD      B,0xFF
D1:     DJNZ    D1
        POP     BC
        RET

ROW_DATA:
        DB      %00111100
        DB      %01000010
        DB      %10100101
        DB      %10000001
        DB      %10100101
        DB      %10011001
        DB      %01000010
        DB      %00111100
