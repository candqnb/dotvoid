#!/usr/bin/env sbcl --script

;;; Git repository checker (1-level depth, since my dotvoid sometimes has more than one git.)
;;;
;;; Features:
;;; 1. Recursively traverses directories
;;; 2. Detects git repositories
;;; 3. Runs git status checks
;;; 4. Verifies:
;;;    - Unstaged changes
;;;    - Pending commits to push
;;;    - Commits to pull
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
  (uiop:directory-exists-p
   (merge-pathnames ".git/" dir)))

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
           "git -C ~S ~A"
           (namestring repo)
           args)))

(defun fetch-remote (repo)
  (git repo "fetch --quiet"))

(defun unstaged-changes-p (repo)
  (not (string= ""
                (git repo "status --porcelain"))))

(defun pending-commits-p (repo)
  (let ((result
         (git repo
              "rev-list --count @{u}..HEAD")))
    (not (or (string= result "")
             (string= result "0")))))

(defun commits-to-pull-p (repo)
  (let ((result
         (git repo
              "rev-list --count HEAD..@{u}")))
    (not (or (string= result "")
             (string= result "0")))))

(defun current-branch (repo)
  (git repo "rev-parse --abbrev-ref HEAD"))

(defun check-repo (repo)
  (handler-case
      (progn
        (fetch-remote repo)

        (list
         :repo (namestring repo)
         :branch (current-branch repo)
         :unstaged (unstaged-changes-p repo)
         :pending (pending-commits-p repo)
         :to-pull (commits-to-pull-p repo)))

    (error (e)
      (list :repo (namestring repo)
            :error (princ-to-string e)))))

(defun print-result (result)
  (format t "~%================================================~%")
  (format t "Repository: ~A~%"
          (getf result :repo))

  (if (getf result :error)
      (format t "ERROR: ~A~%"
              (getf result :error))

      (progn
        (format t "Branch: ~A~%"
                (getf result :branch))

        (format t "Unstaged changes : ~A~%"
                (if (getf result :unstaged)
                    "YES"
                    "NO"))

        (format t "Pending commits   : ~A~%"
                (if (getf result :pending)
                    "YES"
                    "NO"))

        (format t "Need pull         : ~A~%"
                (if (getf result :to-pull)
                    "YES"
                    "NO")))))

(defun main ()
  (let* ((args (uiop:command-line-arguments))
         (root (if args
                   (first args)
                   "~/Projetos"))
		   ;;; If you have another "project" folder, you can hard code here.  
         (repos (find-git-repos root)))

    (format t "~%Scanning immediate subdirectories of: ~A~%"
            root)

    (format t "Found ~D repositories~%"
            (length repos))

    (dolist (repo repos)
      (print-result
       (check-repo repo)))))

(main)
