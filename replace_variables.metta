; Substitute a variable in a pattern with a given value

; Simple and effective way to replace variables by value, but
; it has inconsistency issues when replacing variables with other variables

(= (replace-variable $pattern $var $replace) (
        let $var $replace $pattern
    ))
;Testing replace-variable
! (replace-variable (link (link1 $a $b) (link2 $c $d)) ($a $c $b $d) (aaa ccc bbb ddd) )
; inconsistent result
! (replace-variable (link (link1 $a $b) (link2 $c $d)) ($a $c $b $d) ($aaa $ccc $bbb $ddd) )

(= (replace-variables $pattern $targetVar $replacement) (
        if (== $targetVar ()) $pattern (
            let* (
                ($val1 (car-atom $targetVar) )
                ($val2 (car-atom $replacement) )
                ($val1 $val2)
                ($pattern1 $pattern)
                ($targetVar1 (cdr-atom $targetVar))
                ($replacement1 (cdr-atom $replacement))

            ) (replace-variables $pattern $targetVar1 $replacement1))

            ))



 ; Test replace-variable function by replacing $t with $test
! (replace-variable (link (link1 $a $b) (link2 $c $d)) ($a $c $b $d) (aaa ccc bbb ddd) )
! (replace-variables (link (link1 $a $b) (link2 $c $d)) ($a $c $b $d) ($aaa $ccc $bbb $ddd) )


