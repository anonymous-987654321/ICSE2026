       IDENTIFICATION DIVISION.
       PROGRAM-ID.  CWKTDATE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  DATE-TABLE.
           05  FILLER                 PIC 9(4)    VALUE 0131.
           05  FILLER                 PIC 9(4)    VALUE 0228.
           05  FILLER                 PIC 9(4)    VALUE 0331.
           05  FILLER                 PIC 9(4)    VALUE 0430.
           05  FILLER                 PIC 9(4)    VALUE 0531.
           05  FILLER                 PIC 9(4)    VALUE 0630.
           05  FILLER                 PIC 9(4)    VALUE 0731.
           05  FILLER                 PIC 9(4)    VALUE 0831.
           05  FILLER                 PIC 9(4)    VALUE 0930.
           05  FILLER                 PIC 9(4)    VALUE 1031.
           05  FILLER                 PIC 9(4)    VALUE 1130.
           05  FILLER                 PIC 9(4)    VALUE 1231.
       01  DATE-TABLE-REDEFINED REDEFINES DATE-TABLE.
           05  DATE-FIELDS OCCURS 12 TIMES.
               10  DATE-MM            PIC 9(2).
               10  DATE-DD            PIC 9(2).
       01  WORK-AREAS.
           05  HOLD-YEARS             PIC 9(2)    VALUE 0.
           05  EXTRA-YEARS            PIC 9(2)    VALUE 0.
           05  CHECKED-FOR-EOM-SW     PIC X       VALUE 'N'.
               88  CHECKED-FOR-EOM                VALUE 'Y'.
       LINKAGE SECTION.
       01  EOM-SW                     PIC X.
       01  YRS-OF-SERVICE             PIC 9(2).
       01  RUN-DATE.
           05  RUN-YY                 PIC 9(2).
           05  RUN-MM                 PIC 9(2).
           05  RUN-DD                 PIC 9(2).
       01  HIRE-DATE.
           05  HIRE-YY                PIC 9(2).
           05  HIRE-MM                PIC 9(2).
           05  HIRE-DD                PIC 9(2).
       PROCEDURE DIVISION USING EOM-SW,
                                YRS-OF-SERVICE,
                                RUN-DATE,
                                HIRE-DATE.
       0000-MAINLINE.
           IF CHECKED-FOR-EOM
               PERFORM 1000-CALC-YRS-OF-SERVICE
           ELSE
               PERFORM 2000-CALC-END-OF-MONTH
               MOVE 'Y' TO CHECKED-FOR-EOM-SW.
           GOBACK.
       1000-CALC-YRS-OF-SERVICE.
             IF HIRE-YY > RUN-YY                                        11032000
                   COMPUTE YRS-OF-SERVICE = (100 + RUN-YY) - HIRE-YY    11032000
               ELSE                                                     11032000
                  COMPUTE YRS-OF-SERVICE = RUN-YY - HIRE-YY.
             IF HIRE-MM > RUN-MM
                 COMPUTE YRS-OF-SERVICE = YRS-OF-SERVICE - 1
             ELSE
                 IF HIRE-MM = RUN-MM
                     IF HIRE-DD > RUN-DD
                        COMPUTE YRS-OF-SERVICE = YRS-OF-SERVICE - 1.
       2000-CALC-END-OF-MONTH.
             IF RUN-MM = 02
                 PERFORM 3000-CALC-LEAP-YEAR
             ELSE
                 IF DATE-DD(RUN-MM) = RUN-DD
                     MOVE 'Y' TO EOM-SW.
       3000-CALC-LEAP-YEAR.
             DIVIDE RUN-YY BY 4
                 GIVING HOLD-YEARS
                 REMAINDER EXTRA-YEARS.
             IF EXTRA-YEARS = 0
                 IF RUN-DD = 29
                     MOVE 'Y' TO EOM-SW.