#lang racket

(define pi 3.14159265)

(define (cylinder-surface-area r h)
  (+ (* 2 pi r h)
     (* 2 pi (expt r 2)))
)

(define (max3 a b c)
  (cond ((and (>= a b) (>= a c)) a)
        ((and (>= b a) (>= b c)) b)
        (else c))
)

(define (rac lat)
   (car (reverse lat))
)
(define (snoc a lat)
   (reverse  (cons a (reverse lat)))
)

(define (rdc lat)
   (reverse  (cdr (reverse lat)))
)

(define (inc lat)
  (cond
    ((null? lat) '())
    (else (cons (add1 (car lat)) (inc (cdr lat))))
    )
)

(define (power-of-two? n)
  (cond
    ((< n 2) #f)
    ((= n 2) #t)
    ((> n 2) (power-of-two? (/ n 2)))
    )
  )

(define (dup n x)
  (cond
  ((= 0 n) '())
  (else (cons x (dup (sub1 n) x)))
  )
 )

(define (ordered lat)
  (cond
    ((<= (length lat) 1) #t)
    ((> (car lat) (car (cdr lat))) #f)
    (else (ordered (cdr lat)))
  )
 )

(define (take n lat)
  (cond
    ((= n 0) '())
    ((null? lat) (error "not enough elements"))
    ((= n 1) (car lat))
    ((> n 1) (take (sub1 n) (cdr lat)))
  )
)

(define (drop n lat)
  (cond
    ((= n 0) lat)
    ((null? lat) (error "not enough element"))
    (else (drop (sub1 n) (cdr lat)))
  )
)

(define (prod lat)
  (cond
  ((= (length lat) 1) (car lat))
  (else (* (car lat) (prod (cdr lat))))
  )
 )

(define (>=0 lat)
  (cond
    ((null? lat) #t)
    ((> (car lat) 0) (>=0 (cdr lat)))
    (else #f)
  )
)

(define (fibonacci? lat)
  (cond
    ((< (length lat) 3) (error "the argument list should have at least three elements"))

    (else (fibonacci-h lat))
  )
)

(define (fibonacci-h lat)
  (cond 
    ((< (length lat) 3) #t)
    ((= (+ (car lat) (car (cdr lat))) (car (cdr (cdr lat)))) (fibonacci-h (cdr lat)))
    (else #f)
  )
)

(define (nth n lat)
  (cond
    ((null? lat) (error "no such element"))
    ((= 0 n) (car lat))
    (else (nth (sub1 n) (cdr lat)))
 )
)

(define (every-other l)
  (cond
    ((null? l) '())
    (else (cons (car l) (every-other-h (cdr l))))
  )
 )

(define (every-other-h l)
  (cond
    ((null? l) '())
    (else (every-other (cdr l)))
  )
 )
 
(define (max-list l)
  (cond
    ((null? l) (error "can't take max of an empty list"))
    ((= (length l) 1) (car l))
    ((> (car l) (max-list (cdr l))) (car l))
    (else (max-list (cdr l)))
  )
  )

(define (! n)
  (cond
    ((= n 0) 1)
    (else (* n (! (sub1 n))))
    )
  )

(define (exp m n)
  (cond
    ((= n 0) 1)
    (else (* m (exp m (sub1 n))))
  )
)

(define (arctan x n)
  (cond
    ((< n 0) 0)v
    v
    v
    
    (else (+ (/ (* (exp -1 n) (exp x (+ (* 2 n) 1))) (! (+ (* 2 n) 1))) (arctan x (sub1 n)))
    )
  )
  )

(define (myPI)
  (exact->inexact (+ (* 4 (- (* 4 (arctan  1/5 10)) (arctan 1/239 10)))))
  )