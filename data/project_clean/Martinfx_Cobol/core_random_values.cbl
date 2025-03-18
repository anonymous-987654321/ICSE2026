       IDENTIFICATION DIVISION.
       PROGRAM-ID. CORE-RANDOM-VALUES.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       REPOSITORY.
           FUNCTION ALL INTRINSIC.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 R-CODE USAGE BINARY-LONG.
       01 ESC-KEY PIC 9(8).
       01 SRC-WIDTH PIC 999 VALUE 800.
       01 SRC-HEIGHT PIC 999 VALUE 450.
       01 W-NAME PIC X(25) VALUE "Hello raylib from Cobol".
       01 FRAME-COUNTER PIC 999 VALUE 0.
       01 RAN-NUM USAGE BINARY-LONG.
       01 RAN-TXT PIC X(9).
       01 RESULT PIC 999 VALUE 0.
       01 W-COLOR-WHITE.
         02 W-R PIC S9(3) VALUE 245 BINARY.
         02 W-G PIC S9(3) VALUE 245 BINARY.
         02 W-B PIC S9(3) VALUE 245 BINARY.
         02 W-A PIC S9(3) VALUE 255 BINARY.
       01 W-COLOR-LIGHTGRAY.
         02 W-R PIC S9(3) VALUE 200 BINARY.
         02 W-G PIC S9(3) VALUE 200 BINARY.
         02 W-B PIC S9(3) VALUE 200 BINARY.
         02 W-A PIC S9(3) VALUE 255 BINARY.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
       PERFORM INIT-WINDOW.
       PERFORM MAIN-LOOP.
       PERFORM CLOSE-WINDOW.
       GOBACK.
       INIT-WINDOW SECTION.
         CALL "InitWindow" USING
          BY VALUE SRC-WIDTH SRC-HEIGHT
          BY REFERENCE W-NAME RETURNING R-CODE
            ON EXCEPTION DISPLAY "exception error: raylib not found"
            UPON SYSERR
            END-DISPLAY
         END-CALL
         CALL "GetRandomValue" USING
           BY VALUE -8
           BY VALUE 5
           RETURNING RAN-NUM
         END-CALL
         CALL "SetTargetFPS" USING BY VALUE 60
           RETURNING OMITTED
         END-CALL.
       MAIN-LOOP SECTION.
         PERFORM UNTIL ESC-KEY = 1
          CALL "WindowShouldClose"
            RETURNING ESC-KEY
          END-CALL
          ADD 1 TO FRAME-COUNTER
          END-ADD
          COMPUTE
            RESULT = FUNCTION MOD((FRAME-COUNTER / 120), 2)
          END-COMPUTE
          IF RESULT = 1
            CALL "GetRandomValue" USING
            BY VALUE -8
            BY VALUE 5
            RETURNING RAN-NUM
            END-CALL
            MOVE 0 TO FRAME-COUNTER
          END-IF
          CALL STATIC "BeginDrawing"
            RETURNING OMITTED
          END-CALL
          CALL "ClearBackground" USING BY REFERENCE W-COLOR-WHITE
            RETURNING OMITTED
          END-CALL
          CALL STATIC "DrawText" USING
           BY REFERENCE "Every 2 sec a new random value is generated:"
           BY VALUE 190 200
           BY VALUE 20
           BY CONTENT W-COLOR-LIGHTGRAY
           RETURNING OMITTED
          END-CALL
           MOVE RAN-NUM to RAN-TXT
          CALL STATIC "DrawText" USING
           BY REFERENCE RAN-TXT(9:1)
           BY VALUE 360 220
           BY VALUE 80
           BY CONTENT W-COLOR-LIGHTGRAY
           RETURNING OMITTED
          END-CALL
          CALL STATIC "EndDrawing"
            RETURNING OMITTED
          END-CALL
         END-PERFORM.
       CLOSE-WINDOW SECTION.
         CALL "CloseWindow"
           RETURNING OMITTED
         END-CALL.
