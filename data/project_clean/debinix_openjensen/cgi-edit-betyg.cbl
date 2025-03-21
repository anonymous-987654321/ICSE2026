       IDENTIFICATION DIVISION.
       program-id. cgi-edit-betyg.
       DATA DIVISION.
       working-storage section.
       01   switches-edit.
            03  is-db-connected-switch              PIC X   VALUE 'N'.
                88  is-db-connected                         VALUE 'Y'.
            03  is-valid-init-switch                PIC X   VALUE 'N'.
                88  is-valid-init                           VALUE 'Y'.             
            03  grade-id-is-in-table-switch         PIC X   VALUE 'N'.
                88  grade-id-is-in-table                    VALUE 'Y'.                             
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.        
       01  wc-pagetitle            PIC X(20) VALUE 'Uppdatera betyg'.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).       
       01  wc-username              PIC  X(30).
       EXEC SQL END DECLARE SECTION END-EXEC.              
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  tbl-grade-rec-vars.       
           05  tbl-grade-grade-id       PIC  9(4).
           05  tbl-grade-grade          PIC  X(40).
           05  tbl-grade-comment        PIC  X(40).
       EXEC SQL END DECLARE SECTION END-EXEC.
       01  wr-rec-vars.
           05  wn-grade-id         PIC  9(4) VALUE ZERO.
           05  wc-grade            PIC  X(40) VALUE SPACE.
           05  wc-comment          PIC  X(40) VALUE SPACE.  
       01  wr-cur-rec-vars.
           05  wn-cur-grade-id         PIC  9(4) VALUE ZERO.     
           05  wc-cur-grade        PIC  X(40) VALUE SPACE. 
           05  wc-cur-comment      PIC  X(40) VALUE SPACE.
       EXEC SQL INCLUDE SQLCA END-EXEC.
       PROCEDURE DIVISION.
       0000-main.
           SET ENVIRONMENT "OJ_DBG" TO "1"
           SET ENVIRONMENT "OJ_LOG" TO "1"           
           PERFORM A0100-init
           IF is-valid-init
                PERFORM B0100-connect
                IF is-db-connected
                    PERFORM B0200-edit-grade
                    PERFORM Z0200-disconnect
                END-IF
           END-IF
           PERFORM C0100-closedown
           GOBACK
           .
       A0100-init.       
           CALL 'wui-print-header' USING wn-rtn-code  
           CALL 'wui-start-html' USING wc-pagetitle
           CALL 'write-post-string' USING wn-rtn-code
           IF wn-rtn-code = ZERO
                PERFORM A0110-init-edit-action
           END-IF
           .
       A0110-init-edit-action.
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'grade_id' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                               wc-post-name wc-post-value
           MOVE FUNCTION NUMVAL(wc-post-value) TO wn-grade-id
           IF wc-post-value = SPACE
               MOVE 'Saknar ett angivet grade id'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string      
           ELSE                 
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'grade_grade' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                    wc-post-name wc-post-value
               MOVE wc-post-value TO wc-grade   
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'grade_comment' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code wc-post-name
                                            wc-post-value                                     
               MOVE wc-post-value TO wc-comment           
               IF wc-grade NOT = SPACE OR
                  wc-comment NOT = SPACE
                        SET is-valid-init TO TRUE                  
               ELSE
                   MOVE 'Ingen kolumn att uppdatera'
                        TO wc-printscr-string
                   CALL 'stop-printscr' USING wc-printscr-string
               END-IF   
           END-IF
           . 
       B0100-connect.
           MOVE  "openjensen"    TO   wc-database
           MOVE  "jensen"        TO   wc-username
           MOVE  SPACE           TO   wc-passwd
           EXEC SQL
               CONNECT :wc-username IDENTIFIED BY :wc-passwd
                                                 USING :wc-database 
           END-EXEC
           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                SET is-db-connected TO TRUE
           END-IF  
           .       
       B0200-edit-grade.
           PERFORM B0210-does-grade-id-exist
           IF grade-id-is-in-table
               PERFORM B0220-change-grade-item
           ELSE
               MOVE 'Denna student finns ej'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           END-IF
           .
       B0210-does-grade-id-exist.
           EXEC SQL
             DECLARE cursedit CURSOR FOR
                 SELECT grade_id, grade_grade, grade_comment
                 FROM tbl_grade
           END-EXEC      
           EXEC SQL
                OPEN cursedit
           END-EXEC
           MOVE wn-grade-id TO tbl-grade-grade-id
           EXEC SQL
               FETCH cursedit
                   INTO :tbl-grade-grade-id, :tbl-grade-grade,
                        :tbl-grade-comment
           END-EXEC
           PERFORM UNTIL SQLCODE NOT = ZERO
               IF wn-grade-id = tbl-grade-grade-id
                    SET grade-id-is-in-table TO TRUE
               MOVE tbl-grade-grade-id TO wn-cur-grade-id
               MOVE tbl-grade-grade TO wc-cur-grade
               MOVE tbl-grade-comment TO wc-cur-comment
               END-IF
               EXEC SQL
                   FETCH cursedit
                       INTO :tbl-grade-grade-id, :tbl-grade-grade,
                            :tbl-grade-comment
               END-EXEC
           END-PERFORM
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF                 
           EXEC SQL 
               CLOSE cursedit 
           END-EXEC    
           .
       B0220-change-grade-item.
           IF wc-grade NOT = wc-cur-grade
               MOVE wc-grade TO tbl-grade-grade
           ELSE    
               MOVE wc-cur-grade TO tbl-grade-grade
           END-IF
           IF wc-comment NOT = wc-cur-comment
               MOVE wc-comment TO tbl-grade-comment
           ELSE
               MOVE wc-cur-comment TO tbl-grade-comment
           END-IF
           MOVE wn-grade-id TO tbl-grade-grade-id
           EXEC SQL
               UPDATE tbl_grade
                   SET grade_grade = :tbl-grade-grade,
                       grade_comment = :tbl-grade-comment
               WHERE grade_id = :tbl-grade-grade-id
           END-EXEC
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0230-commit-work
                MOVE 'Betyg data ändrad' TO wc-printscr-string
                CALL 'ok-printscr' USING wc-printscr-string      
           END-IF
           .           
       B0230-commit-work.
           EXEC SQL 
               COMMIT WORK
           END-EXEC
           .                    
       C0100-closedown.
           CALL 'wui-end-html' USING wn-rtn-code 
           .
       Z0100-error-routine.
           EVALUATE SQLSTATE
               WHEN  "02000"
                   MOVE 'Data återfinns ej i databasen'
                       TO wc-printscr-string
                   CALL 'stop-printscr' USING wc-printscr-string 
              WHEN  "08003"
              WHEN  "08001"
                   MOVE 'Anslutning till databas misslyckades'
                       TO wc-printscr-string
                   CALL 'stop-printscr' USING wc-printscr-string 
              WHEN  "23503"
                   MOVE 'Kan ej ta bort data - pga tabellberoenden'
                       TO wc-printscr-string
                   CALL 'stop-printscr' USING wc-printscr-string                              
              WHEN  SPACE
                   MOVE 'Obekant fel - kontakta leverantören'
                       TO wc-printscr-string
                   CALL 'stop-printscr' USING wc-printscr-string  
              WHEN  OTHER
                   CALL 'error-printscr' USING SQLSTATE SQLERRMC
           END-EVALUATE
           .
       Z0200-disconnect. 
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
           .
