(use-modules (srfi srfi-1))

(define guix-master
  `((#:name . "guix")
    (#:url . "git://git.savannah.gnu.org/guix.git")
    (#:branch . "master")
    (#:no-compile? . #t)
    (#:load-path . ".")
    (#:proc . drv-list)
    (#:file . "/home/mathieu/conf/guix/cuirass/guix-drv.scm")))

(define guix-github
  `((#:name . "guix")
    (#:url . "https://github.com/mothacehe/guix.git")
    (#:branch . "master")
    (#:no-compile? . #t)
    (#:load-path . ".")
    (#:proc . drv-list)
    (#:file . "/home/mathieu/conf/guix/cuirass/guix-drv.scm")))

(list guix-master)
