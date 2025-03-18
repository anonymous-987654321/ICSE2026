       PROCESS SQL
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LGUCDB01.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
        01  WS-HEADER.
           03 WS-EYECATCHER            PIC X(16)
                                        VALUE 'LGUCDB01------WS'.
           03 WS-TRANSID               PIC X(4).
           03 WS-TERMID                PIC X(4).
           03 WS-TASKNUM               PIC 9(7).
           03 WS-FILLER                PIC X.
           03 WS-ADDR-DFHCOMMAREA      USAGE is POINTER.
           03 WS-CALEN                 PIC S9(4) COMP.
           03 WS-RETRY                 PIC X.
       01 DB2-IN-INTEGERS.
          03 DB2-CUSTOMERNUM-INT       PIC S9(9) COMP.
          03 DB2-POLICYNUM-INT         PIC S9(9) COMP.
          03 DB2-BROKERID-INT          PIC S9(9) COMP.
          03 DB2-PAYMENT-INT           PIC S9(9) COMP.
          03 DB2-E-TERM-SINT           PIC S9(4) COMP.
          03 DB2-E-SUMASSURED-INT      PIC S9(9) COMP.
          03 DB2-H-BEDROOMS-SINT       PIC S9(4) COMP.
          03 DB2-H-VALUE-INT           PIC S9(9) COMP.
          03 DB2-M-VALUE-INT           PIC S9(9) COMP.
          03 DB2-M-CC-SINT             PIC S9(4) COMP.
          03 DB2-M-PREMIUM-INT         PIC S9(9) COMP.
          03 DB2-M-ACCIDENTS-INT       PIC S9(9) COMP.
       01  WS-ABSTIME                  PIC S9(8) COMP VALUE +0.
       01  WS-TIME                     PIC X(8)  VALUE SPACES.
       01  WS-DATE                     PIC X(10) VALUE SPACES.
       01  ERROR-MSG.
           03 EM-DATE                  PIC X(8)  VALUE SPACES.
           03 FILLER                   PIC X     VALUE SPACES.
           03 EM-TIME                  PIC X(6)  VALUE SPACES.
           03 FILLER                   PIC X(9)  VALUE ' LGUCDB01'.
           03 EM-VARIABLE.
             05 FILLER                 PIC X(6)  VALUE ' CNUM='.
             05 EM-CUSNUM              PIC X(10)  VALUE SPACES.
             05 EM-SQLREQ              PIC X(16) VALUE SPACES.
             05 FILLER                 PIC X(9)  VALUE ' SQLCODE='.
             05 EM-SQLRC               PIC +9(5) USAGE DISPLAY.
       01  CA-ERROR-MSG.
           03 FILLER                   PIC X(9)  VALUE 'COMMAREA='.
           03 CA-DATA                  PIC X(90) VALUE SPACES.
       77  LGUCVS01                    Pic X(8) Value 'LGUCVS01'.
           EXEC SQL
             INCLUDE LGPOLICY
           END-EXEC.
           EXEC SQL
             INCLUDE SQLCA
           END-EXEC.
       LINKAGE SECTION.
       01  DFHCOMMAREA.
           EXEC SQL
             INCLUDE LGCMAREA
           END-EXEC.
       PROCEDURE DIVISION.
       MAINLINE SECTION.
           INITIALIZE WS-HEADER.
           MOVE EIBTRNID TO WS-TRANSID.
           MOVE EIBTRMID TO WS-TERMID.
           MOVE EIBTASKN TO WS-TASKNUM.
           MOVE SPACES   TO WS-RETRY.
           IF EIBCALEN IS EQUAL TO ZERO
               MOVE ' NO COMMAREA RECEIVED' TO EM-VARIABLE
               PERFORM WRITE-ERROR-MESSAGE
               EXEC CICS ABEND ABCODE('LGCA') NODUMP END-EXEC
           END-IF
           MOVE '00' TO CA-RETURN-CODE
           MOVE EIBCALEN TO WS-CALEN.
           SET WS-ADDR-DFHCOMMAREA TO ADDRESS OF DFHCOMMAREA.
           MOVE CA-CUSTOMER-NUM TO DB2-CUSTOMERNUM-INT
           MOVE CA-CUSTOMER-NUM TO EM-CUSNUM
           PERFORM UPDATE-CUSTOMER-INFO.
           EXEC CICS LINK Program(LGUCVS01)
                Commarea(DFHCOMMAREA)
                LENGTH(225)
           END-EXEC.
       END-PROGRAM.
           EXEC CICS RETURN END-EXEC.
       MAINLINE-EXIT.
           EXIT.
       UPDATE-CUSTOMER-INFO.
           MOVE ' UPDATE CUST  ' TO EM-SQLREQ
             EXEC SQL
               UPDATE CUSTOMER
                 SET
                   FIRSTNAME     = :CA-FIRST-NAME,
                   LASTNAME      = :CA-LAST-NAME,
                   DATEOFBIRTH   = :CA-DOB,
                   HOUSENAME     = :CA-HOUSE-NAME,
                   HOUSENUMBER   = :CA-HOUSE-NUM,
                   POSTCODE      = :CA-POSTCODE,
                   PHONEMOBILE   = :CA-PHONE-MOBILE,
                   PHONEHOME     = :CA-PHONE-HOME,
                   EMAILADDRESS  = :CA-EMAIL-ADDRESS
                 WHERE
                     CUSTOMERNUMBER = :DB2-CUSTOMERNUM-INT
             END-EXEC
           IF SQLCODE NOT EQUAL 0
             IF SQLCODE EQUAL 100
               MOVE '01' TO CA-RETURN-CODE
             ELSE
               MOVE '90' TO CA-RETURN-CODE
               PERFORM WRITE-ERROR-MESSAGE
             END-IF
           END-IF.
           EXIT.
       WRITE-ERROR-MESSAGE.
           MOVE SQLCODE TO EM-SQLRC
           EXEC CICS ASKTIME ABSTIME(WS-ABSTIME)
           END-EXEC
           EXEC CICS FORMATTIME ABSTIME(WS-ABSTIME)
                     MMDDYYYY(WS-DATE)
                     TIME(WS-TIME)
           END-EXEC
           MOVE WS-DATE TO EM-DATE
           MOVE WS-TIME TO EM-TIME
           EXEC CICS LINK PROGRAM('LGSTSQ')
                     COMMAREA(ERROR-MSG)
                     LENGTH(LENGTH OF ERROR-MSG)
           END-EXEC.
           IF EIBCALEN > 0 THEN
             IF EIBCALEN < 91 THEN
               MOVE DFHCOMMAREA(1:EIBCALEN) TO CA-DATA
               EXEC CICS LINK PROGRAM('LGSTSQ')
                         COMMAREA(CA-ERROR-MSG)
                         LENGTH(LENGTH OF CA-ERROR-MSG)
               END-EXEC
             ELSE
               MOVE DFHCOMMAREA(1:90) TO CA-DATA
               EXEC CICS LINK PROGRAM('LGSTSQ')
                         COMMAREA(CA-ERROR-MSG)
                         LENGTH(LENGTH OF CA-ERROR-MSG)
               END-EXEC
             END-IF
           END-IF.
           EXIT.
