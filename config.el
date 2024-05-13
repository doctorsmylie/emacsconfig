;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Matthew J. Smylie"
       user-mail-address "matthewjsmylie@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Fira Code" :size 14 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Noto Serif" :size 14 :weight 'regular))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. The default is "doom-one".
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;;Let j and k operate on visual lines instead of real lines.
;;(setq global-visual-line-mode t)
(define-key evil-motion-state-map [remap evil-next-line] #'evil-next-visual-line)
(define-key evil-motion-state-map [remap evil-previous-line] #'evil-previous-visual-line)
;(setq evil-respect-visual-line-mode t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")

;;Customize org mode-specific settings.
;;
(after! org
;; TODO states
  (setq org-todo-keywords
      '((sequence "TODO(t)" "PROG(p@/!)" "WAIT(w@/!)" "HOLD(h@/!)" "|" "DONE(d!)" "SKIP(s@/!)" "NOGO(u@/!)" )
        (sequence "|" "OKAY(o)" "YES!(y)" "NOPE(n)")
        (sequence "[](T)" "[-](S)" "[?](W)" "|" "[X](D!)")
        )
      )
;;
;; TODO colors
  (setq org-todo-keyword-faces
      '(
        ("TODO" . (:foreground "OrangeRed" :weight bold))    ;unstarted
        ("PROG" . (:foreground "Gold" :weight bold))         ;working
        ("WAIT" . (:foreground "DarkViolet" :weight bold))   ;need input from someone else
        ("HOLD" . (:foreground "Violet" :weight bold))       ;long-term pause
        ("DONE" . (:foreground "LimeGreen" :weight bold))    ;done
        ("SKIP" . (:foreground "DeepSkyBlue" :weight bold))  ;project abandoned of my own accord
        ("NOGO" . (:foreground "DarkMagenta" :weight bold))  ;forced to abandon project
        ("YES!" . (:foreground "Green" :weight bold))
        ("NOPE" . (:foreground "DarkOrange" :weight bold))
        ("OKAY" . (:foreground "Cyan" :weight bold))
        ))

  (map! :map org-mode-map
        :localleader
        "z" #'org-agenda-file-to-front )
  (map! :map org-mode-map
        )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;Set scroll margin--it works like scrolloff in vim
(setq! scroll-margin 10)

;;Disable autocomplete for plain text files. DOES NOT WORK PROPERLY.
;;(remove-hook 'text-mode-hook #'turn-on-auto-fill)

;;Skip confirmation on quitting emacs.
(setq confirm-kill-emacs nil)

;;Start in fullscreen.
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;;Set default input method. Just use C-\ to toggle TeX inputs.
(setq default-input-method "TeX")

;;Pixel scrolling. Does not seem to work.
;(setq! pixel-scroll-precision-mode t)

;;Try emacs-in-browser.
(atomic-chrome-start-server)

;;Disable annoying stylistic checks.
(add-hook 'writegood-mode-hook 'writegood-passive-voice-turn-off)
(add-hook 'writegood-mode-hook 'writegood-weasels-turn-off)

;;Open LaTeX output on the right instead of below.
(advice-add 'TeX-command-run-all :around
            (lambda (fn &rest args)
              (let ((old-def (symbol-function 'split-window-below)))
                (fset 'split-window-below #'split-window-right)
                (unwind-protect
                    (apply fn args)
                  (fset 'split-window-below old-def)))))

;;Display workspaces in the tab bar permanently:
;; (after! persp-mode
;;   ;; alternative, non-fancy version which only centers the output of +workspace--tabline
;;   (defun workspaces-formatted ()
;;     (+doom-dashboard--center (frame-width) (+workspace--tabline)))

;;   (defun hy/invisible-current-workspace ()
;;     "The tab bar doesn't update when only faces change (i.e. the
;; current workspace), so we invisibly print the current workspace
;; name as well to trigger updates"
;;     (propertize (safe-persp-name (get-current-persp)) 'invisible t))

;;   (customize-set-variable 'tab-bar-format '(workspaces-formatted tab-bar-format-align-right hy/invisible-current-workspace))

;;   ;; don't show current workspaces when we switch, since we always see them
;;   (advice-add #'+workspace/display :override #'ignore)
;;   ;; same for renaming and deleting (and saving, but oh well)
;;   (advice-add #'+workspace-message :override #'ignore))

;; ;; need to run this later for it to not break frame size for some reason
;; (run-at-time nil nil (cmd! (tab-bar-mode +1)))
;; ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
