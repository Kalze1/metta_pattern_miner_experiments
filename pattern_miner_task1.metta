; Define the data
; Example inheritance relationships are added as atoms
(Inheritance Alice human)  
(Inheritance Alice human)  
(Inheritance Eve woman)    
(Inheritance Frank tall)
(Inheritance Alice human)  
(Inheritance Alice human)  
(Inheritance Eve woman)    
(Inheritance Frank tall)
(Type Alice human)  
(Type Alice human)  
(Type Eve woman)    
(Type Frank tall)
(Type Alice human)  
(Type Alice human)  
(Type Eve woman)    
(Type Frank tall)
(Type Alice human)  
(Type Alice human)  
(Type Eve woman)    
(Type Frank tall)

;; Create and bind spaces for storing data and patterns

!(bind! &db (new-space))  ; Create a new space to store the dataset
!(match &self (Inheritance $x $y) (add-atom &db (Inheritance $x $y))) 

!(match &self (Type $x $y) (add-atom &db (Type $x $y))) 

; Define a space to store specializations (patterns with their generalizations or specifics)
!(bind! &specializations (new-space))  ; A space to store specialized patterns

; Define a space to store the selected patterns (those with frequency above the threshold)
!(bind! &pattern (new-space))  ; A space for patterns that meet the minimum frequency threshold

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Extract the specialization set based on a pattern and perform shallow abstraction.

; The specialize function generates specializations for a given pattern.
; It matches and extracts specialization sets for the given link ($link).
(= (specialize $db $link) (
    (match $db ($link $w $z)  (  ; Match $link patterns in the database and extract their components
        (() (add-atom &specializations ($link $x $z)))   ; Add specialization for variable "$x"
        (() (add-atom &specializations ($link $w $y))))) ; Add specialization for variable "$y"
))

; Apply the specialize function to the current context with the given link
!(specialize &db $link)  ; Generate specializations for the given $link
!(match &specializations ($link $x $y) ($link $x $y))  ; Show the specializations generated

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Define a start method to identify unique patterns in the &specializations space

; This method ensures patterns are unique by removing duplicates and adding only new ones.
(= (start $link $x $y) (
    let*(
            (() (remove-atom &specializations ($link $x $y 0))) ; Remove any existing patterns for this link
            (() (add-atom &specializations ($link $x $y 0)))   ; Add a new unique pattern with an initial frequency of 0
    )
    (yes)  
))

; Apply the start method to ensure uniqueness in the specialization set
!(match &specializations ($link $x $y) (start $link $x $y))

;; Define a helper method to count the number of values (tuples) for variables $x or $y
(= (tuple-count $tuple) (if (== $tuple ()) 0 (+ 1 (tuple-count (cdr-atom $tuple)))))

;; Update the frequency of patterns in the specialization set
(= (add-frequency $link $x $y $val) (
    superpose((remove-atom &specializations ($link $x $y $val))  ; Remove the old frequency
              (add-atom &specializations ($link $x $y $val))    ; Add the updated frequency
              )
))

; Count the frequency of a specific link pattern and update the specialization space
(= (count $link $x $y) (
    let $val (tuple-count (collapse(match &self ($link $x $y) $link)))  ; Calculate the frequency
    (add-frequency $link $x $y $val)  ; Update the frequency in the specialization space
))

; Apply the count method to calculate frequencies for all patterns in the specialization space
!(match &specializations ($link $x $y $v) (count $link $x $y))
!(match &specializations ($link $x $y $v) ($link $x $y $v))  ; Display the updated patterns with their frequencies

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add patterns to the &pattern space based on the frequency threshold

; Check if the frequency of a pattern is >= 3 and add it to the &pattern space if true
!(match &specializations ($link $x $y $v) 
    (if (>= $v 3) 
        (add-atom &pattern ($link $x $y))  ; Add pattern to &pattern space
        (no)  ; Skip patterns below the threshold
    )
)

; Display the final list of selected patterns based on the frequency threshold
!(********************************************************)

; Show the patterns in the &pattern space
!(match &pattern ($link $x $y) ($link $x $y))  ; Display the selected patterns