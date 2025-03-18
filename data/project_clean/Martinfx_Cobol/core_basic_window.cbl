       IDENTIFICATION DIVISION.
       PROGRAM-ID. CORE-BASIC-WINDOW.
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
            ON EXCEPTION
            DISPLAY "exception error: raylib not found"
            UPON SYSERR
            END-DISPLAY
         END-CALL
         CALL "SetTargetFPS" USING BY VALUE 60
           RETURNING OMITTED
         END-CALL.
       MAIN-LOOP SECTION.
         PERFORM UNTIL ESC-KEY = 1
          CALL "WindowShouldClose"
            RETURNING ESC-KEY
          END-CALL
          CALL STATIC "BeginDrawing"
            RETURNING OMITTED
          END-CALL
          CALL "ClearBackground" USING BY REFERENCE W-COLOR-WHITE
            RETURNING OMITTED
          END-CALL
           CALL STATIC "DrawText" USING
             BY REFERENCE "Congrats! You created your first window!"
             BY VALUE 190 200
             BY VALUE 20
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
