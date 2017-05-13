(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(setq evil-want-C-u-scroll t)

(require 'avy)
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
(require 'clean-aindent-mode)
(require 'flycheck-flow)
(require 'rainbow-delimiters)
(require 'helm-ag)
(require 'org)
(require 'magit)

(require 'column-marker)
(add-hook 'js-mode-hook (lambda () (interactive) (column-marker-1 81)))

(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require 'helm-config)
(require 'helm-misc)
(require 'helm-projectile)

;;(autoload 'octave-mode "octave-mod" nil t)
;;(setq auto-mode-alist
;;      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(projectile-mode)

(setq helm-split-window-in-side-p t)
(helm-mode 1)
(define-key evil-normal-state-map (kbd "M-SPC") 'helm-mini)
(setq helm-quick-update t)
(setq helm-bookmark-show-location t)
(setq helm-buffers-fuzzy-matching t)
(setq helm-recentf-fuzzy-match t)
(setq helm-M-x-fuzzy-match t)
(setq projectile-enable-caching t)

(helm-projectile-on)
(global-set-key (kbd "M-x") 'helm-M-x)

(defun helm-my-buffers ()
    (interactive)
    (let ((helm-ff-transformer-show-only-basename nil))
    (helm-other-buffer '(helm-source-buffers-list
                         ;; helm-source-elscreen-list
                         helm-source-recentf
                         helm-source-projectile-files-list
                         ;; helm-source-ctags
                         )
                         "*helm-my-buffers*")))

(setq backup-directory-alist `(("." . "~/.saves")))
(evil-mode 1)
(require 'evil-magit)
(global-evil-mc-mode 1)
(global-evil-tabs-mode t)
(global-evil-search-highlight-persist t)
(global-evil-surround-mode 1)
(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(color-theme-approximate-on)
(evil-leader/set-key "e" 'helm-my-buffers)
(evil-leader/set-key "a" 'helm-do-ag-project-root)
(evil-leader/set-key "r" 'tern-rename-variable)
(evil-leader/set-key "g" 'magit-status)
(evil-leader/set-key "c" 'magit-checkout)
(evil-leader/set-key "b" 'magit-branch-and-checkout)
(powerline-default-theme)
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
(define-key global-map (kbd "RET") 'newline-and-indent)
(ac-config-default)
(setq-default indent-tabs-mode nil)
(define-key text-mode-map (kbd "<tab>") 'tab-to-tab-stop)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                      64 68 72 76 80 84 88 92 96 100 104 108 112
                      116 120))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))
(add-hook 'javascript-mode-hook 'flycheck-mode)
(with-eval-after-load 'flycheck
    (flycheck-add-mode 'javascript-eslint 'web-mode)
    (flycheck-add-mode 'javascript-eslint 'js2-mode)
    (flycheck-add-mode 'javascript-flow 'js2-mode)
    (flycheck-add-next-checker 'javascript-flow 'javascript-eslint))
(set-face-attribute 'flycheck-warning nil
                    :foreground "yellow"
                    :background "red")
(set-face-attribute 'flycheck-error nil
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

(load "elscreen" "ElScreen" t)
(elscreen-start)
(evil-leader/set-key "t" 'elscreen-create) ;creat tab
(define-key evil-normal-state-map "gT" 'elscreen-previous) ;previous tab
(define-key evil-normal-state-map "gt" 'elscreen-next) ;next tab

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

(add-hook 'js-mode-hook (lambda () (tern-mode t)))
;; Add ac-source-dictionary to ac-sources of all buffer
(defun ac-js-setup ()
  (setq ac-sources (append ac-sources '(ac-source-tern-completion))))
(add-hook 'js-mode 'ac-js-setup)
(add-hook 'js2-mode 'ac-js-setup)

;; COPIED FROM EVIL-TMUX_NAVIGATOR https://github.com/keith/evil-tmux-navigator
; Without unsetting C-h this is useless
(global-unset-key (kbd "C-h"))

; This requires windmove commands
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(defun tmux-navigate (direction)
  (let
    ((cmd (concat "windmove-" direction)))
      (condition-case nil
          (funcall (read cmd))
        (error
          (tmux-command direction)))))

(defun tmux-command (direction)
  (shell-command-to-string
    (concat "tmux select-pane -"
      (tmux-direction direction))))

(defun tmux-direction (direction)
  (upcase
    (substring direction 0 1)))

(define-key evil-normal-state-map
            (kbd "C-h")
            (lambda ()
              (interactive)
              (tmux-navigate "left")))
(define-key evil-normal-state-map
            (kbd "C-j")
            (lambda ()
              (interactive)
              (tmux-navigate "down")))
(define-key evil-normal-state-map
            (kbd "C-k")
            (lambda ()
              (interactive)
              (tmux-navigate "up")))
(define-key evil-normal-state-map
            (kbd "C-l")
            (lambda ()
              (interactive)
              (tmux-navigate "right")))

(evil-leader/set-key "v" 'split-window-right)
(evil-leader/set-key "s" 'split-window-below)

(define-key helm-map (kbd "C-k") 'helm-previous-line)
(define-key helm-map (kbd "C-j") 'helm-next-line)

(defun eslint-fix-file ()
  (interactive)
  (message "eslint --fixing the file" (buffer-file-name))
  (shell-command (concat "eslint --fix " (buffer-file-name))))

(defun eslint-fix-file-and-revert ()
  (interactive)
  (eslint-fix-file)
  (revert-buffer t t))

(evil-leader/set-key "f" 'eslint-fix-file-and-revert)

(advice-add 'split-window-right :after #'balance-windows)
(advice-add 'evil-quit :after #'balance-windows)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ignore-case nil)
 '(custom-enabled-themes (quote (darcula)))
 '(custom-safe-themes
   (quote
    ("fad38808e844f1423c68a1888db75adf6586390f5295a03823fa1f4959046f81" "c697b65591ba1fdda42fae093563867a95046466285459bd4e686dc95a819310" default)))
 '(evil-magit-use-y-for-yank t)
 '(evilem-style (quote at-full))
 '(flycheck-eslintrc "./.eslintrc")
 '(flycheck-highlighting-mode (quote symbols))
 '(flycheck-indication-mode (quote left-fringe))
 '(flycheck-javascript-flow-args (quote ("--respect-pragma")))
 '(global-flycheck-mode t)
 '(js2-mode-show-parse-errors nil)
 '(package-selected-packages
   (quote
    (rust-mode evil-magit magit column-marker autopair helm-projectile projectile helm-ag darcula-theme rainbow-delimiters flycheck-flow clean-aindent-mode tern-auto-complete js2-mode flycheck powerline discover-my-major evil-search-highlight-persist evil-mc evil-org evil-tabs helm evil-visualstar evil-surround evil-numbers evil-nerd-commenter evil-matchit evil-mark-replace evil-leader evil-extra-operator evil-exchange evil-easymotion evil-args color-theme-approximate)))
 '(tern-ac-on-dot t)
 '(tern-ac-sync t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-lead-face-0 ((t (:background "color-52" :foreground "white"))))
 '(avy-lead-face-1 ((t (:background "color-55" :foreground "white"))))
 '(avy-lead-face-2 ((t (:background "color-57" :foreground "white")))))
