; Reconstruct an atom by extracting its first element
(= (rebuild-atom $head $tail) (if (== $head ()) $tail
        (let* (
            ($first (car-atom $head))
            ($rest (cdr-atom $head))
            ($result (cons-atom $first $tail))
        ) (rebuild-atom $rest $result))))


; Extract variables from a pattern
(= (extract-vars $pattern $vars) 
    (let* (
        ($restructured (let $head (car-atom $pattern) (if (== (get-metatype $head) Expression) (let $tail (cdr-atom $pattern) (rebuild-atom $head $tail)) $pattern)))
        ($vars1 (let $head1 (car-atom $restructured) (if (== (get-metatype $head1) Variable)(let $updatedVars (cons-atom $head1 $vars) $updatedVars) $vars)))
        ($new-pattern (cdr-atom $restructured)))
    (if (== $new-pattern ()) $vars1 (extract-vars $new-pattern $vars1))))


; Count the number of elements in a tuple
(= (count-elements $tuple) (if (== $tuple ()) 0 (+ 1 (count-elements (cdr-atom $tuple)))))


; Check if a variable is in a list
(= (is-var-in-list $var $list) (if (== $list ()) False (let $head (car-atom $list) (if (== $var $head) True (is-var-in-list $var (cdr-atom $list))))))


; Generate combinations of variables
(= (combine-vars $vars $count $combinations) 
    (let* (
        ($tmp-vars (superpose $vars))
        ($tmp-combinations (if (== (car-atom ($combinations)) ()) () (superpose $combinations)))
        ($new-pattern (cons-atom $tmp-vars $tmp-combinations)))
        (if (== $count 1) $new-pattern (combine-vars $vars (- $count 1) (collapse $new-pattern)))))

; Check if variables from one list exist in another list
(= (vars-exist $list1 $list2) (if (== $list1 ()) False (let $head (car-atom $list1) (if (is-var-in-list $head $list2) True (vars-exist (cdr-atom $list1) $list2)))))


; Get filtered combinations of variables
(= (get-filtered-combinations $all-vars $vars1 $vars2 $length) 
    (let* (
        ($combinations (combine-vars $all-vars $length ()))
        ($vars1-check (if (vars-exist $combinations $vars1) $combinations Empty))
        ($vars2-check (if (vars-exist $combinations $vars2) $combinations Empty))
    ) $combinations
))


(= (create-variables $all-vars $cleared) (
    if (== $all-vars ()) $cleared (let $head (car-atom $all-vars ) (if (is-var-in-list $head $cleared) (create-variables (cdr-atom $all-vars) $cleared) (create-variables (cdr-atom $all-vars) (cons-atom $head $cleared))))
))



; Create combinations of variables from two patterns
(= (conjunction $pattern1 $pattern2)
    (let* (
        ($vars1 (extract-vars $pattern1 ()))
        ($vars2 (extract-vars $pattern2 ()))
        ($all-vars1 (union-atom $vars1 $vars2))
        ($all-vars (create-variables $all-vars1 ()))
        ($length (count-elements $vars2))
    ) (if (== $length 1)   (let (superpose $vars1) (superpose $vars2) ($pattern1 $pattern2)) (let (superpose $vars1) (superpose $vars2) ($pattern1 $pattern2)))
))


!(experimenting with the second pattern that has 1 variable)
!(conjunction (Inheritance $X $Y) (Inheritance Z $W))


!(experimenting with the second pattern that has 2 variable)
!(conjunction (Inheritance $X $Y) (Inheritance $Z $W))

