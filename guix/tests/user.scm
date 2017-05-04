(use-modules (gnu services)
             (gnu services shepherd)
             (guix gexp)
             (guix store)
             (guix derivations)
             (gnu packages linux)
             (gnu packages xdisorg))

(define (test-shepherd-service config)
  (list (shepherd-service
         (documentation "Run TLP script.")
         (provision '(redshift-test))
         (requirement '())
         (start #~(make-forkexec-constructor
                   (list (string-append #$redshift "/bin/redshift")
                         "-l" "48:2")))
         (stop  #~(make-kill-destructor)))))

(define test-service-type
  (service-type
   (name 'test-user)
   (extensions
    (list
     (service-extension shepherd-user-service-type
                        test-shepherd-service)))))

;; (build-derivations (open-connection) (list (run-with-store (open-connection) (gexp->file "lol" (run-with-store (open-connection) (service-value (fold-services (list (service user-service-type #f) (service shepherd-user-service-type #f) (service test-service-type #f)) #:target-type shepherd-user-service-type)))))))

(user-configuration
 (services (list (service test-service-type #f))))
