;; (primitive-load "/home/mathieu/guix/gnu/system/bootloader.scm")

(use-modules (guix store)
             (gnu packages bootloaders)
             (gnu system bootloader)
             (guix gexp)
             (guix packages)
             (guix build utils)
             (guix derivations))

(define %store (open-connection))

(define bootloader (run-with-store %store
                     (package->derivation syslinux)))

(define bootloader-path (derivation->output-path bootloader))
(build-derivations %store (list bootloader))

(define install-kikoo
  #~(lambda (bootloader device mount-point)
      (mkdir #$output)
      (copy-file
       (string-append bootloader "/share/syslinux/cmd.c32")
       (string-append #$output "/cmd.c32"))
      ))

(define install-kikoo2
  #~(lambda (bootloader device mount-point)
      (let ((extlinux (string-append bootloader "/sbin/extlinux"))
            (install-dir (string-append mount-point "/boot/extlinux"))
            (syslinux-dir (string-append bootloader "/share/syslinux")))
        (mkdir-p #$output)
        ;; (for-each (lambda (file)
        ;;             (copy-file file
        ;;                        (string-append #$output "/" (basename file))))
        ;;           (find-files syslinux-dir "\\.c32$"))
        )))

(define install-syslinux2
  (lambda (bootloader device mount-point)
      (let ((extlinux (string-append bootloader "/sbin/extlinux"))
            (install-dir (string-append mount-point "/tmp/syslinux"))
            (syslinux-dir (string-append bootloader "/share/syslinux")))
        (mkdir-p install-dir)
        (for-each (lambda (file)
                    (format #t "copy ~a -> ~a\n" file (string-append install-dir "/" (basename file)))
                    (copy-file file
                               (string-append install-dir "/" (basename file))))
                  (filter (lambda (file) (string=? syslinux-dir (dirname file)))
                          (find-files syslinux-dir "\\.c32$")))
        )))

;; (define kikoo-drv (run-with-store %store
;;                     (gexp->derivation "kikoo"
;;                                       #~(#$install-kikoo #$syslinux "/dev/sda" "/"))))

;; (build-derivations %store (list kikoo-drv))
;; (derivation->output-path kikoo-drv)

