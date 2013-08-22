;;; felineherd.el --- Emacs Meta Packages 
;;
;; Consolidated package management for Emacs
;;
;; Copyright (C) 2013 Christoph A. Kohlhepp, all rights reserved.
;; Email chrisk at manx dot net
;; Licensed under the GNU General Public License.
;;
;; Toolbar icons and derived works subject to
;; http://openiconlibrary.sourceforge.net/LICENSES.html
;; See http://openiconlibrary.sourceforge.net  
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; Commentary: This package provides convenient & pre-configured 
;; access to the Emacs Lisp package repositories. 
;; These include Elpa, Melpa, Marmalade as well as El-Get
;; At the time of writing, the former comprise some 1900 packages, 
;; the latter some 600 packages.
;;
;; Why "felineherd?" It is said that managing Lispers is akin 
;; to herding cats. Emacs, for all it's power, is a testament to this.
;; There are literally thousands of packages allowing the customization
;; of Emacs. These are daunting to set up and configure for the 
;; novice user. Yet a coherent configuration is instrumental to
;; assisting the novice user with becoming productive. As of 
;; Emacs 24, package management is integrated, but yet again
;; there are divergent package manager paradigms (EL-Get & Elpa)
;; and a number of repositories exist. These are not pre-configured.
;; 
;; Felineherd aims to herd the cats by bringing package management 
;; under one roof. 
;;   
;;
;;
;; To install this package, put this file somewhere in your
;; Emacs load path. In my case this is ~/.emacs/includes.
;;
;; Somewhere near the top of your .emacs add the following line
;;
;;          (require 'felineherd)
;;
;; The following package toolbar buttons will appear on your Emacs toolbar.
;;
;;   1) Package        ( Open ELPA, Marmalade, etc package manager)
;;   2) Package EL     ( Open El-Get, separate download, not enabled by default )
;;   3) Package Plus   ( Marks selected package for installation)
;;   4) Package Minus  ( Marks selected package for deletion)
;;   5) Package Apply  ( Apply pending changes on marked packages)
;;   6) Package Unmark ( Unmarks selected package)
;;   7) Package Update ( Marks packages for update where available)
;;
;;
;; Alternatively, the commands
;; 
;;          M-x listpackages 
;; 
;; and 
;;
;;          M-x  el-get-list-packages
;; 
;; can be used to display the respective package inventories
;; and install relevant packages.
;;
;; Customize via :
;;
;;          M-x customize-group  felineherd
;;
;; You can close the relevant package views using the Kill-Buffer [X] button. 
;; 
;; Additional documentation may be found at the following locations:
;;
;; http://www.emacswiki.org/emacs/el-get
;; http://www.emacswiki.org/emacs/ELPA
;; http://www.emacswiki.org/emacs/MELPA
;;
;;

 

;;===============================================================
;; Obsolete packages are supported by Emacs but it issues warnings
;; To disable:
;; Check /Applications/Emacs.app/Contents/Resources/lisp/obsolete
;; Move to /Applications/Emacs.app/Contents/Resources/lisp/
;; The above is OSX specific; adjust paths to your OS
;;===============================================================


; define auxiliary directories
(setq feline-herd-icon-dir       (file-name-as-directory (concat user-emacs-directory  "icons")))

;; create auxiliary directory if necessary
(make-directory feline-herd-icon-dir t)

