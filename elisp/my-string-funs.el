(defun strcmp (s1 s2)
  (let ((cmp (compare-strings s1 nil nil s2 nil nil)))
    (if (numberp cmp) cmp 0)))

(defun numstrcmp (s1 s2)
  (- (string-to-number s1) (string-to-number s2)))

(defun zip (al bl)
  (cond ((and (null al) (null bl)) nil)
        (t (cons (cons (car al)
                       (car bl))
                 (zip (cdr al)
                      (cdr bl))))))

(defun zip-full (al bl filler)
  (cond ((and (null al) (null bl)) nil)
        ((null al) (zip    (make-list (length bl) filler) bl))
        ((null bl) (zip al (make-list (length al) filler)))
        (t (cons (cons (car al)
                       (car bl))
                 (zip-full (cdr al)
                           (cdr bl)
                           filler)))))

(defun zip-align (a-list b-list cmpf filler)
  (let ((res '()))
    (while (not (or (null a-list) (null b-list)))
      (let* ((ac (car a-list))
             (bc (car b-list))
             (compare (funcall cmpf ac bc)))
        (cond ((< compare 0)
               (setq res (cons (cons ac filler) res))
               (setq a-list (cdr a-list)))
              ((> compare 0)
               (setq res (cons (cons filler bc) res))
               (setq b-list (cdr b-list)))
              (t (setq res (cons (cons ac bc) res))
                 (setq a-list (cdr a-list))
                 (setq b-list (cdr b-list))))))
    (append (nreverse res) (zip-full a-list b-list filler))))

(defun file-lines-to-list (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (split-string (buffer-string) "\n" t)))

(defun zip-align-files (file1 file2 cmpf fill)
  (interactive)
  (let* ((list1 (file-lines-to-list file1))
         (list2 (file-lines-to-list file2)))
    (zip-align list1 list2 cmpf fill)))

(defun zip-align-text-files (file1 file2)
  (interactive)
  (let ((buf (generate-new-buffer "zip-aligned-files")))
    (with-current-buffer buf
      (mapc (lambda (pair)
              (insert (car pair) " " (cdr pair) "\n"))
            (zip-align-files file1 file2 'strcmp "- ")))))

;; (zip-align-text-files "/tmp/foo" "/tmp/bar")

(defun zip-align-text-files-by-column (file1 file2)
  (let ((buf (generate-new-buffer "zip-aligned-files")))
    (with-current-buffer buf
      (mapc (lambda (pair)
              (insert (car pair) " " (cdr pair) "\n"))
            (zip-align-files file1 file2 'colcmp "- ")))))

(defun colcmp (line1 line2)
  (let* ((str1 (progn (string-match "\\(?:\\w+\\W+\\)\\(\\w+\\).*$" line1)
                      (match-string 1 line1)))
         (str2 (progn (string-match "\\(\\w+\\).*$" line2)
                      (match-string 1 line2))))
    (numstrcmp str1 str2)))

;;(zip-align-text-files-by-column "/home/kjell/gbl/15707/gbl-15707-corr-cases-3-sorted-headless"
;;                                "/home/kjell/gbl/15707/eids-from-finance-sorted")

;; test zip and zip-full
(progn
  (assert-equal '((1 . 2) (3 . 4) (5 . 6))
               (zip (list 1 3 5) (list 2 4 6)))
  (assert-equal '((1 . 2) (3 . 4) (5 . x))
               (zip-full (list 1 3 5) (list 2 4) 'x))
  )

;; test zip-align
(progn
  (assert-equal '((1 . 1))
                (zip-align '(1) '(1) '- nil))
  (assert-equal '((1 . nil) (2 . nil) (3 . 3) (nil . 3) (nil . 4) (5 . 5))
                (zip-align (list 1 2 3 5) (list 3 3 4 5) '- nil))
  (assert-equal '((1 . x) (x . 2) (3 . 3) (4 . x) (x . 5))
                (zip-align '(1 3 4) '(2 3 5) '- 'x))
  (assert-equal '((1 . x) (x . 2) (3 . 3) (4 . x) (x . 5) (x . 6))
                (zip-align '(1 3 4) '(2 3 5 6) '- 'x))
  (assert-equal '((1 . x) (x . 2) (3 . 3) (4 . x) (x . 5) (6 . x))
                (zip-align '(1 3 4 6) '(2 3 5) '- 'x))
  (assert-equal '(("abc" . "abc") ("def" . "- ") ("- " . "ghi"))
                (zip-align '("abc" "def") '("abc" "ghi") 'strcmp "- "))
  )

;; test strcmp
(progn
  (assert-equal  0 (strcmp "a" "a"))
  (assert-equal -1 (strcmp "a" "b"))
  (assert-equal  1 (strcmp "b" "a"))
  (assert-equal  0 (strcmp "abc" "abc"))
  (assert-equal -3 (strcmp "abc" "abd"))
  (assert-equal  3 (strcmp "abd" "abc"))
  )
