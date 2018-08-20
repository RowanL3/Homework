#lang racket

(define (sum l) (cond
  ((null? l) 0)
  (else (+ (car l) (sum (cdr l))))))

(define (deep-sum l) (cond
	((null? l) 0)
	((list? l) (+ (deep-sum (car l)) (deep-sum (cdr l))))
	(else l)))

(define (deep-inc l) (cond
	((null? l) '())
	((list? l) (cons (deep-inc (car l)) (deep-inc (cdr l))))
	(else (add1 l))))


