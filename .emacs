(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))
;;;;;;;;;;;;;;;;;;;;;;;;; Package Systems ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MELPA

(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (window-numbering jedi elpy org polymode auto-complete ido-gnus smex solarized-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;;;;;;;;;;;;;;;;;;;;;;;;;; Basic Setup ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-message t)
(tool-bar-mode -1)

(load-theme 'solarized-dark t)



(global-set-key (kbd "M-x") 'smex)
;; auto-hyphen
(defadvice smex (around space-inserts-hyphen activate compile)
        (let ((ido-cannot-complete-command 
               `(lambda ()
                  (interactive)
                  (if (string= " " (this-command-keys))
                      (insert ?-)
                    (funcall ,ido-cannot-complete-command)))))
          ad-do-it))

; word wrap
(global-visual-line-mode t)
;; column and line numbers
(setq column-number-mode t)
;; Kill all Dired buffers
(defun kill-dired-buffers ()
	 (interactive)
	 (mapc (lambda (buffer) 
           (when (eq 'dired-mode (buffer-local-value 'major-mode buffer)) 
             (kill-buffer buffer))) 
	       (buffer-list)))


;; window-numbering
(window-numbering-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;; LaTeX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq exec-path (append exec-path '("/usr/bin/tex")))

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;; Statistics ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; find markdown

;; ess setup
(require 'ess-site)



;; R modes
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))

(require 'poly-R)
(require 'poly-markdown)
(require 'ess-view)

; Stata
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/stata14"))
(setq exec-path (append exec-path '("/usr/local/stata14")))
(setq inferior-STA-program-name "stata-mp")

;; ado-mode
(add-to-list 'load-path "~/.emacs.d/ado-mode/lisp")
(require 'ado-mode)


;;;;;;;;;;;;;;;;;;;;;;;;; Org Mode ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Org mode setup
;(setq org-default-notes-file (concat org-directory "~/org/notes.org"))
(setq org-default-notes-file (expand-file-name "~/org/notes.org"))
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cl" 'org-store-link)

;; TODO
(setq org-todo-keywords
     '((sequence "TODO" "DOING" "WAITING" "|" "DONE")))
(setq org-todo-keyword-faces
      '(("TODO" . org-warning)
	("DOING" :background nil :foreground "yellow" :weight bold)
	("WAITING" :background nil :foreground "orange")
	("DONE" :background nil :foreground "green")))

;; set latex table to left aligned
(defcustom org-export-latex-tables-centered nil
      "When non-nil, tables are exported in a center environment."
      :group 'org-export-latex
      :type 'boolean)

;; tiny package
(global-set-key (kbd "C-;") 'tiny-expand)

;; linewrap in tables
(setq truncate-lines 'nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; tags ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-tag-alist '(("@teaching" . ?t) ("@research" . ?r)
		      ("@outreach" . ?o) ("@service" . ?s)))

;;;;;;;;;;;;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set python to anaconda
;; from: https://samrelton.wordpress.com/2013/09/26/emacs-and-anaconda-python/
(defun set-exec-path-from-shell-PATH ()
        (interactive)
        (let ((path-from-shell (replace-regexp-in-string "^.*\n.*shell\n" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
        (setenv "PATH" path-from-shell)
        (setq exec-path (split-string path-from-shell path-separator))))
(set-exec-path-from-shell-PATH)


;; set ipython as default python interpreter
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i")


;; Elpy
(elpy-enable)
(elpy-use-ipython)
(setq elpy-rpc-backend "jedi")
;(setq jedi:complete-on-dot t)
