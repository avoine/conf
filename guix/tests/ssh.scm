(use-modules (ssh auth)
             (ssh session)
             (ssh dist)
             (ssh dist node))

(define ss (make-session #:user "mathieu"
                         #:host "hermione"
                         #:config #t))
(connect! ss)
(userauth-public-key/auto! ss)
(define nn (make-node ss))

(define (testlol node)
  (catch #t
    (lambda () (node-eval node '(+ 2 3 e)))
    (lambda (key . args)
      (display args)
      (newline))))
