(use-modules (guix config)
             (guix store)
             (guix grafts)
             (guix packages)
             (guix derivations)
             (guix monads)
             (guix profiles)
             (gnu packages)
             (srfi srfi-1))

(define (drv-package store package)
  (lambda ()
    `((#:job-name . ,(string-append
                      (package-name package)
                      "-"
                      (package-version package)
                      "-job"))
      (#:derivation . ,(derivation-file-name
                        (parameterize ((%graft? #f))
                          (package-derivation store package #:graft? #f)))))))

(primitive-load "/home/mathieu/conf/guix/packages.scm")

(define (drv-list store arguments)
  (parameterize ((%graft? #f))
		(map (lambda (package)
		       (drv-package store package))
		     (delete-duplicates!
		      (map specification->package+output packages-list)))))
