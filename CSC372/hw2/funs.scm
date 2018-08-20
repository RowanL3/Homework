#lang racket


(define (add-list a b)
  (cond 
    ((not (= (length a) (length b))) (error "unequal lengths"))
    ((null? a) '())
    (else (cons (+ (car a) (car b)) (add-list (cdr a) (cdr b))))
  )
)

(define (swap a)
	(cond
		((< (length a) 2) a)
		(else (cons (car (cdr a)) (cons (car a) (swap (cdr (cdr a))))))
	)
)

(define (add-pairs a)
	(cond 
		((= (length a) 0) '())
		(else (cons (+ (car (car a)) (car (cdr (car a)))) (add-pairs (cdr a))))
	)
)

(define (lt-list a b)
	(cond 
          ((not (= (length a) (length b))) (error "unequal lengths"))
		((null? a) '())
		((< (car a) (car b)) (cons #t (lt-list (cdr a) (cdr b))))
                (else (cons #f (lt-list (cdr a) (cdr b))))
	)
)

(define (zip a b)
	(cond
		((equal? (list? a) #f) (error "arguments must be lists"))
		((equal? (list? b) #f) (error "arguments must be lists"))
		((not (= (length a) (length b))) (error "unequal lengths"))
		((null? a) '())
		(else (cons (list (car a) (car b)) (zip (cdr a) (cdr b))))
	)
)

(define (decimal->unary n)
  (cond
  ((< n 0) (error "negative number"))
  ((> n 0) (unary->decimal (sub1 n)))
  (else '())
  )
)

(define (unary->decimal n)
  (cond
    ((not (is-unary? n)) (check-unary n))
    ((null? n) 0)
    (else (add1 (unary->decimal (cdr n))))
  )
)

(define unary-zero '())
(define unary-one '(1))
(define (isUnaryZero? n) (equal? n unary-zero))
(define (isUnaryOne? n) (equal? n unary-one))

(define (unary-add a b)
  (begin (check-unary a) (check-unary b))
  (cond
    ((null? a) b)
    (else (cons (car a) (unary-add (cdr a) b)))
  )
)

(define (unary-sub a b)
  (begin (check-unary a) (check-unary b))
  (cond
    ((isUnaryZero? (unary-add a b)) unary-zero)
    ((isUnaryZero? a) (error "negative number"))
    ((isUnaryZero? b) a)
    (else (unary-sub (cdr a) (cdr b)))
  )
)


(define (unary-lt a b)
  (begin (check-unary a) (check-unary b))
  (cond
    ((isUnaryZero? (unary-add a b)) #f)
    ((isUnaryZero? a) #t)
    ((isUnaryZero? b) #f)
    (else (unary-lt (cdr a) (cdr b)))
  )
)

(define (unary-mul a b)
  (begin (check-unary a) (check-unary b))
  (cond
    ((isUnaryZero? a) unary-zero)
    ((isUnaryZero? b) unary-zero)
    (else (unary-add a (unary-mul a (cdr b))))
  )
)

(define (is-unary? a)
  (cond
    ((not (list? a)) #f)
    ((null? a) #t)
    ((equal? (car a) 1) (is-unary? (cdr a)))
    (else #f)
  )
)

(define (check-unary a)
  (cond
    ((is-unary? a) #t)
    (else (error "not a unary number"))
  )
)

(define (unary-fac n)
  (begin (check-unary n))
  (cond
    ((not (is-unary? n)) (check-unary n))
    ((isUnaryZero? n) unary-one)
    (else (unary-mul n (unary-fac (cdr n))))
  )
)

(require rsound)
(define frame-rate 44100)
(define volume 0.1)
(define C 16.35)
(define C# 17.32)
(define D 18.35)
(define Eb 19.45)
(define E 20.60)
(define F 21.83)
(define F# 23.12)
(define G 24.50)
(define G# 25.96)
(define A 27.50)
(define Bb 29.14)
(define pause 1)


(define (a-note f octave duration)
(make-tone (* (expt 2 octave) f)
volume
(ceiling (* duration frame-rate))))
(define funky-town
  '(
(C 5 1/8) (C 5 1/8) (Bb 4 1/8) (C 5 1/8) (pause 0 1/8) (G 4 1/8) (pause 0 1/8) (G 4 1/8) (C 5 1/8) (F 5 1/8) (E 5 1/8) (C 5 1/8)
(pause 0 1/2)
))



(define (song->rsound song) (cond ((null? song) '()) (else (cons
(a-note
(eval (caar song)) (eval (cadar song)) (eval (caddar song)))
(song->rsound (cdr song))))))



(define (play-song song)
(play (rs-append* (song->rsound song))))

(define (slower song n) 
  (cond
   ((null? song) '())
   (else (cons (list (car (car song))  (cadar song) (* (eval (caddar song)) n)) (slower (cdr song) n)))
  )
)
(define (higher song n) 
  (cond
   ((null? song) '())
   (else (cons (list (car (car song)) (+ (cadar song) 1)   (caddar song)) (higher (cdr song) n)))
  )
)
(define (repeat-song song n) 
  (cond
   ((zero? n) '())
   (else  (append song (repeat-song song (sub1 n))))
  )
)



