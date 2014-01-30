(eval-when-compile (require 'cl))
(require 'bbdb)
(require 'log4e)

(log4e:deflogger "bbdb-test" "%t [%l] %m" "%H:%M:%S" '((fatal . "fatal")
                                                       (error . "error")
                                                       (warn  . "warn")
                                                       (info  . "info")
                                                       (debug . "debug")
                                                       (trace . "trace")))
(bbdb-test--log-set-level 'trace)

(defsubst bbdb-test::mkrecord (firstnm lastnm company account domain)
  (when company
    (setq company (format "(\"%s\")" company)))
  (format "[\"%s\" \"%s\" nil nil %s nil nil (\"%s@%s\") ((creation-date . \"2014-01-01\") (timestamp . \"2014-01-01\")) nil]"
          lastnm firstnm company account domain))

(defvar bbdb-test::data-hash nil)

(defun bbdb-test::load-data (dir type)
  (bbdb-test--trace "start load data. dir[%s] type[%s]" dir type)
  (let* ((file (concat dir "/" (symbol-name type) ".txt"))
         (s (cond ((file-exists-p file)
                   (with-current-buffer (find-file-noselect file)
                     (buffer-string)))
                  (t
                   (message "%s.txt is need in %s" (symbol-name type) dir)
                   "")))
         (s (replace-regexp-in-string "\\s-+\\'" "" s))
         (datalist))
    (loop for e in (split-string s "\n")
          do (pushnew e datalist :test 'equal))
    datalist))

(defun bbdb-test::get-random-data (dir type &optional regexp)
  (let ((datalist (or (gethash type bbdb-test::data-hash)
                      (puthash type (bbdb-test::load-data dir type) bbdb-test::data-hash))))
    (loop while t
          for e = (nth (random (length datalist)) datalist)
          if (or (not regexp)
                 (string-match regexp e))
          return e)))

;;;###autoload
(defun bbdb-test:mkbbdb (dir datanum)
  "Make BBDB using test data."
  (interactive "DTest Data Directory: \nnMake Data Number: ")
  (when (y-or-n-p (format "Back up %s?" bbdb-file))
    (copy-file bbdb-file (format "%s.bk.%s" bbdb-file (format-time-string "%y%m%d"))))
  (setq bbdb-test::data-hash (make-hash-table :test 'eq))
  (with-current-buffer (find-file-noselect bbdb-file)
    (erase-buffer)
    (insert ";; -*-coding: utf-8-emacs;-*-" "\n"
            ";;; file-format: 7" "\n")
    (loop with already-name = nil
          for i from 1 to datanum
          for namee = (loop with already-firstnm = nil
                            for j from 1 to datanum
                            for firstnm = (loop for k from 1 to datanum
                                                for v = (bbdb-test::get-random-data dir 'firstnm)
                                                if (not (member v already-firstnm))
                                                return (progn (push v already-firstnm)
                                                              v))
                            for lastnmre = (when firstnm
                                             (loop for re in '("\\`[a-zA-Z]+\\'"
                                                               "\\`[^a-zA-Z]+\\'")
                                                   if (string-match re firstnm)
                                                   return re))
                            for lastnm = (when firstnm
                                           (loop for k from 1 to datanum
                                                 for v = (bbdb-test::get-random-data dir 'lastnm lastnmre)
                                                 for fullnm = (concat v " " firstnm)
                                                 if (not (member fullnm already-name))
                                                 return (progn (push fullnm already-name)
                                                               v)))
                            if (and firstnm lastnm)
                            return (list firstnm lastnm))
          for firstnm = (when namee (pop namee))
          for lastnm = (when namee (pop namee))
          for company = (bbdb-test::get-random-data dir 'company)
          for account = (make-temp-name "")
          for domain = (bbdb-test::get-random-data dir 'domain)
          if (or (not firstnm)
                 (not lastnm))
          return (message "Number of the firstnm/lastnm test data seems inadequacy. %s data has been made." i)
          do (progn (insert (bbdb-test::mkrecord firstnm lastnm company account domain) "\n")
                    (bbdb-test--trace "put record : %s %s" lastnm firstnm)
                    (message "put %s record" i)))
    (sit-for 2)
    (save-buffer)
    (kill-buffer))
  (message "Finished make %s" bbdb-file))

(provide 'bbdb-test)
