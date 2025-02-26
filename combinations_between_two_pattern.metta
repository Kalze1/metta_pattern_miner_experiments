; Reconstruct an atom by extracting its first element
(= (rebuild-atom $head $tail) 
    (if (== $head ()) 
        $tail
        (let* (
            ($first (car-atom $head))
            ($rest (cdr-atom $head))
            ($result (cons-atom $first $tail))
        ) 
        (rebuild-atom $rest $result))
    )
)

; Function to extract variables from a pattern
(= (extract-variables $pattern $vars) 
    (let* (
        ($restructured 
            (let $head (car-atom $pattern) 
                (if (== (get-metatype $head) Expression)
                    (let $tail (cdr-atom $pattern) 
                        (rebuild-atom $head $tail)
                    ) 
                    $pattern
                )
            )
        )
        ($vars1 
            (let $head1 (car-atom $restructured) 
                (if (== (get-metatype $head1) Variable)
                    (let $updatedVars (cons-atom $head1 $vars) 
                        $updatedVars
                    ) 
                    $vars
                )
            )
        )
        ($new-pattern (cdr-atom $restructured))
    ) 
    (if (== $new-pattern ()) 
        $vars1  
        (extract-variables $new-pattern $vars1)
    )
))


; Function to count the number of elements in a tuple
(= (tuple-count $tuple) 
    (if (== $tuple ()) 
        0 
        (+ 1 (tuple-count (cdr-atom $tuple)))
    )
)


; Function to generate combinations of variables
(= (combine-variables $vars $count $combinations) (
    let* (
        ($tmp-vars (superpose $vars))
        ($tmp-combinations (if (== (car-atom ($combinations)) ()) () (superpose $combinations)))

        ($new-pattern (cons-atom $tmp-vars $tmp-combinations))
    ) (if (== $count 1) $new-pattern (combine-variables $vars (- $count 1) (collapse $new-pattern))) 
))

; Function to create combinations of variables from two patterns
(= (create-combination $pattern1 $pattern2) 
    (let* (
        ($vars1 (extract-variables $pattern1 ()))
        ($vars2 (extract-variables $pattern2 ()))
        ($all-vars (union-atom $vars1 $vars2))
    ) 
    (combine-variables $all-vars (tuple-count $vars2) ())
))


!(experimenting with the second pattern that has 1 variable)
!(create-combination (link $AAA $BBB) (link CCC $DDD))

!(experimenting with the second pattern that has 2 variables)
!(create-combination (link $AAA $BBB) (link $CCC $DDD))

!(experimenting with the second pattern that has 3 variables)
!(create-combination (link $AAA $BBB) (link $CCC (link1 $DDD $EEE)))