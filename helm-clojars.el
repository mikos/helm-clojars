(require 'url)
(require 'json)

(defun clojars-search (search-query)
  (with-current-buffer
      (url-retrieve-synchronously
       (format "http://clojars.org/search?q=%s&format=json" search-query))
    (goto-char (+ 1 url-http-end-of-headers))
    (json-read-object)))

(defun format-result-for-display (result)
  (format "[%s/%s \"%s\"]"
          (cdr (assoc 'group_name result))
          (cdr (assoc 'jar_name result))
          (cdr (assoc 'version result))))

(defun helm-clojars-search ()
  (mapcar (lambda (result)
            (cons (format-result-for-display result) result))
          (cdr (assoc 'results (clojars-search helm-pattern)))))

(defvar helm-source-clojars-search
  '((name . "Clojars")
    (volatile)
    (delayed)
    (requires-pattern . 3)
    (candidates-process . helm-clojars-search)))

(defun helm-clojars ()
  (interactive)
  (helm :sources '(helm-source-clojars-search)
        :buffer "*helm-clojars*"))

(provide 'helm-clojars)
