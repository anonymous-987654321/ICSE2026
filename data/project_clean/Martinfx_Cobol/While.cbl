       IDENTIFICATION DIVISION.
       PROGRAM-ID. WHILE.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01 W-I PIC 99 VALUE 20.
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM WHILE-LOOP.
           GOBACK.
           WHILE-LOOP SECTION.
           PERFORM UNTIL W-I <= 0
             DISPLAY W-I
             COMPUTE W-I = W-I - 1
           END-PERFORM.
