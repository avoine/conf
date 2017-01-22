(use-modules (guix config)
             (guix store)
             (guix grafts)
             (guix packages)
             (guix derivations)
             (guix monads)
             (guix profiles)
             (gnu packages)
             (gnu packages gnuzilla)
             (srfi srfi-1))

(define (profile-packages)
  (map manifest-entry-name
       (manifest-entries
        (profile-manifest "/var/guix/profiles/per-user/mathieu/guix-profile"))))

(define (drv-package store package)
  (lambda ()
    `((#:job-name . ,(string-append (package-name package) "-job"))
      (#:derivation . ,(derivation-file-name
                        (parameterize ((%graft? #f))
                          (package-derivation store package #:graft? #f)))))))

(define (drv-list store arguments)
  (parameterize ((%graft? #f))
		(map (lambda (package)
		       (drv-package store package))
		     (delete-duplicates!
		      (map specification->package+output (profile-packages))))))
