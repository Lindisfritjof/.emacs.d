;; dette er init filen til customisering af min emacs.
;; ja-nej prompt ændres til y or n
(defalias 'yes-or-no-p 'y-or-n-p)
;; først prøver jeg at sætte shell til bash, fremfor zsh som den ellers insisterer på..
(setq shell-file-name "/usr/bin/bash")
;; =========== MELPA SUPPORT ===================
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; Any add to list for package-archives (to add marmalade or melpa) goes here
(add-to-list 'package-archives 
    '("MELPA" .
      "http://stable.melpa.org/packages/"))
;(package-initialize)

;; hvis der ikke er nogen arkiverede pakker, refresh:
(when (not package-archive-contents)
  (package-refresh-contents))

;; ====== SLUT PÅ INSTALL. AF MELPA SUPPORT ===========

;; =============================================
;; ===== HER BEGYNDER MINE EGNE CONFIGS ========
;; =============================================

;; ====== GENEREL CUSTOMISERING  I EMACS ============
; Lav eget navn i titlen
(setq frame-title-format "Lindisfarne EMACS")

;; Start op i full-screen mode
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Sjov kat der kan noget smart
(nyan-mode 1)

; fjerner velkomst-skærmen
(setq inhibit-startup-screen t)
(setq initial-scratch-message "")

;; fjerner menuerne
(menu-bar-mode -1)
(tool-bar-mode -1)

;; getting rid of those pesky backupfiles
(setq make-backup-files nil)
; bliver spændende om jeg fortryder den del senere...

