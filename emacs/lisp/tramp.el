(setq tramp-ssh-controlmaster-options
      "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no"
      tramp-hisfile-override "/dev/null")
(with-eval-after-load 'tramp-sh
  (push "/run/current-system/profile/bin" tramp-remote-path))

(require 'tramp)
