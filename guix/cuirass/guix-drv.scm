(use-modules (guix config)
             (guix store)
             (guix grafts)
             (guix packages)
             (guix ui)
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

(define (drv-list store arguments)
  (let* ((manifest
         (load* "/home/mathieu/conf/guix/manifest.scm"
                (make-user-module
                 '((guix profiles) (gnu)))))
         (packages
          (map manifest-entry-item
               (manifest-entries manifest))))
    (parameterize ((%graft? #f))
      (map (lambda (package)
             (drv-package store package))
           (delete-duplicates! packages)))))
