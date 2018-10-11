;;; barhop.el --- Summary:
;;; Commentary:
;;; Code:

(require 'projectile)
(require 'counsel-projectile) ;; fixme -- pretty overkill

(defcustom barhop-width 20 "Ha." :group 'barhop)
(defcustom barhop-filter-regex "^\\*"
  "Fuasfasf."
  :group 'barhop
  :type 'string)

(defvar barhop-window nil
  "Speedbar window.")
(defvar barhop-mode-map (make-sparse-keymap)
  "Map for `nav-mode'.")
(defvar barhop-active-map (make-sparse-keymap)
  "Active minor mode map.")

(defvar barhop--timer)
(defvar barhop-candidates nil)

;; fixme
(defface barhop-buffer-face
  '((t :inherit 'font-lock-comment-face :height 0.8))
  "Feebleline filename face."
  :group 'barhop)

;;;###autoload
(define-minor-mode barhop-mode
  "Do some shit. "
  :group 'barhop
  :global t
  :keymap barhop-mode-map
  (if barhop-mode
      ;; -- activate ----
      (progn
        (add-hook 'focus-in-hook 'barhop-open-window);
        (add-hook 'focus-out-hook 'barhop-open-window);
        (setq barhop--timer (run-with-timer 1 1 'barhop-open-window))
        (barhop-open-window))

    ;; -- deactivate  ----
    (remove-hook 'focus-in-hook 'barhop-open-window);
    (remove-hook 'focus-out-hook 'barhop-open-window);
    (let ((win-to-del (get-buffer-window (barhop--own-name))))
      (when win-to-del (delete-window win-to-del)))
    (cancel-timer barhop--timer)
    (kill-matching-buffers "\*counsel\-bar" nil t)))

(defun barhop--insert-candidate (candidate &optional number)
  "Insert CANDIDATE unless it satifies predicate, NUMBER too."
  (if number (insert (propertize (format " %s%-3s" number ")")
                                 'face 'barhop-buffer-face)))
  (insert (propertize (concat candidate "\n")
                      'face 'barhop-buffer-face)))

(defun barhop--filter-candidate (candidate)
  "Ass fff aa CANDIDATE."
  (if (string-match-p barhop-filter-regex candidate) nil t))

(defun barhop--own-name ()
  "The name of the barhop buffer corresponding to current project."
  "*barhop*"
  )

(defun barhop--insert-buffer-list (buffer buflist)
  "Insert BUFLIST into BUFFER."
  (let ((tmp-proj-name (projectile-project-name)))
    (with-current-buffer buffer
      (erase-buffer)
      (insert (propertize (concat "-- " tmp-proj-name " --\n\n")
                          'face 'barhop-buffer-face))
      (mapcar* 'barhop--insert-candidate
               buflist
               (number-sequence 1 (length buflist))))))

(defun barhop--get-project-buffers ()
  "Error catching variant of counsel-projectile--project-buffers."
  (condition-case nil (counsel-projectile--project-buffers) (error nil)))

;;;###autoload
(defun barhop-open-window ()
  "Asf ff ass."
  (interactive)
  (setq barhop-candidates
        (seq-filter 'barhop--filter-candidate
                    (sort (barhop--get-project-buffers) 'string<)))

  (if (and barhop-mode barhop-candidates)
      ;; replicate cuz it's buffer local
      (let ((active-buffer (current-buffer))
            (tmp-barhop-candidates barhop-candidates)
            (existing-bar-window (get-buffer-window (barhop--own-name)
                                                    'visible)))
        (if existing-bar-window
            (barhop--insert-buffer-list (get-buffer
                                              (barhop--own-name))
                                             tmp-barhop-candidates)
          (split-window (selected-window) barhop-width t)
          (barhop--insert-buffer-list (switch-to-buffer
                                            (barhop--own-name))
                                           tmp-barhop-candidates)
          (set-window-dedicated-p existing-bar-window t)
          (window-preserve-size existing-bar-window t t)
          (setq window-size-fixed nil)
          ;; (let ((fit-window-to-buffer-horizontally t))
          ;; (fit-window-to-buffer)) ;; todo
          (other-window 1)))))

(defun self-insert-or-buffer-kill (&optional arg)
  (interactive "P")
  (if arg (kill-buffer (nth (- arg 1) barhop-candidates))
    (self-insert-command 1)))

(defun self-insert-or-buffer-jump (&optional arg)
  (interactive "P")
  (if arg (switch-to-buffer (nth (- arg 1) barhop-candidates))
    (self-insert-command 1)))

(defun self-insert-or-buffer-jump-other-window (&optional arg)
  (interactive "P")
  (if arg (switch-to-buffer-other-window (nth (- arg 1) barhop-candidates))
    (self-insert-command 1)))

(define-key barhop-mode-map (kbd "j") 'self-insert-or-buffer-jump)
(define-key barhop-mode-map (kbd "J") 'self-insert-or-buffer-jump-other-window)
(define-key barhop-mode-map (kbd "K") 'self-insert-or-buffer-kill)


(provide 'barhop)
;;; barhop.el ends here