;; Make it available as an image location
(add-to-list 'image-load-path feline-herd-icon-dir)

;; Define icon files
(setq feline-herd-icon-file (concat feline-herd-icon-dir "/package.xpm"))
(setq feline-herd-el-icon-file (concat feline-herd-icon-dir "/packageel.xpm"))
(setq feline-herd-plus-icon-file (concat feline-herd-icon-dir "/packageplus.xpm"))
(setq feline-herd-minus-icon-file (concat feline-herd-icon-dir "/packageminus.xpm"))
(setq feline-herd-apply-icon-file (concat feline-herd-icon-dir "/packageapply.xpm"))
(setq feline-herd-update-icon-file (concat feline-herd-icon-dir "/packageupdate.xpm"))
(setq feline-herd-unmark-icon-file (concat feline-herd-icon-dir "/packageunmark.xpm"))


(if (version<= emacs-version "24")
    (require 'package)
)

(defvar feline-herd-pending-changes nil)

(setq feline-herd-el-loaded nil)

;; customize group
(defgroup felineherd nil
  "Consolidated package management for Emacs."
  :group 'package
  :group 'el-get
)

(defcustom el-get-path  (expand-file-name "~/.emacs.d/el-get/el-get")
  "Local directory path to el-get installation"
  :group 'felineherd
  :type 'directory)

(defcustom elpa-url "http://tromey.com/elpa/"
  "ELPA web URL"
  :type 'string
  :group 'felineherd)

(defcustom melpa-url "http://melpa.milkbox.net/packages/"
  "MELPA web URL"
  :type 'string
  :group 'felineherd)

(defcustom marmalade-url "http://marmalade-repo.org/packages/"
  "MELPA web URL"
  :type 'string
  :group 'felineherd)

(defcustom el-get-url "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
  "El-Get web URL"
  :type 'string
  :group 'felineherd)

(defcustom el-get-do-load nil
  "Non-nil means we load El-Get at startup (requires restart if changed)"
  :group 'felineherd
  :type 'boolean)

(defcustom felineherd-do-show-icons  t
  "Non-nil means we show icons on toolbar"
  :group 'felineherd
  :type 'boolean)

;;============================================================================================================
;; ELPA Package Manager
;; ELPA installed packages require neither adding to load path nor explicit loading via require need a require
;; They are auto compiled and  available after package-initialize
;;
;; M-x list-packages ~ 1930 packages
;;============================================================================================================
(package-initialize)
;; Add the original Emacs Lisp Package Archive
(add-to-list 'package-archives
    `("elpa" . ,elpa-url))  ; back-quote and splice evaluated elpa-url
;; Add Melpa
(add-to-list 'package-archives 
    `("melpa" . ,melpa-url)) ; back-quote and splice evaluated melpa-url
;; Add the user-contributed repository
(add-to-list 'package-archives
   `("marmalade" . ,marmalade-url)) ; back-quote and splice evaluated marmalade-url


(defun felineherd-post-init ()

  ;;==============================================
  ;; ELget Package Manager
  ;; Makes all el-get installed packages available
  ;; M-x el-get-list-packages ~ 590 packages
  ;;==============================================
  (if el-get-do-load 
      (progn 
        (add-to-list 'load-path el-get-path)

        (unless (require 'el-get nil 'noerror)
          (with-current-buffer (current-buffer)
            (url-retrieve-synchronously
             el-get-url)
            (goto-char (point-max))
            (eval-print-last-sexp))
          )

        (el-get 'sync)
        (setq feline-herd-el-loaded t)
        (message "Loaded package support for El-Get...Done")))
  (if felineherd-do-show-icons
      (progn

        (initialize-toolbar-icons)

        ;; Dump icons resources to icon folder if
        ;; they do not exist already
        (if (not(file-exists-p feline-herd-icon-file))
           (with-temp-file feline-herd-icon-file
              (insert feline-herd-icon-xpm))
        )

        (if (not(file-exists-p feline-herd-el-icon-file))
           (with-temp-file feline-herd-el-icon-file
              (insert feline-herd-el-icon-xpm))
        )

        (if (not(file-exists-p feline-herd-plus-icon-file))
           (with-temp-file feline-herd-plus-icon-file
              (insert feline-herd-plus-icon-xpm))
        )

        (if (not(file-exists-p feline-herd-minus-icon-file))
           (with-temp-file feline-herd-minus-icon-file
              (insert feline-herd-minus-icon-xpm))
        )

        (if (not(file-exists-p feline-herd-apply-icon-file))
           (with-temp-file feline-herd-apply-icon-file
              (insert feline-herd-apply-icon-xpm))
        )

        (if (not(file-exists-p feline-herd-update-icon-file))
           (with-temp-file feline-herd-update-icon-file
              (insert feline-herd-update-icon-xpm))
        )


        (if (not(file-exists-p feline-herd-unmark-icon-file))
           (with-temp-file feline-herd-unmark-icon-file
              (insert feline-herd-unmark-icon-xpm))
        )


        (tool-bar-add-item "package" 'package-list-packages  'package-list-packages
                           :enable '(and (not (get-buffer "*Packages*")) (not (eq major-mode 'package-menu-mode))) 
                           :visible 'felineherd-do-show-icons
                           :help "ELPA Package Management")
        (tool-bar-add-item "packageel" 'el-get-list-packages 'el-get-list-packages 
                           :enable '(and (not (get-buffer "*el-get packages*")) (not (eq major-mode 'el-get-package-menu-mode))) 
                           :visible '(and felineherd-do-show-icons feline-herd-el-loaded)
                           :help "EL-GET Package Management")
      )
  )
)

;; Install hook to run felineherd-post-init after Emacs finishes loading
;;=======================================================================
(add-hook 'after-init-hook 'felineherd-post-init)


;; Define aspects oriented features
;;=================================
(defadvice package-menu-mark-install (after my-package-menu-mark-install-advice activate)
  "Aspect to wrap marking for install"
  (setq feline-herd-pending-changes t))

(defadvice package-menu-mark-delete (after my-package-menu-mark-delete-advice activate)
  "Aspect to wrap marking for delete"
  (setq feline-herd-pending-changes t))

(defadvice el-get-package-menu-mark-install (after el-package-menu-mark-install-advice activate)
  "Aspect to wrap marking for install"
  (setq feline-herd-pending-changes t))

(defadvice el-get-package-menu-mark-delete (after el-package-menu-mark-delete-advice activate)
  "Aspect to wrap marking for delete"
  (setq feline-herd-pending-changes t))



;; Toolbar functions
;; Dispatch on package manager mode
;;=================================
(defun install-selected-package()
  "Marks selected package for installation"
  (interactive)
  (if (eq major-mode 'package-menu-mode) 
      (progn
        (call-interactively 'package-menu-mark-install)
      ) 
  )
  (if (eq major-mode 'el-get-package-menu-mode) 
      (progn
        (call-interactively 'el-get-package-menu-mark-install)
      ) 
  )
)

(defun update-package-handler()
  "Marks updatable packages for re-installation"
  (interactive)
  (if (eq major-mode 'package-menu-mode) 
      (progn
        (call-interactively 'package-menu-mark-upgrades)
      ) 
  )
  (if (eq major-mode 'el-get-package-menu-mode) 
      (progn
        (call-interactively 'el-get-package-menu-mark-update)
      ) 
  )
)


(defun delete-selected-package ()
  "Marks selected package for deletion"
  (interactive)
  (if (eq major-mode 'package-menu-mode) 
      (progn
        (call-interactively 'package-menu-mark-delete)   
      ) 
  )
  (if (eq major-mode 'el-get-package-menu-mode) 
      (progn
        (call-interactively 'el-get-package-menu-mark-delete)
      ) 
  )
)


(defun unmark-selected-package ()
  "Unmarks selected package previously marked for installation or deletion"
  (interactive)
  (if (eq major-mode 'package-menu-mode) 
      (progn
        (call-interactively 'package-menu-mark-unmark)   
      ) 
  )
  (if (eq major-mode 'el-get-package-menu-mode) 
      (progn
        (call-interactively 'el-get-package-menu-mark-unmark)
      ) 
  )
)


(defun apply-package-changes ()
  "Apply pending changes as marked"
  (interactive)
  (if (eq major-mode 'package-menu-mode) 
      (progn
        (call-interactively 'package-menu-execute)
        (switch-to-buffer "*Packages*")
      ) 
  )
  (if (eq major-mode 'el-get-package-menu-mode) 
      (progn
        (call-interactively 'el-get-package-menu-execute)
        (switch-to-buffer "*el-get packages*")
      ) 
  )

  ;; If no leading column is marked up for install or uninstall
  ;; then unflag pending changes
  ;; Use regular expression string match for convenience
  (if (not (string-match "^I\\|^D" (buffer-string))
           (setq feline-herd-pending-changes nil)))

)


;; Add toolbar buttons for package install according to package mode
;;================================================================== 
(add-hook 'package-menu-mode-hook
  (lambda ()
  (define-key package-menu-mode-map [tool-bar package-install]
  `(menu-item "Install Package" install-selected-package
  :enable (if (sentence-at-point) (string-match "available\\|new" (buffer-substring (point-at-bol)(point-at-eol))) nil)
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageplus.xpm"))))
  :visible (sentence-at-point) 
  )
)

(add-hook 'el-get-package-menu-mode-hook
  (lambda ()
  (define-key el-get-package-menu-mode-map [tool-bar el-package-install]
  `(menu-item "Install Package" install-selected-package
  :enable (if (sentence-at-point) (string-match "available\\|new" (buffer-substring (point-at-bol)(point-at-eol))) nil)
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageplus.xpm"))))
  :visible (sentence-at-point)
  )
)

;; Add toolbar buttons for package remove according to package mode 
;;=================================================================
(add-hook 'package-menu-mode-hook
  (lambda ()
  (define-key package-menu-mode-map [tool-bar package-uninstall]
  `(menu-item "Install Package" delete-selected-package
  :enable (if (sentence-at-point) (string-match "installed" (buffer-substring (point-at-bol)(point-at-eol))) nil)
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageminus.xpm"))))
  :visible (sentence-at-point)
  )
)

(add-hook 'el-get-package-menu-mode-hook
  (lambda ()
  (define-key el-get-package-menu-mode-map [tool-bar el-package-uninstall]
  `(menu-item "Install Package" delete-selected-package
  :enable (if (sentence-at-point) (string-match "installed" (buffer-substring (point-at-bol)(point-at-eol))) nil)
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageminus.xpm"))))
  :visible (sentence-at-point)
  )
)

;; Add toolbar buttons for package unmark according to package mode 
;;=================================================================
(add-hook 'package-menu-mode-hook
  (lambda ()
  (define-key package-menu-mode-map [tool-bar package-unmark]
  `(menu-item "Unmark Package" unmark-selected-package
  :enable (if (sentence-at-point) (string-match "^I\\|^D" (buffer-substring (point-at-bol)(point-at-eol))) nil)
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageunmark.xpm"))))
  :visible (sentence-at-point)
  )
)

(add-hook 'el-get-package-menu-mode-hook
  (lambda ()
  (define-key el-get-package-menu-mode-map [tool-bar el-package-unmark]
  `(menu-item "Unmark Package" unmark-selected-package
  :enable (if (sentence-at-point) (string-match "^I\\|^D" (buffer-substring (point-at-bol)(point-at-eol))) nil)
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageunmark.xpm"))))
  :visible (sentence-at-point)
  )
)


;; Add toolbar buttons for package update according to package mode
;;================================================================= 
(add-hook 'package-menu-mode-hook
  (lambda ()
  (define-key package-menu-mode-map [tool-bar package-update]
  `(menu-item "Update Packages" update-package-handler
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageupdate.xpm"))))
  :visible (sentence-at-point)
  )
)

(add-hook 'el-get-package-menu-mode-hook
  (lambda ()
  (define-key el-get-package-menu-mode-map [tool-bar el-package-update]
  `(menu-item "Update Package" update-package-handler
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageupdate.xpm"))))
  :visible (sentence-at-point)
  )
)


;; Add toolbar buttons for package apply changes according to package mode
;;======================================================================== 
(add-hook 'package-menu-mode-hook
  (lambda ()
  (define-key package-menu-mode-map [tool-bar package-apply]
  `(menu-item "Install Package" apply-package-changes
  :enable feline-herd-pending-changes
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageapply.xpm"))))
  :visible (sentence-at-point)
  )
)

(add-hook 'el-get-package-menu-mode-hook
  (lambda ()
  (define-key el-get-package-menu-mode-map [tool-bar el-package-apply]
  `(menu-item "Install Package" apply-package-changes
  :enable feline-herd-pending-changes
  :image (image :type xpm :file ,(concat feline-herd-icon-dir "/packageapply.xpm"))))
  :visible (sentence-at-point)
  )
)

;; Announce that we have finished loading
;;=======================================
(message "Loaded package support for Elpa, Melpa, & Marmalade ...Done")


(provide 'felineherd)

;;============================
;; Embedded Icon Section Below
;;============================

(defun initialize-toolbar-icons ()

(setq feline-herd-icon-xpm 

#("/* XPM */
static char *emblem_package[] = {
/* columns rows colors chars-per-pixel */
\"24 24 207 2 \",
\"   c #744A06\",
\".  c #7A4E07\",
\"X  c #8F5902\",
\"o  c #8F5A02\",
\"O  c #8F5A03\",
\"+  c #905A03\",
\"@  c #925B03\",
\"#  c #915C03\",
\"$  c #905A04\",
\"%  c #935B04\",
\"&  c #925C04\",
\"*  c #915D07\",
\"=  c #935D06\",
\"-  c #915D09\",
\";  c #925D09\",
\":  c #935E0B\",
\">  c #945F0B\",
\",  c #925F0D\",
\"<  c #885F1D\",
\"1  c #93600D\",
\"2  c #94600D\",
\"3  c #9B650F\",
\"4  c #956211\",
\"5  c #976412\",
\"6  c #986512\",
\"7  c #9D6A15\",
\"8  c #906218\",
\"9  c #9D6C1F\",
\"0  c #835F27\",
\"q  c #8F692D\",
\"w  c #986C27\",
\"e  c #A67322\",
\"r  c #A1732A\",
\"t  c #A4762D\",
\"y  c #A8792D\",
\"u  c #A37A37\",
\"i  c #9B7B48\",
\"p  c #B28437\",
\"a  c #C88823\",
\"s  c #C98A25\",
\"d  c #CA8A26\",
\"f  c #CB8C29\",
\"g  c #CC8D29\",
\"h  c #CD8F2C\",
\"j  c #CC8F2D\",
\"k  c #CD8F2D\",
\"l  c #C28E3C\",
\"z  c #CE9130\",
\"x  c #CE9131\",
\"c  c #CE9132\",
\"v  c #D09333\",
\"b  c #D09434\",
\"n  c #D09435\",
\"m  c #D19435\",
\"M  c #D19638\",
\"N  c #D29638\",
\"B  c #D29738\",
\"V  c #D3983A\",
\"C  c #D3983B\",
\"Z  c #D3993C\",
\"A  c #D4993C\",
\"S  c #D49A3E\",
\"D  c #D49A3F\",
\"F  c #D59B3F\",
\"G  c #AD8647\",
\"H  c #B28947\",
\"J  c #B98C45\",
\"K  c #BB904B\",
\"L  c #B28E54\",
\"P  c #B99457\",
\"I  c #D59B40\",
\"U  c #D59C41\",
\"Y  c #D69D43\",
\"T  c #D19C47\",
\"R  c #D79E44\",
\"E  c #D79F44\",
\"W  c #D79F45\",
\"Q  c #D89F46\",
\"!  c #D89F47\",
\"~  c #D39F4D\",
\"^  c #C29652\",
\"/  c #D8A047\",
\"(  c #D7A049\",
\")  c #D8A048\",
\"_  c #D9A149\",
\"`  c #D9A24A\",
\"'  c #D9A24B\",
\"]  c #D9A34B\",
\"[  c #DAA24B\",
\"{  c #DAA34C\",
\"}  c #DBA34C\",
\"|  c #DAA44D\",
\" . c #DBA44E\",
\".. c #DBA54F\",
\"X. c #DBA64F\",
\"o. c #DCA54F\",
\"O. c #DDA651\",
\"+. c #DDA752\",
\"@. c #DCA753\",
\"#. c #DBA654\",
\"$. c #DAA655\",
\"%. c #DDA854\",
\"&. c #DEA854\",
\"*. c #DEA954\",
\"=. c #DEA955\",
\"-. c #DCA857\",
\";. c #DFAB59\",
\":. c #D9A85C\",
\">. c #D8A95D\",
\",. c #DAA95C\",
\"<. c #DCAB5E\",
\"1. c #E0AB5A\",
\"2. c #E1AD5C\",
\"3. c #E1AE5C\",
\"4. c #E2AE5C\",
\"5. c #E0AE5E\",
\"6. c #E2AF5F\",
\"7. c #CFA462\",
\"8. c #D7AB66\",
\"9. c #DEAF64\",
\"0. c #DEB26D\",
\"q. c #C1A476\",
\"w. c #C9A874\",
\"e. c #D3B17B\",
\"r. c #D4B27E\",
\"t. c #DFB778\",
\"y. c #DCB87E\",
\"u. c #E1AF61\",
\"i. c #E2B062\",
\"p. c #E1B165\",
\"a. c #E4B367\",
\"s. c #E0B26A\",
\"d. c #E1B36A\",
\"f. c #E0B26C\",
\"g. c #E0B36D\",
\"h. c #E2B46D\",
\"j. c #E1B56E\",
\"k. c #E9B96E\",
\"l. c #E6B971\",
\"z. c #E5BA76\",
\"x. c #EABC77\",
\"c. c #E4BC7F\",
\"v. c #D1B485\",
\"b. c #DBB880\",
\"n. c #E6C185\",
\"m. c #E7C185\",
\"M. c #E6C186\",
\"N. c #E7C187\",
\"B. c #E8C082\",
\"V. c #E8C285\",
\"C. c #E8C387\",
\"Z. c #E7C38A\",
\"A. c #E7C38B\",
\"S. c #E8C38A\",
\"D. c #EDC78B\",
\"F. c #E8C48C\",
\"G. c #E8C58D\",
\"H. c #E9C58D\",
\"J. c #E9C68D\",
\"K. c #E9C58E\",
\"L. c #E9C68E\",
\"P. c #E9C68F\",
\"I. c #EDC88D\",
\"U. c #EEC88D\",
\"Y. c #EAC790\",
\"T. c #E8C793\",
\"R. c #ECC992\",
\"E. c #EECA94\",
\"W. c #EACB99\",
\"Q. c #E9CB9B\",
\"!. c #E8CB9C\",
\"~. c #D1C0A3\",
\"^. c #D9C9AE\",
\"/. c #EBCFA2\",
\"(. c #E0CBAA\",
\"). c #EBD0A6\",
\"_. c #EDD1A4\",
\"`. c #EDD4AC\",
\"'. c #F2D7AD\",
\"]. c #EBD7B5\",
\"[. c #EED9B8\",
\"{. c #ECDABC\",
\"}. c #EFDDBF\",
\"|. c #F1D8B1\",
\" X c #F1DBB8\",
\".X c #D3CFC7\",
\"XX c #EDDCC1\",
\"oX c #EDDFC7\",
\"OX c #F2DFC1\",
\"+X c #F2DFC2\",
\"@X c #F1DFC4\",
\"#X c #F4E4CA\",
\"$X c #F4E5CC\",
\"%X c #F5E6CE\",
\"&X c #EDE3D1\",
\"*X c #F2E5D0\",
\"=X c #F5E7D0\",
\"-X c #F7E9D2\",
\";X c #F3E9D9\",
\":X c #F8ECD8\",
\">X c #F7F2E9\",
\",X c #F6F3EC\",
\"<X c #F9F5ED\",
\"1X c #F9F6F1\",
\"2X c #F9F7F4\",
\"3X c #F9F9F7\",
\"4X c None\",
/* pixels */
\"4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X\",
\"4X4X4X4X4X4X4X4X4X4X4X4X4X= 5 = 4X4X4X4X4X4X4X4X\",
\"4X4X4X4X4X4X4X4X4X4X4X4X4X, +XK = 4X4X4X4X4X4X4X\",
\"4X4X4X4X4X4X4X4X4X4X2 4X4X4 %XW.J @ 4X4X4X4X4X4X\",
\"4X4X4X4X4X4X2 > w q.^.; 4X5 =X-.!.p = 4X4X4X4X4X\",
\"4X4X4X4X> P (.;X<X,X2XO O - :X5.$.t.7 - 4X4X4X4X\",
\"4X4X4X4XO #X+XXX X&X1XO .Xt {.E.&.$.l % 4X4X4X4X\",
\"4X4X4X4XO |.W.).].oX1XO ~.v.H '.l.O.! O 4X4X4X4X\",
\"4X4X4X4X+ R.K./.[.*X>X% ^ ,.e y V.a.} X 4X4X4X4X\",
\"4X4X4X4XO U.B.y.v.w.G w e.D.b.u 5 :.u.% 4X4X4X4X\",
\"4X4X4X4X3 U.r , 8 < 0 i 7.k.8.L q r x.X 4X4X4X4X\",
\"4X4X4X4XO V.4.5.4.z.K._. X#X%X+X`.T.m.O 4X4X4X4X\",
\"4X4X4X4XX V.;.1.5.u.p.d.h.h.h.0.9.,.g.O 4X4X4X4X\",
\"4X4X4X4XO S.| } Q R I Z N n z h f s T + 4X4X4X4X\",
\"4X4X4X4XO Z._ Q U U Z N n z h g s a ~ O 4X4X4X4X\",
\"4X4X4X4XO S.| _ / U U I A N n c z h ,.O 4X4X4X4X\",
\"4X4X4X4XO S.| } } _ / R R U I Z C N 0.O 4X4X4X4X\",
\"4X4X4X4XO K.-.O.| o.| | | _ _ _ / / c.O 4X4X4X4X\",
\"4X4X4X4XO K.&.&.O.&.&.&.&.&.&.&.&.&.L.O 4X4X4X4X\",
\"4X4X4X4X+ m.J.K.J.J.K.K.K.K.K.K.P.P.m.O 4X4X4X4X\",
\"4X4X4X4X. + O O O O O O O O O O O O O   4X4X4X4X\",
\"4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X\",
\"4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X\",
\"4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X4X\"
};
")
)


(setq feline-herd-el-icon-xpm

#("/* XPM */
static char * packageel_xpm[] = {
\"24 24 133 2\",
\"  	c None\",
\". 	c #935D06\",
\"+ 	c #976412\",
\"@ 	c #925F0D\",
\"# 	c #F2DFC2\",
\"$ 	c #BB904B\",
\"% 	c #94600D\",
\"& 	c #956211\",
\"* 	c #F5E6CE\",
\"= 	c #EACB99\",
\"- 	c #B98C45\",
\"; 	c #925B03\",
\"> 	c #945F0B\",
\", 	c #986C27\",
\"' 	c #C1A476\",
\") 	c #D9C9AE\",
\"! 	c #925D09\",
\"~ 	c #F5E7D0\",
\"{ 	c #DCA857\",
\"] 	c #E8CB9C\",
\"^ 	c #B28437\",
\"/ 	c #B99457\",
\"( 	c #E0CBAA\",
\"_ 	c #F3E9D9\",
\": 	c #F9F5ED\",
\"< 	c #F6F3EC\",
\"[ 	c #F9F7F4\",
\"} 	c #8F5A03\",
\"| 	c #915D09\",
\"1 	c #F8ECD8\",
\"2 	c #E0AE5E\",
\"3 	c #DAA655\",
\"4 	c #DFB778\",
\"5 	c #9D6A15\",
\"6 	c #F4E4CA\",
\"7 	c #EDDCC1\",
\"8 	c #F1DBB8\",
\"9 	c #EDE3D1\",
\"0 	c #F9F6F1\",
\"a 	c #D3CFC7\",
\"b 	c #A4762D\",
\"c 	c #ECDABC\",
\"d 	c #EECA94\",
\"e 	c #DEA854\",
\"f 	c #C28E3C\",
\"g 	c #935B04\",
\"h 	c #F1D8B1\",
\"i 	c #EBD0A6\",
\"j 	c #EBD7B5\",
\"k 	c #EDDFC7\",
\"l 	c #D1C0A3\",
\"m 	c #D1B485\",
\"n 	c #B28947\",
\"o 	c #F2D7AD\",
\"p 	c #E6B971\",
\"q 	c #DDA651\",
\"r 	c #D89F47\",
\"s 	c #905A03\",
\"t 	c #ECC992\",
\"u 	c #E9C58E\",
\"v 	c #EBCFA2\",
\"w 	c #EED9B8\",
\"x 	c #F2E5D0\",
\"y 	c #F7F2E9\",
\"z 	c #C29652\",
\"A 	c #DAA95C\",
\"B 	c #A67322\",
\"C 	c #A8792D\",
\"D 	c #E8C285\",
\"E 	c #E4B367\",
\"F 	c #DBA34C\",
\"G 	c #8F5902\",
\"H 	c #EEC88D\",
\"I 	c #E8C082\",
\"J 	c #DCB87E\",
\"K 	c #C9A874\",
\"L 	c #AD8647\",
\"M 	c #D3B17B\",
\"N 	c #EDC78B\",
\"O 	c #DBB880\",
\"P 	c #A37A37\",
\"Q 	c #D9A85C\",
\"R 	c #E1AF61\",
\"S 	c #9B650F\",
\"T 	c #A1732A\",
\"U 	c #906218\",
\"V 	c #885F1D\",
\"W 	c #835F27\",
\"X 	c #9B7B48\",
\"Y 	c #CFA462\",
\"Z 	c #E9B96E\",
\"` 	c #D7AB66\",
\" .	c #B28E54\",
\"..	c #8F692D\",
\"+.	c #EABC77\",
\"@.	c #E2AE5C\",
\"#.	c #E5BA76\",
\"$.	c #EDD1A4\",
\"%.	c #EDD4AC\",
\"&.	c #E8C793\",
\"*.	c #E7C185\",
\"=.	c #DFAB59\",
\"-.	c #E0AB5A\",
\";.	c #E1B165\",
\">.	c #E1B36A\",
\",.	c #E2B46D\",
\"'.	c #DEB26D\",
\").	c #DEAF64\",
\"!.	c #E0B36D\",
\"~.	c #E8C38A\",
\"{.	c #DAA44D\",
\"].	c #D89F46\",
\"^.	c #D79E44\",
\"/.	c #D59B40\",
\"(.	c #D3993C\",
\"_.	c #D29638\",
\":.	c #D09435\",
\"<.	c #CE9130\",
\"[.	c #CD8F2C\",
\"}.	c #CB8C29\",
\"|.	c #C98A25\",
\"1.	c #D19C47\",
\"2.	c #E7C38A\",
\"3.	c #D9A149\",
\"4.	c #D59C41\",
\"5.	c #000000\",
\"6.	c #C88823\",
\"7.	c #D8A047\",
\"8.	c #20B02D\",
\"9.	c #DCA54F\",
\"0.	c #E9C68D\",
\"a.	c #E9C68F\",
\"b.	c #7A4E07\",
\"                                                \",
\"                          . + .                 \",
\"                          @ # $ .               \",
\"                    %     & * = - ;             \",
\"            % > , ' ) !   + ~ { ] ^ .           \",
\"        > / ( _ : < [ } } | 1 2 3 4 5 |         \",
\"        } 6 # 7 8 9 0 } a b c d e 3 f g         \",
\"        } h = i j k 0 } l m n o p q r }         \",
\"        s t u v w x y g z A B C D E F G         \",
\"        } H I J m K L , M N O P + Q R g         \",
\"        S H T @ U V W X Y Z `  ...T +.G         \",
\"        } D @.2 @.#.u $.8 6 * # %.&.*.}         \",
\"        G D =.-.2 R ;.>.,.,.,.'.).A !.}         \",
\"        } ~.{.F ].^./.(._.:.<.[.}.|.1.s         \",
\"        } 2.3.].4.4.(.5.5.5.5.5.5.6.5.5.        \",
\"        } ~.{.3.7.4.4.5.5.5.5.5.5.8.5.5.8.      \",
\"        } ~.{.F F 3.7.5.5.8.8.8.8.8.5.5.8.      \",
\"        } u { q {.9.{.5.5.5.5.5.7.7.5.5.8.      \",
\"        } u e e q e e 5.5.5.5.5.8.e 5.5.8.      \",
\"        s *.0.u 0.0.u 5.5.8.8.8.8.a.5.5.8.      \",
\"        b.s } } } } } 5.5.8.} } } } 5.5.8.      \",
\"                      5.5.5.5.5.5.  5.5.5.5.5.  \",
\"                      5.5.5.5.5.5.8.5.5.5.5.5.8.\",
\"                          8.8.8.8.8.  8.8.8.8.8.\"};
")
)

(setq feline-herd-plus-icon-xpm

#("/* XPM */
static char * packageplus_xpm[] = {
\"24 24 120 2\",
\"  	c None\",
\". 	c #935D06\",
\"+ 	c #976412\",
\"@ 	c #925F0D\",
\"# 	c #F2DFC2\",
\"$ 	c #BB904B\",
\"% 	c #94600D\",
\"& 	c #956211\",
\"* 	c #F5E6CE\",
\"= 	c #EACB99\",
\"- 	c #B98C45\",
\"; 	c #925B03\",
\"> 	c #945F0B\",
\", 	c #986C27\",
\"' 	c #C1A476\",
\") 	c #D9C9AE\",
\"! 	c #925D09\",
\"~ 	c #F5E7D0\",
\"{ 	c #DCA857\",
\"] 	c #E8CB9C\",
\"^ 	c #B28437\",
\"/ 	c #B99457\",
\"( 	c #E0CBAA\",
\"_ 	c #F3E9D9\",
\": 	c #F9F5ED\",
\"< 	c #F6F3EC\",
\"[ 	c #F9F7F4\",
\"} 	c #8F5A03\",
\"| 	c #915D09\",
\"1 	c #F8ECD8\",
\"2 	c #E0AE5E\",
\"3 	c #DAA655\",
\"4 	c #DFB778\",
\"5 	c #9D6A15\",
\"6 	c #F4E4CA\",
\"7 	c #EDDCC1\",
\"8 	c #F1DBB8\",
\"9 	c #EDE3D1\",
\"0 	c #F9F6F1\",
\"a 	c #D3CFC7\",
\"b 	c #A4762D\",
\"c 	c #ECDABC\",
\"d 	c #EECA94\",
\"e 	c #DEA854\",
\"f 	c #C28E3C\",
\"g 	c #935B04\",
\"h 	c #F1D8B1\",
\"i 	c #EBD0A6\",
\"j 	c #EBD7B5\",
\"k 	c #EDDFC7\",
\"l 	c #D1C0A3\",
\"m 	c #D1B485\",
\"n 	c #B28947\",
\"o 	c #F2D7AD\",
\"p 	c #E6B971\",
\"q 	c #DDA651\",
\"r 	c #D89F47\",
\"s 	c #905A03\",
\"t 	c #ECC992\",
\"u 	c #E9C58E\",
\"v 	c #EBCFA2\",
\"w 	c #EED9B8\",
\"x 	c #F2E5D0\",
\"y 	c #F7F2E9\",
\"z 	c #C29652\",
\"A 	c #DAA95C\",
\"B 	c #A67322\",
\"C 	c #A8792D\",
\"D 	c #E8C285\",
\"E 	c #E4B367\",
\"F 	c #DBA34C\",
\"G 	c #8F5902\",
\"H 	c #EEC88D\",
\"I 	c #E8C082\",
\"J 	c #DCB87E\",
\"K 	c #C9A874\",
\"L 	c #AD8647\",
\"M 	c #D3B17B\",
\"N 	c #EDC78B\",
\"O 	c #DBB880\",
\"P 	c #A37A37\",
\"Q 	c #D9A85C\",
\"R 	c #E1AF61\",
\"S 	c #9B650F\",
\"T 	c #A1732A\",
\"U 	c #906218\",
\"V 	c #885F1D\",
\"W 	c #835F27\",
\"X 	c #9B7B48\",
\"Y 	c #CFA462\",
\"Z 	c #E9B96E\",
\"` 	c #D7AB66\",
\" .	c #B28E54\",
\"..	c #8F692D\",
\"+.	c #000000\",
\"@.	c #E2AE5C\",
\"#.	c #E5BA76\",
\"$.	c #EDD1A4\",
\"%.	c #20B02D\",
\"&.	c #DFAB59\",
\"*.	c #E0AB5A\",
\"=.	c #E1B165\",
\"-.	c #E1B36A\",
\";.	c #E2B46D\",
\">.	c #E8C38A\",
\",.	c #DAA44D\",
\"'.	c #D89F46\",
\").	c #D79E44\",
\"!.	c #D59B40\",
\"~.	c #D3993C\",
\"{.	c #D29638\",
\"].	c #D09435\",
\"^.	c #E7C38A\",
\"/.	c #D9A149\",
\"(.	c #D59C41\",
\"_.	c #D8A047\",
\":.	c #DCA54F\",
\"<.	c #E7C185\",
\"[.	c #E9C68D\",
\"}.	c #7A4E07\",
\"                                                \",
\"                          . + .                 \",
\"                          @ # $ .               \",
\"                    %     & * = - ;             \",
\"            % > , ' ) !   + ~ { ] ^ .           \",
\"        > / ( _ : < [ } } | 1 2 3 4 5 |         \",
\"        } 6 # 7 8 9 0 } a b c d e 3 f g         \",
\"        } h = i j k 0 } l m n o p q r }         \",
\"        s t u v w x y g z A B C D E F G         \",
\"        } H I J m K L , M N O P + Q R g         \",
\"        S H T @ U V W X Y Z `  ...+.+.+.        \",
\"        } D @.2 @.#.u $.8 6 * # +.%.%.%.+.      \",
\"        G D &.*.2 R =.-.;.;.;.+.+.%.%.%.+.+.    \",
\"        } >.,.F '.).!.~.{.].+.+.+.%.%.%.+.+.+.  \",
\"        } ^./.'.(.(.~.{.].+.+.+.+.%.%.%.+.+.+.+.\",
\"        } >.,./._.(.(.!.+.%.%.%.%.%.%.%.%.%.%.%.\",
\"        } >.,.F F /._.).+.%.%.%.%.%.%.%.%.%.%.%.\",
\"        } u { q ,.:.,.,.+.%.%.%.%.%.%.%.%.%.%.%.\",
\"        } u e e q e e e e +.+.+.+.%.%.%.+.+.+.+.\",
\"        s <.[.u [.[.u u u u +.+.+.%.%.%.+.+.+.+.\",
\"        }.s } } } } } } } } } +.+.%.%.%.+.+.+.  \",
\"                                +.%.%.%.+.+.    \",
\"                                  +.+.+.+.      \",
\"                                                \"};
")
)

(setq feline-herd-minus-icon-xpm

#("/* XPM */
static char * packageminus_xpm[] = {
\"24 24 129 2\",
\"  	c None\",
\". 	c #935D06\",
\"+ 	c #976412\",
\"@ 	c #925F0D\",
\"# 	c #F2DFC2\",
\"$ 	c #BB904B\",
\"% 	c #94600D\",
\"& 	c #956211\",
\"* 	c #F5E6CE\",
\"= 	c #EACB99\",
\"- 	c #B98C45\",
\"; 	c #925B03\",
\"> 	c #945F0B\",
\", 	c #986C27\",
\"' 	c #C1A476\",
\") 	c #D9C9AE\",
\"! 	c #925D09\",
\"~ 	c #F5E7D0\",
\"{ 	c #DCA857\",
\"] 	c #E8CB9C\",
\"^ 	c #B28437\",
\"/ 	c #B99457\",
\"( 	c #E0CBAA\",
\"_ 	c #F3E9D9\",
\": 	c #F9F5ED\",
\"< 	c #F6F3EC\",
\"[ 	c #F9F7F4\",
\"} 	c #8F5A03\",
\"| 	c #915D09\",
\"1 	c #F8ECD8\",
\"2 	c #E0AE5E\",
\"3 	c #DAA655\",
\"4 	c #DFB778\",
\"5 	c #9D6A15\",
\"6 	c #F4E4CA\",
\"7 	c #EDDCC1\",
\"8 	c #F1DBB8\",
\"9 	c #EDE3D1\",
\"0 	c #F9F6F1\",
\"a 	c #D3CFC7\",
\"b 	c #A4762D\",
\"c 	c #ECDABC\",
\"d 	c #EECA94\",
\"e 	c #DEA854\",
\"f 	c #C28E3C\",
\"g 	c #935B04\",
\"h 	c #F1D8B1\",
\"i 	c #EBD0A6\",
\"j 	c #EBD7B5\",
\"k 	c #EDDFC7\",
\"l 	c #D1C0A3\",
\"m 	c #D1B485\",
\"n 	c #B28947\",
\"o 	c #F2D7AD\",
\"p 	c #E6B971\",
\"q 	c #DDA651\",
\"r 	c #D89F47\",
\"s 	c #905A03\",
\"t 	c #ECC992\",
\"u 	c #E9C58E\",
\"v 	c #EBCFA2\",
\"w 	c #EED9B8\",
\"x 	c #F2E5D0\",
\"y 	c #F7F2E9\",
\"z 	c #C29652\",
\"A 	c #DAA95C\",
\"B 	c #A67322\",
\"C 	c #A8792D\",
\"D 	c #E8C285\",
\"E 	c #E4B367\",
\"F 	c #DBA34C\",
\"G 	c #8F5902\",
\"H 	c #EEC88D\",
\"I 	c #E8C082\",
\"J 	c #DCB87E\",
\"K 	c #C9A874\",
\"L 	c #AD8647\",
\"M 	c #D3B17B\",
\"N 	c #EDC78B\",
\"O 	c #DBB880\",
\"P 	c #A37A37\",
\"Q 	c #D9A85C\",
\"R 	c #E1AF61\",
\"S 	c #9B650F\",
\"T 	c #A1732A\",
\"U 	c #906218\",
\"V 	c #885F1D\",
\"W 	c #835F27\",
\"X 	c #9B7B48\",
\"Y 	c #CFA462\",
\"Z 	c #E9B96E\",
\"` 	c #D7AB66\",
\" .	c #B28E54\",
\"..	c #8F692D\",
\"+.	c #EABC77\",
\"@.	c #E2AE5C\",
\"#.	c #E5BA76\",
\"$.	c #EDD1A4\",
\"%.	c #EDD4AC\",
\"&.	c #E8C793\",
\"*.	c #E7C185\",
\"=.	c #DFAB59\",
\"-.	c #E0AB5A\",
\";.	c #E1B165\",
\">.	c #E1B36A\",
\",.	c #E2B46D\",
\"'.	c #DEB26D\",
\").	c #DEAF64\",
\"!.	c #E8C38A\",
\"~.	c #DAA44D\",
\"{.	c #D89F46\",
\"].	c #D79E44\",
\"^.	c #D59B40\",
\"/.	c #D3993C\",
\"(.	c #D29638\",
\"_.	c #D09435\",
\":.	c #CE9130\",
\"<.	c #CD8F2C\",
\"[.	c #CB8C29\",
\"}.	c #000000\",
\"|.	c #E7C38A\",
\"1.	c #D9A149\",
\"2.	c #D59C41\",
\"3.	c #D8A047\",
\"4.	c #D4993C\",
\"5.	c #E00F0F\",
\"6.	c #DCA54F\",
\"7.	c #E9C68D\",
\"8.	c #7A4E07\",
\"                                                \",
\"                          . + .                 \",
\"                          @ # $ .               \",
\"                    %     & * = - ;             \",
\"            % > , ' ) !   + ~ { ] ^ .           \",
\"        > / ( _ : < [ } } | 1 2 3 4 5 |         \",
\"        } 6 # 7 8 9 0 } a b c d e 3 f g         \",
\"        } h = i j k 0 } l m n o p q r }         \",
\"        s t u v w x y g z A B C D E F G         \",
\"        } H I J m K L , M N O P + Q R g         \",
\"        S H T @ U V W X Y Z `  ...T +.G         \",
\"        } D @.2 @.#.u $.8 6 * # %.&.*.}         \",
\"        G D =.-.2 R ;.>.,.,.,.'.).).).}         \",
\"        } !.~.F {.].^./.(._.:.<.[.}.}.}.}.      \",
\"        } |.1.{.2.2./.(._.:.<.}.}.}.}.}.}.}.}.  \",
\"        } !.~.1.3.2.2.^.4.}.}.}.}.}.}.}.}.}.}.}.\",
\"        } !.~.F F 1.3.].].}.5.5.5.5.5.5.5.5.5.}.\",
\"        } u { q ~.6.~.~.~.}.5.5.5.5.5.5.5.5.5.}.\",
\"        } u e e q e e e e }.}.}.}.}.}.}.}.}.}.}.\",
\"        s *.7.u 7.7.u u u u u }.}.}.}.}.}.}.}.  \",
\"        8.s } } } } } } } } } } } }.}.}.}.      \",
\"                                                \",
\"                                                \",
\"                                                \"};
")
)

(setq feline-herd-apply-icon-xpm

#("/* XPM */
static char * packageapply_xpm[] = {
\"24 24 139 2\",
\"  	c None\",
\". 	c #935D06\",
\"+ 	c #976412\",
\"@ 	c #925F0D\",
\"# 	c #F2DFC2\",
\"$ 	c #BB904B\",
\"% 	c #94600D\",
\"& 	c #956211\",
\"* 	c #F5E6CE\",
\"= 	c #EACB99\",
\"- 	c #B98C45\",
\"; 	c #925B03\",
\"> 	c #945F0B\",
\", 	c #986C27\",
\"' 	c #C1A476\",
\") 	c #D9C9AE\",
\"! 	c #925D09\",
\"~ 	c #F5E7D0\",
\"{ 	c #DCA857\",
\"] 	c #E8CB9C\",
\"^ 	c #B28437\",
\"/ 	c #B99457\",
\"( 	c #E0CBAA\",
\"_ 	c #F3E9D9\",
\": 	c #F9F5ED\",
\"< 	c #F6F3EC\",
\"[ 	c #F9F7F4\",
\"} 	c #8F5A03\",
\"| 	c #915D09\",
\"1 	c #F8ECD8\",
\"2 	c #E0AE5E\",
\"3 	c #DAA655\",
\"4 	c #DFB778\",
\"5 	c #9D6A15\",
\"6 	c #F4E4CA\",
\"7 	c #EDDCC1\",
\"8 	c #F1DBB8\",
\"9 	c #EDE3D1\",
\"0 	c #F9F6F1\",
\"a 	c #D3CFC7\",
\"b 	c #A4762D\",
\"c 	c #ECDABC\",
\"d 	c #EECA94\",
\"e 	c #DEA854\",
\"f 	c #C28E3C\",
\"g 	c #935B04\",
\"h 	c #F1D8B1\",
\"i 	c #EBD0A6\",
\"j 	c #EBD7B5\",
\"k 	c #EDDFC7\",
\"l 	c #D1C0A3\",
\"m 	c #D1B485\",
\"n 	c #B28947\",
\"o 	c #F2D7AD\",
\"p 	c #E6B971\",
\"q 	c #DDA651\",
\"r 	c #D89F47\",
\"s 	c #905A03\",
\"t 	c #ECC992\",
\"u 	c #E9C58E\",
\"v 	c #EBCFA2\",
\"w 	c #EED9B8\",
\"x 	c #F2E5D0\",
\"y 	c #F7F2E9\",
\"z 	c #C29652\",
\"A 	c #DAA95C\",
\"B 	c #A67322\",
\"C 	c #A8792D\",
\"D 	c #E8C285\",
\"E 	c #E4B367\",
\"F 	c #DBA34C\",
\"G 	c #8F5902\",
\"H 	c #EEC88D\",
\"I 	c #E8C082\",
\"J 	c #DCB87E\",
\"K 	c #C9A874\",
\"L 	c #AD8647\",
\"M 	c #D3B17B\",
\"N 	c #EDC78B\",
\"O 	c #DBB880\",
\"P 	c #A37A37\",
\"Q 	c #D9A85C\",
\"R 	c #E1AF61\",
\"S 	c #9B650F\",
\"T 	c #A1732A\",
\"U 	c #906218\",
\"V 	c #885F1D\",
\"W 	c #835F27\",
\"X 	c #9B7B48\",
\"Y 	c #CFA462\",
\"Z 	c #E9B96E\",
\"` 	c #D7AB66\",
\" .	c #B28E54\",
\"..	c #8F692D\",
\"+.	c #EABC77\",
\"@.	c #063B0B\",
\"#.	c #E2AE5C\",
\"$.	c #E5BA76\",
\"%.	c #EDD1A4\",
\"&.	c #EDD4AC\",
\"*.	c #E8C793\",
\"=.	c #E7C185\",
\"-.	c #4EC923\",
\";.	c #DFAB59\",
\">.	c #E0AB5A\",
\",.	c #E1B165\",
\"'.	c #E1B36A\",
\").	c #E2B46D\",
\"!.	c #DEB26D\",
\"~.	c #DEAF64\",
\"{.	c #E0B36D\",
\"].	c #141C11\",
\"^.	c #E8C38A\",
\"/.	c #DAA44D\",
\"(.	c #D89F46\",
\"_.	c #D79E44\",
\":.	c #D59B40\",
\"<.	c #D3993C\",
\"[.	c #D29638\",
\"}.	c #D09435\",
\"|.	c #CE9130\",
\"1.	c #CD8F2C\",
\"2.	c #CB8C29\",
\"3.	c #C98A25\",
\"4.	c #20B02D\",
\"5.	c #091106\",
\"6.	c #E7C38A\",
\"7.	c #D9A149\",
\"8.	c #D59C41\",
\"9.	c #CC8D29\",
\"0.	c #000000\",
\"a.	c #D8A047\",
\"b.	c #CE9132\",
\"c.	c #4EBE27\",
\"d.	c #040803\",
\"e.	c #DCA54F\",
\"f.	c #E9C68D\",
\"g.	c #7A4E07\",
\"h.	c #744A06\",
\"                                                \",
\"                          . + .                 \",
\"                          @ # $ .               \",
\"                    %     & * = - ;             \",
\"            % > , ' ) !   + ~ { ] ^ .           \",
\"        > / ( _ : < [ } } | 1 2 3 4 5 |         \",
\"        } 6 # 7 8 9 0 } a b c d e 3 f g         \",
\"        } h = i j k 0 } l m n o p q r }         \",
\"        s t u v w x y g z A B C D E F G         \",
\"        } H I J m K L , M N O P + Q R g         \",
\"        S H T @ U V W X Y Z `  ...T +.G   @.@.  \",
\"        } D #.2 #.$.u %.8 6 * # &.*.=.} @.-.@.  \",
\"        G D ;.>.2 R ,.'.).).).!.~.A {.@.-.-.].  \",
\"        } ^./.F (._.:.<.[.}.|.1.2.3.@.4.-.].5.  \",
\"        } 6.7.(.8.8.@.@.@.|.1.9.3.@.4.-.].5.0.  \",
\"        } ^./.7.a.8.@.-.4.@.}.b.@.4.-.].5.0.    \",
\"        } ^./.F F 7.a.5.-.4.@.@.4.-.c.d.0.      \",
\"        } u { q /.e./.0.5.-.4.4.-.c.].0.        \",
\"        } u e e q e e e 0.5.-.-.c.].5.}         \",
\"        s =.f.u f.f.u u u 5.-.-.].5.0.}         \",
\"        g.s } } } } } } } 5.-.-.].0.} h.        \",
\"                          0.5.].].0.            \",
\"                            0.0.0.              \",
\"                                                \"};
")
)

(setq feline-herd-update-icon-xpm

#("/* XPM */
static char * packageupdate_xpm[] = {
\"24 24 130 2\",
\"  	c None\",
\". 	c #935D06\",
\"+ 	c #976412\",
\"@ 	c #925F0D\",
\"# 	c #F2DFC2\",
\"$ 	c #BB904B\",
\"% 	c #94600D\",
\"& 	c #956211\",
\"* 	c #F5E6CE\",
\"= 	c #EACB99\",
\"- 	c #B98C45\",
\"; 	c #925B03\",
\"> 	c #945F0B\",
\", 	c #986C27\",
\"' 	c #C1A476\",
\") 	c #D9C9AE\",
\"! 	c #925D09\",
\"~ 	c #F5E7D0\",
\"{ 	c #DCA857\",
\"] 	c #E8CB9C\",
\"^ 	c #B28437\",
\"/ 	c #B99457\",
\"( 	c #E0CBAA\",
\"_ 	c #F3E9D9\",
\": 	c #F9F5ED\",
\"< 	c #F6F3EC\",
\"[ 	c #F9F7F4\",
\"} 	c #8F5A03\",
\"| 	c #915D09\",
\"1 	c #F8ECD8\",
\"2 	c #E0AE5E\",
\"3 	c #DAA655\",
\"4 	c #DFB778\",
\"5 	c #9D6A15\",
\"6 	c #F4E4CA\",
\"7 	c #EDDCC1\",
\"8 	c #F1DBB8\",
\"9 	c #EDE3D1\",
\"0 	c #F9F6F1\",
\"a 	c #D3CFC7\",
\"b 	c #A4762D\",
\"c 	c #ECDABC\",
\"d 	c #EECA94\",
\"e 	c #DEA854\",
\"f 	c #C28E3C\",
\"g 	c #935B04\",
\"h 	c #F1D8B1\",
\"i 	c #EBD0A6\",
\"j 	c #EBD7B5\",
\"k 	c #EDDFC7\",
\"l 	c #D1C0A3\",
\"m 	c #D1B485\",
\"n 	c #B28947\",
\"o 	c #F2D7AD\",
\"p 	c #E6B971\",
\"q 	c #DDA651\",
\"r 	c #D89F47\",
\"s 	c #905A03\",
\"t 	c #ECC992\",
\"u 	c #E9C58E\",
\"v 	c #EBCFA2\",
\"w 	c #EED9B8\",
\"x 	c #F2E5D0\",
\"y 	c #F7F2E9\",
\"z 	c #C29652\",
\"A 	c #DAA95C\",
\"B 	c #A67322\",
\"C 	c #A8792D\",
\"D 	c #E8C285\",
\"E 	c #E4B367\",
\"F 	c #DBA34C\",
\"G 	c #8F5902\",
\"H 	c #EEC88D\",
\"I 	c #E8C082\",
\"J 	c #DCB87E\",
\"K 	c #C9A874\",
\"L 	c #AD8647\",
\"M 	c #D3B17B\",
\"N 	c #EDC78B\",
\"O 	c #DBB880\",
\"P 	c #A37A37\",
\"Q 	c #D9A85C\",
\"R 	c #E1AF61\",
\"S 	c #9B650F\",
\"T 	c #A1732A\",
\"U 	c #906218\",
\"V 	c #885F1D\",
\"W 	c #835F27\",
\"X 	c #9B7B48\",
\"Y 	c #CFA462\",
\"Z 	c #E9B96E\",
\"` 	c #D7AB66\",
\" .	c #B28E54\",
\"..	c #8F692D\",
\"+.	c #EABC77\",
\"@.	c #E2AE5C\",
\"#.	c #E5BA76\",
\"$.	c #EDD1A4\",
\"%.	c #EDD4AC\",
\"&.	c #E8C793\",
\"*.	c #E7C185\",
\"=.	c #DFAB59\",
\"-.	c #E0AB5A\",
\";.	c #E1B165\",
\">.	c #E1B36A\",
\",.	c #E2B46D\",
\"'.	c #DEB26D\",
\").	c #DEAF64\",
\"!.	c #E0B36D\",
\"~.	c #E8C38A\",
\"{.	c #DAA44D\",
\"].	c #D89F46\",
\"^.	c #D79E44\",
\"/.	c #D59B40\",
\"(.	c #D3993C\",
\"_.	c #D29638\",
\":.	c #D09435\",
\"<.	c #17C51B\",
\"[.	c #C98A25\",
\"}.	c #D19C47\",
\"|.	c #E7C38A\",
\"1.	c #D9A149\",
\"2.	c #D59C41\",
\"3.	c #CE9130\",
\"4.	c #000000\",
\"5.	c #D8A047\",
\"6.	c #D4993C\",
\"7.	c #DCA54F\",
\"8.	c #E9C68D\",
\"9.	c #7A4E07\",
\"                                                \",
\"                          . + .                 \",
\"                          @ # $ .               \",
\"                    %     & * = - ;             \",
\"            % > , ' ) !   + ~ { ] ^ .           \",
\"        > / ( _ : < [ } } | 1 2 3 4 5 |         \",
\"        } 6 # 7 8 9 0 } a b c d e 3 f g         \",
\"        } h = i j k 0 } l m n o p q r }         \",
\"        s t u v w x y g z A B C D E F G         \",
\"        } H I J m K L , M N O P + Q R g         \",
\"        S H T @ U V W X Y Z `  ...T +.G         \",
\"        } D @.2 @.#.u $.8 6 * # %.&.*.}         \",
\"        G D =.-.2 R ;.>.,.,.,.'.).A !.}         \",
\"        } ~.{.F ].^./.(._.:.<.<.<.[.}.s         \",
\"        } |.1.].2.2.(._.:.3.<.<.<.4.4.}         \",
\"        } ~.{.1.5.2.2./.6._.<.<.<.4.4.}         \",
\"        } ~.{.F F 1.5.^.^.2.<.<.<.4.4.}         \",
\"        } u { q {.7.{.{.{.1.<.<.<.4.4.}         \",
\"        } u e e q e e e e e <.<.<.4.4.}         \",
\"        s *.8.u 8.8.u u u u <.<.<.4.4.}         \",
\"        9.s } } } } } } <.<.<.<.<.<.<.4.        \",
\"                          <.<.<.<.<.4.4.        \",
\"                            <.<.<.4.4.          \",
\"                              <.4.4.            \"};
")
)

(setq feline-herd-unmark-icon-xpm

#("/* XPM */
static char * packageunmark_xpm[] = {
\"24 24 232 2\",
\"  	c None\",
\". 	c #935D06\",
\"+ 	c #976412\",
\"@ 	c #925F0D\",
\"# 	c #F2DFC2\",
\"$ 	c #BB904B\",
\"% 	c #94600D\",
\"& 	c #956211\",
\"* 	c #F5E6CE\",
\"= 	c #EACB99\",
\"- 	c #B98C45\",
\"; 	c #925B03\",
\"> 	c #94610E\",
\", 	c #95600D\",
\"' 	c #996D29\",
\") 	c #C1A477\",
\"! 	c #D9C8AD\",
\"~ 	c #925E0A\",
\"{ 	c #F5E7D0\",
\"] 	c #DCA857\",
\"^ 	c #E8CB9C\",
\"/ 	c #B28437\",
\"( 	c #945F0B\",
\"_ 	c #B99457\",
\": 	c #E0CAA9\",
\"< 	c #F1E7D6\",
\"[ 	c #F8F3E9\",
\"} 	c #F5F2EA\",
\"| 	c #F7F3EE\",
\"1 	c #905C07\",
\"2 	c #8F5A04\",
\"3 	c #925E0B\",
\"4 	c #F8EBD7\",
\"5 	c #E0AE5E\",
\"6 	c #DAA655\",
\"7 	c #DFB778\",
\"8 	c #9D6A15\",
\"9 	c #915D09\",
\"0 	c #905B05\",
\"a 	c #F2E1C6\",
\"b 	c #F1DEC1\",
\"c 	c #EDDCC1\",
\"d 	c #F1DCB9\",
\"e 	c #EDE4D2\",
\"f 	c #F5F1E9\",
\"g 	c #93600D\",
\"h 	c #D0CABE\",
\"i 	c #A57830\",
\"j 	c #EBD9BA\",
\"k 	c #EECA94\",
\"l 	c #DEA854\",
\"m 	c #C28E3C\",
\"n 	c #935B04\",
\"o 	c #905C06\",
\"p 	c #EFD4AC\",
\"q 	c #EACC9B\",
\"r 	c #EBD0A7\",
\"s 	c #ECD8B6\",
\"t 	c #EEE0C8\",
\"u 	c #F3EDE3\",
\"v 	c #976515\",
\"w 	c #CEBA99\",
\"x 	c #D1B383\",
\"y 	c #B38A49\",
\"z 	c #F2D6AA\",
\"A 	c #E6B971\",
\"B 	c #DDA651\",
\"C 	c #D89F47\",
\"D 	c #8F5A03\",
\"E 	c #925D07\",
\"F 	c #E8C58D\",
\"G 	c #E9C68F\",
\"H 	c #EACEA1\",
\"I 	c #ECD6B4\",
\"J 	c #EEDFC8\",
\"K 	c #ECE1CF\",
\"L 	c #9D6A1A\",
\"M 	c #C29652\",
\"N 	c #D8A95E\",
\"O 	c #AA782A\",
\"P 	c #AB7C31\",
\"Q 	c #E8C285\",
\"R 	c #E4B367\",
\"S 	c #DBA34C\",
\"T 	c #8F5902\",
\"U 	c #935E08\",
\"V 	c #E8C284\",
\"W 	c #E4BD7F\",
\"X 	c #D8B47A\",
\"Y 	c #CEB07F\",
\"Z 	c #C7A774\",
\"` 	c #AF8A4D\",
\" .	c #A17735\",
\"..	c #CFAA70\",
\"+.	c #E7C083\",
\"@.	c #D7B478\",
\"#.	c #A77E3B\",
\"$.	c #9A6917\",
\"%.	c #D9A85C\",
\"&.	c #E1AF61\",
\"*.	c #9E6914\",
\"=.	c #E7C081\",
\"-.	c #AE8138\",
\";.	c #A37224\",
\">.	c #A2752D\",
\",.	c #9C7433\",
\"'.	c #98733A\",
\").	c #AA8954\",
\"!.	c #D1AA6C\",
\"~.	c #E7BB78\",
\"{.	c #D7AF6E\",
\"].	c #B79359\",
\"^.	c #977135\",
\"/.	c #A6782F\",
\"(.	c #E7B873\",
\"_.	c #935F0A\",
\":.	c #E0B878\",
\"<.	c #DFAB5C\",
\"[.	c #D9A757\",
\"}.	c #D7A455\",
\"|.	c #D7AA66\",
\"1.	c #D9B378\",
\"2.	c #E0BF8B\",
\"3.	c #E8CA9D\",
\"4.	c #EDD5AD\",
\"5.	c #EDD7B5\",
\"6.	c #EAD2AC\",
\"7.	c #E5CA9D\",
\"8.	c #E4C38C\",
\"9.	c #E3BC7E\",
\"0.	c #915C06\",
\"a.	c #945F0A\",
\"b.	c #E1B878\",
\"c.	c #E0AD5C\",
\"d.	c #DFAA58\",
\"e.	c #DFAC5C\",
\"f.	c #DFAD5E\",
\"g.	c #DFAF64\",
\"h.	c #DFB26B\",
\"i.	c #E1B56F\",
\"j.	c #E2B571\",
\"k.	c #DEB26D\",
\"l.	c #DEAF64\",
\"m.	c #DAA95D\",
\"n.	c #DCAD66\",
\"o.	c #925D06\",
\"p.	c #93600A\",
\"q.	c #E0BA7B\",
\"r.	c #DCA753\",
\"s.	c #DBA34D\",
\"t.	c #D9A24A\",
\"u.	c #D8A148\",
\"v.	c #D7A047\",
\"w.	c #D69E46\",
\"x.	c #D69C43\",
\"y.	c #D49B40\",
\"z.	c #D1963C\",
\"A.	c #D09436\",
\"B.	c #CD9031\",
\"C.	c #CB8E2F\",
\"D.	c #CD9842\",
\"E.	c #935E07\",
\"F.	c #945F09\",
\"G.	c #E0BB7C\",
\"H.	c #DBA54F\",
\"I.	c #D8A048\",
\"J.	c #D69E44\",
\"K.	c #D59C43\",
\"L.	c #D39A40\",
\"M.	c #D2993C\",
\"N.	c #D19739\",
\"O.	c #D09534\",
\"P.	c #CE922F\",
\"Q.	c #CC8F2D\",
\"R.	c #CB8D28\",
\"S.	c #CA8C2A\",
\"T.	c #CC9644\",
\"U.	c #945F08\",
\"V.	c #925E08\",
\"W.	c #E3BC7F\",
\"X.	c #DAA652\",
\"Y.	c #D9A149\",
\"Z.	c #D8A047\",
\"`.	c #D59C41\",
\" +	c #D59B40\",
\".+	c #D4993C\",
\"++	c #D29638\",
\"@+	c #E00F0F\",
\"#+	c #CE9130\",
\"$+	c #CE9333\",
\"%+	c #915D07\",
\"&+	c #E3BC80\",
\"*+	c #DAA752\",
\"=+	c #D79E44\",
\"-+	c #E62020\",
\";+	c #000000\",
\">+	c #E5C186\",
\",+	c #DCA959\",
\"'+	c #DAA44D\",
\")+	c #DCA54F\",
\"!+	c #D9A14B\",
\"~+	c #D9A34F\",
\"{+	c #905B04\",
\"]+	c #E7C289\",
\"^+	c #DEA958\",
\"/+	c #DEA957\",
\"(+	c #DDA955\",
\"_+	c #DEAA59\",
\":+	c #DEAB5A\",
\"<+	c #DEAC5A\",
\"[+	c #DEAB5C\",
\"}+	c #DEAB5E\",
\"|+	c #905A03\",
\"1+	c #E5BF83\",
\"2+	c #E7C38A\",
\"3+	c #E6C086\",
\"4+	c #E2BF82\",
\"5+	c #E1BB7D\",
\"6+	c #DEB779\",
\"7+	c #DDB476\",
\"8+	c #DBB272\",
\"9+	c #DAB172\",
\"0+	c #DDB679\",
\"a+	c #7A4E07\",
\"b+	c #8F5B05\",
\"c+	c #935E09\",
\"d+	c #93610A\",
\"e+	c #96620D\",
\"f+	c #97650F\",
\"g+	c #9A6612\",
\"h+	c #9B6715\",
\"i+	c #986611\",
\"                                                \",
\"                          . + .                 \",
\"                          @ # $ .               \",
\"                    %     & * = - ;             \",
\"            > , ' ) ! ~   + { ] ^ / .           \",
\"        ( _ : < [ } | 1 2 3 4 5 6 7 8 9         \",
\"        0 a b c d e f g h i j k l 6 m n         \",
\"        o p q r s t u v w x y z A B C D         \",
\"        E F G H I J K L M N O P Q R S T         \",
\"        U V W X Y Z `  ...+.@.#.$.%.&.n         \",
\"        *.=.-.;.>.,.'.).!.~.{.].^./.(.T         \",
\"        _.:.<.[.}.|.1.2.3.4.5.6.7.8.9.0.        \",
\"        a.b.c.d.e.f.g.h.i.j.j.k.l.m.n.o.        \",
\"        p.q.r.s.t.u.v.w.x.y.z.A.B.C.D.E.        \",
\"        F.G.H.I.J.K.L.M.N.O.P.Q.R.S.T.U.        \",
\"        V.W.X.Y.Z.K.`. +.+++@+@+#+$+@+@+        \",
\"        %+&+*+S S Y.Z.=+=+`.-+-+;+L.-+-+;+      \",
\"        o >+,+B '+)+'+'+'+!+-+-+;+~+-+-+;+      \",
\"        {+]+^+/+(+_+:+<+<+[+-+-+;+}+-+-+;+      \",
\"        |+1+2+3+4+5+6+7+8+9+-+-+;+0+-+-+;+      \",
\"        a+|+b+o.c+d+e+f+g+h+-+-+;+i+-+-+;+      \",
\"                            @+@+@+@+@+@+;+      \",
\"                              @+@+@+@+;+;+      \",
\"                                ;+;+;+;+        \"};
")
)



) ;; end of defun initialize-toolbar-icons

