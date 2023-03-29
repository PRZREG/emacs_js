;; Define and initialise package repositories
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;; Keyboard-centric user interface
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(xterm-mouse-mode 1)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'cmake-mode 'hs-minor-mode)
(add-hook 'c++-mode 'hs-minor-mode)
(add-hook 'cmake-mode 'hs-minor-mode)

(defalias 'yes-or-no-p 'y-or-n-p)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Feature `cc-mode' provides major modes for C, C++.
(use-package cc-mode
  :ensure t
  :config
   ;; Indentation for CC Mode
  (defconst my-cc-style
    '((c-recognize-knr-p . nil)
      (c-basic-offset . 4)
      (c-tab-always-indent . t)
      (c-comment-only-line-offset . 0)
      (comment-column . 40)
      (c-indent-comments-syntactically-p . t)
      (c-indent-comment-alist . ((other . (space . 1))))
      (c-hanging-braces-alist . ((defun-open before after)
                                 (defun-close before after)
                                 (class-open after)
                                 (class-close before)
                                 (inexpr-class-open after)
                                 (inexpr-class-close before)
                                 (namespace-open after)
                                 (namespace-close before after)
                                 (inline-open before after)
                                 (inline-close before after)
                                 (block-open after)
                                 (block-close . c-snug-do-while)
                                 (extern-lang-open after)
                                 (extern-lang-close before after)
                                 (statement-case-open after)
                                 (substatement-open after)))
      (c-hanging-colons-alist . ((case-label after)
                                 (label after)
                                 (access-label after)
                                 (member-init-intro)
                                 (inher-intro)))
      (c-hanging-semi&comma-criteria
       . (c-semi&comma-inside-parenlist
          c-semi&comma-no-newlines-before-nonblanks
          c-semi&comma-no-newlines-for-oneline-inliners))
      (c-cleanup-list . (brace-else-brace
                         brace-elseif-brace
                         brace-catch-brace
                         defun-close-semi
                         list-close-comma
                         scope-operator))
      (c-offsets-alist . ((inexpr-class . +)
                          (inexpr-statement . +)
                          (lambda-intro-cont . +)
                          (inlambda . c-lineup-inexpr-block)
                          (template-args-cont c-lineup-template-args +)
                          (incomposition . +)
                          (inmodule . +)
                          (innamespace . 0)
                          (inextern-lang . +)
                          (composition-close . 0)
                          (module-close . 0)
                          (namespace-close . 0)
                          (extern-lang-close . 0)
                          (composition-open . 0)
                          (module-open . 0)
                          (namespace-open . 0)
                          (extern-lang-open . 0)
                          (friend . 0)
                          (cpp-define-intro c-lineup-cpp-define +)
                          (cpp-macro-cont . +)
                          (cpp-macro . [0])
                          (inclass . +)
                          (stream-op . c-lineup-streamop)
                          (arglist-cont-nonempty c-lineup-gcc-asm-reg
                                                 c-lineup-arglist)
                          (arglist-cont c-lineup-gcc-asm-reg 0)
                          (comment-intro c-lineup-knr-region-comment
                                         c-lineup-comment)
                          (catch-clause . 0)
                          (else-clause . 0)
                          (do-while-closure . 0)
                          (access-label . -)
                          (case-label . 0)
                          (substatement . +)
                          (statement-case-intro . +)
                          (statement . 0)
                          (brace-entry-open . 0)
                          (brace-list-entry . c-lineup-under-anchor)
                          (brace-list-close . 0)
                          (block-close . 0)
                          (block-open . 0)
                          (inher-cont . c-lineup-multi-inher)
                          (inher-intro . +)
                          (member-init-cont . c-lineup-multi-inher)
                          (member-init-intro . +)
                          (annotation-var-cont . +)
                          (annotation-top-cont . 0)
                          (topmost-intro . 0)
                          (func-decl-cont . +)
                          (inline-close . 0)
                          (class-close . 0)
                          (class-open . 0)
                          (defun-block-intro . +)
                          (defun-close . 0)
                          (defun-open . 0)
                          (c . c-lineup-C-comments)
                          (string . c-lineup-dont-change)
                          (topmost-intro-cont . c-lineup-topmost-intro-cont)
                          (brace-list-intro . +)
                          (brace-list-open . 0)
                          (inline-open . +)
                          (arglist-close . +)
                          (arglist-intro . +)
                          (statement-cont . +)
                          (statement-case-open . 0)
                          (label . ++)
                          (substatement-label . ++)
                          (substatement-open . +)
                          (statement-block-intro . +))))
    "My custom C/C++ programming style.")

  ;; Add custom C/C++ style and set it as default. This style is only used for
  ;; languages which do not have a more specific style set in `c-default-style'.
  (c-add-style "mine" my-cc-style)
  (setf (map-elt c-default-style 'other) "mine"))


;; Package `ccls' is a client for ccls, a C/C++/Objective-C language server
;; supporting multi-million line C++ code-bases, powered by libclang. It
;; leverages `lsp-mode', but also provides some ccls extensions to LSP.
(use-package ccls
  :bind (:map ccls-tree-mode-map
              ("e" . #'ccls-tree-toggle-expand)
              ("n" . #'ccls-tree-next-line)
              ("p" . #'ccls-tree-prev-line))
  :config


  ;; Set some basic logging for debugging purpose.
  (setq ccls-args (list "-log-file=/tmp/ccls.log" "-v=1"))

  ;; Change initialisation options to include almost all warnings. Disable some
  ;; clang incompatible flags and set completion to be "smart" case.
  (setq ccls-initialization-options
        '(
          :cache (:directory ".cache/ccls")
          :clang (
                  :extraArgs ["-Weverything"
                              "-Wno-c++98-compat"
                              "-Wno-c++98-compat-pedantic"
                              "-Wno-covered-switch-default"
                              "-Wno-global-constructors"
                              "-Wno-exit-time-destructors"
                              "-Wno-documentation"
                              "-Wno-padded"
                              "-Wno-unneeded-member-function"
                              "-Wno-unused-member-function"
                              "-Wno-language-extension-token"
                              "-Wno-gnu-zero-variadic-macro-arguments"
                              "-Wno-gnu-statement-expression"
                              "-Wno-unused-macros"
                              "-Wno-weak-vtables"
                              "-Wno-ctad-maybe-unsupported"
                              "-Wno-error"]
                  :excludeArgs ["-fconserve-stack"
                                "-fmacro-prefix-map"
                                "-fmerge-constants"
                                "-fno-var-tracking-assignments"
                                "-fstack-usage"
                                "-mabi=lp64"])
          :codeLens (:localVariables :json-false)
          :completion (
                       :caseSensitivity 1
                       :detailedLabel t
                       :duplicateOptional :json-false
                       :include (:maxPathSize 30))
          :index (
                  :blacklist [".*CMakeFiles.*"]
                  :maxInitializerLines 15)))

  ;; Use a bit slower method than font-lock but more accurate.
  (setq ccls-sem-highlight-method 'overlay)

  ;; Use default rainbow semantic highlight theme.
  (ccls-use-default-rainbow-sem-highlight))


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config (add-hook 'after-init-hook #'global-flycheck-mode))



(use-package flycheck-clang-tidy
  :ensure t
  :after flycheck
  :hook
  (lsp-mode . flycheck-clang-tidy-setup)
  )

(use-package lsp-mode
  :init

  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c++-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  ;; Ignore watching files in the workspace if the server has requested that.
  (setq lsp-enable-file-watchers nil)
  ;;disable ccls 
  (setq lsp-disabled-clients '(clangd))
  (setq lsp-clients-clangd-executable "/usr/bin/clangd")
  (setq lsp-clients-clangd-args '("-j=4" "--background-index" "--clang-tidy" "--completion-style=detailed" "-log=error"))
  (setq lsp-client-packages '(ccls))
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)

  :commands lsp)


;; optionally
;; optionally
(use-package lsp-ui
  :config
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
  :commands lsp-ui-mode)

;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package modern-cpp-font-lock
  :ensure t
  :config
  (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

;; Theme
(use-package monokai-theme
:ensure t
:config
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t))

(use-package all-the-icons
  :if (display-graphic-p))


;;Ranger
;; --- Ranger ---
(use-package ranger
  :ensure t)

(use-package bind-map
  :demand t)

(use-package flymake-aspell
  :config
  (add-to-list 'flycheck-checkers 'c-aspell-dynamic)
  (setq ispell-program-name "aspell")
  (setq ispell-silently-savep t)
  :hook (lsp-mode . flyspell-prog-mode))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map ("M-m f" . flyspell-correct-wrapper)))


(use-package devdocs-browser)

(use-package centaur-tabs
  :demand
  :config
  (centaur-tabs-mode t)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-modified-marker "*")
  )

;; Package `ace-window' provides a function, `ace-window' which is meant to
;; replace `other-window' by assigning each window a short, unique label. When
;; there are only two windows present, `other-window' is called. If there are
;; more, each window will have its first label character highlighted. Once a
;; unique label is typed, ace-window will switch to that window.
(use-package ace-window
  :init
  :bind ("M-o" . #'ace-window))

;;Personal key-binding
(defvar my-personal-map
  (let ((map (make-sparse-keymap)))
    (define-key map "wv" 'split-window-horizontally)
    (define-key map "ws" 'split-window-vertically)
    (define-key map "wd" 'ace-delete-window)
    (define-key map "wD" 'ace-delete-other-windows)
    (define-key map "we" 'centaur-tabs-forward)
    (define-key map "wr" 'centaur-tabs-backward)
    (define-key map "ar" 'ranger)
    (define-key map "as" 'shell)
    (define-key map "ap" 'ccls-preprocess-file)
    (define-key map "ad" 'devdocs-browser-open)
    (define-key map "mg" 'projectile-grep)
    (define-key map "mh" 'hs-hide-block)
    (define-key map "ms" 'hs-show-block)
    (define-key map "cm" 'lsp-ui-imenu)
    (define-key map "cs" 'lsp-ui-doc-show)
    (define-key map "ch" 'lsp-ui-doc-hide)
    
     map)
  "My custom key map.")

(bind-map my-personal-map
  :keys ("M-m"))

(which-key-add-key-based-replacements
  "M-m c" "code")

(which-key-add-key-based-replacements
  "M-m m" "misc")

(which-key-add-key-based-replacements
  "M-m w" "windows")

(which-key-add-key-based-replacements
  "M-m a" "apps")

;; Package `winum' helps with navigating windows and frames using numbers. It is
;; an extended and actively maintained version of the `window-numbering'
;; package. This version brings, among other things, support for number sets
;; across multiple frames, giving the user a smoother experience of multi-screen
;; Emacs.
(use-package winum
  :demand t
  :bind (:map winum-keymap
              ("M-1" . #'winum-select-window-1)
              ("M-2" . #'winum-select-window-2)
              ("M-3" . #'winum-select-window-3)
              ("M-4" . #'winum-select-window-4)
              ("M-5" . #'winum-select-window-5)
              ("M-6" . #'winum-select-window-6)
              ("M-7" . #'winum-select-window-7)
              ("M-8" . #'winum-select-window-8)
              ("M-9" . #'winum-select-window-9))
  :config

  ;; Do not assign minibuffer to buffer 0 when it is active
  (setq winum-auto-assign-0-to-minibuffer nil)

  ;; Avoid modyfing modeline - we're going to do that later
  (setq winum-auto-setup-mode-line nil)

  (winum-mode +1))

(windmove-default-keybindings)

(use-package company)
(define-key company-mode-map (kbd "C-c c") 'company-complete)

(use-package selectrum
  :config
  (selectrum-mode +1))


(use-package selectrum-prescient
  :config
  (selectrum-prescient-mode +1)
  (prescient-persist-mode +1))

(use-package projectile
;;  :bind (("M-m p" . projectile-command-map))
  :config

  ;; Sort files by recently active buffers first, then recently opened files.
  (setq projectile-sort-order 'recently-active)

  ;; Use git-grep underhood `projectile-grep' when possible.
  (setq projectile-use-git-grep t)

  ;; When switching projects, give the option to choose what to do. This is a
  ;; way better interface than having to remember ahead of time to use a prefix
  ;; argument on `projectile-switch-project'.
  (setq projectile-switch-project-action 'projectile-commander)

  ;; When switching projects, give the option to choose what to do. This is a
  ;; way better interface than having to remember ahead of time to use a prefix
  ;; argument on `projectile-switch-project'.
  (setq projectile-switch-project-action 'projectile-commander)
  (projectile-mode +1))
(define-key projectile-mode-map (kbd "M-m p") 'projectile-command-map)


;;(use-package crux)

;;For shortcuts in M-x
;;(use-package counsel)

;; Enable rich annotations using the Marginalia package
(use-package marginalia
;; Either bind `marginalia-cycle' globally or only in the minibuffer
:bind (("M-A" . marginalia-cycle)
       :map minibuffer-local-map
       ("M-A" . marginalia-cycle))

;; The :init configuration is always executed (Not lazy!)
:init

;; Must be in the :init section of use-package such that the mode gets
;; enabled right away. Note that this forces loading the package.
(marginalia-mode))

(use-package magit
  :ensure t
  :init
  (progn
    (bind-key "M-m g" 'magit-status)))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(centaur-tabs all-the-icons devdocs-browser cmake-mode flymake-aspell flycheck-aspell folding org-contrib plantuml-mode magit marginalia projectile selectrum-prescient selectrum company winum bind-map ranger monokai-theme which-key use-package modern-cpp-font-lock lsp-ui lsp-treemacs lsp-ivy helm-lsp flycheck)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(use-package plantuml-mode
  :init
   (setq plantuml-default-exec-mode 'jar)
   (setq plantuml-jar-path "/usr/share/java/plantuml/plantuml.jar")
   (setq org-plantuml-jar-path (expand-file-name "/usr/share/java/plantuml/plantuml.jar"))
   (setq org-startup-with-inline-images t)
   (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

  (defun plantuml-completion-at-point ()
    "Get PlantUML keyword completion."
    (let ((bounds (bounds-of-thing-at-point 'symbol))
          (keywords plantuml-kwdList))
      (when (and bounds keywords)
        (list (car bounds)
              (cdr bounds)
              keywords
              :exclusive 'no
              :company-docsig #'identity))))

  :config

  ;; Use binary version instead of server, we do not want to send stuff to
  ;; plantuml servers
  (setq plantuml-default-exec-mode 'executable)

  ;; Define flycheck checker for plantuml.
  (require 'flycheck)
  (flycheck-define-checker plantuml
    "A checker using plantuml."
    :command ("plantuml" "-headless" "-syntax")
    :standard-input t
    :error-patterns ((error line-start "ERROR" "\n" line "\n" (message)
                            line-end))
    :modes plantuml-mode)
  (add-to-list 'flycheck-checkers 'plantuml))


;; Package `org' provides too many features to describe in any reasonable amount
;; of space. It is built fundamentally on `outline-mode', and adds TODO states,
;; deadlines, properties, priorities, etc. to headings. Then it provides tools
;; for interacting with this data, including an agenda view, a time clocker,
;; etc.
(use-package org
  ;; We use straight mirror as the official repo does not allow to fetch a
  ;; shallow repo with a frozen git hash.
  ;;:straight (:host github :repo "emacs-straight/org-mode" :local-repo "org")
  :init

  ;;(setq org-plantuml-jar-path (expand-file-name "/usr/share/java/plantuml/plantuml.jar"))
  ;;(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  ;;(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

  :bind (:map org-mode-map
              ("M-p" . #'org-backward-element)
              ("M-n" . #'org-forward-element)
              ("M-P" . #'org-shiftmetaup)
              ("M-N" . #'org-shiftmetadown))

  :config

  ;; Show headlines but not content by default.
  (setq org-startup-folded 'content)

  ;; Hide the first N-1 stars in a headline.
  (setq org-hide-leading-stars t)

  ;; Do not adapt indentation to outline node level.
  (setq org-adapt-indentation nil)

  ;; Use cornered arrow instead of three dots to increase its visibility.
  (setq org-ellipsis "⤵")

  ;; Require braces in order to trigger interpretations as sub/superscript. This
  ;; can be helpful in documents that need "_" frequently in plain text.
  (setq org-use-sub-superscripts '{})

  ;; Make `mwim' behaving like it should in Org.
  (setq org-special-ctrl-a/e t)

  ;; Add additional backends to export engine.
  (dolist (backend '(beamer md confluence))
    (push backend org-export-backends))

  ;; Add plantuml for generating diagrams inside Org Mode.
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t))))

(use-package cmake-mode)

;; Package `git-commit' assists the user in writing good Git commit messages.
;; While Git allows for the message to be provided on the command line, it is
;; preferable to tell Git to create the commit without actually passing it a
;; message. Git then invokes the `$GIT_EDITOR' (or if that is undefined
;; `$EDITOR') asking the user to provide the message by editing the file
;; ".git/COMMIT_EDITMSG" (or another file in that directory, e.g.
;; ".git/MERGE_MSG" for merge commits).
(use-package git-commit
  :demand t
  :hook (git-commit-mode . display-fill-column-indicator-mode) 
  :config
  

  ;; Make overlong summary with the same face as `column-enforce-mode'.
  (set-face-attribute 'git-commit-overlong-summary nil :underline t)

  ;; List of checks performed by `git-commit'.
  (setq git-commit-style-convention-checks '(non-empty-second-line
                                             overlong-summary-line))
  (setq  git-commit-fill-column 72)

  ;; Column beyond which characters in the summary lines are highlighted.
  (setq git-commit-summary-max-length 50))

(use-package highlight-parentheses
  :ensure t)
(global-highlight-parentheses-mode 1)
