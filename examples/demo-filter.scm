(use-modules (file filter)
             (ice-9 rdelim))

(file-filter (lambda (in out)
               (display (read-line in) out)
               (newline out)))
