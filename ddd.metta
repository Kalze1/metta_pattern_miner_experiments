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


(= (check-variable-in-list $var $list ) (
    if (== $list  ()) False (let $head (car-atom $list) (if (== $var $head) True (check-variable-in-list $var (cdr-atom $list))))
))



(= (find-duplicated-values $list1 $list2 $duplicats) (
    if (== $list1 ()) $duplicats (
        let $head (car-atom $list1) (if (check-variable-in-list $head $list2) (find-duplicated-values (cdr-atom $list1) $list2 (cons-atom $head $duplicats)) (find-duplicated-values (cdr-atom $list1) $list2 $duplicats))
    )
))

(= (replace-variable $pattern $var $replace) (
        let $var $replace $pattern
    ))


(generate-random-variable)
(= (make-diffrece $pattern1 $pattern2) (
    let* (
        ($variables1 (extract-variables $pattern1 ()))
        ($variables2 (extract-variables $pattern2 ()))
        ($duplicats (find-duplicated-values $variables1 $variables2 ()))
        ($replaceby (B))
        ($new-pattern1 (replace-variable $pattern1 $duplicats $replaceby))
    ) ($variables1 $variables2 $duplicats $new-pattern1 $pattern2 $replaceby)
))

;inheritance $x $y and somellink $y $z
!(extract-variables ($s) ())
!(make-diffrece (inheritance $y $y) (somellink $y $z))



