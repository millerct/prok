#lang racket/gui
(require "structs.rkt"
         "utils.rkt")

(provide look)

(define (look args where who)
  (if (empty? args)
      (~a "In this area, there is: " (oxford-list (object-names where)))
      (let* ([args-str (string-join args)]
             [split-str (string-split args-str " IN ")]
             [what-str (first split-str)]
             [from-str (if (= 1 (length split-str))
                           '()
                           (last split-str))]
             [from (if (empty? from-str)
                       where
                       (find-object-by-name from-str where))]
             [what (find-object-by-name what-str from)])
        (if what
            (~a "There is a " what-str " in " (object-name from) "."
                (describe-object what))
            (~a "The \""  what-str "\" you're looking for isn't in this area.")))))

(define (describe-object obj)
  (let ([output ""])
    (cond
      [(item? obj)
       (append-str! output (~a "\nIt has a size of: "
                               (item-size obj) "."))
       (when (equipment? obj)
         (append-str! output (~a "\nIt is a piece of equipment of type: "
                                 (equipment-type obj) "."))
         (when (weapon? obj)
           (append-str! output (~a "\nIt deals "
                                   (weapon-damage obj) " damage.")))
         (when (armor? obj)
           (append-str! output (~a "\nIt has a damage resistance of: "
                                   (armor-resistance obj) "."))))]
      [(player? obj)
       (append-str! output "\nIt's you.")
       (append-str! output (~a "\nYou're at "
                               (creature-health obj) "HP."))
       (if (empty? (creature-equipment obj))
           (append-str! output (~a "\nYou don't have anything equipped."))
           (append-str! output (~a "\nYour current equipment is: "
                                   (oxford-list (equipment-names obj)))))
       (if (empty? (entity-inventory obj))
           (append-str! output (~a "\nYou don't have anything in your inventory."))
           (append-str! output (~a "\nIn your bag, you have: "
                                   (oxford-list (object-names obj)))))]
      
      [(creature? obj)
       (append-str! output (~a "\nIts species is: "
                               (creature-species obj) "."))
       (append-str! output (~a "\nIt's at "
                               (creature-health obj) "HP."))
         
       (if (empty? (creature-equipment obj))
           (append-str! output (~a "\nIt doesn't look like it's carrying anything."))
           (append-str! output (~a "\nIt looks like it's carrying: "
                                   (oxford-list (equipment-types obj)))))]
      [else
       (when (entity? obj)
         (append-str! output (~a "\nInside is: " (oxford-list (object-names obj)))))]
      )
    output))