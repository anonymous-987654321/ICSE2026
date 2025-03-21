       IDENTIFICATION DIVISION.
       program-id. get-post-value IS INITIAL.
       ENVIRONMENT DIVISION.
       input-output section.
       file-control. 
           SELECT OPTIONAL postfilein
               ASSIGN TO '../data/postfile.dat'
               ORGANIZATION IS LINE SEQUENTIAL.             
       DATA DIVISION.
       file section.
       FD  postfilein.
       01  fd-postfile-post. 
           03  fc-post-name               PIC X(64).
           03  fc-post-separator          PIC X.      
           03  fc-post-value              PIC X(64).            
       working-storage section.
       01   switches.
            03  value-is-found-switch     PIC X         VALUE 'N'.
                88  value-is-found                      VALUE 'Y'.
            03  is-eof-input-switch      PIC X          VALUE 'N'.
                88  is-eof-input                        VALUE 'Y'.
       01  wc-cnv-post-string   PIC X(40) VALUE SPACE.
       01  wc-post-string       PIC X(40) VALUE SPACE.
       01  wc-urlchars          PIC X(5)  VALUE SPACE.
       01  wn-index             PIC 9(3)  VALUE 1.
       01  wn-str-length        PIC 9(3)  VALUE ZERO.
       01  wn-tmp-lengt         PIC 9(3)  VALUE ZERO.
       01  wn-field-length      PIC 9(3)  VALUE ZERO.
       01  wn-incounter         PIC 99    VALUE 1.
       01  wn-outcounter        PIC 99    VALUE 1.
       01  wc-final-string      PIC X(40) VALUE SPACE.
       linkage section.
       01  ln-rtn-code                    PIC  S99.
       01  lc-post-name                   PIC X(40).         
       01  lc-post-value                  PIC X(40).
       PROCEDURE DIVISION USING ln-rtn-code lc-post-name lc-post-value.
       0000-main.
           PERFORM A0100-init
           PERFORM B0100-get-post-value
           PERFORM C0100-closedown  
           EXIT PROGRAM
           .
       A0100-init.
           MOVE -1 TO ln-rtn-code
           OPEN INPUT postfilein
           .
       B0100-get-post-value.
           READ postfilein
              AT END
                   SET is-eof-input TO TRUE
           END-READ
           IF NOT is-eof-input
              MOVE ZERO TO ln-rtn-code
              PERFORM UNTIL is-eof-input OR value-is-found
                 IF fc-post-name = lc-post-name
                     PERFORM B0110-convert-to-utf8
                     INSPECT wc-final-string CONVERTING "+" to " " 
                     MOVE wc-final-string TO lc-post-value
                     SET value-is-found TO TRUE
                 END-IF
                 READ postfilein
                      AT END
                          SET is-eof-input TO TRUE
                 END-READ              
              END-PERFORM
           END-IF
           .
       B0110-convert-to-utf8.   
           MOVE SPACE TO wc-post-string
           MOVE SPACE TO wc-cnv-post-string
           MOVE fc-post-value TO wc-post-string
           MOVE FUNCTION LENGTH(wc-post-string) TO wn-field-length
           INSPECT wc-post-string TALLYING wn-tmp-lengt
                                                 FOR TRAILING SPACES
           COMPUTE wn-str-length = wn-field-length - wn-tmp-lengt.          
           PERFORM VARYING wn-index FROM 1 BY 1
               UNTIL wn-index > wn-str-length
               IF wc-post-string(wn-index:1) = '%'
                   EVALUATE wc-post-string(wn-index:6)
                     WHEN '%C3%A5'
                         MOVE x'c3a5' TO wc-cnv-post-string(wn-index:2)
                     WHEN '%C3%A4'
                         MOVE x'c3a4' TO wc-cnv-post-string(wn-index:2)
                     WHEN '%C3%B6'
                         MOVE x'c3b6' TO wc-cnv-post-string(wn-index:2)
                     WHEN '%C3%85'
                         MOVE x'c385' TO wc-cnv-post-string(wn-index:2)
                     WHEN '%C3%84'
                         MOVE x'c384' TO wc-cnv-post-string(wn-index:2)
                     WHEN '%C3%96'
                         MOVE x'c396' TO wc-cnv-post-string(wn-index:2)            
                   END-EVALUATE
                   ADD 5 TO wn-index
               ELSE
                   MOVE wc-post-string(wn-index:1) TO
                                wc-cnv-post-string(wn-index:1)
               END-IF
           END-PERFORM
           PERFORM B0120-remove-empty-bytes
           .
       B0120-remove-empty-bytes.
           MOVE SPACE TO wc-final-string
           MOVE 1 TO wn-outcounter
           PERFORM VARYING wn-incounter FROM 1 BY 1
               UNTIL wn-incounter > wn-field-length
               IF wc-cnv-post-string(wn-incounter:1) NOT = SPACE
                   MOVE wc-cnv-post-string(wn-incounter:1) TO
                           wc-final-string(wn-outcounter:1)
                   ADD 1 TO wn-outcounter
               END-IF
           END-PERFORM
           .          
       C0100-closedown.
           CLOSE postfilein
           .
