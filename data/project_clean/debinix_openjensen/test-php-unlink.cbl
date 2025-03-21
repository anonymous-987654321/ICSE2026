       IDENTIFICATION DIVISION.
       program-id. test-php-unlink.
       ENVIRONMENT DIVISION.
       input-output section.
       file-control.           
           SELECT OPTIONAL statusfile 
              ASSIGN TO '../data/status'
              ORGANIZATION IS LINE SEQUENTIAL.              
       DATA DIVISION.
       file section.     
       FD  statusfile.
       01  fd-fileout-status         PIC  X(1) VALUE SPACE. 
       working-storage section.
       01 wc-file-name               PIC  X(60) VALUE SPACE.
       01 wc-dest-path               PIC  X(80) VALUE SPACE.
       PROCEDURE DIVISION.
       0000-main.
           PERFORM Z0100-write-status-ok-file
           GOBACK
           .
       Z0100-write-status-ok-file.
           MOVE '../data/phpunlinktest' TO wc-file-name
           OPEN EXTEND statusfile           
           CLOSE statusfile
           MOVE SPACE TO wc-dest-path    
           STRING wc-file-name DELIMITED BY SPACE 
                          '.'  DELIMITED BY SPACE
              'OK' DELIMITED BY SPACE
                               INTO wc-dest-path
           CALL 'CBL_COPY_FILE' USING '../data/status', wc-dest-path
           CALL 'CBL_DELETE_FILE' USING '../data/status'           
           .
