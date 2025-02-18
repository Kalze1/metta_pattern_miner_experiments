
(= (replace-variables $pattern $variables $replacements) (
    let* (
        ($variable-head (car-atom $variables) )
        ($replacement-head (car-atom $replacements) )
        ($pattern-new (collapse(let $variable-head $replacement-head $pattern)))
        ($variable-tail (cdr-atom $variables))
        ($replacement-tail (cdr-atom $replacements))

    ) (if (== $variable-tail ()) (superpose $pattern-new) (replace-variables (superpose $pattern-new) $variable-tail $replacement-tail))

    ))


 ; Test replace-variable function by replacing $t with $test
! (replace-variables (link (link1 $a $b) (link2 $c $d)) ($a $c $b $d) ($aaa $ccc $bbb $ddd) )


