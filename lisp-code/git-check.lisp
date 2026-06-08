#!/usr/bin/sbcl --script

;;; Git repository checker (1-level depth, since my dotvoid sometimes has more than one git.)
;;;
;;; Features:
;;; 1. Recursively traverses directories
;;; 2. Detects git repositories
;;; 3. Runs git status checks
;;; 4. Verifies:
;;;    - Unstaged changes
;;;    - Pending commits to push
;;; 5. Prints a summary log
;;; 
;;; Usage:
;;;   sbcl --script git-check.lisp /path/to/projects

(require 'uiop)

(defun run-command (command)
  (string-trim
   '(#\Space #\Newline #\Tab)
   (uiop:run-program command
                     :output :string
                     :ignore-error-status t)))

(defun git-repo-p (dir)
  ;; FIX: support both .git directory and .git file (worktrees/submodules)
  (or (uiop:directory-exists-p
       (merge-pathnames ".git/" dir))
      (uiop:file-exists-p
       (merge-pathnames ".git" dir))))

(defun immediate-subdirectories (dir)
  "Return only direct child directories."
  (remove-if-not
   #'uiop:directory-exists-p
   (directory
    (merge-pathnames "*/"
                     (uiop:ensure-directory-pathname dir)))))

(defun find-git-repos (root)
  "Find git repos only one level deep."
  (remove-if-not
   #'git-repo-p
   (immediate-subdirectories root)))

(defun git (repo args)
  (run-command
   (format nil
           "git -C ~A ~A"
           (namestring repo)
           args)))

(defun unstaged-changes-p (repo)
  (not (string= ""
                (git repo "status --porcelain"))))

(defun pending-commits-p (repo)
  ;; FIX: safe handling when no upstream exists
  (handler-case
      (> (parse-integer
          (git repo "rev-list --count @{u}..HEAD")
          :junk-allowed t)
         0)
    (error () nil)))

(defun current-branch (repo)
  (git repo "rev-parse --abbrev-ref HEAD"))

(defun flag (value)
  (if value "+" "-"))

(defun check-repo (repo)
  (handler-case
      (list
       :repo repo
       :branch (current-branch repo)
       :unstaged (unstaged-changes-p repo)
       :pending (pending-commits-p repo))

    (error (e)
      (list :repo repo
            :error (princ-to-string e)))))

(defun folder-name (path)
  "Return only the last component of the path."
  ;; FIX: safer than pathname-name for directories
  (car (last (pathname-directory (uiop:ensure-directory-pathname path)))))

(defun print-result (result)
  (if (getf result :error)
      (format t "~20A ERROR: ~A~%"
              (folder-name (getf result :repo))
              (getf result :error))
      (format t "~20A [~A] M~A P:~A~%"
              (folder-name (getf result :repo))
              (getf result :branch)
              (flag (getf result :unstaged))
              (flag (getf result :pending)))))

(defun main ()
  (let* ((args (uiop:command-line-arguments))
         (root (uiop:ensure-directory-pathname
                (or (first args)
                    (merge-pathnames "Projetos/"
                                     (user-homedir-pathname)))))
         (repos (find-git-repos root)))

    (format t "Found ~D repositories~%"
            (length repos))

    (dolist (repo repos)
      (print-result
       (check-repo repo)))))

(main)
