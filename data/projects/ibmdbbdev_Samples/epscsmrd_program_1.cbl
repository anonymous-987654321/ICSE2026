       IDENTIFICATION DIVISION.
        PROGRAM-ID. 'EPSCSMRF'.
        AUTHOR. WD4Z.
        INSTALLATION. 9.0.0.V200809191411.
        DATE-WRITTEN. 1/19/09 2:11 PM
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       1 CONVERTER-ERROR-5.
       2 PIC X(31) USAGE DISPLAY
           VALUE 'Failed To Get Exception Message'.
       LOCAL-STORAGE SECTION.
       1 MSG-PTR PIC S9(9) COMP.
       1 MSG-PART PIC X(80).
       1 MSG-OFFSET PIC 9(9) COMP.
       1 MSG-PART-LENGTH PIC 9(9) COMP.
       1 FEEDBACK-CODE.
       2 CONDITION-TOKEN-VALUE.
       88 CEE000 VALUE X'0000000000000000'.
       88 CEE0E7 VALUE X'000101C749C3C5C5'.
       3 SEVERITY PIC S9(4) BINARY.
       3 MSG-NO PIC S9(4) BINARY.
       3 CASE-SEV-CTL PIC X.
       3 FACILITY PIC XXX.
       2 I-S-INFO PIC S9(9) BINARY.
       LINKAGE SECTION.
       1 TOKEN POINTER.
       1 RESULT PIC S9(9) BINARY.
       88 RESUME VALUE 10.
       1 CURRENT-CONDITION.
       2 CONDITION-TOKEN-VALUE.
       88 CEE000 VALUE X'0000000000000000'.
       88 CEE0E7 VALUE X'000101C749C3C5C5'.
       3 SEVERITY PIC S9(4) BINARY.
       3 MSG-NO PIC S9(4) BINARY.
       3 CASE-SEV-CTL PIC X.
       3 FACILITY PIC XXX.
       2 I-S-INFO PIC S9(9) BINARY.
       1 NEW-CONDITION PIC X(12).
       1 ERROR-CDATA-PTR PIC X(512).
       1 ERROR-RESPONSE.
       2 ERROR-OCCURRED PIC X.
       2 ERROR-MESSAGE-NUMBER PIC 9(9).
       2 ERROR-REASON-LENGTH PIC 9(9) BINARY.
       2 ERROR-REASON PIC X(512).
       PROCEDURE DIVISION USING CURRENT-CONDITION TOKEN
           RESULT NEW-CONDITION.
       MAINLINE SECTION.
           SET ADDRESS OF ERROR-RESPONSE TO TOKEN
           PERFORM FILL-DESCRIPTION-BUFFER
           PERFORM DISPLAY-MESSAGE-TEXT
           MOVE 'Y' TO ERROR-OCCURRED
           SET RESUME TO TRUE
           GOBACK
           .
       FILL-DESCRIPTION-BUFFER.
           MOVE 0 TO MSG-PTR
           MOVE 512 TO ERROR-REASON-LENGTH
           MOVE SPACES TO MSG-PART ERROR-REASON
           CALL 'CEEMGET' USING
             CURRENT-CONDITION MSG-PART
             MSG-PTR FEEDBACK-CODE
           IF NOT CEE000 OF FEEDBACK-CODE AND
              NOT CEE0E7 OF FEEDBACK-CODE
            DISPLAY CONVERTER-ERROR-5
           END-IF
           IF NOT CEE0E7 OF FEEDBACK-CODE
            PERFORM COMPUTE-PART-LENGTH
            MOVE MSG-PART-LENGTH TO ERROR-REASON-LENGTH
            MOVE MSG-PART TO ERROR-REASON
           ELSE
            MOVE MSG-PART TO ERROR-REASON
            MOVE MSG-PTR TO MSG-OFFSET
            PERFORM UNTIL MSG-PTR = 0
             MOVE SPACES TO MSG-PART
             CALL 'CEEMGET' USING
              CURRENT-CONDITION MSG-PART
              MSG-PTR FEEDBACK-CODE
             IF NOT CEE000 OF FEEDBACK-CODE AND
                NOT CEE0E7 OF FEEDBACK-CODE
              DISPLAY CONVERTER-ERROR-5
             END-IF
             IF MSG-PTR NOT = 0
              MOVE MSG-PART TO
               ERROR-REASON(MSG-OFFSET + 1:MSG-PTR)
              ADD MSG-PTR TO MSG-OFFSET
             ELSE
              PERFORM COMPUTE-PART-LENGTH
              MOVE MSG-PART TO
               ERROR-REASON(MSG-OFFSET + 1:MSG-PART-LENGTH)
              ADD MSG-PART-LENGTH TO MSG-OFFSET
             END-IF
            END-PERFORM
           END-IF
           MOVE MSG-NO OF CURRENT-CONDITION TO
            ERROR-MESSAGE-NUMBER
           MOVE MSG-OFFSET TO ERROR-REASON-LENGTH
           .
       COMPUTE-PART-LENGTH.
           PERFORM VARYING MSG-PART-LENGTH FROM 80 BY -1
            UNTIL MSG-PART(MSG-PART-LENGTH:1) NOT = SPACE
            OR MSG-PART-LENGTH < 1
           END-PERFORM
           .
       DISPLAY-MESSAGE-TEXT.
           DISPLAY ERROR-REASON(1:ERROR-REASON-LENGTH)
           .
       END PROGRAM 'EPSCSMRF'.
