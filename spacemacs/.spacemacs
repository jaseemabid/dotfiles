;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(asciidoc
     (c-c++ :variables c-c++-enable-clang-support t)
     (shell :variables
            shell-default-shell 'eshell
            shell-default-height 30
            shell-default-position 'bottom)
     auto-completion
     better-defaults
     csv
     emacs-lisp
     erlang
     finance
     git
     go
     gtags
     haskell
     helm
     html
     markdown
     org
     python
     rust
     scheme
     spacemacs-layouts
     spell-checking
     sql
     syntax-checking
     yaml)
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(llvm-mode)
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages
   '(anaconda-mode
     auto-compile
     fancy-battery
     lorem-ipsum
     neotree
     smartparens
     version-control
     yapf-mode
     yasnippet)
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading t
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'emacs-lisp-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '()
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Inconsolata"
                               :size 20
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts t
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar nil
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers t
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server t
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'trailing))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  (setq init-file-user "jaseem"
        user-full-name "Jaseem Abid"
        user-nick "jaseemabid"
        user-mail-address "jaseemabid@gmail.com")

  ;; A whole bunch of config vars
  (setq-default c-basic-indent 4
                c-basic-offset 4
                c-default-style nil
                case-fold-search t
                fill-column 80
                indent-tabs-mode nil
                major-mode 'org-mode
                powerline-default-separator 'arrow
                require-final-newline t
                sentence-end-double-space nil
                spaceline-minor-modes-p nil
                tab-width 4
                truncate-lines t
                vc-follow-symlinks t
                visible-bell t
                vc-follow-symlinks t)

  (use-package abbrev
    :diminish abbrev-mode

    :config
    ;; stop asking whether to save newly added abbrev when quitting emacs
    (setq save-abbrevs nil)
    (setq-default abbrev-mode t)

    (define-abbrev-table 'global-abbrev-table
      '(
        ;; math/unicode symbols
        ("8n" "ℕ")
        ("8r" "ℝ")
        ("8sig" "σ")
        ("8bot" "⟂")
        ("8gam" "γ")
        ("8in" "∈")
        ("8inf" "∞")
        ("8inr" "₹")
        ("8lam" "λ")
        ("8lar" "←")
        ("8luv" "♥")
        ("8meh" "¯\\_(ツ)_/¯")
        ("8nin" "∉")
        ("8no" "❌")
        ("8ok" "✓")
        ("8rar" "→")
        ("8rs" "₹")
        ("8sig" "σ")
        ("8smly" "☺")
        ("8star" "★")
        ("8t" "#+title:")
        ("8tau" "τ")

        ;; email
        ("8me" user-mail-address)
        ("8i"  user-full-name))))

  (use-package files
    :init
    (add-hook 'find-file-hook 'j/find-file-large-hook)
    (remove-hook 'find-file-hook 'vc-find-file-hook)
    (defun j/find-file-large-hook ()
      "If a file is over a given size, make the buffer read only."
      (when (> (buffer-size) (* 1024 1024))
        (setq buffer-read-only t)
        (buffer-disable-undo)
        (fundamental-mode))))

  (use-package exec-path-from-shell
    :config
    (setq exec-path-from-shell-check-startup-files nil)
    (exec-path-from-shell-initialize))

  (use-package geiser
    :config
    (setq geiser-chez-binary "scheme"
          geiser-active-implementations '(chez)))

  (use-package magit
    :config
    (setq-default magit-revision-show-gravatars nil))

  (use-package org
    :bind (("C-c a" . org-agenda)
           ("C-c k" . org-store-link)
           ("C-c r" . org-capture)
           :map org-mode-map
           ("C-c l" . j/org-insert-link))
    :config
    (setq org-agenda-files `("~/Notes")
          org-agenda-timegrid-use-ampm t ;; 12hr format for agenda view
          org-completion-use-ido t
          org-default-notes-file "~/Notes/todo.org"
          org-directory "~/Notes"
          org-log-done 'time
          org-return-follows-link t
          org-src-fontify-natively t
          org-startup-folded nil
          org-capture-templates
          '(("t" "Add personal todo" entry (file+headline "~/Notes/todo.org" "Tasks")
             "* TODO %?\n  %i"
             :kill-buffer t
             :empty-lines 1)
            ("w" "Add a work todo" entry (file+headline "~/Notes/work.org" "Tasks")
             "* TODO %?\n  %i"
             :kill-buffer t)
            ("r" "Refile" plain (file "~/Notes/refile.org")
             "%?\n %i"
             :kill-buffer t)
            ("b" "Reading" entry (file+headline "~/Notes/reading.org" "Reading")
             "** %^{title}\n   %T\n\n%?"
             :kill-buffer t)
            ("j" "Journal" plain (file (format "%s%s.org" "~/Notes/Journal/"
                                               (format-time-string "%Y %m %d")))
             "%U\n\n%?%i"
             :kill-buffer t
             :unnarrowed t))))

  (use-package popwin
    :init
    (defun syntax-checking/post-init-popwin ()
      (push '("^\\*Flycheck.+\\*$"
              :regexp t
              :dedicated nil
              :width 0.5
              :position right
              :stick t
              :noselect t)
            popwin:special-display-config)))

  (use-package uniquify
    :init
    (setq uniquify-buffer-name-style 'forward
          uniquify-min-dir-content 1))

  ;; A bunch of personal key bindings
  (spacemacs/set-leader-keys
    "bx" 'bury-buffer
    "fq" 'unfill-toggle
    "w1" 'spacemacs/toggle-maximize-buffer
    "yw" 'copy-word)

  ;; A bunch of hooks
  (add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)
  (add-hook 'c++-mode-hook 'pick-cpp)

  ;; Functions

  ;; https://www.emacswiki.org/emacs/CopyWithoutSelection
  (defun copy-word (&optional arg)
    "Copy words at point into kill-ring"
    (interactive "P")
    (save-excursion
      (let ((beg (progn (backward-word 1) (point)))
            (end (progn (forward-word arg) (point))))
        (copy-region-as-kill beg end))))

  (defun stop-using-minibuffer ()
    "kill the minibuffer"
    (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
      (abort-recursive-edit)))

  (defun pick-cpp ()
    (setq flycheck-gcc-language-standard "c++11"))

  t)


(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-want-Y-yank-to-eol nil)
 '(package-selected-packages
   (quote
    (adoc-mode markup-faces powerline anaconda-mode smartparens goto-chg window-purpose godoctor go-rename go-guru go-eldoc flycheck-gometalinter company-go go-mode sqlup-mode sql-indent cmake-ide levenshtein dash-functional iedit alert web-mode tagedit slim-mode scss-mode sass-mode pug-mode less-css-mode impatient-mode simple-httpd helm-css-scss haml-mode emmet-mode company-web web-completion-data helm-gtags ggtags org-category-capture evil flycheck haskell-mode yasnippet company projectile helm helm-core avy markdown-mode org-plus-contrib magit magit-popup with-editor async hydra rust-mode dash solarized-theme geiser neotree lorem-ipsum fancy-battery auto-compile packed yapfify yaml-mode xterm-color ws-butler winum which-key volatile-highlights vi-tilde-fringe uuidgen use-package unfill toml-mode toc-org symon string-inflection spaceline smeargle shell-pop restart-emacs realgud rainbow-delimiters racer pyvenv pytest pyenv-mode py-isort popwin pip-requirements persp-mode pcre2el password-generator paradox orgit org-projectile org-present org-pomodoro org-download org-bullets org-brain open-junk-file mwim multi-term move-text mmm-mode material-theme markdown-toc magit-gitflow macrostep llvm-mode live-py-mode linum-relative link-hint ledger-mode intero info+ indent-guide hy-mode hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-pydoc helm-purpose helm-projectile helm-mode-manager helm-make helm-hoogle helm-gitignore helm-flx helm-descbinds helm-company helm-c-yasnippet helm-ag haskell-snippets google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md fuzzy flyspell-correct-helm flycheck-rust flycheck-pos-tip flycheck-ledger flycheck-haskell flx-ido fill-column-indicator eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-org evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu eshell-z eshell-prompt-extras esh-help erlang elisp-slime-nav editorconfig dumb-jump disaster define-word dante cython-mode csv-mode company-statistics company-ghci company-ghc company-cabal company-c-headers company-anaconda column-enforce-mode cmm-mode cmake-mode clean-aindent-mode clang-format cargo auto-yasnippet auto-highlight-symbol auto-dictionary aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line ac-ispell)))
 '(popwin:popup-window-position (quote right)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-want-Y-yank-to-eol nil)
 '(package-selected-packages
   (quote
    (material-theme yapfify yaml-mode xterm-color ws-butler winum which-key web-mode volatile-highlights vi-tilde-fringe uuidgen use-package unfill toml-mode toc-org tagedit sql-indent spaceline powerline smeargle slim-mode shell-pop scss-mode sass-mode restart-emacs rainbow-delimiters racer pyvenv pytest pyenv-mode py-isort pug-mode popwin pip-requirements persp-mode pcre2el paradox spinner orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-plus-contrib org-download org-bullets open-junk-file mwim multi-term move-text mmm-mode markdown-toc markdown-mode magit-gitflow macrostep llvm-mode live-py-mode linum-relative link-hint less-css-mode ledger-mode intero info+ indent-guide hydra hy-mode dash-functional hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-pydoc helm-projectile helm-mode-manager helm-make projectile helm-hoogle helm-gtags helm-gitignore request helm-flx helm-descbinds helm-css-scss helm-company helm-c-yasnippet helm-ag haskell-snippets haml-mode google-translate golden-ratio go-guru go-eldoc gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md ggtags geiser fuzzy flyspell-correct-helm flyspell-correct flycheck-rust seq flycheck-pos-tip pos-tip flycheck-ledger flycheck-haskell flycheck pkg-info epl flx-ido flx fill-column-indicator eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit magit magit-popup git-commit with-editor evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight eshell-z eshell-prompt-extras esh-help erlang emmet-mode elisp-slime-nav dumb-jump disaster diminish define-word cython-mode csv-mode company-web web-completion-data company-statistics company-go go-mode company-ghci company-ghc ghc haskell-mode company-cabal company-c-headers company-anaconda anaconda-mode pythonic f dash s company column-enforce-mode cmm-mode cmake-mode clean-aindent-mode clang-format cargo rust-mode bind-map bind-key auto-yasnippet yasnippet auto-highlight-symbol auto-dictionary aggressive-indent adoc-mode markup-faces adaptive-wrap ace-window ace-link ace-jump-helm-line helm avy helm-core async ac-ispell auto-complete popup))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markup-attribute-face ((t (:inherit markup-meta-face :slant italic))))
 '(markup-title-0-face ((t (:inherit markup-gen-face :height 1.4))))
 '(markup-title-1-face ((t (:inherit markup-gen-face :height 1.2))))
 '(markup-title-2-face ((t (:inherit markup-gen-face :height 1.2))))
 '(markup-title-3-face ((t (:inherit markup-gen-face :weight bold :height 1.2)))))
