       PROCESS CICS,NODYNAM,NSYMBOL(NATIONAL),TRUNC(STD)
       IDENTIFICATION DIVISION.
        PROGRAM-ID. CSSTATUS.
        AUTHOR. GOHILPR.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
        WORKING-STORAGE SECTION.
       1 ACCOUNT-NUMBER-IN.
         2 CUST-NO-IN PIC X(4).
       1 RETURN-DATA.
         2 CUSTOMER-IMPORTANCE    PIC X(8)  VALUE ' '.
        LOCAL-STORAGE SECTION.
       1 OK                 PIC S9(8) COMP.
       1 CONTAINER-NAMES.
         2 INPUT-CONTAINER    PIC X(16) VALUE 'INPUTCONTAINER  '.
         2 CSSTATUS-CONTAINER PIC X(16) VALUE 'GETVIPSTATUS    '.
       1 PROG-NAMES.
         2 GETPOL             PIC X(8) VALUE 'GETPOL  '.
         2 GETSPND            PIC X(8) VALUE 'GETSPND '.
       1 COMMAND-RESP  PIC S9(8) COMP.
       1 COMMAND-RESP2 PIC S9(8) COMP.
        LINKAGE SECTION.
       PROCEDURE DIVISION .
       MAINLINE SECTION.
           EXEC CICS GET CONTAINER (INPUT-CONTAINER)
                           INTO    ( ACCOUNT-NUMBER-IN )
                           RESP    ( COMMAND-RESP )
                           RESP2   ( COMMAND-RESP2 )
           END-EXEC
           EXEC CICS LINK PROGRAM(GETPOL)
           END-EXEC
           EXEC CICS LINK PROGRAM(GETSPND)
           END-EXEC
           IF ACCOUNT-NUMBER-IN = '0001'
           THEN
             MOVE 'VERY VIP' TO CUSTOMER-IMPORTANCE
           ELSE
             MOVE 'REGULAR ' TO CUSTOMER-IMPORTANCE
           END-IF
           EXEC CICS PUT CONTAINER ( CSSTATUS-CONTAINER )
                           FROM    ( CUSTOMER-IMPORTANCE )
                           RESP    ( COMMAND-RESP )
                           RESP2   ( COMMAND-RESP2 )
           END-EXEC
           EXEC CICS RETURN
           END-EXEC.
       END PROGRAM 'CSSTATUS'.
