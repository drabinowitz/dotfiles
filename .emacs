(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(setq evil-want-C-u-scroll t)

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
(require 'evil-mc)
(require 'evil-tabs)
(require 'evil-search-highlight-persist)
(require 'color-theme-approximate)
(require 'projectile)
(require 'discover-my-major)
(require 'powerline)
(require 'cl)
(require 'flycheck)
(require 'auto-complete)
(require 'tern)
(require 'tern-auto-complete)

;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require 'helm-config)
(require 'helm-misc)
(require 'helm-projectile)
(require 'helm-locate)
(helm-mode 1)
(define-key evil-normal-state-map (kbd "M-SPC") 'helm-mini)
(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)

(helm-projectile-on)
(global-set-key (kbd "M-x") 'helm-M-x)

(defun helm-my-buffers ()
    (interactive)
    (let ((helm-ff-transformer-show-only-basename nil))
    (helm-other-buffer '(helm-source-buffers-list
                         ;; helm-source-elscreen
                         helm-source-projectile-files-list
                         ;; helm-source-ctags
                         helm-source-recentf
                         helm-source-locate)
                         "*helm-my-buffers*")))

(evil-mode 1)
(global-evil-mc-mode 1)
(global-evil-tabs-mode t)
(global-evil-search-highlight-persist t)
(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(color-theme-approximate-on)
(evil-leader/set-key "e" 'helm-my-buffers)
(powerline-default-theme)
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
(setq-default tab-width 4 indent-tabs-mode nil)
(define-key global-map (kbd "RET") 'newline-and-indent)
(ac-config-default)

(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))
(flycheck-add-mode 'javascript-eslint 'web-mode)
(set-face-attribute 'flycheck-warning nil
                    :foreground "yellow"
                    :background "red")

(evilem-default-keybindings "SPC")
(evilem-define (kbd "SPC w") 'evil-forward-word-begin)
(evilem-define (kbd "SPC e") 'evil-forward-word-end)
(evilem-define (kbd "SPC b") 'evil-backward-word-begin)
(evilem-define (kbd "SPC ge") 'evil-backward-word-end)

;; save bookmarks
(setq bookmark-default-file "~/.emacs.d/bookmarks"
      bookmark-save-flag 1) ;; save after every change

(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

(evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)

(define-key evil-normal-state-map (kbd "C-0") (lambda() (interactive) (elscreen-goto 0)))
(define-key evil-normal-state-map (kbd "C-1") (lambda() (interactive) (elscreen-goto 1)))
(define-key evil-normal-state-map (kbd "C-2") (lambda() (interactive) (elscreen-goto 2)))
(define-key evil-normal-state-map (kbd "C-3") (lambda() (interactive) (elscreen-goto 3)))
(define-key evil-normal-state-map (kbd "C-4") (lambda() (interactive) (elscreen-goto 4)))
(define-key evil-normal-state-map (kbd "C-5") (lambda() (interactive) (elscreen-goto 5)))
(define-key evil-normal-state-map (kbd "C-6") (lambda() (interactive) (elscreen-goto 6)))
(define-key evil-normal-state-map (kbd "C-7") (lambda() (interactive) (elscreen-goto 7)))
(define-key evil-normal-state-map (kbd "C-8") (lambda() (interactive) (elscreen-goto 8)))
(define-key evil-normal-state-map (kbd "C-9") (lambda() (interactive) (elscreen-goto 9)))

;;; C-c as general purpose escape key sequence.
;;;
(defun my-esc (prompt)
  "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
  (cond
    ;; If we're in one of the Evil states that defines [escape] key, return [escape] so as
    ;; Key Lookup will use it.
    ((or (evil-insert-state-p) (evil-normal-state-p) (evil-replace-state-p) (evil-visual-state-p)) [escape])
    ;; This is the best way I could infer for now to have C-c work during evil-read-key.
    ;; Note: As long as I return [escape] in normal-state, I don't need this.
    ;;((eq overriding-terminal-local-map evil-read-key-map) (keyboard-quit) (kbd ""))
    (t (kbd "C-g"))))
(define-key key-translation-map (kbd "C-c") 'my-esc)
;; Works around the fact that Evil uses read-event directly when in operator state, which
;; doesn't use the key-translation-map.
(define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)

;; change mode-line color by evil state
   (lexical-let ((default-color (cons (face-background 'mode-line)
                                      (face-foreground 'mode-line))))
     (add-hook 'post-command-hook
       (lambda ()
         (let ((color (cond ((minibufferp) default-color)
                            ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                            ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                            ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                            (t default-color))))
           (set-face-background 'mode-line (car color))
           (set-face-foreground 'mode-line (cdr color))))))

;; Add ac-source-dictionary to ac-sources of all buffer
(defun ac-js-setup ()
  (setq ac-sources (append ac-sources '(ac-source-tern-completion))))

(add-hook 'js-mode 'ac-js-setup)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (tern-auto-complete js2-mode flycheck powerline discover-my-major evil-search-highlight-persist evil-mc evil-org evil-tabs helm evil-visualstar evil-surround evil-numbers evil-nerd-commenter evil-matchit evil-mark-replace evil-leader evil-extra-operator evil-exchange evil-easymotion evil-args color-theme-approximate)))
 '(tern-ac-on-dot t)
 '(tern-ac-sync t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
