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


(= (check-variable-in-list $var $list ) (
    if (== $list  ()) False (let $head (car-atom $list) (if (== $var $head) True (check-variable-in-list $var (cdr-atom $list))))
))



(= (find-duplicated-values $list1 $list2 $duplicats) (
    if (== $list1 ()) $duplicats (
        let $head (car-atom $list1) (if (check-variable-in-list $head $list2) (find-duplicated-values (cdr-atom $list1) $list2 (cons-atom $head $duplicats)) (find-duplicated-values (cdr-atom $list1) $list2 $duplicats))
    )
))


!(bind! gen-str (py-atom helper.gen_str))

(= (make-diffrences $pattern1 $pattern2 $duplicats) (
    let $duplicats ((gen-str)) $pattern1
))

(= (make-diffrences $pattern1 $pattern2 $duplicats) (
    let $duplicats ((gen-str)) $pattern2
))

(= (make-diffrence $pattern1 $pattern2) (
    let* (
        ($variables1 (extract-variables $pattern1 ()))
        ($variables2 (extract-variables $pattern2 ()))
        ($duplicats (find-duplicated-values $variables1 $variables2 ()))
    ) (make-diffrences $pattern1 $pattern2 $duplicats)
))

;inheritance $x $y and somellink $y $z
!(make-diffrence (inheritance $z $e) (somellink $y $z))



