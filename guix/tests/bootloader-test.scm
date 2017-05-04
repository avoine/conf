(use-modules (gnu)
             (gnu system grub))

(define extlinux-os
  (operating-system
    (host-name "host-name")
    (timezone "Europe/Zurich")
    (bootloader (grub-configuration
                 (device "/dev/sdx")))
    (file-systems
     (cons
      (file-system
        (device "my-root")
        (title 'label)
        (mount-point "/")
        (type "ext4"))
      %base-file-systems))))

;; (define syslinux-os
;;   (operating-system
;;     (inherit extlinux-os)
;;     (bootloader (syslinux-configuration))))

(define grub-os
  (operating-system
    (inherit extlinux-os)
    (bootloader (grub-configuration
                 (device "/dev/sdx")))))

;; syslinux-os
grub-os
