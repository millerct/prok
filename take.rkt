#lang racket/gui
(require "utils.rkt"
         "structs.rkt")
(provide take)

(define (take args where who)
  (if (empty? args)
      "You need to say what to take."
      (let* ([args-str (string-join args)]
             [split-str (string-split args-str " FROM ")]
             [what-str (first split-str)]
             [from-str (if (= 1 (length split-str))
                           '()
                           (last split-str))]
             [from (if (empty? from-str)
                       where
                       (find-object-by-name from-str where))]
             [what (find-object-by-name what-str from)])
        (when (empty? from-str)
          (set! from-str (object-name where)))
        (if what
            (if (creature? what)
                "You can't take a living thing."
                (if (entity? what)
                    "You can't take something with an inventory."
                    (move-obj! what from who)))
            (~a "There isn't a \"" what-str "\" in this area.")))))