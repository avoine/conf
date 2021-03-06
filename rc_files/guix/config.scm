(use-modules (gnu)
             (mat linux-nonfree))
(use-service-modules desktop xorg networking dbus cups ssh)
(use-package-modules admin certs ssh)

(define %my-base-services
  (modify-services %base-services
    (guix-service-type config =>
                       (guix-configuration
                        (inherit config)
                        (extra-options '("--gc-keep-derivations"
                                         "--gc-keep-outputs"))))))

(operating-system
  (host-name "sagarmatha")
  (timezone "Europe/Paris")
  (locale "en_US.UTF-8")
  (sudoers-file (plain-file "sudoers"
                            (string-append "root ALL=(ALL) ALL\n"
                                           "%wheel ALL=(ALL) ALL\n"
                                           "mathieu ALL=(ALL) NOPASSWD: ALL")))

  (bootloader (grub-configuration (device "/dev/sda")
                                  (timeout 1)))

  (kernel linux-rc-guix)
  ;; (kernel-arguments '("acpi_backlight=video thinkpad_acpi.debug=0xffff pcie_aspm=force i915.enable_rc6=1 i915.enable_fbc=1"))
  (kernel-arguments '("acpi_backlight=video thinkpad_acpi.debug=0xffff pcie_aspm=force"))

  (initrd (lambda (file-systems . rest)
            (apply base-initrd file-systems
                   #:load-modules? #t
                   #:virtio? #f
                   #:qemu-networking? #f
                   rest)))

  (file-systems (cons (file-system
                        (device "my-root")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  (swap-devices '("/dev/sda2"))

  (users (cons (user-account
                (name "mathieu")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/mathieu"))
               %base-user-accounts))

  (packages (cons* nss-certs openssh %base-packages))

  (services (cons* (slim-service #:auto-login? #t #:default-user "mathieu")
                   (service wpa-supplicant-service-type wpa-supplicant)
                   (service openssh-service-type
                            (openssh-configuration
                             (x11-forwarding? #t)
                             (password-authentication? #f)
                             (permit-root-login 'without-password)))
                   (connman-service)
                   (dbus-service)
                   (ntp-service #:allow-large-adjustment? #t)
                   %my-base-services)))
