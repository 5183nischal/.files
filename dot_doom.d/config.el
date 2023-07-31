;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!ds


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Nischal Mainali"
      user-mail-address "nm2508@nyu.edu"
      +doom-dashboard-banner-dir doom-private-dir
      +doom-dashboard-banner-file "favicon-pixel.png"
      +doom-dashboard-banner-padding '(0 . 2)
      pixel-scroll-precision-mode t)

(server-start)

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;; (setq doom-font (font-spec :family "Iosevka SS04" :size 15 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 15))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)

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

(setq projectile-project-search-path '("~/Documents/projects" ))

(setq scroll-margin 2
      auto-save-default t
      delete-by-moving-to-trash t
      truncate-string-ellipsis "…"
      browse-url-browser-function 'xwidget-webkit-browse-url)

(setq auto-save-visited-interval 15)
(auto-save-visited-mode +1)

(global-subword-mode 1)
(global-copilot-mode 1)

(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

(cond
 ((string-equal system-type "darwin")
  (setq frame-resize-pixelwise  t
        window-resize-pixelwise t)))

(if (boundp 'mac-mouse-wheel-smooth-scroll)
    (setq  mac-mouse-wheel-smooth-scroll t))

(if (> emacs-major-version 28)
    (pixel-scroll-precision-mode))

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))

;; https://stackoverflow.com/questions/9547912/emacs-calendar-show-more-than-3-months
(defun dt/year-calendar (&optional year)
  (interactive)
  (require 'calendar)
  (let* (
      (current-year (number-to-string (nth 5 (decode-time (current-time)))))
      (month 0)
      (year (if year year (string-to-number (format-time-string "%Y" (current-time))))))
    (switch-to-buffer (get-buffer-create calendar-buffer))
    (when (not (eq major-mode 'calendar-mode))
      (calendar-mode))
    (setq displayed-month month)
    (setq displayed-year year)
    (setq buffer-read-only nil)
    (erase-buffer)
    ;; horizontal rows
    (dotimes (j 4)
      ;; vertical columns
      (dotimes (i 3)
        (calendar-generate-month
          (setq month (+ month 1))
          year
          ;; indentation / spacing between months
          (+ 5 (* 25 i))))
      (goto-char (point-max))
      (insert (make-string (- 10 (count-lines (point-min) (point-max))) ?\n))
      (widen)
      (goto-char (point-max))
      (narrow-to-region (point-max) (point-max)))
    (widen)
    (goto-char (point-min))
    (setq buffer-read-only t)))

(defun dt/scroll-year-calendar-forward (&optional arg event)
  "Scroll the yearly calendar by year in a forward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (unless arg (setq arg 0))
  (save-selected-window
    (if (setq event (event-start event)) (select-window (posn-window event)))
    (unless (zerop arg)
      (let* (
              (year (+ displayed-year arg)))
        (dt/year-calendar year)))
    (goto-char (point-min))
    (run-hooks 'calendar-move-hook)))

(defun dt/scroll-year-calendar-backward (&optional arg event)
  "Scroll the yearly calendar by year in a backward direction."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     last-nonmenu-event))
  (dt/scroll-year-calendar-forward (- (or arg 1)) event))

(map! :leader
      :desc "Scroll year calendar backward" "<left>" #'dt/scroll-year-calendar-backward
      :desc "Scroll year calendar forward" "<right>" #'dt/scroll-year-calendar-forward)

(defalias 'year-calendar 'dt/year-calendar)

;;what's up with super key??
(map!
 :n "C-s" #'save-buffer
 :n "C-/" #'evil-avy-goto-char-timer
 :n "q" #'kill-current-buffer
 :v "v" #'er/expand-region
 :v "V" #'er/contract-region

 :vgni "s-x" #'execute-extended-command
 :vgni "s-," #'+vertico/switch-workspace-buffer
 :vgni "s-/" #'consult-buffer
 :vgni "s-f" #'consult-line
 :vgni "s-." #'+workspace/switch-to
 :vgni "C-<tab>" #'mode-line-other-buffer
 :vgni "H-s-x" #'execute-extended-command
 :vgni "H-s-," #'+vertico/switch-workspace-buffer
 :vgni "H-s-/" #'consult-buffer
 :vgni "H-s-." #'+workspace/switch-to
 :vgni "s-1"   #'+workspace/switch-to-0
 :vgni "s-2"   #'+workspace/switch-to-1
 :vgni "s-3"   #'+workspace/switch-to-2
 :vgni "s-4"   #'+workspace/switch-to-3
 :vgni "s-5"   #'+workspace/switch-to-4
 :vgni "s-6"   #'+workspace/switch-to-5
 :vgni "s-7"   #'+workspace/switch-to-6
 :vgni "s-8"   #'+workspace/switch-to-7
 :vgni "s-9"   #'+workspace/switch-to-8
 :vgni "s-0"   #'+workspace/switch-to-final)

(map!
 :n "C-h" #'evil-window-left
 :n "C-j" #'evil-window-down
 :n "C-k" #'evil-window-up
 :n "C-l" #'evil-window-right

 (:map evil-window-map
  "-" (lambda () (interactive) (evil-window-decrease-height 7))
  "+" (lambda () (interactive) (evil-window-increase-height 7))
  "<" (lambda () (interactive) (evil-window-decrease-width 7))
  ">" (lambda () (interactive) (evil-window-increase-width 7))))

(use-package! emacs-everywhere
 :if (daemonp)
  :config
  (require 'spell-fu)
  (setq emacs-everywhere-major-mode-function #'org-mode
        emacs-everywhere-frame-name-format "Edit ∷ %s — %s")
  (defadvice! emacs-everywhere-raise-frame ()
    :after #'emacs-everywhere-set-frame-name
    (setq emacs-everywhere-frame-name (format emacs-everywhere-frame-name-format
                                (emacs-everywhere-app-class emacs-everywhere-current-app)
                                (truncate-string-to-width
                                 (emacs-everywhere-app-title emacs-everywhere-current-app)
                                 45 nil nil "…")))
    ;; need to wait till frame refresh happen before really set
    (run-with-timer 0.1 nil #'emacs-everywhere-raise-frame-1))
  (defun emacs-everywhere-raise-frame-1 ()
    (call-process "wmctrl" nil nil nil "-a" emacs-everywhere-frame-name)))

;;fonts
(setq doom-font (font-spec :family "JetBrains Mono" :size 17)
      doom-big-font (font-spec :family "JetBrains Mono" :size 22)
      doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 18)
      doom-unicode-font (font-spec :family "JuliaMono")
      doom-serif-font (font-spec :family "IBM Plex Sans" :size 18 :weight 'medium))

(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; (setq scroll-preserve-screen-position t
;;       scroll-conservatively 0
;;       maximum-scroll-margin 0.5
;;       scroll-margin 99999)


(setq ns-use-proxy-icon nil)
(modify-all-frames-parameters '((ns-appearance . dark)
                                (ns-transparent-titlebar . t)))
;; (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
;; (add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-native-fullscreen t)
(setq ns-auto-titlebar-mode t)
(setq frame-title-format nil)
(setq frame-resize-pixelwise t)

(setq default-frame-alist '((scroll-bar-background . "transparent")))

(add-to-list 'default-frame-alist '(undecorated-round . t)) ;; was in earlyinit.el
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

;; (set-frame-parameter (selected-frame) 'alpha 85)
(force-mode-line-update)

(when IS-MAC
  ;; NOTE: Not tangled
  (set-frame-parameter (selected-frame) 'alpha '(98 100))
  (add-to-list 'default-frame-alist '(alpha 98 100))
  ;; (set-frame-parameter (selected-frame) 'alpha '(81 . 81))
  ;; (add-to-list 'default-frame-alist '(alpha . (81 . 81)))
  (add-to-list 'default-frame-alist '(inhibit-double-buffering . t)))

(use-package doom-themes
  ;; :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (setq doom-gruvbox-dark-variant "light")
  (setq doom-gruvbox-light-variant "light")

  ;; (load-theme 'doom-gruvbox-light t)

  (require 'hl-line)
  (defun mac-appearance-change-hook ()
    (let ((appearance (plist-get (mac-application-state) :appearance)))
      (cond (
             (equal appearance "NSAppearanceNameAqua")
             (disable-theme 'doom-gruvbox)
             (load-theme 'doom-gruvbox-light t)
             ;; (set-face-attribute 'hl-line nil :inherit nil :background "#f9f5d7")
             )
            (
             (equal appearance "NSAppearanceNameDarkAqua")
             (disable-theme 'doom-gruvbox-light)
             (load-theme 'doom-nord t)
             ;; (set-face-attribute 'hl-line nil :inherit nil :background "gray9")
             ))))
  (add-hook 'after-init-hook 'mac-appearance-change-hook)
  (add-hook 'mac-effective-appearance-change-hook 'mac-appearance-change-hook)

  ;; Enable flashing mode-line on errors
  ;; (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (custom-set-faces
   `(fringe ((nil))))
  ;; Inspired by https://github.com/tarsius/moody
  (let ((line (face-attribute 'mode-line :underline)))
    (set-face-attribute 'mode-line nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :overline   line)
    (set-face-attribute 'mode-line-inactive nil :underline  line)
    (set-face-attribute 'mode-line nil :box nil)
    (set-face-attribute 'mode-line-inactive nil :box nil))
    ;; (set-face-attribute 'mode-line-inactive nil :background "#212121" :foreground "#5B6268"))
  )

;; Stretch cursor to the glyph width
(setq-default x-stretch-cursor t)
;; Enable relative line numbers
(setq display-line-numbers-type 'relative)
;; Enable beacon mode
(beacon-mode 1)

(defvar +text-mode-left-margin-width 1
  "The `left-margin-width' to be used in `text-mode' buffers.")

(defun +setup-text-mode-left-margin ()
  (when (and (derived-mode-p 'text-mode)
             (not (and (bound-and-true-p visual-fill-column-mode)
                       visual-fill-column-center-text))
             (eq (current-buffer) ; Check current buffer is active.
                 (window-buffer (frame-selected-window))))
    (setq left-margin-width (if display-line-numbers
                                0 +text-mode-left-margin-width))
    (set-window-buffer (get-buffer-window (current-buffer))
                       (current-buffer))))
(add-hook 'window-configuration-change-hook #'+setup-text-mode-left-margin)
(add-hook 'display-line-numbers-mode-hook #'+setup-text-mode-left-margin)
(add-hook 'text-mode-hook #'+setup-text-mode-left-margin)
(defadvice! +doom/toggle-line-numbers--call-hook-a ()
  :after #'doom/toggle-line-numbers
  (run-hooks 'display-line-numbers-mode-hook))

(dolist (mode '(prog-mode-hook
                latex-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


(defun mb/delete-trailing-whitespace ()
  "Deletes trailing whitespace in writable buffers"
  (interactive)
  (if (not buffer-read-only) (delete-trailing-whitespace)))
(add-hook 'before-save-hook 'mb/delete-trailing-whitespace)

(after! text-mode
  (add-hook! 'text-mode-hook
    (unless (derived-mode-p 'org-mode)
      ;; Apply ANSI color codes
      (with-silent-modifications
        (ansi-color-apply-on-region (point-min) (point-max) t)))))

(map! :leader
      (:prefix ("t" . "toggle")
       :desc "Toggle line numbers"            "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines"          "t" #'toggle-truncate-lines))

(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda ()
    (when (not (memq major-mode
                (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1 )

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)

(when IS-MAC
  (setq exec-path-from-shell-check-startup-files nil))

(when IS-MAC (setq ns-use-thin-smoothing t))

;; Keybonds
(global-set-key [(hyper a)] 'mark-whole-buffer)
(global-set-key [(hyper v)] 'yank)
(global-set-key [(hyper c)] 'kill-ring-save)
(global-set-key [(hyper s)] 'save-buffer)
(global-set-key [(hyper l)] 'goto-line)
(global-set-key [(hyper w)]
                (lambda () (interactive) (delete-window)))
(global-set-key [(hyper z)] 'undo)

;; mac switch meta key
(defun mac-switch-meta nil
  "switch meta between Option and Command"
  (interactive)
  (if (eq mac-option-modifier nil)
      (progn
	(setq mac-option-modifier 'meta)
	(setq mac-command-modifier 'hyper)
	)
    (progn
      (setq mac-option-modifier nil)
      (setq mac-command-modifier 'meta)
      )
    )
  )

;; Increase undo history limits even more
(after! undo-fu
  ;; Emacs undo defaults
  (setq undo-limit        10000000    ;; 1MB   (default is 160kB, Doom's default is 400kB)
        undo-strong-limit 100000000   ;; 100MB (default is 240kB, Doom's default is 3MB)
        undo-outer-limit  1000000000) ;; 1GB   (default is 24MB,  Doom's default is 48MB)

  ;; Undo-fu customization options
  (setq undo-fu-allow-undo-in-region t ;; Undoing with a selection will use undo within that region.
        undo-fu-ignore-keyboard-quit t)) ;; Use the `undo-fu-disable-checkpoint' command instead of Ctrl-G `keyboard-quit' for non-linear behavior.

;; Evil undo
(after! evil
  (setq evil-want-fine-undo t)) ;; By default while in insert all changes are one big blob

(use-package! vundo
  :defer t
  :init
  (defconst +vundo-unicode-symbols
   '((selected-node   . ?●)
     (node            . ?○)
     (vertical-stem   . ?│)
     (branch          . ?├)
     (last-branch     . ?╰)
     (horizontal-stem . ?─)))

  (map! :leader
        (:prefix ("o")
         :desc "vundo" "v" #'vundo))

  :config
  (setq vundo-glyph-alist +vundo-unicode-symbols
        vundo-compact-display t
        vundo-window-max-height 6))

(use-package! aggressive-indent
  :commands (aggressive-indent-mode))

(map!
 :map smartparens-mode-map
 :leader (:prefix ("l" . "Lisps")
          :nvie "f" #'sp-forward-sexp
          :nvie "b" #'sp-backward-sexp
          :nvim "u" #'sp-unwrap-sexp
          :nie "k" #'sp-kill-sexp
          :nie "s" #'sp-split-sexp
          :nie "(" #'sp-wrap-round
          :nie "[" #'sp-wrap-square
          :nie "{" #'sp-wrap-curly))

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun dt/insert-auto-tangle-tag ()
  "Insert auto-tangle tag in a literate config."
  (interactive)
  (evil-org-open-below 1)
  (insert "#+auto_tangle: t ")
  (evil-force-normal-state))

(map! :leader
      :desc "Insert auto_tangle tag" "i a" #'dt/insert-auto-tangle-tag)

(use-package! evil-escape
  :config
  (setq evil-esc-delay 0.25))

(use-package! evil-vimish-fold
  :config
  (global-evil-vimish-fold-mode))

(use-package! evil-goggles
  :init
  (setq evil-goggles-enable-change t
        evil-goggles-enable-delete t
        evil-goggles-pulse         t
        evil-goggles-duration      0.15)
  :config
  (custom-set-faces!
    `((evil-goggles-yank-face evil-goggles-surround-face)
      :background ,(doom-blend (doom-color 'blue) (doom-color 'bg-alt) 0.5)
      :extend t)
    `(evil-goggles-paste-face
      :background ,(doom-blend (doom-color 'green) (doom-color 'bg-alt) 0.5)
      :extend t)
    `(evil-goggles-delete-face
      :background ,(doom-blend (doom-color 'red) (doom-color 'bg-alt) 0.5)
      :extend t)
    `(evil-goggles-change-face
      :background ,(doom-blend (doom-color 'orange) (doom-color 'bg-alt) 0.5)
      :extend t)
    `(evil-goggles-commentary-face
      :background ,(doom-blend (doom-color 'grey) (doom-color 'bg-alt) 0.5)
      :extend t)
    `((evil-goggles-indent-face evil-goggles-join-face evil-goggles-shift-face)
      :background ,(doom-blend (doom-color 'yellow) (doom-color 'bg-alt) 0.25)
      :extend t)
    ))

(map! :map evil-window-map
      "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

(setq evil-vsplit-window-right t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))


(after! evil
  (setq evil-ex-substitute-global t     ; I like my s/../.. to by global by default
        evil-move-cursor-back nil       ; Don't move the block cursor when toggling insert mode
        evil-kill-on-visual-paste nil)) ; Don't put overwritten text in the kill ring

(setq which-key-allow-multiple-replacements t
      which-key-idle-delay 0.5) ;; I need the help, I really do

(setq which-key-allow-multiple-replacements t)
(after! which-key
  (pushnew!
   which-key-replacement-alist
   '(("" . "\\`+?evil[-:]?\\(?:a-\\)?\\(.*\\)") . (nil . "◂\\1"))
   '(("\\`g s" . "\\`evilem--?motion-\\(.*\\)") . (nil . "◃\\1"))
   ))

(require 'org-protocol)
(after! org
    ;; Rougier GTD
    (setq org-directory "~/Documents/org/")
    ;; (setq org-agenda-files (list "inbox.org" "agenda.org"))
    (setq org-agenda-files
        (mapcar 'file-truename
            (file-expand-wildcards "~/Documents/org/*.org")))
    ;; Save the corresponding buffers
    (defun gtd-save-org-buffers ()
    "Save `org-agenda-files' buffers without user confirmation.
    See also `org-save-all-org-buffers'"
    (interactive)
    (message "Saving org-agenda-files buffers...")
    (save-some-buffers t (lambda ()
                (when (member (buffer-file-name) org-agenda-files)
                t)))
    (message "Saving org-agenda-files buffers... done"))

    ;; Add it after refile
    (advice-add 'org-refile :after
            (lambda (&rest _)
            (gtd-save-org-buffers)))

    (setq org-capture-templates
        `(("i" "Inbox" entry  (file "inbox.org")
            ,"* TODO %?")
            ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
            ,"* %? :meeting:")
            ("n" "Note" entry  (file "notes.org")
            ,(concat "* Note (%a)\n"
                    "%?"))))

    (define-key global-map (kbd "C-c c") 'org-capture)
    (defun org-capture-inbox ()
        (interactive)
        (call-interactively 'org-store-link)
        (org-capture nil "i"))

    (define-key global-map (kbd "C-c i") 'org-capture-inbox)
    (define-key global-map (kbd "C-c a") 'org-agenda)

    (setq org-agenda-hide-tags-regexp ".")
    (setq org-agenda-prefix-format
        '((agenda . " %i %-12:c%?-12t% s")
            (todo   . " ")
            (tags   . " %i %-12:c")
            (search . " %i %-12:c")))
    (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)")))

    ;; Refile
    (setq org-refile-use-outline-path 'file)
    (setq org-outline-path-complete-in-steps nil)
    (setq org-refile-targets
        '(("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))


    (setq org-agenda-custom-commands
        '(("g" "Get Things Done (GTD)"
            ((agenda ""
                    ((org-agenda-skip-function
                        '(org-agenda-skip-entry-if 'deadline))
                    (org-deadline-warning-days 0)))
            (todo "NEXT"
                    ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                    (org-agenda-prefix-format "  %i %-12:c [%e] ")
                    (org-agenda-overriding-header "\nTasks\n")))
            (agenda nil
                    ((org-agenda-entry-types '(:deadline))
                    (org-agenda-format-date "")
                    (org-deadline-warning-days 7)
                    (org-agenda-skip-function
                        '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                    (org-agenda-overriding-header "\nDeadlines")))
            (tags-todo "inbox"
                        ((org-agenda-prefix-format "  %?-12t% s")
                        (org-agenda-overriding-header "\nInbox\n")))
            (tags "CLOSED>=\"<today>\""
                    ((org-agenda-overriding-header "\nCompleted today\n")))))))

    (setq org-modules (quote (org-protocol)))
    )

;;
;; (use-package! org-super-agenda
;;   :after org-agenda
;;   :init
;;   (setq org-super-agenda-groups '((:name "Today"
;;                                   :time-grid t
;;                                   :scheduled today)
;;                            (:name "Due today"
;;                                   :deadline today)
;;                            (:name "Important"
;;                                   :priority "A")
;;                            (:name "Overdue"
;;                                   :deadline past)
;;                            (:name "Due soon"
;;                                   :deadline future)
;;                            (:name "Big Outcomes"
;;                                   :tag "bo")))
;;   :config
;;   (org-super-agenda-mode)
;; )

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("S-<tab>" . 'copilot-accept-completion)
              ("S-TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(customize-set-variable 'copilot-enable-predicates '(evil-insert-state-p))

(use-package! gptel
 :config
 (setq! gptel-api-key "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"))

;; https://github.com/alexluigit/dirvish

;;; ../dotfiles/emacs/.doom.d/+dirvish.el -*- lexical-binding: t; -*-


;; https://github.com/alexluigit/dirvish
(use-package! dirvish
  :config
  (setq dired-kill-when-opening-new-dired-buffer t) ; added in emacs 28
  (setq dired-clean-confirm-killing-deleted-buffers nil)
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq dired-dwim-target t)
  (setq dirvish-use-header-line nil)     ; hide header line (show the classic dired header)
  ;; (setq dired-listing-switches
  ;;       "-AGhlv --group-directories-first --sort=time")
  (setq dirvish-hide-details t) ;; toggleable via dirvish-dispatch `? ('
  (setq dired-omit-files nil) ;; don't hide any files
  (setq delete-by-moving-to-trash t)
  (setq dired-listing-switches
        "-l --almost-all --human-readable --group-directories-first --no-group")

  (map! :map dirvish-mode-map
        :n "b" #'dirvish-goto-bookmark
        :n "z" #'dirvish-show-history
        :n "f" #'dirvish-file-info-menu
        :n "F" #'dirvish-toggle-fullscreen
        :n "l" #'dired-find-file
        :n "h" #'dired-up-directory
        :n "?" #'dirvish-dispatch
        :localleader
        "h" #'dired-omit-mode))

;; in case you want to keep the +all flag in the popup
(set-popup-rule! "^ \\*Dirvish.*" :ignore t)
;; pdf previewr
(setq dirvish-preview-dispatchers
      (cl-substitute 'pdf-preface 'pdf dirvish-preview-dispatchers))

(use-package pdf-view
  :hook (pdf-tools-enabled . pdf-view-midnight-minor-mode)
  :hook (pdf-tools-enabled . hide-mode-line-mode)
  :config
  (setq pdf-view-midnight-colors '("#ABB2BF" . "#282C35"))
  (setq-default pdf-view-display-size 'fit-page)
  (setq pdf-view-use-scaling t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dired
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package! dired
  :config
  (when (string= system-type "darwin")
    (setq dired-use-ls-dired nil))
  (enable-command 'dired-find-alternate-file)
  (map!
   ;; :n "-" #'dired-jump
   :n "-" #'dirvish
   :map dired-mode-map
   :n "-"        #'dired-up-directory
   :n "<return>" #'dired-find-alternate-file
   :n "/"        #'dired
   :n "q"        (cmd! (quit-window t))))

(use-package moody
  ;; :ensure t
  :config
  (setq x-underline-at-descent-line t)
  (setq-default mode-line-format
                '(" "
                  mode-line-front-space
                  mode-line-client
                  mode-line-frame-identification
                  mode-line-buffer-identification " " mode-line-position
                  (vc-mode vc-mode)
                  (multiple-cursors-mode mc/mode-line)
                  " " mode-line-modes
                  mode-line-end-spaces))

  (use-package minions
    ;; :ensure t
    :config
    (minions-mode +1))

  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)

  (setq-default x-underline-at-descent-line t
                column-number-mode t))

(setq vterm-always-compile-module t)
(setq vterm-kill-buffer-on-exit t)

(after! vterm
  (setf (alist-get "magit-status" vterm-eval-cmds nil nil #'equal)
        '((lambda (path)
            (magit-status path)))))

(setq +ligatures-in-modes t)

(after! vertico
  ;; settings
  (setq vertico-resize nil        ; How to resize the Vertico minibuffer window.
        vertico-count 17          ; Maximal number of candidates to show.
        vertico-count-format nil) ; No prefix with number of entries

  ;; looks
  (setq vertico-grid-separator
        #("  |  " 2 3 (display (space :width (1))
                               face (:background "#ECEFF1")))
        vertico-group-format
        (concat #(" " 0 1 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator))
                #(" %s " 0 4 (face vertico-group-title))
                #(" " 0 1 (face vertico-group-separator
                            display (space :align-to (- right (-1 . right-margin) (- +1)))))))
  (set-face-attribute 'vertico-group-separator nil
                      :strike-through t)

  ;; minibuffer tweaks
  (defun my/vertico--resize-window (height)
    "Resize active minibuffer window to HEIGHT."
      (setq-local truncate-lines t
                  resize-mini-windows 'grow-only
                  max-mini-window-height 1.0)
    (unless (frame-root-window-p (active-minibuffer-window))
      (unless vertico-resize
        (setq height (max height vertico-count)))
      (let* ((window-resize-pixelwise t)
             (dp (- (max (cdr (window-text-pixel-size))
                         (* (default-line-height) (1+ height)))
                    (window-pixel-height))))
        (when (or (and (> dp 0) (/= height 0))
                  (and (< dp 0) (eq vertico-resize t)))
          (window-resize nil dp nil nil 'pixelwise)))))

  (advice-add #'vertico--resize-window :override #'my/vertico--resize-window)

  ;; completion at point
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args)))
  (defun minibuffer-format-candidate (orig cand prefix suffix index _start)
    (let ((prefix (if (= vertico--index index)
                      "  "
                    "   ")))
      (funcall orig cand prefix suffix index _start)))
  (advice-add #'vertico--format-candidate
             :around #'minibuffer-format-candidate)
  (defun vertico--prompt-selection ()
    "Highlight the prompt"

    (let ((inhibit-modification-hooks t))
      (set-text-properties (minibuffer-prompt-end) (point-max)
                           '(face (nano-strong nano-salient)))))
  (defun minibuffer-vertico-setup ()
    (setq truncate-lines t)
    (setq completion-in-region-function
          (if vertico-mode
              #'consult-completion-in-region
            #'completion--in-region)))

  (add-hook 'vertico-mode-hook #'minibuffer-vertico-setup)
  (add-hook 'minibuffer-setup-hook #'minibuffer-vertico-setup))

(after! marginalia
  (setq marginalia-censor-variables nil)

  (defadvice! +marginalia--anotate-local-file-colorful (cand)
    "Just a more colourful version of `marginalia--anotate-local-file'."
    :override #'marginalia--annotate-local-file
    (when-let (attrs (file-attributes (substitute-in-file-name
                                       (marginalia--full-candidate cand))
                                      'integer))
      (marginalia--fields
       ((marginalia--file-owner attrs)
        :width 12 :face 'marginalia-file-owner)
       ((marginalia--file-modes attrs))
       ((+marginalia-file-size-colorful (file-attribute-size attrs))
        :width 7)
       ((+marginalia--time-colorful (file-attribute-modification-time attrs))
        :width 12))))

  (defun +marginalia--time-colorful (time)
    (let* ((seconds (float-time (time-subtract (current-time) time)))
           (color (doom-blend
                   (face-attribute 'marginalia-date :foreground nil t)
                   (face-attribute 'marginalia-documentation :foreground nil t)
                   (/ 1.0 (log (+ 3 (/ (+ 1 seconds) 345600.0)))))))
      ;; 1 - log(3 + 1/(days + 1)) % grey
      (propertize (marginalia--time time) 'face (list :foreground color))))

  (defun +marginalia-file-size-colorful (size)
    (let* ((size-index (/ (log10 (+ 1 size)) 7.0))
           (color (if (< size-index 10000000) ; 10m
                      (doom-blend 'orange 'green size-index)
                    (doom-blend 'red 'orange (- size-index 1)))))
      (propertize (file-size-human-readable size) 'face (list :foreground color)))))

(after! marginalia
  (setq marginalia--ellipsis "…"    ; Nicer ellipsis
        marginalia-align 'right     ; right alignment
        marginalia-align-offset -1)) ; one space on the right

(setq bookmark-default-file "~/.config/doom/bookmarks")

(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks"                          "L" #'list-bookmarks
       :desc "Set bookmark"                            "m" #'bookmark-set
       :desc "Delete bookmark"                         "M" #'bookmark-set
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(evil-define-key 'normal ibuffer-mode-map
  (kbd "f c") 'ibuffer-filter-by-content
  (kbd "f d") 'ibuffer-filter-by-directory
  (kbd "f f") 'ibuffer-filter-by-filename
  (kbd "f m") 'ibuffer-filter-by-mode
  (kbd "f n") 'ibuffer-filter-by-name
  (kbd "f x") 'ibuffer-filter-disable
  (kbd "g h") 'ibuffer-do-kill-lines
  (kbd "g H") 'ibuffer-update)

(after! org
  (setq org-startup-with-inline-images t)
  (add-hook 'org-babel-after-execute-hook 'clear-image-cache)
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
  (setq-local org-image-actual-width '(512))
  (setq org-src-window-setup 'current-window))


(evil-define-command +evil-buffer-org-new (count file)
  "Creates a new ORG buffer replacing the current window, optionally
   editing a certain FILE"
  :repeat nil
  (interactive "P<f>")
  (if file
      (evil-edit file)
    (let ((buffer (generate-new-buffer "*new org*")))
      (set-window-buffer nil buffer)
      (with-current-buffer buffer
        (org-mode)
        (setq-local doom-real-buffer-p t)))))

(map! :leader
      (:prefix "b"
       :desc "New empty Org buffer" "o" #'+evil-buffer-org-new))

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
         (intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
         (let ((file-name (->> info caddr (alist-get :file))))
           (unless file-name
             (setq file-name (make-temp-file "babel-lsp-")))
           (setq buffer-file-name file-name)
           (lsp-deferred)))
       (put ',intern-pre 'function-documentation
            (format "Enable lsp-mode in the buffer of org source block (%s)."
                    (upcase ,lang)))
       (if (fboundp ',edit-pre)
           (advice-add ',edit-pre :after ',intern-pre)
         (progn
           (defun ,edit-pre (info)
             (,intern-pre info))
           (put ',edit-pre 'function-documentation
                (format "Prepare local buffer environment for org source block (%s)."
                        (upcase ,lang))))))))

(defvar org-babel-lang-list
  '("go" "python" "ipython" "jupyter" "bash" "sh"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))

(setq eros-eval-result-prefix "⟹ ")

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-list '((43 . "➤")
                          (45 . "–")
                          (42 . "•"))
        org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo)
          ("PROJ" :inverse-video t :inherit +org-todo-project)
          ("STRT" :inverse-video t :inherit +org-todo-active)
          ("[-]"  :inverse-video t :inherit +org-todo-active)
          ("HOLD" :inverse-video t :inherit +org-todo-onhold)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold)
          ("[?]"  :inverse-video t :inherit +org-todo-onhold)
          ("KILL" :inverse-video t :inherit +org-todo-cancel)
          ("NO"   :inverse-video t :inherit +org-todo-cancel))
        org-modern-footnote
        (cons nil (cadr org-script-display))
        org-modern-block-fringe nil
        org-modern-block-name
        '((t . t)
          ("src" "»" "«")
          ("example" "»–" "–«")
          ("quote" "❝" "❞")
          ("export" "⏩" "⏪"))
        org-modern-progress nil
        org-modern-priority nil
        org-modern-horizontal-rule (make-string 36 ?─)
        org-modern-keyword
        '((t . t)
          ("title" . "𝙏")
          ("subtitle" . "𝙩")
          ("author" . "𝘼")
          ("email" . #("" 0 1 (display (raise -0.14))))
          ("date" . "𝘿")
          ("property" . "☸")
          ("options" . "⌥")
          ("startup" . "⏻")
          ("macro" . "𝓜")
          ("bind" . #("" 0 1 (display (raise -0.1))))
          ("bibliography" . "")
          ("print_bibliography" . #("" 0 1 (display (raise -0.1))))
          ("cite_export" . "⮭")
          ("print_glossary" . #("ᴬᶻ" 0 1 (display (raise -0.1))))
          ("glossary_sources" . #("" 0 1 (display (raise -0.14))))
          ("include" . "⇤")
          ("setupfile" . "⇚")
          ("html_head" . "🅷")
          ("html" . "🅗")
          ("latex_class" . "🄻")
          ("latex_class_options" . #("🄻" 1 2 (display (raise -0.14))))
          ("latex_header" . "🅻")
          ("latex_header_extra" . "🅻⁺")
          ("latex" . "🅛")
          ("beamer_theme" . "🄱")
          ("beamer_color_theme" . #("🄱" 1 2 (display (raise -0.12))))
          ("beamer_font_theme" . "🄱𝐀")
          ("beamer_header" . "🅱")
          ("beamer" . "🅑")
          ("attr_latex" . "🄛")
          ("attr_html" . "🄗")
          ("attr_org" . "⒪")
          ("call" . #("" 0 1 (display (raise -0.15))))
          ("name" . "⁍")
          ("header" . "›")
          ("caption" . "☰")
          ("results" . "🠶")))
  (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo)))

(defvar +org-responsive-image-percentage 0.4)
(defvar +org-responsive-image-width-limits '(400 . 700)) ;; '(min-width . max-width)

(defun +org--responsive-image-h ()
  (when (eq major-mode 'org-mode)
    (setq org-image-actual-width
          (max (car +org-responsive-image-width-limits)
               (min (cdr +org-responsive-image-width-limits)
                    (truncate (* (window-pixel-width) +org-responsive-image-percentage)))))))

(add-hook 'window-configuration-change-hook #'+org--responsive-image-h)

(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-autolinks nil)
  ;; for proper first-time setup, `org-appear--set-elements'
  ;; needs to be run after other hooks have acted.
  (run-at-time nil nil #'org-appear--set-elements))

(add-hook 'org-mode-hook #'+org-pretty-mode)

(custom-set-faces!
  '(org-document-title :height 1.2))

(custom-set-faces!
  '(outline-1 :weight extra-bold :height 1.25)
  '(outline-2 :weight bold :height 1.15)
  '(outline-3 :weight bold :height 1.12)
  '(outline-4 :weight semi-bold :height 1.09)
  '(outline-5 :weight semi-bold :height 1.06)
  '(outline-6 :weight semi-bold :height 1.03)
  '(outline-8 :weight semi-bold)
  '(outline-9 :weight semi-bold))

(setq org-agenda-deadline-faces
      '((1.001 . error)
        (1.0 . org-warning)
        (0.5 . org-upcoming-deadline)
        (0.0 . org-upcoming-distant-deadline)))

(setq org-fontify-quote-and-verse-blocks t)

(defun locally-defer-font-lock ()
  "Set jit-lock defer and stealth, when buffer is over a certain size."
  (when (> (buffer-size) 50000)
    (setq-local jit-lock-defer-time 0.05
                jit-lock-stealth-time 1)))

(add-hook 'org-mode-hook #'locally-defer-font-lock)

(setq org-ellipsis " ▾ "
      org-hide-leading-stars t
      org-priority-highest ?A
      org-priority-lowest ?E
      org-priority-faces
      '((?A . 'all-the-icons-red)
        (?B . 'all-the-icons-orange)
        (?C . 'all-the-icons-yellow)
        (?D . 'all-the-icons-green)
        (?E . 'all-the-icons-blue)))

(add-hook! 'latex-mode-hook
  (setq-local line-spacing 0.35))

(setq
 ;; Dont auto-insert braces on _^, I have keybinds for that
 TeX-electric-sub-and-superscript nil
 ;; Do cache: I have relatively long compilation times
 preview-auto-cache-preamble t
 ;; Don't raise/lower super/subscripts
 font-latex-fontify-script nil)
(setq TeX-save-query nil
      TeX-show-compilation nil
      TeX-command-extra-options "-shell-escape")
(after! latex
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1%(mode)%' %t" TeX-run-TeX nil t))
  )
(setq +latex-viewers '(sioyek pdf-tools evince zathura okular skim sumatrapdf))
(setq TeX-source-correlate-method 'synctex) ;
(setq TeX-source-correlate-mode t)
;; (setq preview-image-type 'dvisvgm)
(TeX-fold-mode 1)
(setq TeX-auto-save t) ;enable autosave on during LaTeX-mode
(setq TeX-parse-self t) ; enable autoparsing
(setq TeX-output-dir "output")

(setq TeX-view-program-list
      '(("Sioyek"
        ("sioyek %o --reuse-window"
         (mode-io-correlate " --forward-search-file %b --forward-search-line %n --inverse-search \"emacsclient --no-wait +%2:%3 %1\""))
        "sioyek"))
      TeX-view-program-selection
      '(((output-dvi has-no-display-manager)
         "dvi2tty")
        ((output-dvi style-pstricks)
         "dvips and gv")
        (output-dvi "xdvi")
        (output-pdf "Sioyek")
        (output-html "xdg-open"))
      +latex-viewers '(sioyek))

(add-to-list 'TeX-view-program-selection
               '(output-pdf "Sioyek"))
(add-hook 'LaTeX-mode-hook #'TeX-source-correlate-mode)

(with-eval-after-load 'latex
  (define-key TeX-source-correlate-map [C-down-mouse-1] #'TeX-view-mouse))

(defadvice! prvt/dont-fold-brackets (start)
  :override #'TeX-find-macro-end-helper
  "Dont consider brackets proceeding a macro as its arguments. Described here:
URL `https://tex.stackexchange.com/questions/188287/auctex-folding-and-square-brackets-in-math-mode'"
  ;; Here I just copied over the definition of `TeX-find-macro-end-helper' and
  ;; deleted the bracket branch of the cond.
  (save-excursion
    (save-match-data
      (catch 'found
        (goto-char (1+ start))
        (if (zerop (skip-chars-forward "A-Za-z@"))
            (forward-char)
          (skip-chars-forward "*"))
        (while (not (eobp))
          (cond
           ;; DONT Skip over pairs of square brackets
           ;; Skip over pairs of curly braces
           ((or (looking-at "[ \t]*\n?{") ; Be conservative: Consider
                                        ; only consecutive lines.
                (and (looking-at (concat "[ \t]*" TeX-comment-start-regexp))
                     (save-excursion
                       (forward-line 1)
                       (looking-at "[ \t]*{"))))
            (goto-char (match-end 0))
            (goto-char (or (TeX-find-closing-brace)
                           ;; If we cannot find a regular end, use the
                           ;; next whitespace.
                           (save-excursion (skip-chars-forward "^ \t\n")
                                           (point)))))
           (t
            (throw 'found (point)))))
        ;; Make sure that this function does not return nil, even
        ;; when the above `while' loop is totally skipped. (bug#35638)
        (throw 'found (point))))))

;;; Aesthetics
(setq
 TeX-fold-math-spec-list
 `( ;; missing symbols
   ("≤" ("le"))
   ("≥" ("ge"))
   ("≠" ("ne"))
   ("‘{1}’" ("text"))
   ;; conviniance shorts
   ("‹" ("left"))
   ("›" ("right"))
   ("¡{1}" ("mathclap"))
   ("👻{1}" ("phantom"))
   ("⟋{1}" ("cancel"))
   ("␣" ("textvisiblespace"))
   ;; private macros
   ("ℝ" ("RR"))
   ("𝔼" ("EX"))
   ("ℕ" ("NN"))
   ("Nₑ" ("NE"))
   ("Nₒ" ("NO"))

   ("ℚ" ("QQ"))
   ("ℤ" ("ZZ"))
   ("ℂ" ("CC"))
   ("𝔽" ("FF"))
   ("𝓣" ("TT"))
   ("ℝ→ℝ" ("rtr"))
   ("I→ℝ" ("itr"))
   ("½" ("halff"))
   ("({1})" ("pa"))
   ("({1}]" ("pba"))
   ("[{1})" ("bpa"))
   ("[{1}]" ("bra"))
   ;; ("|{1}|" ("abs")) ; collides with the auto snippets and kicks me out
   ("❴{1}❵" ("bre" "set")) ; explicitly using bold unicode braces
   ("⌊{1}⌋" ("floor"))
   ("⌈{1}⌉" ("ceil"))
   ("‖{1}‖" ("norm"))
   ("❬{1}❭" ("anb")) ; explititly using narrower unicode angle brackets

   ;; fancification
   ("{1}" ("mathrm"))
   (,(lambda (word) (string-offset-roman-chars 119743 word)) ("mathbf"))
   (,(lambda (word) (string-offset-roman-chars 119951 word)) ("mathcal"))
   (,(lambda (word) (string-offset-roman-chars 120003 word)) ("mathfrak"))
   (,(lambda (word) (string-offset-roman-chars 120055 word)) ("mathbb"))
   (,(lambda (word) (string-offset-roman-chars 120159 word)) ("mathsf"))
   (,(lambda (word) (string-offset-roman-chars 120367 word)) ("mathtt"))
   )
 TeX-fold-macro-spec-list ; thanks to @tecosaur
 '( ;; as the defaults
   ("[f]" ("footnote" "marginpar"))
   ("[c]" ("cite"))
   ("[l]" ("label"))
   ("[r]" ("ref" "pageref" "eqref"))
   ("[i]" ("index" "glossary"))
   ("..." ("dots"))
   ("{1}" ("emph" "textit" "textsl" "textmd" "textrm" "textsf" "texttt"
           "textbf" "textsc" "textup"))
   ;; tweaked defaults
   ("©" ("copyright"))
   ("®" ("textregistered"))
   ("™"  ("texttrademark"))
   ("[1]:||•" ("item"))
   ("❡ {1}" ("chapter" "chapter*"))
   ("❡❡ {1}" ("part" "part*"))
   ("§ {1}" ("section" "section*"))
   ("§§ {1}" ("subsection" "subsection*"))
   ("§§§ {1}" ("subsubsection" "subsubsection*"))
   ("¶ {1}" ("paragraph" "paragraph*"))
   ("¶¶ {1}" ("subparagraph" "subparagraph*"))
   ))

;; Kindly borrowed from @tecosaur
(defun string-offset-roman-chars (offset word)
  "Shift the codepoint of each charachter in WORD by OFFSET with an extra -6 shift if the letter is lowercase"
  (apply 'string
         (mapcar (lambda (c) (+ (if (>= c 97) (- c 6) c) offset)) word)))


(defun +latex/dwim-at-point ()
  "TODO."
  (interactive)
  (let (preview-revealed? preview-unrevealed? tex-fold?)
    (dolist (ol (overlays-at (point)))
      ;; (message "%s %s" ol (overlay-get ol 'category))
      (pcase (overlay-get ol 'category)
        ('preview-overlay
         (if (overlay-get ol 'display)
             (setq preview-unrevealed? ol)
           (setq preview-revealed? ol)))
        ('TeX-fold
         (setq tex-fold? ol))))
    (cond
     (preview-unrevealed?
      (preview-toggle preview-unrevealed? nil))
     (tex-fold?
      (TeX-fold-show-item tex-fold?))
     ((or preview-revealed? (texmathp))
      (preview-at-point)))))


;; Making \( \) less visible
(defface unimportant-latex-face
  '((t
     :inherit font-lock-comment-face))
  "Face used to make \\(\\), \\=\\[\\] less visible."
  :group 'LaTeX-math)

(font-lock-add-keywords
 'latex-mode
 `((,(rx "\\" (any "()[]")) 0 'unimportant-latex-face prepend))
 'end)

;; Fontify anything that looks like a TeX macro, not limited to known commands
;; FIXME this also fontifies tex macros in comments, hadn't found a solution yet
(font-lock-add-keywords
 'latex-mode
 `(("\\\\[A-Za-z@*]+" 0 'font-lock-keyword-face prepend))
 'end)

(add-hook! 'doom-load-theme-hook
  (custom-set-faces!
    ;; On default, 1-depth braces don't stand out in LaTeX math
    `(rainbow-delimiters-depth-1-face :foreground nil :inherit rainbow-delimiters-depth-6-face)
    ;; Just configured for the theme:
    `(preview-face :background ,(doom-color 'base1))
    `(font-latex-doctex-documentation-face :background ,(doom-color 'base2))
    `(TeX-fold-folded-face :inherit font-lock-builtin-face)
    `(TeX-fold-unfolded-face
      ;; This should stand out from hl-line
      :background ,(doom-blend (doom-color 'base4) (doom-color 'bg) 0.3))))

;; Bigger compiled math cause it's pretty
(after! preview
  (setq-default preview-scale 1.65)
  (setq preview-scale 1.65))

;; Completion is 100% annoying me here, adds tons of lag and gives
;; terrible suggestions
(after! company
  (cl-callf nconc company-global-modes (list 'latex-mode)))
(add-hook! 'TeX-mode-hook
           ;;(hl-todo-mode) ; TODO
           ;; Flycheck with both chktex and lacheck both just bother me with
           ;; worthless advice all the time. when my HW doesn't compile I'll re-
           ;; enable them.
           (flycheck-mode -1))

;;;;;;;;;;;;;;;; yoav
(add-hook! 'doom-load-theme-hook
  (custom-set-faces!
    ;; On default, 1-depth braces don't stand out in LaTeX math
    `(rainbow-delimiters-depth-1-face :foreground nil :inherit rainbow-delimiters-depth-6-face)
    ;; Just configured for the theme:
    `(preview-face :background ,(doom-color 'base1))
    `(font-latex-doctex-documentation-face :background ,(doom-color 'base2))
    `(TeX-fold-folded-face :inherit font-lock-builtin-face)
    `(TeX-fold-unfolded-face
      ;; This should stand out from hl-line
      :background ,(doom-blend (doom-color 'base4) (doom-color 'bg) 0.3))))

;; Bigger compiled math cause it's pretty
(after! preview
  (setq-default preview-scale 1.3)
  (setq preview-scale 1.3))

(after! company
  (cl-callf nconc company-global-modes (list 'latex-mode)))
(add-hook! 'TeX-mode-hook
           ;;(hl-todo-mode) ; TODO
           ;; Flycheck with both chktex and lacheck both just bother me with
           ;; worthless advice all the time. when my HW doesn't compile I'll re-
           ;; enable them.
           (flycheck-mode -1))

;; (map! :map cdlatex-mode-map :i "TAB" #'cdlatex-tab)
(after! cdlatex
  (setq cdlatex-use-dollar-to-ensure-math t)
  (map! :map cdlatex-mode-map
        :i "TAB" #'cdlatex-tab))

(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(defadvice! org-edit-latex-emv-after-insert ()
  :after #'org-cdlatex-environment-indent
  (org-edit-latex-environment))

(setq yas-triggers-in-field t)
(use-package! laas
  :hook (LaTeX-mode . laas-mode)
  :config
  ;; no space after expansions
  (setq laas-enable-auto-space nil)
  (after! tex-fold
    (add-hook! 'laas-mode-hook
      (add-hook! 'aas-post-snippet-expand-hook :local
        (when (and TeX-fold-mode (not (eq (char-after) ?})))
          (+latex-fold-last-macro-a)))))
  (defun +aas-expand-snippet-fn (&optional parens func)
    (interactive)
    (yas-expand-snippet (format "%s%s${1:?}%s$0"
                                (or func (concat "\\" aas-transient-snippet-key))
                                (or (car parens) "(")
                                (or (cdr parens) ")")))
    (laas--shut-up-smartparens))
  (defun +aas-expand-snippet-latex-fn (&optional func)
    (interactive)
    (+aas-expand-snippet-fn '("{" . "}") func))
  (defun +aas-with-spacing (x)
    (when (/= (char-before) ?\ )
      (insert " "))
    (insert x)
    (insert " "))

  ;; define b( -> \left(\right) for many delimiters
  (defun +aas-wrap-delims (l r)
    (yas-expand-snippet (format "\\left%s $1 \\right%s" l r))
    (laas--shut-up-smartparens))
  (apply #'aas-set-snippets 'laas-mode
         :cond #'texmathp
         (cl-loop for (key l r) in
                  '(("("  "("        ")")
                    ("["  "["        "]")
                    ("{"  "\\{"      "\\}")
                    ("<"  "\\langle" "\\rangle")
                    ("|"  "\\lvert"  "\\rvert")
                    ("d|" "\\lVert"  "\\rVert"))
                  collect (format "b%s" key)
                  collect (let ((l l) (r r))
                            (cmd! (+aas-wrap-delims l r)))))
  (aas-set-snippets
      'laas-mode
    ;; easy question number insertion using sections
    :cond (lambda () (and (bolp) (not (texmathp))))
    "aho" (cmd! (doom-snippets-expand :uuid "empty-section"))
    "qho" (cmd! (doom-snippets-expand :uuid "empty-subsection"))
    ;; usual math stuff
    :cond #'laas-object-on-left-condition
    "pn" "^n"
    :cond #'texmathp
    ;; not sure if this should be mainline
    "abs" #'+aas-expand-snippet-latex-fn
    "ivs" "^{-1}"
    "conj" "^*"
    "td" (cmd! (+aas-expand-snippet-latex-fn "^"))
    "sb" (cmd! (+aas-expand-snippet-latex-fn "_"))
    "opr" (cmd! (+aas-expand-snippet-latex-fn "\\operatorname"))
    "qq" (cmd! (+aas-expand-snippet-latex-fn "\\sqrt"))
    "bon" "\\{0,1\\}"
    "conj" "^*"
    "|^" "\\uparrow"
    "|v" "\\downarrow"
    ;; used for applying inveresed function f^{-1}()
    "ivh" (cmd! (yas-expand-snippet "^{-1}($1)$0") (laas--shut-up-smartparens))
    "Span" (cmd! (+aas-expand-snippet-fn '("\\left( " . " \\right)")))
    ;; Probability
    ;;"Ber" #'+aas-expand-snippet-fn
    ;;"Bin" #'+aas-expand-snippet-fn
    ;;"Cov" #'+aas-expand-snippet-fn
    "EX" (cmd! (+aas-expand-snippet-fn '("[" . "]")))
    "exx" "e^x"
    "Geom" #'+aas-expand-snippet-fn
    "HyperGeom" #'+aas-expand-snippet-fn
    "NB" #'+aas-expand-snippet-fn
    "Poi" #'+aas-expand-snippet-fn
    "Rank" #'+aas-expand-snippet-fn
    "Uniform" #'+aas-expand-snippet-fn
    "Var" #'+aas-expand-snippet-fn
    "Cov" #'+aas-expand-snippet-fn
    "std" #'+aas-expand-snippet-fn
    "supp" "\\supp"
    ;; Complexity
    "On" "O(n)"
    "O1" "O(1)"
    "Olog" "O(\\log n)"
    "Olon" "O(n \\log n)"
    "emx" "e^{-x}"
    ;; Algorithms
    "Oe" "O(|E|)"
    "Ove" "O(|V|+|E|)"
    ;; Topology
    "norm" #'+aas-expand-snippet-latex-fn
    "TT" "\\TT"
    "BB" "\\mathcal{B}"
    ;;"CC" "\\mathcal{C}"
    ;; Logic
    "VBA" "\\overbar{v}(A)"
    "VBB" "\\overbar{v}(B)"
    "UBB" "\\overbar{u}(B)"
    "UBB" "\\overbar{u}(B)"
    ;; Info
    "Ane" "A_{n,\\epsilon}"
    ;; Crypto
    "~te" "\\approx_{T,\\epsilon}"
    ;; Complex Analysis
    "par" (cmd! (yas-expand-snippet "\\frac{\\partial $1}{\\partial $2}$0")
                (laas--shut-up-smartparens))
    ;; I usually have auto space off but it's conveniant in these
    "inn" (cmd! (+aas-with-spacing "\\in"))
    "notin" (cmd! (+aas-with-spacing "\\not\\in"))
    "subs" (cmd! (+aas-with-spacing "\\subseteq"))
    "->" (cmd! (+aas-with-spacing "\\to"))
    "<-" (cmd! (+aas-with-spacing "\\leftarrow"))
    "_>" (cmd! (+aas-with-spacing "\\to")) ; alias
    "!=" (cmd! (+aas-with-spacing "\\neq")) ; alias
    "!+" (cmd! (+aas-with-spacing "\\neq")) ; alias
    "||" (cmd! (+aas-with-spacing "\\mid"))
    ;; use my private overbar macro instead of overline
    :cond #'laas-object-on-left-condition
    "bar" (cmd! (laas-wrap-previous-object "overbar"))))

(autoload 'math-delimiters-insert "math-delimiters")

(with-eval-after-load 'org
  (define-key org-mode-map "$" #'math-delimiters-insert))

(with-eval-after-load 'tex              ; for AUCTeX
  (define-key TeX-mode-map "$" #'math-delimiters-insert))

(with-eval-after-load 'tex-mode         ; for the built-in TeX/LaTeX modes
  (define-key tex-mode-map "$" #'math-delimiters-insert))

(with-eval-after-load 'cdlatex
  (define-key cdlatex-mode-map "$" nil))

(use-package! latex-change-env
  :after latex
  :bind
  (:map LaTeX-mode-map ("C-c r" . latex-change-env))
  ;; (:map LaTeX-mode-map ("s-<return>" . LaTeX-insert-item))
  :config
  (setq latex-change-env-display math-delimiters-display))

(use-package! pdf-view
  :hook (pdf-tools-enabled . pdf-view-themed-minor-mode)
  :config
  (setq pdf-view-use-scaling t
        pdf-view-use-imagemagick nil
        pdf-view-display-size 'fit-page))

;;; bibtex stuff

(after! citar
  (setq org-cite-global-bibliography '("/Users/nisch/Library/texmf/bibtex/bib/Zotero.bib"))
  (setq! citar-bibliography '("/Users/nisch/Library/texmf/bibtex/bib/Zotero.bib"))
  (setq! citar-library-paths '("/Users/nisch/Documents/papers_library/papers"))
  )

(after! treemacs
  (defvar treemacs-file-ignore-extensions '()
    "File extension which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-globs '()
    "Globs which will are transformed to `treemacs-file-ignore-regexps' which `treemacs-ignore-filter' will ensure are ignored")
  (defvar treemacs-file-ignore-regexps '()
    "RegExps to be tested to ignore files, generated from `treeemacs-file-ignore-globs'")
  (defun treemacs-file-ignore-generate-regexps ()
    "Generate `treemacs-file-ignore-regexps' from `treemacs-file-ignore-globs'"
    (setq treemacs-file-ignore-regexps (mapcar 'dired-glob-regexp treemacs-file-ignore-globs)))
  (if (equal treemacs-file-ignore-globs '()) nil (treemacs-file-ignore-generate-regexps))
  (defun treemacs-ignore-filter (file full-path)
    "Ignore files specified by `treemacs-file-ignore-extensions', and `treemacs-file-ignore-regexps'"
    (or (member (file-name-extension file) treemacs-file-ignore-extensions)
        (let ((ignore-file nil))
          (dolist (regexp treemacs-file-ignore-regexps ignore-file)
            (setq ignore-file (or ignore-file (if (string-match-p regexp full-path) t nil)))))))
  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-filter))

(setq treemacs-file-ignore-extensions
      '(;; LaTeX
        "aux"
        "ptc"
        "fdb_latexmk"
        "fls"
        "synctex.gz"
        "toc"
        ;; LaTeX - glossary
        "glg"
        "glo"
        "gls"
        "glsdefs"
        "ist"
        "acn"
        "acr"
        "alg"
        ;; LaTeX - pgfplots
        "mw"
        ;; LaTeX - pdfx
        "pdfa.xmpi"
        ))
(setq treemacs-file-ignore-globs
      '(;; LaTeX
        "*/_minted-*"
        ;; AucTeX
        "*/.auctex-auto"
        "*/_region_.log"
        "*/_region_.tex"))

;; (use-package! lsp-ltex
;;   :commands (+lsp-ltex-toggle
;;              +lsp-ltex-enable
;;              +lsp-ltex-disable
;;              +lsp-ltex-setup)
;;   :hook ((latex-mode LaTeX-mode org-mode markdown-mode html-mode bibtex-mode) . #'+lsp-ltex-setup)
;;   :init
;;   ;; There is some problematic modes when it comes to enabling LSP
;;   (defvar +lsp-ltex-disabled-modes '(org-msg-edit-mode))
;;   :config
;;   ;; Add doom-docs-mode to LSP language IDs
;;   (add-to-list 'lsp-language-id-configuration '(doom-docs-org-mode . "org"))
;;   :init
;;   (setq lsp-ltex-check-frequency "save"
;;         lsp-ltex-log-level "warning" ;; No need to log everything
;;         lsp-ltex-diagnostic-severity "warning"
;;         lsp-ltex-enabled ["bibtex" "context" "context.tex"
;;                           "html" "latex" "markdown" "org"
;;                           "restructuredtext" "rsweave"]
;;         ;; Path in which, interactively added words and rules will be stored.
;;         lsp-ltex-user-rules-path (expand-file-name "lsp-ltex" doom-data-dir))
;;   (setq lsp-ltex-server-store-path nil)

;;   ;; When n-gram data sets are available, use them to detect errors with words
;;   ;; that are often confused (like their and there).
;;   ;; (when (file-directory-p "/usr/share/ngrams")
;;   ;;   (setq lsp-ltex-additional-rules-language-model "/usr/share/ngrams"))

;;   (defun +lsp-ltex-setup ()
;;     "Load LTeX LSP server."
;;     (interactive)
;;     (require 'lsp-ltex)
;;     (when (and (+lsp-ltex--enabled-p)
;;                (not (memq major-mode +lsp-ltex-disabled-modes)))
;;       (lsp-deferred)))

;;   (defun +lsp-ltex--enabled-p ()
;;     (not (memq 'ltex-ls lsp-disabled-clients)))

;;   (defun +lsp-ltex-enable ()
;;     "Enable LTeX LSP for the current buffer."
;;     (interactive)
;;     (unless (+lsp-ltex--enabled-p)
;;       (setq-local lsp-disabled-clients (delq 'ltex-ls lsp-disabled-clients))
;;       (message "Enabled ltex-ls"))
;;     (+lsp-ltex-setup))

;;   (defun +lsp-ltex-disable ()
;;     "Disable LTeX LSP for the current buffer."
;;     (interactive)
;;     (when (+lsp-ltex--enabled-p)
;;       (setq-local lsp-disabled-clients (cons 'ltex-ls lsp-disabled-clients))
;;       (lsp-disconnect)
;;       (message "Disabled ltex-ls")))

;;   (defun +lsp-ltex-toggle ()
;;     "Toggle LTeX LSP for the current buffer."
;;     (interactive)
;;     (if (+lsp-ltex--enabled-p)
;;         (+lsp-ltex-disable)
;;       (+lsp-ltex-enable)))

;;   (map! :localleader
;;         :map (text-mode-map latex-mode-map LaTeX-mode-map org-mode-map markdown-mode-map)
;;         :desc "Toggle grammar check" "G" #'+lsp-ltex-toggle))

;; (after! lsp-ltex
;;   (setq lsp-ltex-language "auto"
;;         lsp-ltex-mother-tongue "en"
;;         flycheck-checker-error-threshold 1000)

;;   (advice-add
;;    '+lsp-ltex-setup :after
;;    (lambda ()
;;      (setq-local lsp-idle-delay 5.0
;;                  lsp-progress-function #'lsp-on-progress-legacy
;;                  lsp-progress-spinner-type 'half-circle
;;                  lsp-ui-sideline-show-code-actions nil
;;                  lsp-ui-sideline-show-diagnostics nil
;;                  lsp-ui-sideline-enable nil)))

;;   ;; FIXME
;;   (defun +lsp-ltex-check-document ()
;;     (interactive)
;;     (when-let ((file (buffer-file-name)))
;;       (let* ((uri (lsp--path-to-uri file))
;;              (beg (region-beginning))
;;              (end (region-end))
;;              (req (if (region-active-p)
;;                       `(:uri ,uri
;;                         :range ,(lsp--region-to-range beg end))
;;                     `(:uri ,uri))))
;;         (lsp-send-execute-command "_ltex.checkDocument" req)))))

(after! org
  (setq org-highlight-latex-and-related '(native script entities))
  (require 'org-src)
  (add-to-list 'org-src-block-faces '("latex" (:inherit default :extend t))))

(setq org-latex-create-formula-image-program 'dvisvgm)
(setq org-startup-with-latex-preview t)
(after! org
  (plist-put org-format-latex-options :background "Transparent")
  (plist-put org-format-latex-options :zoom 0.97)
  (plist-put org-format-latex-options :scale 1)
  (setq org-latex-default-class "koma-article"
        org-latex-caption-above nil
        org-latex-listings 'minted
        ;; latexmk tends to play along nicer than pdflatex
        org-latex-pdf-process '("latexmk -f -pdf %f")))

(use-package! academic-phrases)

(defun +helper-paragraphized-yank ()
  "Copy, then remove newlines and Org styling (/*_~)."
  (interactive)
  (copy-region-as-kill nil nil t)
  (with-temp-buffer
    (yank)
    ;; Remove newlines, and Org styling (/*_~)
    (goto-char (point-min))
    (let ((case-fold-search nil))
      (while (re-search-forward "[\n/*_~]" nil t)
        (replace-match (if (s-matches-p (match-string 0) "\n") " " "") t)))
    (kill-region (point-min) (point-max))))

(map! :localleader
      :map (org-mode-map markdown-mode-map latex-mode-map text-mode-map)
      :desc "Paragraphized yank" "y" #'+helper-paragraphized-yank)

(unless (getenv "CONDA_DEFAULT_ENV")
  (conda-env-activate "base"))
(setq jupyter-repl-echo-eval-p t)
(map! :after evil-org
      :map evil-org-mode-map
      :leader
      :desc "tangle" :n "ct" #'org-babel-tangle
      :localleader
      :desc "Hydra" :n "," #'jupyter-org-hydra/body
      :desc "Inspect at point" :n "?" #'jupyter-inspect-at-point
      :desc "Execute and step" :n "RET" #'jupyter-org-execute-and-next-block
      :desc "Delete code block" :n "x" #'jupyter-org-kill-block-and-results
      :desc "New code block above" :n "+" #'jupyter-org-insert-src-block
      :desc "New code block below" :n "=" (λ! () (interactive) (jupyter-org-insert-src-block t nil))
      :desc "Merge code blocks" :n "m" #'jupyter-org-merge-blocks
      ;; :desc "Split code block" :n "-" #'jupyter-org-split-src-block
      :desc "Split code block" :n "-" #'org-babel-demarcate-block
      :desc "Fold results" :n "z" #'org-babel-hide-result-toggle

      :map org-src-mode-map
      :localleader
      :desc "Exit edit" :n "'" #'org-edit-src-exit)

(after! evil-org
  (setq org-babel-default-header-args:jupyter-python '((:async . "yes")
                                                       ;; (:pandoc t)
                                                       (:kernel . "python3"))))

;; (use-package code-cells
;;   :config
;;   ;; (setq code-cells-convert-ipynb-style '(("pandoc" "--to" "ipynb" "--from" "org")
;;   ;; 					 ("pandoc" "--to" "org" "--from" "ipynb")
;;   ;; 					 org-mode))
;;   (let ((map code-cells-mode-map))
;;     (define-key map (kbd "C-c <up>") 'code-cells-backward-cell)
;;     (define-key map (kbd "C-c <down>") 'code-cells-forward-cell)
;;     (define-key map (kbd "M-<up>") 'code-cells-move-cell-up)
;;     (define-key map (kbd "M-<down>") 'code-cells-move-cell-down)
;;     (define-key map (kbd "C-c C-c") 'code-cells-eval)
;;     ;; Overriding other minor mode bindings requires some insistence...
;;     (define-key map [remap jupyter-eval-line-or-region] 'code-cells-eval)))
;; (defun my/new-notebook (notebook-name &optional kernel)
;;   "Creates an empty notebook in the current directory with an associated kernel."
;;   (interactive "sEnter the notebook name: ")
;;   (when (file-name-extension notebook-name)
;;     (setq notebook-name (file-name-sans-extension notebook-name)))
;;   (unless kernel
;;     (setq kernel (completing-read "Choose kernel: " (jupyter-available-kernelspecs))))
;;   (unless (executable-find "jupytext")
;;     (error "Can't find \"jupytext\""))
;;   (let ((notebook-py (concat notebook-name ".py")))
;;     (shell-command (concat "touch " notebook-py))
;;     (shell-command (concat "jupytext --set-kernel " kernel " " notebook-py))
;;     (shell-command (concat "jupytext --to notebook " notebook-py))
;;     (shell-command (concat "rm " notebook-py))
;;     (message (concat "Notebook successfully created at " notebook-name ".ipynb"))))


;; (setq code-cells-convert-ipynb-style '(
;;                                        ("pandoc" "--to" "ipynb" "--from" "org")
;;                                        ("pandoc" "--to" "org" "--from" "ipynb")
;;                                        org-mode))

(use-package edit-indirect
  :defer t
  :commands (keep-this-line)
  :bind (("C-c e" . edit-indirect-region)
         :map edit-indirect-mode-map
         ("C-c C-s" . keep-this-line)))

(defun edit-sentence-at-point ()
  (interactive)
  (setq bnds (bounds-of-thing-at-point 'sentence))
  (goto-char (car bnds))
  (set-mark-command nil)
  (goto-char (cdr bnds))
  (edit-indirect-region (region-beginning) (region-end) t))

(defun keep-this-line ()
  (interactive)
  (save-excursion (setq this--line (thing-at-point 'sentence))
                  (goto-char (point-min))
                  (keep-lines this--line))
  (edit-indirect-commit))


(global-set-key (kbd "C-c s") #'edit-sentence-at-point)
;; (define-key edit-indirect-mode-map (kbd "C-c C-s") #'keep-this-line))

(use-package! lexic
  :commands lexic-search lexic-list-dictionary
  :config
  (map! :map lexic-mode-map
        :n "q" #'lexic-return-from-lexic
        :nv "RET" #'lexic-search-word-at-point
        :n "a" #'outline-show-all
        :n "h" (cmd! (outline-hide-sublevels 3))
        :n "o" #'lexic-toggle-entry
        :n "n" #'lexic-next-entry
        :n "N" (cmd! (lexic-next-entry t))
        :n "p" #'lexic-previous-entry
        :n "P" (cmd! (lexic-previous-entry t))
        :n "E" (cmd! (lexic-return-from-lexic) ; expand
                     (switch-to-buffer (lexic-get-buffer)))
        :n "M" (cmd! (lexic-return-from-lexic) ; minimise
                     (lexic-goto-lexic))
        :n "C-p" #'lexic-search-history-backwards
        :n "C-n" #'lexic-search-history-forwards
        :n "/" (cmd! (call-interactively #'lexic-search))))

(defadvice! +lookup/dictionary-definition-lexic (identifier &optional arg)
  "Look up the definition of the word at point (or selection) using `lexic-search'."
  :override #'+lookup/dictionary-definition
  (interactive
   (list (or (doom-thing-at-point-or-region 'word)
             (read-string "Look up in dictionary: "))
         current-prefix-arg))
  (lexic-search identifier nil nil t))

;; ]e [e next and previous error respectively.
(map! (:after flycheck
       :m "]e" 'flycheck-next-error
       :m "[e" 'flycheck-previous-error))

(flycheck-define-checker vale
  "A checker for prose"
  :command ("vale"
            "--output" "line"
            "--config" "/Users/nisch/.config/vale/.vale.ini"
            source)
  :standard-input nil
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ":" (id (one-or-more (not (any ":")))) ":" (message) line-end))
  :modes (markdown-mode org-mode text-mode)
  )
(add-to-list 'flycheck-checkers 'vale 'append)
;; disable global flycheck mode
(add-hook 'org-mode-hook (lambda () (flycheck-mode -1)))