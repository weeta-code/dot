;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-capture-templates
   '(("i" "Inbox" entry (file "~/org/inbox.org")
      "* TODO %?\12:PROPERTIES:\12:CAPTURED: %U\12:END:\12%a")
     ("t" "Todo" entry (file "~/org/todo.org")
      "* TODO %?\12:PROPERTIES:\12:CAPTURED: %U\12:END:\12%a")
     ("n" "Note" entry (file "~/org/notes.org")
      "* %?\12:PROPERTIES:\12:CAPTURED: %U\12:END:\12%a")
     ("j" "journal" entry (file "~/org/journal.org") "")))
 '(package-selected-packages
   '(avy consult corfu cuda-mode dashboard doom-modeline doom-themes eat
         evil-collection evil-escape evil-surround general go-mode
         gptel lua-mode majutsu marginalia orderless org-gcal org-roam
         rust-mode swift-mode treesit-auto vertico))
 '(package-vc-selected-packages '((majutsu :url "https://github.com/0WD0/majutsu"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
