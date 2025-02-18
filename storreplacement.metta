
; (= (replace-variables $pattern $variables $replacements) (
;         if (== $targetVar ()) $pattern (
;             let* (
;                 ($variable-head (car-atom $variables) )
;                 ($replacement-head (car-atom $replacements) )
;                 ($variable-tail (cdr-atom $variables))
;                 ($replacement-tail (cdr-atom $replacements))

;             ) (if (== $variable-tail ()) $pattern (replace-variable $pattern $variable-head $replacement-head $variable-tail $replacement-tail)))

;             ))
; (= (replace-variable $pattern $variable-head $replacement-head $variable-tail $replacement-tail) (
;     let $variable-head $replacement-head (replace-variables $pattern $variable-tail $replacement-tail)
; ))


;  ; Test replace-variable function by replacing $t with $test
; ! (replace-variables (link (link1 $a $b) (link2 $c $d)) ($a $c $b $d) ($aaa $ccc $bbb $ddd) )


(= (rep $pattern $var $rep ) (
    let (car-atom $var) (car-atom $rep)  (if (== 6 6) $pattern (rep $pattern (cdr-atom $var) (cdr-atom $rep) ))
))

(= (experment $pattern $var $rep) (
    let* (
        ($var-h (car-atom $var))
        ($rep-h (car-atom $rep))
        ($var-t (cdr-atom $var))
        ($rep-t (cdr-atom $rep))
        ) ($var-h $rep-h(rep $pattern $var-h $rep-h ))
))
; (= (rep $pattern $var $rep ) (
;     let $var $rep  $pattern 
; ))


!(rep (link (link1 $a $b) (link2 $c $d)) ($a $b ) ($AAA $BBB) )

; !(experment (link (link1 $a $b ) (link2 $c $d)) ($a $b $c $d $e) ($AAA $BBB $CCC $DDD $EEE) )
