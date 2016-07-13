(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(require 'evil)
(require 'evil-numbers)
(require 'evil-easymotion)
(require 'evil-surround)
(require 'evil-leader)
(require 'evil-nerd-commenter)
(require 'evil-mark-replace)
(require 'evil-matchit)
(require 'evil-exchange)
(require 'evil-extra-operator)
(require 'evil-args)
(require 'evil-visualstar)
(require 'color-theme-approximate)
(require 'helm-config)

(evil-mode 1)
(color-theme-approximate-on)

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm evil-visualstar evil-surround evil-numbers evil-nerd-commenter evil-matchit evil-mark-replace evil-leader evil-extra-operator evil-exchange evil-easymotion evil-args color-theme-approximate))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
