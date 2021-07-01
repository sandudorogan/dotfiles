;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Sandu Dorogan"
      user-mail-address "sandu.dorogan@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 17))

(setq auto-window-vscroll nil)


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(setq scroll-margin 8)

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



(after! projectile
  (pushnew! projectile-project-root-files "project.clj" "build.boot" "deps.edn"))

;; Large clojure buffers tend to be slower than large buffers of other modes, so
;; it should have a lower threshold too.
(add-to-list 'doom-large-file-size-alist '("\\.\\(?:clj[sc]?\\|dtm\\|edn\\)\\'" . 0.5))

(defmacro comment (&rest _)
  "Comment out one or more s-expressions."
  nil)

;;
;;; Packages

(setq lsp-completion-enable 't
      lsp-completion-enable-additional-text-edit 't
      lsp-completion-use-last-result 't
      lsp-log-io nil
      lsp-headerline-breadcrumb-enable 't
      lsp-headerline-breadcrumb-enable-diagnostics 't
      lsp-semantic-tokens-apply-modifiers 't
      lsp-semantic-tokens-enable 't
      lsp-lens-enable nil
      lsp-enable-indentation nil
      lsp-ui-sideline-show-code-actions nil
      lsp-disabled-clients '(js-ts)
      tab-always-indent 'complete)

(use-package! aggressive-indent
  :config
  (global-aggressive-indent-mode 1))

(use-package! clojure-mode
  :config
  (add-hook! 'clojure-mode-hook
             #'subword-mode
             #'paredit-mode
             #'rainbow-delimiters-mode)

  (setq clojure-align-forms-automatically t
        clojure-indent-style 'align-arguments)

  (when (featurep! +lsp)

    (comment (after! lsp-clojure
               (dolist (m '(clojure-mode
                            clojurec-mode
                            clojurescript-mode
                            clojurex-mode))
                 (add-to-list 'lsp-language-id-configuration (cons m "clojure")))))))

;; (after! lsp-mode
;;   ;; TODO PR this upstream
;;   (add-to-list 'lsp-language-id-configuration '(beancount-mode . "beancount"))
;;   (defvar lsp-beancount-langserver-executable "beancount-langserver")
;;   (defvar lsp-beancount-journal-file nil)
;;   (defvar lsp-beancount-python-interpreter
;;     (or (executable-find "python3")
;;         (executable-find "python")))
;;   (lsp-register-client
;;    (make-lsp-client :new-connection
;;                     (lsp-stdio-connection `(,lsp-beancount-langserver-executable "--stdio"))
;;                     :major-modes '(beancount-mode)
;;                     :initialization-options
;;                     `((journalFile . ,lsp-beancount-journal-file)
;;                       (pythonPath . ,lsp-beancount-python-interpreter))
;;                     :server-id 'beancount-ls)))

(use-package! clj-refactor
  ;; :pin melpa-stable
  :hook
  (clojure-mode . clj-refactor-mode)
  (clojure-mode . yas-minor-mode)
  :config
  (set-lookup-handlers! 'clj-refactor-mode
    :references #'cljr-find-usages)
  (cljr-add-keybindings-with-prefix "C-c .")
  (map! :map clojure-mode-map
        :localleader
        :desc "refactor" "R" #'hydra-cljr-help-menu/body)
  :custom
  ;; (cljr-favor-prefix-notation nil)
  ;; (cljr-ignore-analyzer-errors t)
  (cljr-magic-requires t)
  (cljr-magic-require-namespaces
   '(("a"    . "clojure.core.async")
     ("d"    . "datomic.api")
     ("edn"  . "clojure.edn")
     ("io"   . "clojure.java.io")
     ("json" . "cheshire.core")
     ("log"  . "clojure.tools.logging")
     ("s"    . "clojure.spec.alpha")
     ("set"  . "clojure.set")
     ("st"   . "clojure.spec.alpha.test")
     ("str"  . "clojure.string")
     ("walk" . "clojure.walk")
     ("zip"  . "clojure.zip")
     ("rf"   . "re-frame.core"))))

(global-set-key (kbd "TAB") #'company-indent-or-complete-common)

(use-package! cider
  ;; NOTE if `org-directory' doesn't exist, `cider-jack' in won't work
  :hook
  (clojure-mode-local-vars . cider-mode)
  :init
  (after! clojure-mode
    (set-repl-handler! 'clojure-mode #'+clojure/open-repl :persist t)
    (set-repl-handler! 'clojurescript-mode #'+clojure/open-cljs-repl :persist t)
    (set-eval-handler! '(clojure-mode clojurescript-mode) #'cider-eval-region))
  :config
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (add-hook 'cider-mode-hook #'company-mode)
  (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-repl-mode-hook #'company-mode)
  ;; (set-lookup-handlers! 'cider-mode nil)
  (set-lookup-handlers! '(cider-mode cider-repl-mode)
    :definition #'+clojure-cider-lookup-definition
    :documentation #'cider-doc)

  (setq cider-font-lock-dynamically '(macro core function var deprecated)
        cider-overlays-use-font-lock t
        cider-repl-history-display-style 'one-line
        cider-repl-history-file (concat doom-cache-dir "cider-repl-history")
        cider-repl-history-highlight-current-entry t
        cider-repl-history-quit-action 'delete-and-restore
        cider-repl-history-highlight-inserted-item t
        cider-repl-history-size 1000
        cider-repl-result-prefix " => "
        cider-repl-use-clojure-font-lock t
        cider-repl-use-pretty-printing t
        cider-repl-wrap-history nil
        cider-default-cljs-repl 'shadow
        cider-shadow-default-options ":studio"
        cider-shadow-watched-builds '("studio" "sdk" "story-server")
        cider-enhanced-cljs-completion-p nil ;; keep nil until furher notice: https://github.com/clojure-emacs/clj-suitable#emacs-cider
        cider-stacktrace-default-filters '(tooling dup)))

(use-package! smart-jump
  :after (cider)
  :config
  (smart-jump-register
   :modes '(clojure-mode cider-mode cider-repl-mode)
   :jump-fn 'cider-find-var
   :pop-fn 'cider-pop-back
   :refs-fn 'cljr-find-usages
   :should-jump 'cider-connected-p
   :heuristic 'point
   :async 500))

(use-package! flycheck-clj-kondo
  :when (featurep! :checkers syntax)
  :after flycheck)

