;;;; emacs-21.3.1
;

;; Turn on debugging (comment this out for normal use)
(setq debug-on-error t)

(add-to-list 'load-path "~/emacs_files")
(add-to-list 'load-path "~/emacs_files/s.el")

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; MacOS X specific stuff
(setq mac-option-modifier 'hyper)
(setq mac-command-modifier 'meta)
; Delete selected text
(delete-selection-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(adaptive-fill-mode nil)
 '(auto-save-interval 3000)
 '(auto-save-timeout 300)
 '(c++-mode-hook (quote (turn-on-auto-fill)))
 '(c-basic-offset 2)
 '(c-ignore-auto-fill nil)
 '(c-initialization-hook (quote (turn-on-auto-fill)))
 '(c-mode-common-hook (quote (turn-on-auto-fill)))
 '(c-mode-hook (quote (turn-on-auto-fill)))
 '(c-special-indent-hook (quote (turn-on-auto-fill)))
 '(case-fold-search t)
 '(cc-mode-hook (quote (turn-on-auto-fill cc-mode-hook-identify)))
 '(column-number-mode t)
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(fill-column 78)
 '(global-font-lock-mode t nil (font-lock))
 '(global-hl-line-mode t nil (hl-line))
 '(hl-line-face (quote highlight))
 '(indent-tabs-mode nil)
 '(mouse-wheel-mode t nil (mwheel))
 '(objc-mode-hook (quote (turn-on-auto-fill)))
 '(server-host "ntv-mbp")
 '(server-mode t)
 '(show-paren-mode t nil (paren))
 '(tags-case-fold-search nil)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(transient-mark-mode t))

 (global-set-key [f1]  'goto-line)
 (global-set-key [f2]  'revert-buffer)
 (global-set-key [(control -)]  'undo)
 (require 'redo+)
 (global-set-key [(control =)]  'redo)

(global-set-key [f3] '(lambda () (interactive) (list (split-window-horizontally) (other-window 1))))
(global-set-key [f4] '(lambda () (interactive) (list (split-window-vertically) (other-window 1))))

;; Open everything in c++-mode
(setq auto-mode-alist
	  (append '(("\\.C$"  . c++-mode)
		    ("\\.cu$" . c++-mode)
		    ("\\.cc$" . c++-mode)
		    ("\\.hh$" . c++-mode)
		    ("\\.c$"  . c++-mode)
		    ("\\.h$"  . c++-mode)
		    ("\\.bsh$"  . java-mode)
		    ("\\.java$"  . java-mode)
		    ("\\.java.in$"  . java-mode)) auto-mode-alist))

;; Show column number at bottom of screen
(column-number-mode 1)

;; add pretty colors
(setq font-lock-maximum-decoration t)

;; ispell needs aspell installed and file ispell
;(global-set-key "\M-$" 'ispell-complete-word)

;;; Tramp stuff
;(require 'tramp)
;(setq tramp-default-method "scpx")
;(custom-set-variables
; '(load-home-init-file t t))
;(custom-set-faces)
;(setq tramp-auto-save-directory "~/emacs/tramp-autosave")

;; Colin's tramp stuff
;(require 'tramp)
;(require 'tramp-sh)
;(require 'list-fns)
;(set-alist-slot 'tramp-default-method-alist
;                 "bedev" '("ntv" "sshx"))
;(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;(setq tramp-password-prompt-regexp
;      "^.*\\([Pp]ass\\(?:code\\|phrase\\|word\\)\\).*:\0? *")

;;; Tabbing stuff
(require 'tabbar)
(tabbar-mode) ;comment out this line to start without the tab on top
(global-set-key [(meta shift h)] 'tabbar-mode)
(global-set-key [(meta shift up)] 'tabbar-backward-group)
(global-set-key [(meta shift down)] 'tabbar-forward-group)
(global-set-key [(meta shift left)] 'tabbar-backward)
(global-set-key [(meta shift right)] 'tabbar-forward)
(global-set-key [(meta next)] 'tabbar-forward-tab)
(global-set-key [(meta prior)] 'tabbar-backward-tab)
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)

;; Have highlighting all the time
(global-font-lock-mode 1)

;; use spaces, not tabs for indenting
(setq-default indent-tabs-mode nil)


(if (locate-library "python")
    (require 'python)) ;; python mode available in emacs >= 22

(add-hook 'python-mode-hook
          (lambda ()
            (highlight-80+-mode t)
            ))

;; show trailing whitespace ...
(set-face-background 'trailing-whitespace "#900000")
(setq-default show-trailing-whitespace t)
;; ... and terminate with extreme prejudice
(defun delete-trailing-whitespace-sometimes () ""
  (if (not (eq major-mode 'diff-mode))
      (delete-trailing-whitespace)))
(add-hook 'write-file-hooks 'delete-trailing-whitespace-sometimes)

;; don't show trailing whitespaces on terminals!
(add-hook 'term-mode-hook
          (lambda () (setq show-trailing-whitespace nil)))

(require 'highlight-80+)
(let
    ((mode-hook (lambda ()
            (c-set-style "fb-php-style")
            (highlight-80+-mode t)
            ; php-mode.el disables this, but that conflicts with arc lint
            (set (make-local-variable 'require-final-newline) t)
            ; Turn on pfff-flymake by default.  pfff-flymake-enabled is the
            ; killswitch, defining it and setting to nil forces pfff-flymake
            ; off.
            (when (or (not (boundp 'pfff-flymake-enabled))
                      pfff-flymake-enabled)
              (pfff-flymake-mode t)
              )
            ; turn on autocomplete
            (hh-complete-hook)
            )))
  (add-hook 'php-mode-hook mode-hook)
  (add-hook 'xhp-mode-hook mode-hook))

;;=========================================================
;;Python Indentation Style
;;========================================================
(add-hook 'python-mode-hook
          (lambda ()
            (set-variable 'python-indent 4)
            (highlight-80+-mode t)
            ))
