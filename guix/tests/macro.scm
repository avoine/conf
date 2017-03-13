(use-modules (ice-9 match))

;; (let ((l '(2 3)))
;;   (match l
;;     (() 3)
;;     (x x)))

(define (id ctx part . parts)
  (let ((part (syntax->datum part)))
    (datum->syntax
     ctx
     (match parts
       (() part)
       (parts (symbol-append part
                             (syntax->datum (apply id ctx parts))))))))
(define-syntax lol
  (lambda (x)
    (syntax-case x ()
      ((_ e)
       (with-syntax
           ((ttt (id #'x #'e #'-rrr #'-ggg)))
         #'(ttt))))))

(lol bbb)
