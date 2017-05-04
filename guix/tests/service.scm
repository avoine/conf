(primitive-load "/home/mathieu/guix/gnu/services/pm.scm")

(use-modules (guix store)
             (guix gexp)
             (guix derivations)
             (gnu services configuration)
             (gnu services pm))

(define %store (open-connection))

(define tlp-conf
  (text-file* "tlp.bite"
              (plain-file-content
               (plain-file
                "tlp.bite"
                (with-output-to-string
                  (lambda ()
                    (serialize-configuration (tlp-configuration
                                              (cpu-scaling-governor-on-ac '("cfq" "cfq"))
                                              (cpu-boost-on-ac? #t)
                                              (cpu-boost-on-bat? #t))
                                             (@@ (gnu services pm) tlp-configuration-fields))))))))

(define tlp-doc
  (plain-file
   "tlp.texi"
   (generate-tlp-documentation)))

(define lold (run-with-store %store tlp-conf))
(build-derivations %store (list lold))
(define lole (derivation->output-path lold))

;; (define docd (run-with-store %store tlp-doc))
;; (build-derivations %store (list docd))
;; (define docl (derivation->output-path docd))
