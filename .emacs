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
(require 'web-mode)

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
(evil-leader/set-key "d" 'magit-branch-delete)
(evil-leader/set-key "t" 'tide-jump-to-definition)
(evil-leader/set-key "T" 'tide-jump-back)

  (setq-default mode-line-format
        '("%e"
          (:eval
           (let* ((active (powerline-selected-window-active))
                  (mode-line-buffer-id (if active 'mode-line-buffer-id 'mode-line-buffer-id-inactive))
                  (mode-line (if active 'mode-line 'mode-line-inactive))
                  (face0 (if active 'powerline-active0 'powerline-inactive0))
                  (face1 (if active 'powerline-active1 'powerline-inactive1))
                  (face2 (if active 'powerline-active2 'powerline-inactive2))
                  (separator-left (intern (format "powerline-%s-%s"
						  (powerline-current-separator)
                                                  (car powerline-default-separator-dir))))
                  (separator-right (intern (format "powerline-%s-%s"
                                                   (powerline-current-separator)
                                                   (cdr powerline-default-separator-dir))))
                  (lhs (list (powerline-raw "%*" face0 'l)
                             (powerline-buffer-id `(mode-line-buffer-id ,face0) 'l)
			     (powerline-raw "%4l" face0 'l)
			     (powerline-raw ":" face0 'l)
			     (powerline-raw "%3c" face0 'r)
			     (powerline-raw " " face0)
			     (powerline-raw "%6p" face0 'r)
                             (powerline-major-mode face1 'l)
                             (powerline-process face1)
                             (powerline-minor-modes face1 'l)
                             (powerline-narrow face1 'l)
                             (powerline-raw " " face1)
                             (funcall separator-left face1 face2)
                             (powerline-vc face2 'r)
                             (when (bound-and-true-p nyan-mode)
                               (powerline-raw (list (nyan-create)) face2 'l))))
                  (rhs (list (powerline-raw global-mode-string face2 'r)
                             (funcall separator-right face2 face1)
			     (unless window-system
			       (powerline-raw (char-to-string #xe0a1) face1 'l))
			     (powerline-raw "%4l" face1 'l)
			     (powerline-raw ":" face1 'l)
			     (powerline-raw "%3c" face1 'r)
			     (funcall separator-right face1 face0)
			     (powerline-raw " " face0)
			     (powerline-raw "%6p" face0 'r)
                             (when powerline-display-hud
                               (powerline-hud face0 face2))
			     (powerline-fill face0 0)
			     )))
	     (concat (powerline-render lhs)
		     (powerline-fill face2 (powerline-width rhs))
		     (powerline-render rhs))))))

(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
(define-key global-map (kbd "RET") 'newline-and-indent)
(ac-config-default)
(setq-default indent-tabs-mode nil)
(define-key text-mode-map (kbd "<tab>") 'tab-to-tab-stop)
(setq tab-stop-list '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32
                        34 36 38 40 42 44 46 48 50 52 54 56 58 60
                        62 64 66 68 70 72 74 76 78 80 82 84 86 88
                        90 92 94 96 98 100 102 104 106 108 110 112
                        114 116 118 120))
(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
)
(add-hook 'web-mode-hook  'my-web-mode-hook)
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . rjsx-mode))
(autoload 'jsx-mode "jsx-mode" "JSX mode" t)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))
(add-hook 'javascript-mode-hook 'flycheck-mode)
(add-hook 'rjsx-mode-hook 'flycheck-mode)
(add-hook 'rjsx-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'eslint-fix-file-and-revert nil 'make-it-local)))

(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(add-hook 'typescript-mode-hook 'flycheck-mode)
(add-hook 'typescript-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'tslint-fix-file-and-revert nil 'make-it-local)))

(add-hook 'web-mode-hook
          (lambda ()
            (add-hook 'after-save-hook #'tslint-fix-file-and-revert nil 'make-it-local)))

(defun my/use-tslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (tslint (and root
                      (expand-file-name "node_modules/tslint/bin/tslint.js"
                                        root))))
    (when (and tslint (file-executable-p tslint))
      (setq-local flycheck-typescript-tslint-executable tslint))))

(add-hook 'flycheck-mode-hook #'my/use-tslint-from-node-modules)

(with-eval-after-load 'flycheck
    (flycheck-add-mode 'javascript-flow 'rjsx-mode)
    (flycheck-add-next-checker 'javascript-flow 'javascript-eslint))
(set-face-attribute 'flycheck-warning nil
                    :foreground "yellow"
                    :background "red")
(set-face-attribute 'flycheck-error nil
                    :foreground "yellow"
                    :background "red")

(add-hook 'after-init-hook 'global-company-mode)

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
(define-key evil-normal-state-map "gT" 'elscreen-previous) ;previous tab
(define-key evil-normal-state-map "gt" 'elscreen-next) ;next tab
(define-key evil-normal-state-map "gc" 'elscreen-create) ;next tab

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
(define-key key-translation-map (kbd "C-n") 'my-esc)
;; Works around the fact that Evil uses read-event directly when in operator state, which
;; doesn't use the key-translation-map.
(define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)
(define-key evil-operator-state-map (kbd "C-n") 'keyboard-quit)

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
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
;; Add ac-source-dictionary to ac-sources of all buffer
(defun ac-js-setup ()
  (setq ac-sources (append ac-sources '(ac-source-tern-completion))))
(add-hook 'js-mode 'ac-js-setup)
(add-hook 'js2-mode 'ac-js-setup)
(add-hook 'jsx-mode 'ac-js-setup)

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
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root)))
         (prettier (and root
                      (expand-file-name "node_modules/prettier/bin-prettier.js"
                                        root))))
    (when (and (and eslint (file-executable-p eslint)) (and prettier (file-executable-p prettier)))
      (shell-command (concat "PRETTIED=$(" prettier " " (buffer-file-name) "); echo $PRETTIED | " eslint " --stdin --stdin-filename='" (buffer-file-name) "' --fix-dry-run --format=json | NODE_P=$PRETTIED node -p \"JSON.parse(fs.readFileSync('/dev/stdin','utf-8'))[0].output || process.env.NODE_P\" > " (buffer-file-name))))))

(defun eslint-fix-file-and-revert ()
  (interactive)
  (eslint-fix-file)
  (revert-buffer t t))

(defun tslint-fix-file ()
  (interactive)
  (message "tslint --fixing the file" (buffer-file-name))
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (tslint (and root
                      (expand-file-name "node_modules/tslint/bin/tslint"
                                        root)))
         (tslint-config (and root
                      (expand-file-name "tsconfig.json"
                                        root)))
         (prettier (and root
                      (expand-file-name "node_modules/prettier/bin-prettier.js"
                                        root))))
    (when (and (and tslint (file-executable-p tslint)) (and prettier (file-executable-p prettier)))
      (shell-command (concat prettier " --parser typescript --write " (buffer-file-name) " && " tslint " --out /dev/null --fix " (buffer-file-name))))))

(defun tslint-fix-file-and-revert ()
  (interactive)
  (tslint-fix-file)
  (revert-buffer t t))

(evil-leader/set-key "f" 'eslint-fix-file-and-revert)

(advice-add 'split-window-right :after #'balance-windows)
(advice-add 'split-window-below :after #'balance-windows)
(advice-add 'evil-quit :after #'balance-windows)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-ignore-case nil)
 '(company-backends
   '(company-flow company-eclim company-semantic company-clang company-xcode company-cmake company-capf company-files
                  (company-dabbrev-code company-gtags company-etags company-keywords)
                  company-oddmuse company-dabbrev))
 '(custom-enabled-themes '(darcula))
 '(custom-safe-themes
   '("3d5720f488f2ed54dd4e40e9252da2912110948366a16aef503f3e9e7dfe4915" "fad38808e844f1423c68a1888db75adf6586390f5295a03823fa1f4959046f81" "c697b65591ba1fdda42fae093563867a95046466285459bd4e686dc95a819310" default))
 '(evil-magit-use-y-for-yank t)
 '(evil-shift-width 2)
 '(evilem-style 'at-full)
 '(flycheck-eslintrc "./.eslintrc")
 '(flycheck-highlighting-mode 'symbols)
 '(flycheck-indication-mode 'left-fringe)
 '(flycheck-javascript-flow-args '("--respect-pragma"))
 '(global-flycheck-mode t)
 '(js-indent-level 2)
 '(js2-mode-show-parse-errors nil)
 '(package-selected-packages
   '(php-mode web-mode tide company-flow company keychain-environment lua-mode rjsx-mode string-inflection typescript-mode rust-mode evil-magit magit column-marker autopair helm-projectile projectile helm-ag darcula-theme rainbow-delimiters flycheck-flow clean-aindent-mode tern-auto-complete js2-mode jsx-mode flycheck powerline discover-my-major evil-search-highlight-persist evil-mc evil-org evil-tabs helm evil-visualstar evil-surround evil-numbers evil-nerd-commenter evil-matchit evil-mark-replace evil-leader evil-extra-operator evil-exchange evil-easymotion evil-args color-theme-approximate))
 '(sgml-basic-offset 2)
 '(standard-indent 2)
 '(tab-stop-list
   '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80))
 '(tern-ac-on-dot t)
 '(tern-ac-sync t)
 '(tide-always-show-documentation t)
 '(tide-completion-detailed t)
 '(tide-jump-to-definition-reuse-window t)
 '(typescript-indent-level 2)
 '(web-mode-enable-auto-indentation t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-lead-face-0 ((t (:background "color-52" :foreground "white"))))
 '(avy-lead-face-1 ((t (:background "color-55" :foreground "white"))))
 '(avy-lead-face-2 ((t (:background "color-57" :foreground "white"))))
 '(js2-function-call ((t (:inherit default :foreground "color-110"))))
 '(js2-object-property ((t (:inherit default :foreground "color-109"))))
 '(mode-line-inactive ((t (:inherit mode-line :background "white" :foreground "brightblack" :inverse-video t :box nil :underline nil :slant normal :weight normal))))
 '(powerline-inactive0 ((t (:inherit mode-line-inactive)))))
