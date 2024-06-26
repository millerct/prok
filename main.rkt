#|-----------------------------------------|
 | prok, a prototype procgen               |
 | 2024                                    |
 |-----------------------------------------|#
#lang racket/gui
(require racket/gui/easy
         racket/gui/easy/operator)
(require "interpret.rkt")

(define mono (send the-font-list find-or-create-font 12 'modern 'normal 'normal))
(define/obs @log   "You awake in a dark room.")
(define/obs @input "Type here...")

(define (text-entered event content)
  (when (eqv? event 'return)
    (:= @input "")
    (let ([input (string-upcase content)])
      (:= @log (~a (obs-peek @log) "\n> " input "\n" (interpret input))))))

(render
 (window
  #:title "Prok"
  (vpanel
   (input @log
          ;hack to prevent text editing without disabling the editor
          (λ (ev cnt) (let ([old (obs-peek @log)]) (:= @log "") (:= @log old)))
          #:style '(multiple)
          #:min-size '(600 400)
          #:stretch '(#t #t)
          #:font mono)
   (input @input
          text-entered
          #:enabled? #t
          #:style '(single)
          #:stretch '(#t #f)
          #:font mono))))
