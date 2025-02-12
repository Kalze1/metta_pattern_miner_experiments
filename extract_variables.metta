  ; Reconstruct an atom by extracting its first element
(= (rebuild-atom $head $tail) (if (== $head ()) $tail
        (let* ( ($first (car-atom $head))
                ($rest (cdr-atom $head))
                ($result (cons-atom $first $tail))) (rebuild-atom $rest $result))))


; Function to extract variables from a pattern
(= (extract-variables $pattern $vars ) (
    let* (
        ($restructured (let $head (car-atom $pattern) (if (== (get-metatype $head) Expression)
            (let $tail (cdr-atom $pattern) (rebuild-atom $head $tail)) $pattern)))
        ($vars1 (let $head1 (car-atom $restructured) (if (== (get-metatype $head1) Variable)
            (let $updatedVars (cons-atom $head1 $vars) $updatedVars) $vars)))
        ($new-pattern (cdr-atom $restructured))
    ) (if (== $new-pattern ()) $vars  (extract-variables $new-pattern $vars1))
)
)


 ; Test extract-variables function
! (extract-variables (link (link1 $X $y) (link2 $t $s)) ())
