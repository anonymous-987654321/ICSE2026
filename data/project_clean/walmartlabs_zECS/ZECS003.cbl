       CBL CICS(SP)
       IDENTIFICATION DIVISION.
       PROGRAM-ID. ZECS003.
       AUTHOR.     Randy Frerking and Rich Jackson.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  CURRENT-ABS            PIC S9(15) VALUE ZEROES COMP-3.
       01  TWELVE                 PIC S9(08) VALUE     12 COMP.
       01  TEN                    PIC S9(08) VALUE     10 COMP.
       01  SEVEN                  PIC S9(08) VALUE      7 COMP.
       01  TWO                    PIC S9(08) VALUE      2 COMP.
       01  ONE                    PIC S9(08) VALUE      1 COMP.
       01  FIVE-TWELVE            PIC S9(08) VALUE    512 COMP.
       01  EOF                    PIC  X(01) VALUE SPACES.
       01  SLASH                  PIC  X(01) VALUE '/'.
       01  ADR                    PIC  X(03) VALUE 'ADR'.
       01  SDR                    PIC  X(03) VALUE 'SDR'.
       01  DOT                    PIC  X(01) VALUE '.'.
       01  CLEAR-ALL              PIC  X(07) VALUE 'clear=*'.
       01  CRLF                   PIC  X(02) VALUE X'0D25'.
       01  ZECS-DC.
           02  DC-TRANID          PIC  X(04) VALUE 'ZC##'.
           02  FILLER             PIC  X(02) VALUE 'DC'.
           02  FILLER             PIC  X(42) VALUE SPACES.
       01  ZK-FCT.
           02  ZK-TRANID          PIC  X(04) VALUE 'ZC##'.
           02  FILLER             PIC  X(04) VALUE 'KEY '.
       01  ZF-FCT.
           02  ZF-TRANID          PIC  X(04) VALUE 'ZC##'.
           02  FILLER             PIC  X(04) VALUE 'FILE'.
       01  ZK-LENGTH              PIC S9(04) COMP VALUE ZEROES.
       01  ZF-LENGTH              PIC S9(04) COMP VALUE ZEROES.
       01  DELETE-LENGTH          PIC S9(04) COMP VALUE 8.
       01  ZK-RECORD.
           02  ZK-KEY             PIC X(255) VALUE LOW-VALUES.
           02  FILLER             PIC  X(01) VALUE LOW-VALUES.
           02  ZK-ZF-KEY.
               05  ZK-ZF-IDN      PIC  X(06) VALUE LOW-VALUES.
               05  ZK-ZF-NC       PIC  X(02) VALUE LOW-VALUES.
           02  ZK-SEGMENTS        PIC  X(01) VALUE SPACES.
           02  FILLER             PIC X(247) VALUE SPACES.
       01  FC-READ                PIC  X(06) VALUE 'READ  '.
       01  FC-DELETE              PIC  X(06) VALUE 'DELETE'.
       01  CSSL                   PIC  X(04) VALUE '@tdq@'.
       01  TD-LENGTH              PIC S9(04) COMP VALUE ZEROES.
       01  TD-RECORD.
           02  TD-DATE            PIC  X(10).
           02  FILLER             PIC  X(01) VALUE SPACES.
           02  TD-TIME            PIC  X(08).
           02  FILLER             PIC  X(01) VALUE SPACES.
           02  TD-TRANID          PIC  X(04).
           02  FILLER             PIC  X(01) VALUE SPACES.
           02  TD-MESSAGE         PIC  X(90) VALUE SPACES.
       01  FILE-ERROR.
           02  FILLER             PIC  X(12) VALUE 'FILE  I/O - '.
           02  FILLER             PIC  X(07) VALUE 'EIBFN: '.
           02  FE-FN              PIC  X(06) VALUE SPACES.
           02  FILLER             PIC  X(10) VALUE ' EIBRESP: '.
           02  FE-RESP            PIC  9(04) VALUE ZEROES.
           02  FILLER             PIC  X(11) VALUE ' EIBRESP2: '.
           02  FE-RESP2           PIC  9(04) VALUE ZEROES.
           02  FILLER             PIC  X(12) VALUE ' Paragraph: '.
           02  FE-PARAGRAPH       PIC  X(04) VALUE SPACES.
           02  FILLER             PIC  X(20) VALUE SPACES.
       01  KEY-ERROR.
           02  FILLER             PIC  X(12) VALUE 'KEY   I/O - '.
           02  FILLER             PIC  X(07) VALUE 'EIBFN: '.
           02  KE-FN              PIC  X(06) VALUE SPACES.
           02  FILLER             PIC  X(10) VALUE ' EIBRESP: '.
           02  KE-RESP            PIC  9(04) VALUE ZEROES.
           02  FILLER             PIC  X(11) VALUE ' EIBRESP2: '.
           02  KE-RESP2           PIC  9(04) VALUE ZEROES.
           02  FILLER             PIC  X(12) VALUE ' Paragraph: '.
           02  KE-PARAGRAPH       PIC  X(04) VALUE SPACES.
           02  FILLER             PIC  X(20) VALUE SPACES.
       01  URI-MAP                PIC  X(08) VALUE SPACES.
       01  URI-PATH               PIC X(255) VALUE SPACES.
       01  RESOURCES              PIC  X(10) VALUE '/resources'.
       01  REPLICATE              PIC  X(10) VALUE '/replicate'.
       01  HTTP-OK                PIC  X(02) VALUE 'OK'.
       01  HTTP-STATUS-200        PIC S9(04) COMP VALUE 200.
       01  SEND-ACTION            PIC S9(08) COMP VALUE ZEROES.
       01  NUMBER-OF-SPACES       PIC S9(08) COMP VALUE ZEROES.
       01  NUMBER-OF-NULLS        PIC S9(08) COMP VALUE ZEROES.
       01  WEB-METHOD             PIC S9(08) COMP VALUE ZEROES.
       01  WEB-PATH-LENGTH        PIC S9(08) COMP VALUE 256.
       01  ACTIVE-SINGLE          PIC  X(02) VALUE 'A1'.
       01  ACTIVE-ACTIVE          PIC  X(02) VALUE 'AA'.
       01  ACTIVE-STANDBY         PIC  X(02) VALUE 'AS'.
       01  DC-CONTROL.
           02  FILLER             PIC  X(06).
           02  DC-TYPE            PIC  X(02) VALUE SPACES.
           02  DC-CRLF            PIC  X(02).
           02  THE-OTHER-DC       PIC X(160) VALUE SPACES.
           02  FILLER             PIC  X(02).
       01  DC-TOKEN               PIC  X(16) VALUE SPACES.
       01  DC-LENGTH              PIC S9(08) COMP  VALUE ZEROES.
       01  THE-OTHER-DC-LENGTH    PIC S9(08) COMP  VALUE 160.
       01  SESSION-TOKEN          PIC  9(18) COMP VALUE ZEROES.
       01  URL-SCHEME-NAME        PIC  X(16) VALUE SPACES.
       01  URL-SCHEME             PIC S9(08) COMP VALUE ZEROES.
       01  URL-PORT               PIC S9(08) COMP VALUE ZEROES.
       01  URL-HOST-NAME          PIC  X(80) VALUE SPACES.
       01  URL-HOST-NAME-LENGTH   PIC S9(08) COMP VALUE 80.
       01  WEB-STATUS-CODE        PIC S9(04) COMP VALUE 00.
       01  WEB-STATUS-LENGTH      PIC S9(08) COMP VALUE 15.
       01  WEB-STATUS-ABSTIME     PIC  9(15) VALUE ZEROES.
       01  WEB-PATH               PIC X(512) VALUE SPACES.
       01  CONVERSE-LENGTH        PIC S9(08) COMP VALUE 40.
       01  CONVERSE-RESPONSE      PIC  X(40) VALUE SPACES.
       01  TEXT-PLAIN             PIC  X(56) VALUE 'text/plain'.
       01  ZF-PREFIX              PIC S9(08) VALUE 356    COMP.
       01  ZF-RECORD.
           02  ZF-KEY-16.
               05  ZF-KEY.
                 10  ZF-KEY-IDN   PIC  X(06) VALUE LOW-VALUES.
                 10  ZF-KEY-NC    PIC  X(02) VALUE LOW-VALUES.
               05  ZF-SEGMENT     PIC  9(04) VALUE ZEROES COMP.
               05  ZF-SUFFIX      PIC  9(04) VALUE ZEROES COMP.
               05  ZF-ZEROES      PIC  9(08) VALUE ZEROES COMP.
           02  ZF-ABS             PIC S9(15) VALUE ZEROES COMP-3.
           02  ZF-TTL             PIC S9(07) VALUE ZEROES COMP-3.
           02  ZF-SEGMENTS        PIC  9(04) VALUE ZEROES COMP.
           02  ZF-EXTRA           PIC  X(15).
           02  ZF-ZK-KEY          PIC  X(255).
           02  ZF-MEDIA           PIC  X(56).
           02  ZF-DATA            PIC  X(32000).
           02  FILLER             PIC  X(344).
       LINKAGE SECTION.
       01  DFHCOMMAREA.
           02  CA-TYPE            PIC  X(03).
           02  CA-URI-FIELD-01    PIC  X(10).
       PROCEDURE DIVISION.
           PERFORM 1000-INITIALIZE         THRU 1000-EXIT.
           PERFORM 2000-REPLICATE          THRU 2000-EXIT.
           PERFORM 3000-READ-ZF            THRU 3000-EXIT
                   WITH TEST AFTER
                   UNTIL EOF EQUAL 'Y'.
           PERFORM 4000-CLEAR-COMPLETE     THRU 4000-EXIT.
           PERFORM 9000-RETURN             THRU 9000-EXIT.
       1000-INITIALIZE.
           MOVE EIBTRNID(3:2)     TO ZK-TRANID(3:2)
                                     ZF-TRANID(3:2)
                                     DC-TRANID(3:2).
           EXEC CICS ASKTIME ABSTIME(CURRENT-ABS) NOHANDLE
           END-EXEC.
           IF  CA-TYPE         EQUAL ADR
           OR  CA-URI-FIELD-01 EQUAL REPLICATE
               PERFORM 8000-SEND-RESPONSE     THRU 8000-EXIT.
       1000-EXIT.
           EXIT.
       2000-REPLICATE.
           PERFORM 7000-GET-URL               THRU 7000-EXIT.
           IF  CA-URI-FIELD-01 EQUAL REPLICATE
               MOVE LOW-VALUES TO    DC-TYPE.
           IF  EIBRESP EQUAL DFHRESP(NORMAL)
           IF  DC-TYPE EQUAL ACTIVE-ACTIVE
           OR  DC-TYPE EQUAL ACTIVE-STANDBY
               PERFORM 7100-WEB-OPEN          THRU 7100-EXIT.
           IF  EIBRESP EQUAL DFHRESP(NORMAL)
           IF  DC-TYPE EQUAL ACTIVE-ACTIVE
           OR  DC-TYPE EQUAL ACTIVE-STANDBY
               MOVE DFHVALUE(DELETE)            TO WEB-METHOD
               PERFORM 7200-WEB-CONVERSE      THRU 7200-EXIT.
           IF  EIBRESP EQUAL DFHRESP(NORMAL)
           IF  DC-TYPE EQUAL ACTIVE-ACTIVE
           OR  DC-TYPE EQUAL ACTIVE-STANDBY
               PERFORM 7300-WEB-CLOSE         THRU 7300-EXIT.
       2000-EXIT.
           EXIT.
       3000-READ-ZF.
           MOVE LENGTH OF ZF-RECORD       TO ZF-LENGTH.
           EXEC CICS READ FILE(ZF-FCT)
                RIDFLD(ZF-KEY-16)
                INTO  (ZF-RECORD)
                LENGTH(ZF-LENGTH)
                GTEQ
                NOHANDLE
           END-EXEC.
           IF  EIBRESP NOT EQUAL DFHRESP(NORMAL)
               MOVE 'Y'       TO EOF
           ELSE
               IF  ZF-ABS LESS   THAN CURRENT-ABS
                   PERFORM 3100-DELETE      THRU 3100-EXIT.
           ADD ONE            TO ZF-ZEROES.
       3000-EXIT.
           EXIT.
       3100-DELETE.
           EXEC CICS DELETE FILE(ZF-FCT)
                RIDFLD(ZF-KEY-16)
                KEYLENGTH(DELETE-LENGTH)
                GENERIC
                NOHANDLE
           END-EXEC.
           EXEC CICS DELETE FILE(ZK-FCT)
                RIDFLD(ZF-ZK-KEY)
                NOHANDLE
           END-EXEC.
       3100-EXIT.
           EXIT.
       4000-CLEAR-COMPLETE.
           IF  CA-URI-FIELD-01 EQUAL RESOURCES
           AND CA-TYPE         EQUAL SDR
               PERFORM 8000-SEND-RESPONSE     THRU 8000-EXIT.
       4000-EXIT.
           EXIT.
       7000-GET-URL.
           EXEC CICS DOCUMENT CREATE DOCTOKEN(DC-TOKEN)
                TEMPLATE(ZECS-DC)
                NOHANDLE
           END-EXEC.
           MOVE LENGTH OF DC-CONTROL TO DC-LENGTH.
           IF  EIBRESP EQUAL DFHRESP(NORMAL)
               EXEC CICS DOCUMENT RETRIEVE DOCTOKEN(DC-TOKEN)
                    INTO     (DC-CONTROL)
                    LENGTH   (DC-LENGTH)
                    MAXLENGTH(DC-LENGTH)
                    DATAONLY
                    NOHANDLE
               END-EXEC.
           IF  EIBRESP EQUAL DFHRESP(NORMAL)
           AND DC-LENGTH GREATER THAN TEN
               SUBTRACT TWELVE FROM DC-LENGTH
                             GIVING THE-OTHER-DC-LENGTH
               EXEC CICS WEB PARSE
                    URL(THE-OTHER-DC)
                    URLLENGTH(THE-OTHER-DC-LENGTH)
                    SCHEMENAME(URL-SCHEME-NAME)
                    HOST(URL-HOST-NAME)
                    HOSTLENGTH(URL-HOST-NAME-LENGTH)
                    PORTNUMBER(URL-PORT)
                    NOHANDLE
               END-EXEC.
           IF  EIBRESP NOT EQUAL DFHRESP(NORMAL)
           OR  DC-LENGTH LESS THAN TEN
           OR  DC-LENGTH EQUAL            TEN
               MOVE ACTIVE-SINGLE                 TO DC-TYPE.
       7000-EXIT.
           EXIT.
       7100-WEB-OPEN.
           IF  URL-SCHEME-NAME EQUAL 'HTTPS'
               MOVE DFHVALUE(HTTPS)  TO URL-SCHEME
           ELSE
               MOVE DFHVALUE(HTTP)   TO URL-SCHEME.
           EXEC CICS WEB OPEN
                HOST(URL-HOST-NAME)
                HOSTLENGTH(URL-HOST-NAME-LENGTH)
                PORTNUMBER(URL-PORT)
                SCHEME(URL-SCHEME)
                SESSTOKEN(SESSION-TOKEN)
                NOHANDLE
           END-EXEC.
       7100-EXIT.
           EXIT.
       7200-WEB-CONVERSE.
           MOVE FIVE-TWELVE      TO WEB-PATH-LENGTH.
           MOVE ZEROES           TO NUMBER-OF-NULLS.
           MOVE EIBTRNID         TO URI-MAP.
           MOVE 'R'              TO URI-MAP(5:1).
           EXEC CICS INQUIRE URIMAP(URI-MAP)
                PATH(URI-PATH)
                NOHANDLE
           END-EXEC.
           STRING URI-PATH
                  DOT
                  ADR
                  SLASH
                  DELIMITED BY '*'
                  INTO WEB-PATH.
           INSPECT WEB-PATH TALLYING NUMBER-OF-NULLS
                   FOR ALL LOW-VALUES.
           SUBTRACT NUMBER-OF-NULLS  FROM WEB-PATH-LENGTH.
           INSPECT WEB-PATH TALLYING NUMBER-OF-SPACES
                   FOR ALL SPACES.
           SUBTRACT NUMBER-OF-SPACES FROM WEB-PATH-LENGTH.
           MOVE REPLICATE TO WEB-PATH(1:10).
           EXEC CICS WEB CONVERSE
                SESSTOKEN(SESSION-TOKEN)
                PATH(WEB-PATH)
                PATHLENGTH(WEB-PATH-LENGTH)
                METHOD(WEB-METHOD)
                MEDIATYPE(ZF-MEDIA)
                INTO(CONVERSE-RESPONSE)
                TOLENGTH(CONVERSE-LENGTH)
                MAXLENGTH(CONVERSE-LENGTH)
                STATUSCODE(WEB-STATUS-CODE)
                STATUSLEN (WEB-STATUS-LENGTH)
                STATUSTEXT(WEB-STATUS-ABSTIME)
                QUERYSTRING(CLEAR-ALL)
                QUERYSTRLEN(SEVEN)
                NOOUTCONVERT
                NOHANDLE
           END-EXEC.
       7200-EXIT.
           EXIT.
       7300-WEB-CLOSE.
           EXEC CICS WEB CLOSE
                SESSTOKEN(SESSION-TOKEN)
                NOHANDLE
           END-EXEC.
       7300-EXIT.
           EXIT.
       8000-SEND-RESPONSE.
           MOVE DFHVALUE(IMMEDIATE)    TO SEND-ACTION.
           EXEC CICS WEB SEND
                FROM       (CRLF)
                FROMLENGTH (TWO)
                MEDIATYPE  (TEXT-PLAIN)
                ACTION     (SEND-ACTION)
                STATUSCODE (HTTP-STATUS-200)
                STATUSTEXT (HTTP-OK)
                SRVCONVERT
                NOHANDLE
           END-EXEC.
       8000-EXIT.
           EXIT.
       9000-RETURN.
           EXEC CICS RETURN
           END-EXEC.
       9000-EXIT.
           EXIT.
