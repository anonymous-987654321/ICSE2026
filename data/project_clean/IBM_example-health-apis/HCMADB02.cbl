       IDENTIFICATION DIVISION.
       PROGRAM-ID. HCMADB02.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-HEADER.
           03 WS-EYECATCHER            PIC X(16)
                                        VALUE 'HCMADB02------WS'.
           03 WS-TRANSID               PIC X(4).
           03 WS-TERMID                PIC X(4).
           03 WS-TASKNUM               PIC 9(7).
           03 WS-FILLER                PIC X.
           03 WS-ADDR-DFHCOMMAREA      USAGE is POINTER.
           03 WS-CALEN                 PIC S9(4) COMP.
       01  WS-RESP                   PIC S9(8) COMP.
       01 HCAZERRS           PIC x(8) Value 'HCAZERRS'.
       01  WS-ABSTIME                  PIC S9(8) COMP VALUE +0.
       01  WS-TIME                     PIC X(8)  VALUE SPACES.
       01  WS-DATE                     PIC X(10) VALUE SPACES.
       01  ERROR-MSG.
           03 EM-DATE                  PIC X(8)  VALUE SPACES.
           03 FILLER                   PIC X     VALUE SPACES.
           03 EM-TIME                  PIC X(6)  VALUE SPACES.
           03 FILLER                   PIC X(9)  VALUE ' HCP1BI01'.
           03 EM-VARIABLE.
             05 FILLER                 PIC X(6)  VALUE ' PNUM='.
             05 EM-PATNUM              PIC X(10)  VALUE SPACES.
             05 FILLER                 PIC X(6)  VALUE ' MNUM='.
             05 EM-MEDNUM              PIC X(10)  VALUE SPACES.
             05 EM-SQLREQ              PIC X(16) VALUE SPACES.
             05 FILLER                 PIC X(9)  VALUE ' SQLCODE='.
             05 EM-SQLRC               PIC +9(5) USAGE DISPLAY.
       01 CA-ERROR-MSG.
           03 FILLER                PIC X(9)  VALUE 'COMMAREA='.
           03 CA-DATA               PIC X(90) VALUE SPACES.
       01  WS-COMMAREA-LENGTHS.
           03 WS-CA-HEADER-LEN         PIC S9(4) COMP VALUE +18.
           03 WS-REQUIRED-CA-LEN       PIC S9(4)      VALUE +0.
       01  WS-NUM-DATE-FIELDS.
             05  WS-WORKING-DATE          PIC  9(8).
             05  WS-START-NUM-DATE.
                 10  WS-START-NUM-YEAR    PIC  9(4).
                 10  WS-START-NUM-MONTH   PIC  9(2).
                 10  WS-START-NUM-DAY     PIC  9(2).
             05  WS-START-NUM-TIME.
                 10  WS-START-NUM-HOUR    PIC  9(2).
                 10  WS-START-NUM-MINUTE  PIC  9(2).
                 10  WS-START-NUM-SECOND  PIC  9(2).
                 10  WS-START-NUM-MS      PIC  9(2).
             05  WS-END-NUM-DATE.
                 10  WS-END-NUM-YEAR    PIC  9(4).
                 10  WS-END-NUM-MONTH   PIC  9(2).
                 10  WS-END-NUM-DAY     PIC  9(2).
             05  WS-END-NUM-TIME.
                 10  WS-END-NUM-HOUR    PIC  9(2).
                 10  WS-END-NUM-MINUTE  PIC  9(2).
                 10  WS-END-NUM-SECOND  PIC  9(2).
                 10  WS-END-NUM-MS      PIC  9(2).
             05  WS-INTEGER-START-DATE   PIC 9(8).
             05  WS-INTEGER-END-DATE     PIC 9(8).
       01  DB2-OUT.
           03 DB2-PRESCRIPTION-ID-INT  PIC S9(9) COMP.
           03 DB2-PATIENT-ID           PIC S9(9) COMP.
           03 DB2-TIMESTAMP            PIC X(19).
           03 DB2-TAKEN                PIC X.
           EXEC SQL
               INCLUDE SQLCA
           END-EXEC.
       LINKAGE SECTION.
       01  DFHCOMMAREA.
           EXEC SQL
             INCLUDE HCCMAREA
           END-EXEC.
       PROCEDURE DIVISION.
       MAINLINE SECTION.
       REG-100-COMMON-CODE.
           INITIALIZE WS-HEADER.
           MOVE EIBTRNID TO WS-TRANSID.
           MOVE EIBTRMID TO WS-TERMID.
           MOVE EIBTASKN TO WS-TASKNUM.
           INITIALIZE DB2-OUT.
       REG-120-PROCESS-COMMAREA.
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
           MOVE CA-PATIENT-ID TO DB2-PATIENT-ID.
           MOVE CA-PRESCRIPTION-ID TO DB2-PRESCRIPTION-ID-INT.
           MOVE 'N' TO DB2-TAKEN.
       REG-150-PROCESS-DATES.
           MOVE CA-START-DATE (1:4) TO  WS-START-NUM-YEAR
           MOVE CA-START-DATE (6:2) TO  WS-START-NUM-MONTH
           MOVE CA-START-DATE (9:2) TO  WS-START-NUM-DAY
           MOVE CA-END-DATE (1:4) TO  WS-END-NUM-YEAR
           MOVE CA-END-DATE (6:2) TO  WS-END-NUM-MONTH
           MOVE CA-END-DATE (9:2) TO  WS-END-NUM-DAY
           MOVE WS-START-NUM-DATE TO  WS-WORKING-DATE
           COMPUTE WS-INTEGER-START-DATE =
                   FUNCTION INTEGER-OF-DATE (WS-WORKING-DATE)
           MOVE WS-END-NUM-DATE TO  WS-WORKING-DATE
           COMPUTE WS-INTEGER-END-DATE =
                   FUNCTION INTEGER-OF-DATE (WS-WORKING-DATE)
           PERFORM UNTIL WS-INTEGER-START-DATE > WS-INTEGER-END-DATE
               COMPUTE WS-WORKING-DATE =
                       FUNCTION DATE-OF-INTEGER (WS-INTEGER-START-DATE)
               MOVE WS-WORKING-DATE TO WS-START-NUM-DATE
               EVALUATE CA-FREQUENCY
                  WHEN 1
                    MOVE 12000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                  WHEN 2
                    MOVE 08000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                    MOVE 20000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                  WHEN 3
                    MOVE 08000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                    MOVE 14000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                    MOVE 20000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                  WHEN 4
                    MOVE 08000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                    MOVE 12000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                    MOVE 16000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
                    MOVE 20000000 TO WS-START-NUM-TIME
                    PERFORM INSERT-PRESCRIPTION
               END-EVALUATE
               ADD 1 TO WS-INTEGER-START-DATE
           END-PERFORM.
           EXEC CICS RETURN END-EXEC.
       MAINLINE-EXIT.
           EXIT.
       FORMAT-TIMESTAMP.
           MOVE WS-START-NUM-YEAR   TO DB2-TIMESTAMP(1:4)
           MOVE '-'                 TO DB2-TIMESTAMP(5:1)
           MOVE WS-START-NUM-MONTH  TO DB2-TIMESTAMP(6:2)
           MOVE '-'                 TO DB2-TIMESTAMP(8:1)
           MOVE WS-START-NUM-DAY    TO DB2-TIMESTAMP(9:2)
           MOVE SPACE               TO DB2-TIMESTAMP (11:1)
           MOVE WS-START-NUM-HOUR   TO DB2-TIMESTAMP(12:2)
           MOVE ':'                 TO DB2-TIMESTAMP(14:1)
           MOVE WS-START-NUM-MINUTE TO DB2-TIMESTAMP(15:2)
           MOVE ':'                 TO DB2-TIMESTAMP(17:1)
           MOVE WS-START-NUM-SECOND TO DB2-TIMESTAMP(18:2)
           EXIT.
       INSERT-PRESCRIPTION.
           MOVE ' INSERT PRESCRIPTION' TO EM-SQLREQ
           PERFORM FORMAT-TIMESTAMP
             EXEC SQL
               INSERT INTO PRESCRIPTION
                         ( PRESCRIPTIONID,
                           PATIENTID,
                           PDATETIME,
                           TAKEN )
                  VALUES ( :DB2-PRESCRIPTION-ID-INT,
                           :DB2-PATIENT-ID,
                           :DB2-TIMESTAMP,
                           :DB2-TAKEN )
             END-EXEC
             IF SQLCODE NOT EQUAL 0
               MOVE '90' TO CA-RETURN-CODE
               PERFORM WRITE-ERROR-MESSAGE
               EXEC CICS RETURN END-EXEC
             END-IF.
           EXIT.
       WRITE-ERROR-MESSAGE.
           EXEC CICS ASKTIME ABSTIME(WS-ABSTIME)
           END-EXEC
           EXEC CICS FORMATTIME ABSTIME(WS-ABSTIME)
                     MMDDYYYY(WS-DATE)
                     TIME(WS-TIME)
           END-EXEC
           MOVE WS-DATE TO EM-DATE
           MOVE WS-TIME TO EM-TIME
           EXEC CICS LINK PROGRAM(HCAZERRS)
                     COMMAREA(ERROR-MSG)
                     LENGTH(LENGTH OF ERROR-MSG)
           END-EXEC.
           IF EIBCALEN > 0 THEN
             IF EIBCALEN < 91 THEN
               MOVE DFHCOMMAREA(1:EIBCALEN) TO CA-DATA
               EXEC CICS LINK PROGRAM(HCAZERRS)
                         COMMAREA(CA-ERROR-MSG)
                         LENGTH(LENGTH OF CA-ERROR-MSG)
               END-EXEC
             ELSE
               MOVE DFHCOMMAREA(1:90) TO CA-DATA
               EXEC CICS LINK PROGRAM(HCAZERRS)
                         COMMAREA(CA-ERROR-MSG)
                         LENGTH(LENGTH OF CA-ERROR-MSG)
               END-EXEC
             END-IF
           END-IF.
           EXIT.
