;;; koda-theme.el --- Minimal monochrome dark theme, ported from koda.nvim -*- lexical-binding: t; -*-
;;; Commentary:
;; Hand-translated from oskarnurm/koda.nvim (palette/dark.lua + groups).
;; Near-monochrome: grey base, white for active tokens, gold for constants,
;; blue as the single accent.
;;; Code:

(deftheme koda "Minimal monochrome dark theme, ported from koda.nvim.")

(let ((bg       "#101010")
      (fg       "#b0b0b0")
      (dim      "#474747")
      (line     "#272727")   ; cursorline / selection
      (keyword  "#777777")
      (type     "#777777")
      (operator "#777777")
      (comment  "#50585d")
      (white    "#ffffff")   ; func / string / var / emphasis
      (const    "#d9ba73")   ; constants, numbers, warning
      (blue     "#458ee6")   ; the accent
      (info     "#8ebeec")
      (success  "#86cd82")
      (warning  "#d9ba73")
      (danger   "#ff7676")
      (red      "#701516")
      (pink     "#f2a4db")
      (cyan     "#5abfb5"))
  (custom-theme-set-faces
   'koda

   ;; ---- base UI ----
   `(default                    ((t (:background ,bg :foreground ,fg))))
   `(cursor                     ((t (:background ,fg))))
   `(region                     ((t (:background ,line))))
   `(hl-line                    ((t (:background ,line))))
   `(fringe                     ((t (:background ,bg))))
   `(line-number               ((t (:foreground ,comment))))
   `(line-number-current-line  ((t (:foreground ,white :weight bold))))
   `(highlight                  ((t (:background ,line))))
   `(secondary-selection        ((t (:background ,dim))))
   `(vertical-border            ((t (:foreground ,line))))
   `(window-divider             ((t (:foreground ,line))))
   `(minibuffer-prompt          ((t (:foreground ,blue))))
   `(link                       ((t (:foreground ,blue :underline t))))
   `(show-paren-match           ((t (:foreground ,const :weight bold))))
   `(trailing-whitespace        ((t (:background ,red))))

   ;; ---- syntax (font-lock) ----
   `(font-lock-keyword-face           ((t (:foreground ,keyword))))
   `(font-lock-builtin-face           ((t (:foreground ,keyword))))
   `(font-lock-preprocessor-face      ((t (:foreground ,keyword))))
   `(font-lock-type-face              ((t (:foreground ,type))))
   `(font-lock-function-name-face     ((t (:foreground ,white))))
   `(font-lock-function-call-face     ((t (:foreground ,white))))
   `(font-lock-variable-name-face     ((t (:foreground ,white))))
   `(font-lock-string-face            ((t (:foreground ,white))))
   `(font-lock-constant-face          ((t (:foreground ,const))))
   `(font-lock-number-face            ((t (:foreground ,const))))
   `(font-lock-comment-face           ((t (:foreground ,comment :slant normal))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,comment))))
   `(font-lock-doc-face               ((t (:foreground ,comment))))
   `(font-lock-operator-face          ((t (:foreground ,operator))))
   `(font-lock-negation-char-face     ((t (:foreground ,operator))))
   `(font-lock-warning-face           ((t (:foreground ,warning :weight bold))))

   ;; ---- completion: corfu (blink) + vertico ----
   `(corfu-default      ((t (:background ,bg :foreground ,fg))))
   `(corfu-current      ((t (:background ,line :foreground ,fg :weight bold))))
   `(corfu-border       ((t (:background ,dim))))
   `(corfu-bar          ((t (:background ,dim))))
   `(vertico-current    ((t (:background ,line :extend t))))
   `(completions-common-part ((t (:foreground ,const))))

   ;; ---- which-key / marginalia ----
   `(which-key-key-face                 ((t (:foreground ,const))))
   `(which-key-command-description-face ((t (:foreground ,fg))))
   `(which-key-group-description-face   ((t (:foreground ,blue))))
   `(marginalia-documentation           ((t (:foreground ,comment))))

   ;; ---- diagnostics (flymake) ----
   `(flymake-error      ((t (:underline (:style wave :color ,danger)))))
   `(flymake-warning    ((t (:underline (:style wave :color ,warning)))))
   `(flymake-note       ((t (:underline (:style wave :color ,info)))))
   `(error              ((t (:foreground ,danger :weight bold))))
   `(warning            ((t (:foreground ,warning))))
   `(success            ((t (:foreground ,success))))

   ;; ---- search ----
   `(isearch        ((t (:background ,const :foreground ,bg))))
   `(lazy-highlight ((t (:background ,dim :foreground ,fg))))
   `(isearch-fail   ((t (:background ,red :foreground ,white))))

   ;; ---- eglot / eldoc ----
   `(eglot-highlight-symbol-face ((t (:background ,line :weight bold))))
   `(eldoc-highlight-function-argument ((t (:foreground ,const :weight bold))))

   ;; ---- mode line (doom-modeline mostly owns this; set sane base) ----
   `(mode-line          ((t (:background ,line :foreground ,fg :box nil))))
   `(mode-line-inactive ((t (:background ,bg   :foreground ,dim :box nil))))

   ;; ---- dashboard ----
   `(dashboard-heading ((t (:foreground ,fg :weight bold))))
   `(dashboard-banner-logo-title ((t (:foreground ,white :weight bold))))))

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'koda)
;;; koda-theme.el ends here
