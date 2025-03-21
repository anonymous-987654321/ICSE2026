                     identification division.
                     function-id. gregorian_to_linear.
                     environment division.
                     configuration section.
                     repository.
                         function isleapyear
                         function floor-div
                         function all intrinsic.
                     data division.
                     working-storage section.
                     01  fdm-x   pic s9(8) comp-5.
                     01  c4      pic s9(8) comp-5 value 4.
                     01  c12     pic s9(8) comp-5 value 12.
                     01  c100    pic s9(8) comp-5 value 100.
                     01  c400    pic s9(8) comp-5 value 400.
                     01  gtl-year-less-1  pic s9(5) comp-5.
                     01  gtl-temp-days    pic 9999  comp-5.
                     linkage section.
                     01  gtl-year         pic s9(5) comp-5.
                     01  gtl-month        pic 99    comp-5.
                     01  gtl-day-of-month pic 99    comp-5.
                     01  gtl-linear       pic s9(8) comp-5.
                     procedure division using gtl-year gtl-month gtl-day-of-month returning gtl-linear.
                     0100-main.
                         subtract 1 from gtl-year giving gtl-year-less-1.
                         multiply gtl-year-less-1 by 365 giving gtl-linear.
                         move gtl-year-less-1 to fdm-x.
                         add floor-div(fdm-x, c4) to gtl-linear.
                         subtract floor-div(fdm-x, c100) from gtl-linear.
                         add floor-div(fdm-x, c400) to gtl-linear.
                         multiply 367 by gtl-month giving gtl-temp-days.
                         subtract 362 from gtl-temp-days giving fdm-x.
                         add floor-div(fdm-x, c12) to gtl-linear.
                         add gtl-day-of-month to gtl-linear.
                         if gtl-month > 2
                             if isleapyear(gtl-year) = 'Y'
                                 subtract 1 from gtl-linear
                             else
                                 subtract 2 from gtl-linear
                             end-if
                         end-if.
                         goback.
                     end function gregorian_to_linear.
