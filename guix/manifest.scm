(define (spec->packages spec)
  (call-with-values (lambda ()
                      (specification->package+output spec)) list))

(define packages-list
  '("acpi"
    "acpica"
    "alsa-utils"
    "autoconf"
    "automake"
    "bash"
    "bzip2"
    "cmst"
    "connman"
    "cuirass"
    "cups"
    "curl"
    "emacs"
    "emacs-ag"
    "emacs-debbugs"
    "emacs-evil"
    "emacs-exwm"
    "emacs-f"
    "emacs-flx"
    "emacs-guix"
    "emacs-hydra"
    "emacs-ido-ubiquitous"
    "emacs-magit-popup"
    "emacs-markdown-mode"
    "emacs-mu4e-alert"
    "emacs-paredit"
    "emacs-page-break-lines"
    "emacs-pdf-tools"
    "emacs-rainbow-delimiters"
    "emacs-s"
    "emacs-smex"
    "emacs-strace-mode"
    "ethtool"
    "file"
    "firefox@52"
    "font-dejavu"
    "gcc-toolchain"
    "geiser"
    "gettext"
    "git"
    "git:send-email"
    "gparted"
    "guile-json"
    "global"
    "gnutls"
    "gnupg"
    "guile"
    "help2man"
    "htop"
    "icu4c"
    "isync"
    "imagemagick"
    "libevent"
    "libgcrypt"
    "libtool"
    "libreoffice"
    "linux-nonfree"
    "lm-sensors"
    "lzop"
    "magit"
    "make"
    "mcron"
    "mesa"
    "mplayer"
    "mu"
    "ncdu"
    "ncurses"
    "nmap"
    "ntfs-3g"
    "nss"
    "ntp"
    "openssh"
    "openssl"
    "pavucontrol"
    "perl"
    "pinentry"
    "pinentry-tty"
    "pkg-config"
    "powertop"
    "pulseaudio"
    "python"
    "python-wrapper"
    "qemu"
    "qt"
    "ratpoison"
    "reptyr"
    "rsync"
    "screen"
    "setxkbmap"
    "shotwell"
    "slim"
    "speedtest-cli"
    "sqlite"
    "strace"
    "texi2html"
    "texinfo"
    "transmission"
    "transmission:gui"
    "tree"
    "unrar"
    "unzip"
    "vim"
    "vlc"
    "w3m"
    "wget"
    "wpa-supplicant"
    "xbacklight"
    "xdg-utils"
    "xev"
    "xrandr"
    "xrdb"
    "yasm"
    "zip"
  ))

(packages->manifest
 (map spec->packages packages-list))
