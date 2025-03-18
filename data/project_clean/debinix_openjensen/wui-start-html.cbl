       IDENTIFICATION DIVISION.
       program-id. wui-start-html.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       working-storage section.      
       linkage section.
       01  wc-pagetitle        PIC X(20).   
       PROCEDURE DIVISION USING wc-pagetitle.
       000-start-html.
           DISPLAY
            "<!DOCTYPE HTML PUBLIC "
            "-//W3C//DTD HTML 4.01 Transitional//EN "
            "http://www.w3.org/TR/html4/loose.dtd"
            ">"
            '<html lang="sv">'
            "<head>"
            '<meta http-equiv="Content-Type"'
            'content="text/html; charset=utf-8">'	
            "<title>"
            wc-pagetitle
            "</title>"
            "<style>"
            "</style>"
            "</head>"
            "<body>"            
           END-DISPLAY        
           EXIT PROGRAM
           .
