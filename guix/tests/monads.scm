;; interesting links
;; https://cgi.soic.indiana.edu/~c311/lib/exe/fetch.php?media=manymonads.pdf
;; http://planet.racket-lang.org/package-source/toups/functional.plt/1/1/planet-docs/better-monads-guide/index.html
;; http://okmij.org/ftp/Scheme/monad-in-Scheme.html

(define (make-numbered-value tag val) (cons tag val))
(define (nvalue-tag tv) (car tv))
(define (nvalue-val tv) (cdr tv))

;;-- return:: a -> NumberedM a
(define (return val)
  (lambda (curr_counter)
    (make-numbered-value curr_counter val)))

;;-- (>>=):: NumberedM a -> (a -> NumberedM b) -> NumberedM b
(define (>>= m f)
  (lambda (curr_counter)
    (let* ((m_result (m curr_counter))
           (n1 (nvalue-tag m_result))
           (v  (nvalue-val m_result))
           (m1 (f v)))
      (m1 n1))))

(define incr
  (lambda (n)
    (make-numbered-value (+ 1 n) n)))

(define (runM m init-counter)
  (m init-counter))

(define (make-node val kids)
       (>>=
        incr
        (lambda (counter)
          (return (cons (make-numbered-value counter val) kids)))))
