;;; hand rolled -*- lexical-binding: t; -*- 

;;; package bootstrap
(require 'package)

;; stop customize litterringgg
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t) ; t = don't error if it doesn't exist yet 
;;; add melpa
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(unless (file-exists-p
          (expand-file-name "elpa/archives/melpa/archive-contents"
                            user-emacs-directory))
  (package-refresh-contents)) ; download package index once

(require 'use-package)
(setq use-package-always-ensure t) ; every use package call auto installs the package

;; opts
(setq-default indent-tabs-mode nil
              tab-width 2) ; expandtab
(setq inhibit-startup-message t
      ring-bell-function 'ignore
      use-short-answers t
      create-lockfiles nil
      make-backup-files nil)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type t)
(column-number-mode 1)
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(global-visual-line-mode 1)

;; minibuffer completion 
(use-package vertico
  :init (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        ;; file paths tab compl segment by segment
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package consult)

;; history and recent files
(setq history-length 200
      recentf-max-saved-items 200)
(savehist-mode 1)
(recentf-mode 1)

;; evil mode
(use-package evil
  :init 
  (setq evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-Y-yank-to-eol t
        evil-undo-system 'undo-redo
        evil-split-window-below t
        evil-vsplit-window-right t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-escape
  :after evil
  :config
  (setq evil-escape-key-sequence "jk"
        evil-escape-delay 0.15)
  (evil-escape-mode 1))

(use-package general
  :after evil
  :config
  (general-create-definer my/leader
    :states '(normal visual)
    :keymaps 'override
    :prefix "SPC")
  (my/leader
    "nh" '(evil-ex-nohighlight :which-key "clear search hl")
    "sv" '(evil-window-vsplit :which-key "vsplit")
    "sh" '(evil-window-split :which-key "split")
    "sx" '(evil-window-delete :which-key "delete split")))

;;; auto pairs and surround

(electric-pair-mode 1)

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode 1))

;; lsp + complete
(use-package corfu
  :init (global-corfu-mode 1)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.1
        corfu-auto-prefix 2
        corfu-cycle t)
  :bind (:map corfu-map
              ("C-j" . corfu-next)
              ("C-k" . corfu-previous)))

(setq read-process-output-max (* 1024 1024))

(use-package eglot
  :ensure nil
  :hook ((c-mode c-ts-mode c++-mode c++-ts-mode
          python-mode python-ts-mode
          typescript-ts-mode tsx-ts-mode js-ts-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode)
                 . ("clangd" "--offset-encoding=utf-16")))
  (my/leader
    "rn" '(eglot-rename :which-key "rename")
    "ca" '(eglot-code-actions :which-key "code-actions")
    "cf" '(eglot-format :which-key "format")))

;; nav keys
(general-define-key
  :states 'normal
  "gd" 'xref-find-definitions
  "gr" 'xref-find-references
  "K" 'eldoc-doc-buffer
  "[d" 'flymake-goto-prev-error
  "]d" 'flymake-goto-next-error)

;; jump-to-char (bound under SPC b f below)
(use-package avy)

;;swift
(use-package swift-mode
  :hook (swift-mode . eglot-ensure))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(swift-mode . ("sourcekit-lsp"))))

(use-package go-mode :hook (go-mode . eglot-ensure))
(use-package lua-mode :hook (lua-mode . eglot-ensure))
(use-package rust-mode :hook (rust-mode . eglot-ensure))
(use-package cuda-mode :hook (cuda-mode . eglot-ensure))
(with-eval-after-load 'eglot
  ;; Must be the *system* clangd (Fedora llvm20): the Swift toolchain's clangd
  ;; is built without the NVPTX target and cannot parse CUDA device code.
  ;; CUDA flags/headers live in ~/.config/clangd/config.yaml (.cu/.cuh match).
  (add-to-list 'eglot-server-programs
               '(cuda-mode . ("/usr/bin/clangd" "--offset-encoding=utf-16"))))

;; org mode stuffs
(use-package org
  :ensure nil
  :config
  (setq org-directory "~/org"
        org-agenda-files (list "~/org")
        org-default-notes-file "~/org/inbox.org"
        org-archive-location "~/org/archive.org"
        org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
        org-capture-templates
        '(("i" "Inbox" entry (file "~/org/inbox.org")
           "* TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n%a")
          ("t" "Todo" entry (file "~/org/todo.org")
           "* TODO %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n%a")
          ("n" "Note" entry (file "~/org/notes.org")
           "* %?\n:PROPERTIES:\n:CAPTURED: %U\n:END:\n%a"))))

(use-package org-roam
  :init (setq org-roam-directory "~/org/roam")
  :config (org-roam-db-autosync-mode 1))

(load (expand-file-name "secrets.el" user-emacs-directory) t t)

(use-package org-gcal
  :config
  (setq org-gcal-fetch-file-alist
        '(("victordesouz@umass.edu" . "~/org/gcal.org")))
  (org-gcal-reload-client-id-secret))

;;; Majutsu
(use-package magit)

(use-package majutsu
  :vc (:url "https://github.com/0WD0/majutsu" :rev :newest)
  :commands (majutsu majutsu-dispatch))

;;; Marks

(setq bookmark-save-flag 1)

;;; treesittin
(use-package treesit-auto
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode 1))

;;; ai
(use-package gptel
  :config
  (setq gptel-default-mode 'org-mode)


  (gptel-make-openai "OpenRouter"
    :host "openrouter.ai"
    :endpoint "/api/v1/chat/completions" :stream t
    :key #'gptel-api-key-from-auth-source
    :models '(deepseek/deepseek-v4-flash
              z-ai/glm-5.2))

  ;; (gptel-make-openai "openrouter-wafer"
  ;;   :host "openrouter.ai"
  ;;   :endpoint "/api/v1/chat/completions" :stream t
  ;;   :key #'gptel-api-key-from-auth-source
  ;;   :models '(@preset/deepseek-v4-flash-wafer))

  (setq gptel-backend
        (gptel-make-openai "remote-14b"
          :host "10.0.0.116:8080" :protocol "http"
          :endpoint "/v1/chat/completions" :stream t :key "dummy"
          :models '(mlx-community/Qwen2.5-Coder-14B-Instruct-4bit))
        gptel-model 'deepseek/deepseek-v4-flash))


;;; eat
(use-package eat
  :config
  (setq eat-kill-buffer-on-exit t
        eat-term-name "xterm-256color"))

(add-to-list 'display-buffer-alist
             '("\\*eat\\*"
               (display-buffer-in-side-window)
               (side . bottom)
               (slot . 0)
               (window-height . 0.35)))

(defun my/eat-toggle ()
  "Toggle a persistent eat terminal drawer"
  (interactive)
  (let* ((buf (get-buffer "*eat*"))
         (win (and buf (get-buffer-window buf))))
    (cond 
      (win (delete-window win))
      (buf (pop-to-buffer buf))
      (t (eat)))))

(defun my/eat-new ()
  "kill existing eat and start a fresh shell"
  (interactive)
  (when-let ((buf (get-buffer "*eat*")))
    (let ((kill-buffer-query-functions nil))
      (kill-buffer buf)))
  (eat))

;;; visual stuffs
(use-package nerd-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25
        doom-modeline-buffer-encoding nil))

(use-package dashboard
  :init (dashboard-setup-startup-hook)
  :config
  (setq dashboard-center-content t
        dashboard-items '((recents . 5)
                          (projects . 5)
                          (bookmarks . 5)
                          (agenda . 5))
        dashboard-item-shortcuts '((recents   . "r")
                                 (bookmarks . "m")
                                 (projects  . "p")
                                 (agenda    . "a"))
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-startup-banner "~/.config/emacs/banner.txt"))

;; compline-theme.el is built on def-doom-theme, so it needs doom-themes
;; (a standalone MELPA package that works fine outside Doom).
(use-package doom-themes)
(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))
(load-theme 'compline t)

(my/leader
  "f" '(:ignore t :which-key "find")
  "ff" '(consult-fd :which-key "files(project based)")
  "fr" '(consult-recent-file :which-key "recent")
  "fs" '(consult-ripgrep :which-key "grep")
  "fb" '(consult-buffer :which-key "buffers")
  "fc" '((lambda () (interactive)
           (consult-ripgrep nil (thing-at-point 'symbol t)))
         :which-key "grep word under cursor")
  "t" '(:ignore t :which-key "terminal")
  "tt" '(my/eat-toggle :which-key "toggle terminal")
  "tm" '(my/eat-new :which-key "new terminal")
  "o" '(:ignore t :which-key "org")
  "oa" '(org-agenda :which-key "agenda")
  "oc" '(org-capture :which-key "capture")
  "oi" '((lambda () (interactive) (find-file "~/org/inbox.org")) :which-key "inbox")
  "ot" '((lambda () (interactive) (find-file "~/org/todo.org")) :which-key "todo")
  "on" '((lambda () (interactive) (find-file "~/org/notes.org")) :which-key "notes")
  "z" '(:ignore t :which-key "notes (roam)")
  "zf" '(org-roam-node-find :which-key "find note")
  "zn" '(org-roam-capture :which-key "new note")
  "zi" '(org-roam-node-insert :which-key "insert link")
  "zb" '(org-roam-buffer-toggle :which-key "backlines")
  "zt" '(org-roam-tag-add :which-key "add tag")
  "j" '(:ignore t :which-key "git / jj")
  "jj" '(majutsu :which-key "majutsu (jj)")
  "m" '(:ignore t :which-key "marks")
  "mm" '(bookmark-set :which-key "set mark")
  "ml" '(consult-bookmark :which-key "list / jump")
  "ma" '(bookmark-edit-annotation :which-key "annotate")
  "md" '(bookmark-delete :which-key "delete")
  "a" '(:ignore t :which-key "ai")
  "ac" '(gptel :which-key "chat")
  "as" '(gptel-send :which-key "send")
  "ar" '(gptel-rewrite :which-key "inline rewrite")
  "a" '(gptel-menu :which-key "menu / actions")
  "b" '(:ignore t :which-key "avy")
  "bf" '(avy-goto-char-timer :which-key "avy jump")
  "gc" '(comment-region :which-key "comment line"))

(which-key-mode 1)
(setq which-key-idle-delay 0.4)
