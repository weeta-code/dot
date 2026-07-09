;;; pre-frame, pre-package setup -*- lexical-binding: t; -*-

;;; pause gc in startup then drop to steady state ceiling once up 

(setq gc-cons-threshold most-positive-fixnum)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 64 1024 1024)))) ; 64 MB

;; don't let the async native-compile log pop up a *Warnings* buffer on every
;; package (re)compile -- still logged, just silent
(setq native-comp-async-report-warnings-errors 'silent)

;; kill chrome before the frame paints
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t) ; dash added later

