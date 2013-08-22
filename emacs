(add-to-list 'load-path "~/.elisp")
(add-to-list 'load-path "~/.emacs.d/elixir")
(load "php-mode")
(load "mustache-mode")
(require 'elixir-mode)

(global-set-key "\C-x\C-c" 'keyboard-quit)
(global-font-lock-mode 1)
(global-set-key "\C-cc\C-c" 'clipboard-kill-ring-save)
(global-set-key "\C-cc\C-x" 'clipboard-kill-region)
(global-set-key "\C-cc\C-v" 'clipboard-yank)
(setq c-basic-offset 2)
(setq perl-indent-level 4)
(setq explicit-shell-file-name "/bin/bash")
(setq indent-tabs-mode nil)

(setq
 tramp-password-prompt-regexp
 (concat
  "^.*"
  (regexp-opt
   '("passphrase" "Passphrase"
     ;; English
     "password" "Password"
     ;; Deutsch
     "passwort" "Passwort"
     ;; RSA
     "PASSCODE"
     ;; Français
     "mot de passe" "Mot de passe") t)
  ".*:? *"))

   (defun modify-alist (alist-symbol key value &optional search-cdr)
      (let ((alist (symbol-value alist-symbol)))
        (while alist
          (if (eq (if search-cdr
                      (cdr (car alist))
                    (car (car alist))) key)
              (setcdr (car alist) value)
            (setq alist (cdr alist))))))

    (modify-alist 'interpreter-mode-alist 'perl-mode 'cperl-mode t)
    (modify-alist 'auto-mode-alist        'perl-mode 'cperl-mode t)


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-default-style (quote ((c-mode . "linux") (java-mode . "java") (awk-mode . "awk"))))
 '(cperl-indent-level 4)
 '(erc-email-userid "user")
 '(erc-modules (quote (autojoin button fill irccontrols match netsplit noncommands pcomplete readonly ring services stamp track)))
 '(erc-nick (quote ("foomanchu" "fewmanchew")))
 '(erc-prompt-for-password t)
 '(flyspell-highlight-flag t)
 '(indent-tabs-mode nil)
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-mode t nil (mwheel))
 '(tool-bar-mode t nil (tool-bar))
 '(vc-handled-backends (quote (RCS CVS SVN SCCS Bzr Hg Arch))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "#062406" :foreground "PaleGreen" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 125 :width normal :foundry "unknown" :family "Inconsolata"))))
 '(cursor ((t (:background "orange"))))
 '(menu ((((type x-toolkit)) (:background "#062406" :foreground "#efefbf" :height 1.0))))
 '(mmm-default-submode-face ((t (:background "#005044"))))
 '(mode-line ((((type x w32 mac) (class color)) (:background "DarkGreen" :foreground "PaleGreen" :box (:line-width -1 :style released-button)))))
 '(region ((((class color) (background dark)) (:background "DarkBlue"))))
 '(scroll-bar ((t (:background "DarkGreen" :foreground "PaleGreen"))))
 '(show-paren-match-face ((((class color)) (:background "yellow" :foreground "black"))) t)
 '(tool-bar ((((type x w32 mac) (class color)) (:background "DarkGreen" :foreground "PaleGreen" :box (:line-width 1 :style released-button))))))


(put 'upcase-region 'disabled nil)
