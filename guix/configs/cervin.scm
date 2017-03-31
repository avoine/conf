(use-modules (gnu)
             (linux-nonfree)
             (srfi srfi-1))
(use-package-modules linux)
(use-service-modules desktop cuirass pm)

(primitive-load "/home/mathieu/conf/guix/configs/common.scm")

(define %cervin-base-services
  (cons
   (service tlp-service-type (tlp-configuration))
   (operating-system-user-services %common-os)))

(operating-system
  (inherit %common-os)
  (host-name "cervin")
  (kernel linux-nonfree)
  (kernel-arguments '("acpi_backlight=video thinkpad_acpi.debug=0xffff pcie_aspm=force"))
  (initrd (lambda (file-systems . rest)
            (apply raw-initrd file-systems
                   #:helper-packages (list e2fsck/static)
                   rest)))
  (packages (operating-system-packages %common-os))
  (services %cervin-base-services))
