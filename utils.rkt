#lang racket/gui
(require "structs.rkt")
(provide (all-defined-out))

(define (find-object obj where)
  (find-object-by-name (object-name obj) where))

(define (find-object-by-name obj-name where)
  (findf (λ (o) (string=? obj-name (object-name o)))
         (if (creature? where)
             (append (creature-equipment where) (entity-inventory where))
             (entity-inventory where))))

(define (object-names where)
  (map object-name (entity-inventory where)))

(define (equipment-names where)
  (map object-name (creature-equipment where)))

(define (equipment-types creature)
  (filter string?
          (map (λ (e)
                 (unless (string=? (equipment-type e) "invis")
                   (equipment-type e)))
               (creature-equipment creature))))

(define (oxford-list lst)
  (if (empty? lst)
      "nothing."
      (string-join lst ", "
                   #:before-last ", and "
                   #:after-last ".")))

(define-syntax-rule (append-str! str1 str2)
  (set! str1 (~a str1 str2)))

(define (add-to-inventory! ent obj)
  (set-entity-inventory! ent (append (entity-inventory ent) (list obj))))
(define (remove-from-inventory! ent obj)
  (set-entity-inventory! ent (remove obj (entity-inventory ent))))
(define (move-obj! obj from to)
  (let ([obj-str (object-name obj)]
        [from-str (object-name from)])
    (add-to-inventory! to obj)
    (remove-from-inventory! from obj)
    (~a "Took " obj-str " from " from-str ".")))