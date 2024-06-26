#lang racket/gui
(provide (all-defined-out))

(struct pos (x y))
;for clarity - an x/y pair that represents a dimension instead of a position
(struct dim pos ())

(struct object (name))

(struct item object (size))
(struct equipment item (type))
(struct weapon equipment (damage))
(struct armor equipment (resistance))

(struct entity object ((inventory #:mutable)))
(struct creature entity (species
                         (health #:mutable)
                         (equipment #:mutable)))
(struct player creature (capacity))

(struct room entity (size))
