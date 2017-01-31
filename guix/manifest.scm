(define (spec->packages spec)
  (call-with-values (lambda ()
                      (specification->package+output spec)) list))

(primitive-load "/home/mathieu/conf/guix/packages.scm")

(packages->manifest
 (map spec->packages packages-list))
