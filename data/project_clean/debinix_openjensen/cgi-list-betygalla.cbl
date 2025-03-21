       IDENTIFICATION DIVISION.
       program-id. cgi-list-betygalla.
       ENVIRONMENT DIVISION.
       input-output section.
       file-control.
           SELECT fileout ASSIGN TO
              '../data/betyg-all.txt'
              ORGANIZATION IS LINE SEQUENTIAL.
           SELECT gradetmpfile 
              ASSIGN TO
              '../data/gradetmp.dat'
              ORGANIZATION IS LINE SEQUENTIAL.  
           SELECT OPTIONAL statusfile
              ASSIGN TO
              '../data/status'             
              ORGANIZATION IS LINE SEQUENTIAL.      
       DATA DIVISION.
       file section.
       FD  fileout.
       01  fd-fileout-post. 
           03  fc-course-name             PIC X(40).
           03  fc-sep-1                   PIC X.      
           03  fc-user-firstname          PIC X(40).
           03  fc-sep-2                   PIC X.           
           03  fc-user-lastname           PIC X(40).
           03  fc-sep-3                   PIC X.     
           03  fc-grade                   PIC X(40).
           03  fc-sep-4                   PIC X.
           03  fc-grade-id                PIC 9(4).
           03  fc-sep-5                   PIC X.           
           03  fc-user-id                 PIC 9(4).
           03  fc-sep-6                   PIC X.           
           03  fc-course-id               PIC 9(4).
           03  fc-sep-7                   PIC X.                
           03  fc-grade-comment           PIC X(40).
           03  fc-sep-8                   PIC X.      
           03  fc-magic-number            PIC X(40).     
       FD  gradetmpfile.    
       01  fd-tmpfile-post.
           03  fc-tmp-user-grade-id       PIC 9(4).
           03  fc-tmp-user-grade-comment  PIC X(40).       
           03  fc-tmp-user-id             PIC 9(4).
           03  fc-tmp-course-id           PIC 9(4).
           03  fc-tmp-program-id          PIC 9(4).         
           03  fc-tmp-user-grade          PIC X(40).
       FD  statusfile.
       01  fd-fileout-status         PIC  X(1) VALUE SPACE.       
       working-storage section.
       01   switches.
           03  is-db-connected-switch      PIC X   VALUE 'N'.
               88  is-db-connected                 VALUE 'Y'.
           03  is-valid-init-switch        PIC X   VALUE 'N'.
               88  is-valid-init                   VALUE 'Y'.
           03  is-eof-input-switch         PIC X   VALUE 'N'.
               88  is-eof-input                    VALUE 'Y'.
           03  value-is-found-switch       PIC X   VALUE 'N'.
               88  value-is-found                  VALUE 'Y'.
           03  is-sql-error-switch         PIC X   VALUE 'N'.
                88  is-sql-error                   VALUE 'Y'.
       01  sub-init-swithes.        
            03  is-valid-init-program-witch PIC X   VALUE 'N'.
                88  is-valid-init-program           VALUE 'Y'.
            03  is-valid-init-magic-switch  PIC X   VALUE 'N'.
                88  is-valid-init-magic             VALUE 'Y'.                   
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.   
       01  wc-pagetitle            PIC X(20) VALUE 'Lista alla kurser'.
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).       
       01  wc-username              PIC  X(30).
           EXEC SQL END DECLARE SECTION END-EXEC.       
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  tbl-user-record.       
           05  tbl_user-user_id          PIC  9(4).
           05  tbl_user-user_firstname   PIC  X(40).
           05  tbl_user-user_lastname    PIC  X(40).
           05  tbl_user-usertype_id      PIC  9(4).            
           05  tbl_user-user_program     PIC  9(4).           
       01  wr-user-record.
           05  wn-user_id               PIC  9(4)  VALUE ZERO.          
           05  wc-user_firstname        PIC  X(40) VALUE SPACE.
           05  wc-user_lastname         PIC  X(40) VALUE SPACE.
           05  wn-user-typeid           PIC  9(4)  VALUE ZERO.                
           05  wn-user-program          PIC  9(4)  VALUE ZERO.         
       01  tbl-course-record.       
           05  tbl_course-course_id        PIC  9(4).
           05  tbl_course-course_name      PIC  X(40).
           05  tbl_course-program_id       PIC  9(4).           
       01  wr-course-record.
           05  wn-course_id          PIC  9(4)  VALUE ZERO.          
           05  wc-course_name        PIC  X(40) VALUE SPACE.
           05  wn-course-program_id  PIC  9(4)  VALUE ZERO.  
       01  tbl-grade-record.
           05  tbl_grade-grade_id         PIC  9(4).          
           05  tbl_grade-grade_grade      PIC  X(40).
           05  tbl_grade-grade_comment    PIC  X(40).           
           05  tbl_grade-user_id          PIC  9(4).
           05  tbl_grade-course_id        PIC  9(4).            
       01  wr-grade-record.
           05  wn-grade-grade_id     PIC  9(4)  VALUE ZERO.       
           05  wc-grade_grade        PIC  X(40) VALUE SPACE.
           05  wc-grade_comment      PIC  X(40) VALUE SPACE.           
           05  wn-grade-user_id      PIC  9(4)  VALUE ZERO.
           05  wn-grade-course_id    PIC  9(4)  VALUE ZERO. 
           EXEC SQL END DECLARE SECTION END-EXEC.    
           EXEC SQL INCLUDE SQLCA END-EXEC.
       01 wn-program_id              PIC  9(4) VALUE ZERO.
       01 wc-magic-number            PIC  X(40) VALUE SPACE.
       01 wc-file-name               PIC  X(60) VALUE SPACE.
       01 wc-dest-path               PIC  X(80) VALUE SPACE.
       01 WC-NO-SQLVALUE-TO-PHP      PIC X(1)  VALUE '-'.   
       PROCEDURE DIVISION.
       0000-main.
           SET ENVIRONMENT "OJ_DBG" TO "1"
           SET ENVIRONMENT "OJ_LOG" TO "1"           
           PERFORM A0100-init
           IF is-valid-init
                PERFORM B0100-connect
                IF is-db-connected
                    PERFORM B0200-create-students-gradefile
                    PERFORM B0250-write-all-courses-in-pgrm
                    PERFORM B0300-disconnect
                END-IF
           ELSE     
                MOVE 'Kunde ej läsa POST data' TO wc-printscr-string
                CALL 'stop-printscr' USING wc-printscr-string  
           END-IF
           PERFORM C0100-closedown
           GOBACK
           .
       A0100-init.       
           CALL 'wui-print-header' USING wn-rtn-code  
           CALL 'wui-start-html' USING wc-pagetitle
           CALL 'write-post-string' USING wn-rtn-code
           IF wn-rtn-code = ZERO
               SET is-valid-init TO TRUE
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'user_program' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value 
               IF wc-post-value NOT = SPACE
                   SET is-valid-init-program TO TRUE       
                   MOVE FUNCTION NUMVAL(wc-post-value) TO wn-program_id
               END-IF
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'magic_number' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
               IF wc-post-value NOT = SPACE
                   SET is-valid-init-magic TO TRUE  
                   MOVE wc-post-value TO wc-magic-number       
               END-IF
               IF is-valid-init-program AND is-valid-init-magic
                  SET is-valid-init TO TRUE
                  OPEN OUTPUT fileout
               END-IF               
           END-IF
           .
       B0100-connect.
           MOVE  "openjensen"    TO   wc-database.
           MOVE  "jensen"        TO   wc-username.
           MOVE  SPACE           TO   wc-passwd.
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
       B0200-create-students-gradefile.       
           OPEN OUTPUT gradetmpfile
           MOVE 1 TO wn-user-typeid
           EXEC SQL  
                DECLARE cursgrade CURSOR FOR
                SELECT g.grade_id, g.grade_grade, g.grade_comment,
                       g.course_id, u.user_id, u.user_program
                FROM tbl_user u
                LEFT JOIN tbl_grade g
                ON u.user_id = g.user_id
                JOIN tbl_course c
                ON g.course_id = c.course_id 
                AND u.usertype_id = :wn-user-typeid
           END-EXEC
           EXEC SQL
               OPEN cursgrade
           END-EXEC
           EXEC SQL 
               FETCH cursgrade INTO :tbl_grade-grade_id,
                                    :tbl_grade-grade_grade,
                                    :tbl_grade-grade_comment,
                                    :tbl_grade-course_id,
                                    :tbl_user-user_id,
                                    :tbl_user-user_program
           END-EXEC
           PERFORM UNTIL SQLCODE NOT = ZERO
              MOVE tbl_grade-grade_id TO wn-grade-grade_id
              MOVE tbl_grade-grade_grade TO wc-grade_grade
              MOVE tbl_grade-grade_comment TO wc-grade_comment
              MOVE tbl_grade-course_id TO wn-grade-course_id
              MOVE tbl_user-user_id TO wn-user_id
              MOVE tbl_user-user_program TO wn-user-program
              PERFORM B0210-write-grade-to-file
              INITIALIZE wr-grade-record
              INITIALIZE wr-user-record
               EXEC SQL 
               FETCH cursgrade INTO :tbl_grade-grade_id,
                                    :tbl_grade-grade_grade,
                                    :tbl_grade-grade_comment,
                                    :tbl_grade-course_id,
                                    :tbl_user-user_id,
                                    :tbl_user-user_program
               END-EXEC
           END-PERFORM       
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF              
           EXEC SQL 
               CLOSE cursgrade 
           END-EXEC
           CLOSE gradetmpfile
           .
       B0210-write-grade-to-file.       
           IF wn-user-program = wn-program_id
               MOVE wn-grade-grade_id TO fc-tmp-user-grade-id
               MOVE wc-grade_grade TO fc-tmp-user-grade
               MOVE wc-grade_comment TO fc-tmp-user-grade-comment
               MOVE wn-grade-course_id TO fc-tmp-course-id
               MOVE wn-user_id TO fc-tmp-user-id
               MOVE wn-user-program TO fc-tmp-program-id
               WRITE fd-tmpfile-post
           END-IF
           .
       B0250-write-all-courses-in-pgrm.
           MOVE 1 TO wn-user-typeid
           MOVE wn-program_id TO wn-course-program_id           
           EXEC SQL            
              DECLARE cursall CURSOR FOR           
              SELECT c.course_name, u.user_firstname, u.user_lastname,
                     u.user_id, c.course_id, u.user_program
              FROM tbl_user u
              JOIN tbl_course c
              ON c.program_id = u.user_program
              AND   u.usertype_id = :wn-user-typeid
              AND   u.user_program = :wn-course-program_id
              ORDER BY c.course_name, u.user_lastname
           END-EXEC           
           EXEC SQL
               OPEN cursall
           END-EXEC
           EXEC SQL 
               FETCH cursall INTO :tbl_course-course_name,
                                  :tbl_user-user_firstname,
                                  :tbl_user-user_lastname,                       
                                  :tbl_user-user_id,
                                  :tbl_course-course_id,
                                  :tbl_user-user_program
           END-EXEC
           PERFORM UNTIL SQLCODE NOT = ZERO
              MOVE tbl_course-course_name TO wc-course_name
              MOVE tbl_user-user_firstname TO wc-user_firstname
              MOVE tbl_user-user_lastname TO wc-user_lastname              
              MOVE tbl_user-user_id TO wn-user_id
              MOVE tbl_course-course_id TO wn-course_id
              MOVE tbl_user-user_program TO wn-user-program
              PERFORM B0260-write-course-row
              INITIALIZE wr-user-record
              INITIALIZE wr-course-record
               EXEC SQL 
               FETCH cursall INTO :tbl_course-course_name,
                                  :tbl_user-user_firstname,
                                  :tbl_user-user_lastname,                       
                                  :tbl_user-user_id,
                                  :tbl_course-course_id,
                                  :tbl_user-user_program
               END-EXEC
           END-PERFORM
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF              
           EXEC SQL 
               CLOSE cursall 
           END-EXEC 
           .
       B0260-write-course-row.            
           OPEN INPUT gradetmpfile
           READ gradetmpfile INTO fd-tmpfile-post
              AT END
                   SET is-eof-input TO TRUE
                   MOVE ZERO TO wn-grade-grade_id
                   MOVE WC-NO-SQLVALUE-TO-PHP TO wc-grade_grade                   
                   MOVE WC-NO-SQLVALUE-TO-PHP TO wc-grade_comment
           END-READ
           IF NOT is-eof-input
              PERFORM UNTIL is-eof-input OR value-is-found             
                 IF ( fc-tmp-user-id = wn-user_id AND
                      fc-tmp-course-id = wn-course_id AND
                      fc-tmp-program-id = wn-user-program )
                     MOVE fc-tmp-user-grade-id TO wn-grade-grade_id
                     MOVE fc-tmp-user-grade TO wc-grade_grade
                     MOVE fc-tmp-user-grade-comment
                                            TO wc-grade_comment                     
                    SET value-is-found TO TRUE
                 ELSE
                     MOVE ZERO TO wn-grade-grade_id
                     MOVE WC-NO-SQLVALUE-TO-PHP TO wc-grade_grade                   
                     MOVE WC-NO-SQLVALUE-TO-PHP TO wc-grade_comment
                 END-IF
                 READ gradetmpfile INTO fd-tmpfile-post
                      AT END
                          SET is-eof-input TO TRUE
                 END-READ              
              END-PERFORM
           END-IF           
           MOVE wc-course_name TO fc-course-name
           MOVE ',' TO fc-sep-1
           MOVE wc-user_firstname TO fc-user-firstname
           MOVE ',' TO fc-sep-2
           MOVE wc-user_lastname TO fc-user-lastname
           MOVE ',' TO fc-sep-3
           MOVE wc-grade_grade TO fc-grade
           MOVE ',' TO fc-sep-4
           MOVE wn-grade-grade_id TO fc-grade-id           
           MOVE ',' TO fc-sep-5
           MOVE wn-user_id TO fc-user-id           
           MOVE ',' TO fc-sep-6
           MOVE wn-course_id TO fc-course-id
           MOVE ',' TO fc-sep-7                
           MOVE wc-grade_comment TO fc-grade-comment
           MOVE ',' TO fc-sep-8           
           MOVE wc-magic-number TO fc-magic-number   
           WRITE fd-fileout-post
           CLOSE gradetmpfile
           MOVE 'N' TO value-is-found-switch
           MOVe 'N' TO is-eof-input-switch
           .                
       B0300-disconnect. 
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
           IF NOT is-sql-error
               PERFORM Z0200-write-status-ok-file
           END-IF
           CLOSE fileout
           .
       C0100-closedown.
           CALL 'wui-end-html' USING wn-rtn-code 
           .
       Z0100-error-routine.
           SET is-sql-error TO TRUE
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
       Z0200-write-status-ok-file.
           MOVE wc-magic-number TO wc-file-name
           OPEN EXTEND statusfile           
           CLOSE statusfile
           MOVE SPACE TO wc-dest-path    
           STRING '../data/'   DELIMITED BY SPACE
              wc-file-name DELIMITED BY SPACE 
                      '.'  DELIMITED BY SPACE
                      'OK' DELIMITED BY SPACE
                      INTO wc-dest-path
                      ON OVERFLOW
                      MOVE 'Filnamn för långt' TO wc-printscr-string
                      CALL 'stop-printscr' USING wc-printscr-string
                      NOT ON OVERFLOW
                         CONTINUE
           END-STRING                         
           CALL 'C$COPY' USING '../data/status', wc-dest-path, 0
           CALL 'C$DELETE' USING '../data/status', 0           
           .              
