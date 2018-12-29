;;; -*- lexical-binding: t; -*-

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package magit
  :defer t
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

(use-package evil-magit :after magit)

(use-package flycheck
  :hook (haskell-mode . flycheck-mode))

(provide 'init-prog-tools)