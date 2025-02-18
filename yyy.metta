  ; Reconstruct an atom by extracting its first element
(= (rebuild-atom $head $tail) (if (== $head ()) $tail
        (let* ( ($first (car-atom $head))
                ($rest (cdr-atom $head))
                ($result (cons-atom $first $tail))) (rebuild-atom $rest $result))))


; Function to extract variables from a pattern
(= (extract-variables $pattern $vars ) (
    let* (
        ($head (car-atom $pattern))
        ($tail (cdr-atom $pattern))
        ($restructured (if (== (get-metatype $head) Expression) (rebuild-atom $head $tail) $pattern))
        ($reconstructed-head (car-atom $restructured))
        ($var-updated (if (== (get-metatype $reconstructed-head) Variable) (cons-atom $reconstructed-head $vars) $vars))
        (() (if (== (get-metatype $reconstructed-head) Expression) (extract-variables $restructured $var-updated) ()))
        ($new-pattern (cdr-atom $restructured))
    ) (if (== $new-pattern ()) $var-updated  (extract-variables $new-pattern $var-updated))
)
)


 ; Test extract-variables function
 ! (extract-variables (inheritance $z $e) ())

; ! (extract-variables (($X) ) ())
