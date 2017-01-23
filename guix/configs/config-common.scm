(use-modules (gnu)
             (linux-nonfree))
(use-service-modules desktop xorg networking dbus cups ssh)
(use-package-modules admin certs ssh version-control)

(define %common-bootloader
 (grub-configuration (device "/dev/sda")
                     (timeout 1)))

(define %common-initrd
 (lambda (file-systems . rest)
   (apply base-initrd file-systems
          ;; #:load-modules? #t
          #:virtio? #f
          #:qemu-networking? #f
          rest)))

(define %common-file-systems
  (cons (file-system
          (device "my-root")
          (title 'label)
          (mount-point "/")
          (type "ext4"))
        %base-file-systems))

(define %common-swap '("/dev/sda2"))

(define %common-users
  (cons (user-account
         (name "mathieu")
         (group "users")
         (supplementary-groups '("wheel" "netdev"
                                 "audio" "video"))
         (home-directory "/home/mathieu"))
        %base-user-accounts))

(define %common-packages
  (cons* nss-certs openssh git %base-packages))

(define %common-base-services
  (modify-services %base-services
    (guix-service-type config =>
                       (guix-configuration
                        (inherit config)
                        (substitute-urls '("https://mirror.hydra.gnu.org"
                                           "https://bayfront.guixsd.org"))
                        (extra-options '("--gc-keep-derivations"
                                         "--gc-keep-outputs"))))))

(define %common-services
  (cons* (slim-service #:auto-login? #t #:default-user "mathieu")
         (service wpa-supplicant-service-type wpa-supplicant)
         (service openssh-service-type
                  (openssh-configuration
                   (x11-forwarding? #t)
                   (password-authentication? #f)
                   (permit-root-login 'without-password)))
         (connman-service)
         (dbus-service)
         (ntp-service #:allow-large-adjustment? #t)
         %common-base-services))

(define %common-os
  (operating-system
    (host-name "dummy")
    (timezone "Europe/Paris")
    (locale "en_US.UTF-8")
    (sudoers-file (plain-file "sudoers"
                              (string-append "root ALL=(ALL) ALL\n"
                                             "%wheel ALL=(ALL) ALL\n"
                                             "mathieu ALL=(ALL) NOPASSWD: ALL")))
    (bootloader %common-bootloader)
    (kernel linux-nonfree)
    (initrd %common-initrd)

    (file-systems %common-file-systems)
    (swap-devices %common-swap)

    (users %common-users)

    (packages %common-packages)
    (services %common-services)))