;; linjetal i tekstmode også
(add-hook 'olvetti-mode-hook 'display-line-numbers-mode)
(add-hook 'fountain-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'markdown-mode-hook 'display-line-numbers-mode)

;; ======= SLUT PÅ GENEREL OPFØRSEL I EMACS ===


;; ===== Programmeringssmukkesering ============
;; først smækker vi elpy på
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; og tilføjer flycheck
;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; autopep sammen med
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
;; linjetal fremhævet
(setq display-line-numbers 'relative)

;;(add-hook 'prog-mode-hook 'writeroom-mode)
(setq elpy-rpc-python-command "python3")
(setq python-shell-interpreter "python3"
      python-shell-interpreter-args "-i")

;; Jedi-mode + lsp (se matrix-chatten)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(require 'jedi)
(jedi:setup)
(require 'lsp-python-ms)
(require 'lsp-jedi)
(push 'lsp-jedi lsp-language-id-configuration)

;; Treesitter-mode configs
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; end treesitter mode configs

;; babel mode configs, så der står python kode i src-blokkene
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

;; SLIME
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(dolist (package '(slime))
  (unless (package-installed-p package)
    (package-install package)))
(require 'slime)
(slime-setup '(slime-fancy slime-quicklisp slime-asdf slime-mrepl))

;(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

;company-mode
 (add-to-list 'company-backends 'company-jedi)
(setq elpy-rpc-virtualenv-path "/home/fritjof/.emacs.d/elpy/rpc-venv")
(add-hook 'elpy-mode-hook (lambda () (elpy-shell-toggle-dedicated-shell 1)))

;; HTML - web-mode
(setq web-mode-enable-auto-pairing t)
(add-hook 'html-mode-hook 'web-mode)

;; org agenda
(setq calendar-week-start-day 1)

;; CalDAV - setup
(require 'org-caldav)

     ;; URL of the caldav server
     (setq org-caldav-url "https://riversouldiers.dk/remote.php/dav/calendars")

     ;; calendar ID on server
     (setq org-caldav-calendar-id "fritjof/personal/")

     ;; Org filename where new entries from calendar stored
     (setq org-caldav-inbox "~/org/kalenderfiler.org")

     ;; Additional Org files to check for calendar events
     (setq org-caldav-files nil)

     ;; Usually a good idea to set the timezone manually
     (setq org-icalendar-timezone "Europe/Berlin")


;; org reveal / ox-reveal
(use-package ox-reveal)
(require 'ox-reveal)

;; ======= SKRIVESMUKKESERING ================
;; og så laver vi olivetti-mode til .txt-filer
(add-hook 'fountain-mode-hook 'olivetti-mode)
(add-hook 'text-mode-hook 'olivetti-mode)
(add-hook 'text-mode-hook 'company-mode)

;; piller ved lisp eval depth
;; her står der ikke noget endnu, for jeg ved ikke hvad det skulle være...

;; Her smækker jeg markdown-mode på
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("603a831e0f2e466480cdc633ba37a0b1ae3c3e9a4e90183833bc4def3421a961"
     default)))


;; og her får vi et preview via flymd
(require 'flymd)
 (defun my-flymd-browser-function (url)
   (let ((browse-url-browser-function 'browse-url-firefox))
     (browse-url url)))
 (setq flymd-browser-open-function 'my-flymd-browser-function)

;; Uh, nice rainbows! 
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Fountain-mode custom
;; C-c C-e f for export

(use-package fountain-mode
  :config
  (defun fritjof-fountain-export ()
    (interactive)
    (fountain-export-command "afterwriting-a4pdf-doublespace"))
  (bind-key "C-c C-e f" #'fritjof-fountain-export 'fountain-mode-map))

;; Tænder for "automatisk opdatering" af filer som bliver ændret i filsystemt, kun for doc-view-mode
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;;=======================
;; org mode konfigurering
;;=======================
(require 'org)
(setq org-default-notes-file (concat org-directory))

(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

;;capture todo items using C-c c t                                              
(define-key global-map (kbd "C-c c") 'org-capture)
 (setq org-capture-templates
   '(("t" "Todo" entry
      (file+olp+datetree "~/org/todo.org")
      "* TODO %?
   %i
   %a")
     ("n" "noter" entry
      (file+headline "~/org/noter.org" "Noter")
      (file "* %T"))
     ("b" "Bog-noter" entry
      (file "~/org/bog-noter.org")
      "* %T")
     ("d" "Dagbog" entry
     (file "~/org/dagbog.org")
      "* %T")))

;; org agenda setup
(setq org-agenda-files (quote ("~/org")))

;; org bullet pænhed
(use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; org agenda
(global-set-key (kbd "C-c o a") #'org-agenda)

;; ox-hugo eksport af or-mode filer
(with-eval-after-load 'ox
  (require 'ox-hugo))

;; e-bøger
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;;LaTeX herunder
(setq +latex-viewers '(pdf-tools))

;;========= E-POST MED mu4e ================
;; SMTP-info for protonmail fundet på https://doubleyloop.net/2019/09/06/emacs-mu4e-mbsync-and-protonmail/

;; setting mu4e to executable path & require
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(setq mu4e-mu-binary "/usr/local/bin/mu")
(require 'mu4e)

;; SMTP from https://doubleloop.net/2019/09/06/emacs-mu4e-mbsync-and-protonmail/
(setq mu4e-maildir "~/.mail"
    mu4e-attachment-dir "~/Hentet"
    mu4e-sent-folder "/Sent"
    mu4e-drafts-folder "/Drafts"
    mu4e-trash-folder "/Trash"
    mu4e-refile-folder "/Archive")

(setq user-mail-address "fritjofarnfred@protonmail.com"
      user-full-name  "Øjvind Fritjof Arnfred")
                (setq mu4e-compose-signature  (concat
					     "Venlig hilsen/Kind regards\n"
                                             "Øjvind Fritjof Arnfred\n"
					     "+45 29 65 28 52\n"
                                             "https://www.fritjofarnfred.dk"))
;; Get mail
(setq mu4e-get-mail-command "mbsync protonmail"
    mu4e-change-filenames-when-moving t   ; needed for mbsync
    mu4e-update-interval 120)             ; update every 2 minutes

;; send med MSMTP
(setq sendmail-program "/usr/bin/msmtp"
      message-sendmail-f-is-evil t
      message-sendmail-extra-arguments '("--read-envelope-from")
      send-mail-function 'smtpmail-send-it
      message-send-mail-function 'message-send-mail-with-sendmail)

;; og så skal der køres nifty org-mode på det hele
(use-package org-mime
  :ensure t)

; customizing style
(setq org-mime-export-options '(:section-numbers nil
                                :with-author nil
                                :with-toc nil))

;; What if we want to write in Org Mode?
;Run "M-x org-mime-edit-mail-in-org-mode"

; Now you can use M-x org-mime-htmlize inside of a mail composition buffer to convert it to HTML!
;You can include: … anything that org-mode can convert to HTML

;;============SLUT PÅ EPOST====================

;; Start på oversættelse med po-mode
  (autoload 'po-mode "po-mode"
            "Major mode for translators to edit PO files" t)
  (setq auto-mode-alist (cons '("\\.po\\'\\|\\.po\\." . po-mode)
                              auto-mode-alist))

;;To use the right coding system automatically under Emacs 20 or newer,
;;also add:
  (autoload 'po-find-file-coding-system "po-compat")
  (modify-coding-system-alist 'file "\\.po\\'\\|\\.po\\."
                              'po-find-file-coding-system)

;; overskrid ikke linjegrænse.
  (defun po-wrap ()
       "Filter current po-mode buffer through `msgcat' tool to wrap all lines."
       (interactive)
       (if (eq major-mode 'po-mode)
           (let ((tmp-file (make-temp-file "po-wrap."))
     	    (tmp-buf (generate-new-buffer "*temp*")))
     	(unwind-protect
     	    (progn
     	      (write-region (point-min) (point-max) tmp-file nil 1)
     	      (if (zerop
     		   (call-process
     		    "msgcat" nil tmp-buf t (shell-quote-argument tmp-file)))
     		  (let ((saved (point))
     			(inhibit-read-only t))
     		    (delete-region (point-min) (point-max))
     		    (insert-buffer tmp-buf)
     		    (goto-char (min saved (point-max))))
     		(with-current-buffer tmp-buf
     		  (error (buffer-string)))))
     	  (kill-buffer tmp-buf)
     	  (delete-file tmp-file)))))

;; auto-fill til po-mode
    (add-hook 'po-subedit-mode-hook '(lambda () (longlines-mode 1)))
    (add-hook 'po-subedit-exit-hook '(lambda () (longlines-mode 0)))

;; po-mode stavekontrol
    (defun po-guess-language ()
      "Return the language related to this PO file."
      (save-excursion
        (goto-char (point-min))
        (re-search-forward po-any-msgstr-block-regexp)
        (goto-char (match-beginning 0))
        (if (re-search-forward
             "\n\"Language: +\\(.+\\)\\\\n\"$"
             (match-end 0) t)
            (po-match-string 1))))
    
    (defadvice po-edit-string (around setup-spell-checking (string type expand-tabs) activate)
      "Set up spell checking in subedit buffer."
      (let ((po-language (po-guess-language)))
        ad-do-it
        (if po-language
            (progn
              (ispell-change-dictionary po-language)
              (turn-on-flyspell)
              (flyspell-buffer)))))

;; Counsel settings (med hjælp fra Mark)
;; kilde: https://github.com/abo-abo/swiper
(use-package counsel
  :config
  (keymap-global-set "M-x" #'counsel-M-x)
  (keymap-global-set "C-x C-f" #'counsel-find-file))

(use-package ivy
  :config
  (ivy-mode)
  (setopt ivy-use-virtual-buffers t)
  (setopt enable-recursive-minibuffers t))

;; elfeed RSS-reader
(use-package elfeed)

```el
(global-set-key (kbd "C-x w") 'elfeed)
```
;; for newsticker opførsel (også rss)

;; url-liste for newsticker
(setq newsticker-url-list '(
	("https://sachachua.com/blog/feed/index.xml" Sascha Chua's Emacs Blog)
	("https://emacstil.com/feed.xml" Emacs TIL)
	("https://irreal.org/blog/?feed=rss2" Irreal Blog)))

(defun my/close-newsticker ()
    "Kill all tree-view related buffers."
    (kill-buffer "*Newsticker List*")
    (kill-buffer "*Newsticker Item*")
    (kill-buffer "*Newsticker Tree*"))

(advice-add 'newsticker-treeview-quit :after 'my/close-newsticker)


;; set eww som default browser
(setq browse-url-browser-function 'eww-browse-url)

;; =============================================
;; ===== Her slutter min egenkonfig af emacs ===
;; =============================================

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
; den her er fonts, sat af mig selv:
(set-face-attribute 'default nil
		    :family "Courier Prime Code"
		    :height 140)
