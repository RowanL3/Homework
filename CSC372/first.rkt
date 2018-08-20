 #lang racket

 (define (len lat)
          (cond   
                 ((null? lat) 0)
                 ((even? (car lat)) (add1 (len (cdr lat))))
                 (else (len (cdr lat)))))

(define (only-even lat) (= (len lat) (length lat)))

(define (remember a lat)
  (cond
    ((null? lat) ' ())
    ((eqv? (car lat) a) (remember a (cdr lat)))
    (else (cons (car lat) (remember a (cdr lat))))))
                                   
