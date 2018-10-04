(defun tyoverby/layers ()
  (setq-default
   dotspacemacs-configuration-layers
   '(
     helm
     auto-completion
     better-defaults
     emacs-lisp
     ocaml
     git
     markdown
     org
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     syntax-checking
     version-control
     )
   dotspacemacs-additional-packages '(real-auto-save flycheck-ocaml)
   dotspacemacs-excluded-packages '(vi-tilde-fringe)))

(defun tyoverby/init ()
  (setq-default
   dotspacemacs-default-font '("Source Code Pro" :size 14 :weight normal :width normal :powerline-scale 1.1)
   dotspacemacs-remap-Y-to-y$ 't
   dotspacemacs-helm-resize 't
   dotspacemacs-helm-no-header 't
   ))

(defun dotspacemacs/user-init ()
  "Runs after `dotspacemacs/init', before layer configuration executes."
  ;; Same background color for comments and regular code
  (setq spacemacs-theme-comment-bg nil)
  ;; Fixes powerline color issues
  (setq powerline-image-apple-rgb 't)

  ;; No bold for any font!
  (mapc
   (lambda (face)
     (when (eq (face-attribute face :weight) 'bold)
       (set-face-attribute face nil :weight 'normal)))
   (face-list))
  )

(defun dotspacemacs/user-config ()
  "Runs at the very end of Spacemacs initialization after layers configuration."

  ;; Removes the help message from neotree
  (setq neo-banner-message nil)
  ;; Arrow neotree theme
  (setq neo-theme 'arrow)
  ;; Neotree is on the right
  (setq neo-window-position 'right)

  ;; No idea what this does
  (setq-default mode-line-format nil)
  ;; Vertical bars for powerline separator
  (setq powerline-default-separator nil)

  ;; Real autosave saves the buffer every 10 seconds
  (require 'real-auto-save)
  (add-hook 'prog-mode-hook 'real-auto-save-mode)
  (setq real-auto-save-interval 10)

  ;; Open neotree via tab in normal mode
  (define-key evil-normal-state-map (kbd "TAB") 'neotree-find-project-root)
  ;; Open buffers list on ctrl-space
  (define-key evil-normal-state-map (kbd "C-SPC") 'helm-buffers-list)
  ;; Open fuzzy finder with ctrl-p
  (define-key evil-normal-state-map (kbd "C-p") 'projectile-find-file)
  ;; In neotree, use Tab and ctrl-space to close it, ctrl-w to move away 
  (add-hook
   'neotree-mode-hook
   (lambda ()
     (evilified-state-evilify-map neotree-mode-map
       :mode neotree-mode
       :bindings
       (kbd "TAB")    'neotree-toggle
       (kbd "C-SPC")  'neotree-toggle
       (kbd "C-w")    'evil-window-prev)))

  ;; (add-hook
  ;;  'flycheck-mode-hook
  ;;  (lambda ()
  ;;    (evilified-state-evilify-map flycheck-error-list-mode-map
  ;;      :mode flycheck-mode
  ;;      :bindings
  ;;      (kbd "C-w")    'evil-window-prev)))

  ;; Flycheck + Ocaml
  (with-eval-after-load 'merlin
    ;; Disable Merlin's own error checking
    (setq merlin-error-after-save nil)
    ;; Enable Flycheck checker
    (flycheck-ocaml-setup))

  (add-hook 'tuareg-mode-hook #'merlin-mode)
  (add-hook 'tuareg-mode-hook #'flycheck-mode)

  ;; Heafty spacing on each buffer
  (fringe-mode 30))
