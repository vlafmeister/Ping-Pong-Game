; PING PONG GAME

        ORG     0
START:  LD      A, #80H         ; initialize paddle position
        LD      (PADDLE), A
        LD      A, #80H         ; initialize ball position
        LD      (BALL), A
        LD      A, #01H         ; initialize ball direction
        LD      (BALLDIR), A
        LD      A, #00H         ; initialize score
        LD      (SCORE), A

LOOP:   CALL    READSW          ; read paddle switch input
        LD      A, (PADDLE)
        CP      #01H            ; check if paddle is at left edge
        JR      Z, LEFTEDGE
        CP      #FEH            ; check if paddle is at right edge
        JR      Z, RIGHTEDGE
        JR      CONT

LEFTEDGE:    LD  A, #02H         ; move paddle to right
            LD  (PADDLE), A
            JR  CONT

RIGHTEDGE:   LD  A, #7DH         ; move paddle to left
            LD  (PADDLE), A
            JR  CONT

CONT:   CALL    MOVEBALL        ; move ball
        CALL    DRAW           ; draw paddle and ball
        CALL    SCOREUP        ; update score if ball hits paddle
        JR      LOOP

; Subroutine to read paddle switch input
READSW: LD      A, (#FF00)
        CPL
        AND     #00000011B
        RET

; Subroutine to move ball
MOVEBALL:
        LD      A, (BALL)
        LD      B, (BALLDIR)
        ADD     B
        CP      #01H            ; check if ball hits right wall
        JR      Z, HITRIGHT
        CP      #7FH            ; check if ball hits left wall
        JR      Z, HITLEFT
        CP      #00H            ; check if ball hits paddle
        JR      Z, HITPADDLE
        JR      NOHIT

HITRIGHT:    LD  A, #7EH         ; change ball direction to left
            LD  (BALLDIR), A
            JR  NOHIT

HITLEFT:     LD  A, #01H         ; change ball direction to right
            LD  (BALLDIR), A
            JR  NOHIT

HITPADDLE:   LD  A, #FEH         ; change ball direction to right
            LD  (BALLDIR), A
            LD  A, (PADDLE)      ; move ball up by 1
            DEC A
            LD  (BALL), A
            JR  NOHIT

NOHIT:  LD      A, (BALL)
        LD      B, (BALLDIR)
        ADD     B
        LD      (BALL), A
        RET

; Subroutine to draw paddle and ball
DRAW:   LD      A, (PADDLE)
        LD      (#FF01), A      ; draw paddle
        LD      A, (BALL)
        LD      (#FF02), A      ; draw ball
        RET

; Subroutine to update score if ball hits paddle
SCOREUP:LD      A, (BALL)
        CP      #FFH            ; check if ball hits top wall
        JR      NZ, NOSCORE
        LD      A, (SCORE)
        INC     A
        LD      (SCORE), A
NOSCORE:RET

; Variables
PADDLE
