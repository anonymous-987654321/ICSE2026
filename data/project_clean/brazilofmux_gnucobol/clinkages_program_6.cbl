identification division.
function-id. c_kdayonorbefore.
data division.
working-storage section.
    isvalid               usage   signed-int.
    88  notvalid value 0.
linkage section.
    k                   usage   unsigned-short.
    ld-max              usage   signed-int.
    results.
    05  ld                  usage   signed-int.
    05  bool              pic x.
        88  is_valid       value 'Y'.
        88  is_not_valid   value 'N'.
procedure division using k ld-max returning results.
    -main.
    call 'du_kdayonorbefore' using by value k ld-max by reference ld returning isvalid.
    if not notvalid
        move 'Y' to bool
    else
        move 'N' to bool
    end-if.
    goback.
end function c_kdayonorbefore.
