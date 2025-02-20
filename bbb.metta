; Reconstruct an atom by extracting its first element
(= (rebuild-atom $head $tail) (if (== $head ()) $tail
    (let* ( ($first (car-atom $head))
        ($rest (cdr-atom $head))
        ($result (cons-atom $first $tail))) (rebuild-atom $rest $result))))


; Function to extract variables from a pattern
(= (extract-variables $pattern $vars) (
    let* (
    ($restructured (let $head (car-atom $pattern) (if (== (get-metatype $head) Expression)
        (let $tail (cdr-atom $pattern) (rebuild-atom $head $tail)) $pattern)))
    ($vars1 (let $head1 (car-atom $restructured) (if (== (get-metatype $head1) Variable)
        (let $updated-vars (cons-atom $head1 $vars) $updated-vars) $vars)))
    ($new-pattern (cdr-atom $restructured))
    ) (if (== $new-pattern ()) $vars  (extract-variables $new-pattern $vars1))
)
)


; Check if a variable is in a list
(= (is-variable-in-list $var $list) (
    if (== $list ()) False (let $head (car-atom $list) (if (== $var $head) True (is-variable-in-list $var (cdr-atom $list))))
))


; Find duplicated variables between two lists
(= (find-duplicate-variables $list1 $list2 $duplicates) (
    if (== $list1 ()) $duplicates (
    let $head (car-atom $list1) (if (is-variable-in-list $head $list2) (find-duplicate-variables (cdr-atom $list1) $list2 (cons-atom $head $duplicates)) (find-duplicate-variables (cdr-atom $list1) $list2 $duplicates))
    )
))


!(bind! random-variable (py-atom helper.gen_random))

; Replace variables in a pattern with random variables
(= (replace-variables $pattern $variables) (
    let* (
    ($variable-head (car-atom $variables))
    ($replacement (random-variable))
    ($pattern-new (collapse (let $variable-head $replacement $pattern)))
    ($variable-tail (cdr-atom $variables))
    ) (if (== $variable-tail ()) (superpose $pattern-new) (replace-variables (superpose $pattern-new) $variable-tail))
))


; Make a difference between two patterns by replacing duplicated variables with random variables
(= (make-difference $pattern1 $pattern2) (
    let* (
    ($variables1 (extract-variables $pattern1 ()))
    ($variables2 (extract-variables $pattern2 ()))
    ($duplicates (find-duplicate-variables $variables1 $variables2 ()))
    ) (superpose ($pattern1 (replace-variables $pattern2 $duplicates)))
))


; Testing the implementation of removing duplicated variables
! (make-difference (inheritance $RRR $VVV) (some-link $RRR $SSS))
