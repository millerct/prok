#lang racket/gui
(require "structs.rkt"
         "look.rkt"
         "take.rkt"
         "utils.rkt")
(provide interpret)

;temporary hard-coded player and room with items for testing, before implementing procgen
(define room1 (room "A DARK ROOM"
                    (list (armor "LEATHER CAP" 1 "helmet" 2)
                          (entity "CHEST"
                                  (list (weapon "BIG SWORD" 4 "sword" 5)))
                          (creature "STINKY RAT"
                                    (list (item "RAT FLESH" 1))
                                    'rat
                                    6
                                    (list (weapon "YELLOW TOOTH" 1 "invis" 2)
                                          (weapon "SHARP CLAW" 1 "invis" 4))))
                    (dim 0 0)))

(define plyr (player "YOU"
                     '()
                     'human 20 '() 50))
(add-to-inventory! room1 plyr)

(define (interpret in)
  (let ([command (string-upcase in)])
    (if (or (string=? command "TYPE HERE...") (string=? command ""))
        "You need to type something in the box."
        (let* ([tokens (string-split command)]
               [verb (first tokens)]
               [args (rest tokens)])
          (case verb
            [("LOOK" "OBSERVE") (look args room1 plyr)]
            [("TAKE" "GRAB" "GIMME") (take args room1 plyr)]
            [("EQUIP" "PUT ON") (equip args room1 plyr)]
            [else (~a "I don't understand the verb " verb ".")])))))