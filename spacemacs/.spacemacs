;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
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
     docker
     emacs-lisp
     erlang
     finance
     git
     go
     gtags
     haskell
     helm
     html
     idris
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
   dotspacemacs-additional-packages '(groovy-mode llvm-mode)
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages
   '(anaconda-mode
     anzu
     auto-compile
     csv-mode
     fancy-battery
     git-timemachine
     gnuplot
     golden-ratio
     lorem-ipsum
     neotree
     org-download
     neotree
     fancy-battery
     golden-ratio
     org-projectile
     smartparens
     version-control
     yapf-mode
     yasnippet)
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5
   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the lastest
   ;; version of packages from MELPA. (default nil)
   dotspacemacs-use-spacelpa nil
   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default nil)
   dotspacemacs-verify-spacelpa-archives nil
   ;; If non-nil then spacemacs will check for updates at startup
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
   dotspacemacs-themes '(deeper-blue
                         solarized-dark
                         solarized-light
                         spacemacs-dark
                         spacemacs-light)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '("Inconsolata"
                               :size 22
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
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non-nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, `J' and `K' move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non-nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non-nil then the last auto saved layouts are resumed automatically upon
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
   ;; If non-nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non-nil, the helm header is hidden when there is only one source.
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
   ;; If non-nil, the paste transient-state is enabled. While enabled, pressing
   ;; `p' several times cycles through the elements in the `kill-ring'.
   ;; (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil
   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar nil
   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non-nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
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
   ;; If non-nil `smartparens-strict-mode' will be enabled in programming modes.
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
   ;; If non-nil, advise quit functions to keep server open when quitting.
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
   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"
   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'trailing))

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
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
                go-tab-width 4
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
                vc-follow-symlinks t
                winum-scope 'frame-local)

  ;; Always split horizontally
  (setq-default split-height-threshold nil
                split-width-threshold  0)

  ;; Enable auto fill
  (auto-fill-mode)

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
        ("8no" "✗")
        ("8ok" "✓")
        ("8rar" "→")
        ("8rs" "₹")
        ("8sig" "σ")
        ("8smly" "☺")
        ("8star" "★")
        ("8t" "#+title:")
        ("8tau" "τ")

        ("8a1" "❶")
        ("8a2" "❷")
        ("8a3" "❸")
        ("8a4" "❹")
        ("8a5" "❺")
        ("8a6" "❻")
        ("8a7" "❼")
        ("8a8" "❽")
        ("8a9" "❾")

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

  (use-package flyspell
    :bind (("<f6>" . flyspell-correct-previous-word-generic)))

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

    (defun j/org-insert-link ()
      "Insert org link where default description is set to html title."
      (interactive)
      (let* ((url (read-string "URL: "))
             (title (get-html-title-from-url url)))
        (org-insert-link nil url title)
        (cleanup-fancy-quotes)))

    (require 'mm-url)

    (defun get-html-title-from-url (url)
      "Return content in <title> tag."
      (let (x1 x2 (download-buffer (url-retrieve-synchronously url t)))
        (save-excursion
          (set-buffer download-buffer)
          (beginning-of-buffer)
          (setq x1 (search-forward "<title>"))
          (search-forward "</title>")
          (setq x2 (search-backward "<"))
          (mm-url-decode-entities-string (buffer-substring-no-properties x1 x2)))))

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

  (use-package spaceline
    :init
    (spaceline-toggle-buffer-encoding-abbrev-off)
    (spaceline-toggle-buffer-position-off)
    (spaceline-toggle-flycheck-warning-off)
    (spaceline-toggle-hud)
    (spaceline-toggle-input-method-off)
    (spaceline-toggle-major-mode-off)
    (spaceline-toggle-version-control-off))

  (use-package uniquify
    :init
    (setq uniquify-buffer-name-style 'forward
          uniquify-min-dir-content 1))

  ;; A bunch of personal key bindings
  (spacemacs/set-leader-keys
    ","  'replace-string
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

;; Load customized config
(setq custom-file "~/.emacs.d/private/custom.el")
(load custom-file 'noerror)
