       IDENTIFICATION DIVISION.
       PROGRAM-ID. HCMABA01.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
        01  WS-HEADER.
           03 WS-EYECATCHER            PIC X(16)
                                        VALUE 'HCMABA01------WS'.
           03 WS-TRANSID               PIC X(4).
           03 WS-TERMID                PIC X(4).
           03 WS-TASKNUM               PIC 9(7).
           03 WS-FILLER                PIC X.
           03 WS-ADDR-DFHCOMMAREA      USAGE is POINTER.
           03 WS-CALEN                 PIC S9(4) COMP.
       COPY HCERRSWS.
       01  WS-COMMAREA-LENGTHS.
           03 WS-CA-HEADER-LEN         PIC S9(4) COMP VALUE +18.
           03 WS-REQUIRED-CA-LEN       PIC S9(4)      VALUE +0.
       77  HCMADB01                    PIC X(8)       VALUE 'HCMADB01'.
       77  HCMADB02                    PIC X(8)       VALUE 'HCMADB02'.
       LINKAGE SECTION.
       01  DFHCOMMAREA.
             COPY HCCMAREA.
       PROCEDURE DIVISION.
       MAINLINE SECTION.
           INITIALIZE WS-HEADER.
           MOVE EIBTRNID TO WS-TRANSID.
           MOVE EIBTRMID TO WS-TERMID.
           MOVE EIBTASKN TO WS-TASKNUM.
           IF EIBCALEN IS EQUAL TO ZERO
               MOVE ' NO COMMAREA RECEIVED' TO EM-VARIABLE
               PERFORM WRITE-ERROR-MESSAGE
               EXEC CICS ABEND ABCODE('HCCA') NODUMP END-EXEC
           END-IF
           MOVE '00' TO CA-RETURN-CODE
           MOVE EIBCALEN TO WS-CALEN.
           SET WS-ADDR-DFHCOMMAREA TO ADDRESS OF DFHCOMMAREA.
           ADD WS-CA-HEADER-LEN TO WS-REQUIRED-CA-LEN
           IF EIBCALEN IS LESS THAN WS-REQUIRED-CA-LEN
             MOVE '98' TO CA-RETURN-CODE
             EXEC CICS RETURN END-EXEC
           END-IF
           PERFORM INSERT-MEDICATION.
           If CA-RETURN-CODE > 0
             EXEC CICS RETURN END-EXEC
           ELSE
             PERFORM INSERT-PRESCRIPTION
           End-if.
       MAINLINE-END.
           EXEC CICS RETURN END-EXEC.
       MAINLINE-EXIT.
           EXIT.
       INSERT-MEDICATION.
           EXEC CICS LINK Program(HCMADB01)
                Commarea(DFHCOMMAREA)
                LENGTH(32500)
           END-EXEC.
           EXIT.
       INSERT-PRESCRIPTION.
           EXEC CICS LINK Program(HCMADB02)
                Commarea(DFHCOMMAREA)
                LENGTH(32500)
           END-EXEC.
           EXIT.
       COPY HCERRSPD.