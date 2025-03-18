       IDENTIFICATION DIVISION.
        PROGRAM-ID. 'EPSCSMRO'.
        AUTHOR. WD4Z.
        INSTALLATION. 9.0.0.V200809191411.
        DATE-WRITTEN. 1/19/09 2:11 PM.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       1 ERROR-MESSAGES.
       2 CONVERTER-ERROR-3.
       3 PIC X(36) USAGE DISPLAY
           VALUE 'Failed To Register Exception Handler'.
       2 CONVERTER-ERROR-4.
       3 PIC X(38) USAGE DISPLAY
           VALUE 'Failed To Unregister Exception Handler'.
       2 CONVERTER-ERROR-7.
       3 PIC X(40) USAGE DISPLAY
           VALUE 'Language Environment Service Call Failed'.
       2 CONVERTER-ERROR-8.
       3 PIC X(35) USAGE DISPLAY
           VALUE 'Language Environment Message Number'.
       2 CONVERTER-ERROR-9.
       3 PIC X(31) USAGE DISPLAY
           VALUE 'XML Converter Is Terminating...'.
       1 X0000000B.
       2 PIC 9(4) COMP VALUE 26.
       2 PIC X(26) USAGE DISPLAY
           VALUE '</epspcom_program_retcode>'.
       1 X00000005.
       2 PIC 9(4) COMP VALUE 31.
       2 PIC X(31) USAGE DISPLAY
           VALUE '</epspcom_return_month_payment>'.
       1 X00000001.
       2 PIC 9(4) COMP VALUE 30.
       2 PIC X(30) USAGE DISPLAY
           VALUE '</DFHCOMMAREA></SOAP-ENV:Body>'.
       1 X00000008.
       2 PIC 9(4) COMP VALUE 17.
       2 PIC X(17) USAGE DISPLAY
           VALUE '</epspcom_errmsg>'.
       1 X00000004.
       2 PIC 9(4) COMP VALUE 30.
       2 PIC X(30) USAGE DISPLAY
           VALUE '<epspcom_return_month_payment>'.
       1 X00000000.
       2 PIC 9(4) COMP VALUE 88.
       2 PIC X(48) USAGE DISPLAY
           VALUE '<SOAP-ENV:Body><DFHCOMMAREA xmlns="http://www.EP'.
       2 PIC X(40) USAGE DISPLAY
           VALUE 'SCSMRTO.com/schemas/EPSCSMRTOInterface">'.
       1 X0000000A.
       2 PIC 9(4) COMP VALUE 25.
       2 PIC X(25) USAGE DISPLAY
           VALUE '<epspcom_program_retcode>'.
       1 X00000007.
       2 PIC 9(4) COMP VALUE 16.
       2 PIC X(16) USAGE DISPLAY
           VALUE '<epspcom_errmsg>'.
       LOCAL-STORAGE SECTION.
       1 CEESRP-DATA.
       2 RECOVERY-POINT PIC S9(9) COMP.
       2 NUMVAL-ERROR PIC X.
       2 UNICODE-ERROR PIC X.
       2 OTHER-ERROR PIC X.
       2 SAVED-CONDITION PIC X(12).
       1 ROUTINE PROCEDURE-POINTER.
       1 TOKEN POINTER.
       1 FEEDBACK-CODE.
       2 CONDITION-TOKEN-VALUE.
       88 CEE000 VALUE X'0000000000000000'.
       88 CEE0E7 VALUE X'000101C749C3C5C5'.
       3 SEVERITY PIC S9(4) BINARY.
       3 MSG-NO PIC S9(4) BINARY.
       3 CASE-SEV-CTL PIC X.
       3 FACILITY PIC XXX.
       2 I-S-INFO PIC S9(9) BINARY.
       1 NEW-CONDITION.
       2 CONDITION-TOKEN-VALUE.
       88 CEE000 VALUE X'0000000000000000'.
       88 CEE0E7 VALUE X'000101C749C3C5C5'.
       3 SEVERITY PIC S9(4) BINARY.
       3 MSG-NO PIC S9(4) BINARY.
       3 CASE-SEV-CTL PIC X.
       3 FACILITY PIC XXX.
       2 I-S-INFO PIC S9(9) BINARY.
       1 VSTRING.
       2 VSTRING-LENGTH PIC S9(4) COMP.
       2 VSTRING-DATA PIC X(80).
       1 SEV PIC S9(4) COMP.
       1 MSGNO PIC S9(4) COMP.
       1 CASE PIC S9(4) COMP.
       1 SEV2 PIC S9(4) COMP.
       1 CNTRL PIC S9(4) COMP.
       1 FACID PIC X(3) DISPLAY.
       1 ISINFO PIC S9(9) COMP.
       1 QDATA PIC S9(9) COMP.
       1 INSERTNO PIC S9(9) COMP.
       1 EEC PIC 9(9) DISPLAY.
       1 CMP-TMPA PIC 9(9) COMP.
       1 CMP-TMPB PIC 9(9) COMP.
       1 ERROR-CODE PIC S9(9) COMP.
       1 MSG-VAR-PART-LEN PIC 9(9) COMP.
       1 MSGBLD-RETURN-CODE PIC S9(9) COMP.
       1 LAST-INSTRUCTION PIC 9(9) COMP.
       1 LS2XML-LANG-BUFFER-POINTER POINTER.
       1 LS2XML-LANG-BUFFER-ADDRESS
           REDEFINES LS2XML-LANG-BUFFER-POINTER PIC 9(9) COMP.
       1 LANG-STRUCT-NAME PIC X(30).
       1 LANG-STRUCT-NAME-LENGTH PIC 9(4) COMP.
       1 LS2XML-XML-TEMPLATE-BUFFER PIC X(95).
       1 ARRAY-SUBSCRIPTS.
       2 X0000000C PIC 9(9) COMP VALUE 0.
       1 INSTRUCTIONS.
       2 INSTRUCT OCCURS 22 TIMES
            INDEXED BY INSTRUCT-NDX.
       3 MBOPCODE PIC X VALUE X'FF'.
       3 MBWSPOPT PIC X.
       3 MBDNMPTR POINTER.
       3 MBDATPTR POINTER.
       3 MBDATLEN PIC 9(9) COMP.
       3 MBDATYPE PIC X.
       3 MBSTGPTR POINTER.
       3 MBETGPTR POINTER.
       LINKAGE SECTION.
       01 DFHCOMMAREA
           .
       10 PROCESS-INDICATOR
           PICTURE X
           USAGE DISPLAY
           .
       10 EPSPCOM-PRINCIPLE-DATA
           PICTURE S9(9)V9(2)
           USAGE COMP
           .
       10 EPSPCOM-NUMBER-OF-YEARS
           PICTURE S9(4)
           USAGE COMP
           .
       10 EPSPCOM-NUMBER-OF-MONTHS
           PICTURE S9(4)
           USAGE COMP
           .
       10 EPSPCOM-QUOTED-INTEREST-RATE
           PICTURE S9(2)V9(3)
           USAGE COMP
           .
       10 EPSPCOM-YEAR-MONTH-IND
           PICTURE X
           USAGE DISPLAY
           .
       10 EPSPCOM-RETURN-MONTH-PAYMENT
           PICTURE S9(7)V9(2)
           USAGE COMP
           .
       10 EPSPCOM-ERRMSG
           PICTURE X(80)
           USAGE DISPLAY
           .
       10 EPSPCOM-PROGRAM-RETCODE
           PICTURE 9(4)
           USAGE DISPLAY
           .
       88 EPS02-REQUEST-SUCCESS
           VALUE
           0
           .
       10 EPSPCOM-PROGRAM-RETCODE-RDF REDEFINES EPSPCOM-PROGRAM-RETCODE
           PICTURE X(4)
           USAGE DISPLAY
           .
       1 X0000003D.
       10 X00000003 PIC -9(7).9(2).
       10 X00000006 PIC X(80).
       10 X00000009 PIC 9(4).
       1 LS2XML-XML-BUFFER-LENGTH PIC 9(9) COMP.
       1 LS2XML-XML-BUFFER PIC X(758).
       1 LS2XML-LANG-BUFFER PIC X(106).
       1 OPTIONAL-FEEDBACK-CODE PIC X(12).
       1 CONVERTER-RETURN-CODE PIC S9(9) COMP.
       PROCEDURE DIVISION USING
           LS2XML-LANG-BUFFER
           LS2XML-XML-BUFFER-LENGTH
           LS2XML-XML-BUFFER
           OPTIONAL-FEEDBACK-CODE
           RETURNING
           CONVERTER-RETURN-CODE.
       MAINLINE SECTION.
           MOVE 'N' TO NUMVAL-ERROR UNICODE-ERROR OTHER-ERROR
           PERFORM CHECK-PARAMETERS
           PERFORM REGISTER-EXCEPTION-HANDLER
           CALL 'CEE3SRP' USING RECOVERY-POINT FEEDBACK-CODE
           SERVICE LABEL
           IF UNICODE-ERROR = 'Y'
            MOVE 288 TO MSGNO
            PERFORM UNREGISTER-EXCEPTION-HANDLER
            PERFORM SIGNAL-CONDITION
            GOBACK
           END-IF
           IF OTHER-ERROR = 'Y'
            PERFORM UNREGISTER-EXCEPTION-HANDLER
            PERFORM SIGNAL-CONDITION
            GOBACK
           END-IF
           SET LS2XML-LANG-BUFFER-POINTER
            TO ADDRESS OF LS2XML-LANG-BUFFER
           INITIALIZE LS2XML-XML-BUFFER-LENGTH
           SET INSTRUCT-NDX TO 1
           MOVE 'DFHCOMMAREA'
             TO LANG-STRUCT-NAME
           MOVE 11
             TO LANG-STRUCT-NAME-LENGTH
           SET ADDRESS OF DFHCOMMAREA
            TO LS2XML-LANG-BUFFER-POINTER
           SET ADDRESS OF X0000003D
            TO ADDRESS OF LS2XML-XML-TEMPLATE-BUFFER
           INITIALIZE X0000003D
           MOVE X'E0' TO MBOPCODE(INSTRUCT-NDX)
           SET MBSTGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000000
           SET INSTRUCT-NDX UP BY 1
           MOVE X'B0' TO MBOPCODE(INSTRUCT-NDX)
           MOVE X'C3' TO MBWSPOPT(INSTRUCT-NDX)
           MOVE 11 TO MBDATLEN(INSTRUCT-NDX)
           SET MBDATPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000003
           MOVE 'N' TO MBDATYPE(INSTRUCT-NDX)
           SET MBSTGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000004
           SET MBETGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000005
           SET INSTRUCT-NDX UP BY 1
           MOVE EPSPCOM-RETURN-MONTH-PAYMENT
             OF DFHCOMMAREA
            TO X00000003
           MOVE X'A0' TO MBOPCODE(INSTRUCT-NDX)
           MOVE X'C3' TO MBWSPOPT(INSTRUCT-NDX)
           MOVE 80 TO MBDATLEN(INSTRUCT-NDX)
           SET MBDATPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000006
           MOVE 'X' TO MBDATYPE(INSTRUCT-NDX)
           SET MBSTGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000007
           SET MBETGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000008
           SET INSTRUCT-NDX UP BY 1
           MOVE EPSPCOM-ERRMSG
             OF DFHCOMMAREA
            TO X00000006
           MOVE X'B0' TO MBOPCODE(INSTRUCT-NDX)
           MOVE X'C3' TO MBWSPOPT(INSTRUCT-NDX)
           MOVE 4 TO MBDATLEN(INSTRUCT-NDX)
           SET MBDATPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000009
           MOVE 'N' TO MBDATYPE(INSTRUCT-NDX)
           SET MBSTGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X0000000A
           SET MBETGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X0000000B
           SET INSTRUCT-NDX UP BY 1
           IF EPSPCOM-PROGRAM-RETCODE
           OF DFHCOMMAREA
            IS NOT NUMERIC
            MOVE ZEROS TO X00000009
           ELSE
            MOVE EPSPCOM-PROGRAM-RETCODE
              OF DFHCOMMAREA
             TO X00000009
           END-IF
           MOVE X'E1' TO MBOPCODE(INSTRUCT-NDX)
           SET MBETGPTR(INSTRUCT-NDX)
            TO ADDRESS OF X00000001
           SET INSTRUCT-NDX UP BY 1
           PERFORM INVOKE-MESSAGE-BUILDER
           PERFORM UNREGISTER-EXCEPTION-HANDLER
           GOBACK
           .
       CHECK-PARAMETERS.
           IF ADDRESS OF LS2XML-LANG-BUFFER EQUAL NULL AND
              ADDRESS OF LS2XML-XML-BUFFER-LENGTH NOT EQUAL NULL
            CALL 'EPSCSMRL' USING LS2XML-XML-BUFFER-LENGTH
            GOBACK
           ELSE
            IF ADDRESS OF LS2XML-XML-BUFFER EQUAL NULL AND
               ADDRESS OF LS2XML-XML-BUFFER-LENGTH NOT EQUAL NULL
             CALL 'EPSCSMRK' USING LS2XML-XML-BUFFER-LENGTH
             GOBACK
           END-IF
           IF ADDRESS OF LS2XML-LANG-BUFFER EQUAL NULL OR
              ADDRESS OF LS2XML-XML-BUFFER-LENGTH EQUAL NULL OR
              ADDRESS OF LS2XML-XML-BUFFER EQUAL NULL
            MOVE 294 TO MSGNO
            PERFORM SIGNAL-CONDITION
            GOBACK
           END-IF
           .
       INVOKE-MESSAGE-BUILDER.
           CALL 'EPSCSMRC' USING
            INSTRUCTIONS LS2XML-XML-BUFFER-LENGTH
            LS2XML-XML-BUFFER LAST-INSTRUCTION
            RETURNING
             MSGBLD-RETURN-CODE
           IF MSGBLD-RETURN-CODE NOT EQUAL ZERO
            MOVE MSGBLD-RETURN-CODE
             TO MSGNO CONVERTER-RETURN-CODE
            PERFORM UNREGISTER-EXCEPTION-HANDLER
            PERFORM SIGNAL-CONDITION
            GOBACK
           ELSE
            MOVE ZERO TO CONVERTER-RETURN-CODE
           END-IF
           SET INSTRUCT-NDX TO 1
           MOVE ALL X'FF' TO INSTRUCTIONS
           .
       SIGNAL-CONDITION.
           IF OTHER-ERROR = 'N'
            MOVE 3 TO SEV SEV2
            MOVE 1 TO CASE CNTRL
            MOVE 0 TO ISINFO
            MOVE 0 TO INSERTNO
            MOVE 'IGZ' TO FACID
            CALL 'CEENCOD' USING
             SEV MSGNO CASE SEV2
             CNTRL FACID ISINFO
             NEW-CONDITION FEEDBACK-CODE
            PERFORM CHECK-LE-SERVICE-FC
            MOVE 8 TO VSTRING-LENGTH
            MOVE 'EPSCSMRO'
             TO VSTRING-DATA (1:8)
            PERFORM INSERT-VSTRING
            MOVE MSGNO TO ERROR-CODE
            EVALUATE MSGNO
             WHEN 287
              MOVE 758 TO EEC
              PERFORM INSERT-NUMBER
             WHEN 288
              MOVE 1140 TO EEC
              PERFORM INSERT-NUMBER
              MOVE 1140 TO EEC
              PERFORM INSERT-NUMBER
            END-EVALUATE
           ELSE
            MOVE SAVED-CONDITION TO NEW-CONDITION
            MOVE MSG-NO OF NEW-CONDITION TO ERROR-CODE
           END-IF
           MOVE 0 TO QDATA
           IF ADDRESS OF OPTIONAL-FEEDBACK-CODE = NULL
            CALL 'CEESGL' USING
             NEW-CONDITION QDATA OMITTED
           ELSE
            MOVE NEW-CONDITION TO OPTIONAL-FEEDBACK-CODE
           END-IF
           IF MSGNO NOT EQUAL 294
            MOVE ERROR-CODE TO CONVERTER-RETURN-CODE
           END-IF
           .
       INSERT-NUMBER.
           MOVE ZERO TO CMP-TMPA
           INSPECT EEC
            TALLYING CMP-TMPA FOR LEADING ZEROS
           COMPUTE CMP-TMPB = 9 - CMP-TMPA
           MOVE CMP-TMPB TO VSTRING-LENGTH
           MOVE EEC (CMP-TMPA + 1:CMP-TMPB)
            TO VSTRING-DATA
           PERFORM INSERT-VSTRING
           .
       INSERT-VSTRING.
           ADD 1 TO INSERTNO
           CALL 'CEECMI' USING
            NEW-CONDITION INSERTNO
            VSTRING FEEDBACK-CODE
           PERFORM CHECK-LE-SERVICE-FC
           .
       CHECK-LE-SERVICE-FC.
           IF NOT CEE000 OF FEEDBACK-CODE
            DISPLAY CONVERTER-ERROR-7
            DISPLAY CONVERTER-ERROR-8 ' '
             FACILITY OF FEEDBACK-CODE
             MSG-NO OF FEEDBACK-CODE
            DISPLAY CONVERTER-ERROR-9
            STOP RUN
           END-IF
           .
       REGISTER-EXCEPTION-HANDLER.
           SET ROUTINE
            TO ENTRY 'EPSCSMRE'
           SET TOKEN TO ADDRESS OF CEESRP-DATA
           CALL 'CEEHDLR' USING
            ROUTINE TOKEN FEEDBACK-CODE
           IF NOT CEE000 OF FEEDBACK-CODE
            DISPLAY CONVERTER-ERROR-3
            STOP RUN
           END-IF
           .
       UNREGISTER-EXCEPTION-HANDLER.
           CALL 'CEEHDLU' USING
            ROUTINE FEEDBACK-CODE
           IF NOT CEE000 OF FEEDBACK-CODE
            DISPLAY CONVERTER-ERROR-4
            STOP RUN
           END-IF
           .
       END PROGRAM 'EPSCSMRO'.
