(use-modules (guix scripts refresh)
             (guix profiles)
             (gnu packages)
             (guix store)
             (guix ui)
             (guix grafts)
             (guix packages)
             (srfi srfi-1))

(define %store (open-connection))

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
             (package-name package))
           (delete-duplicates! packages)))))

(define packages-list
  (with-store %store
    (drv-list %store '())))

(define packages
  (string-join packages-list " "))

(guix-refresh packages)
